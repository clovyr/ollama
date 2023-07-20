<script lang="ts" setup>
import { ref } from 'vue';

interface msg {
  text: String;
  from: String;
  timestamp: Date;
}

interface GenReq {
  model: String;
  prompt: String;
  context: Number[];
  // Options `json:"options"`
}

interface GenRes {
  model: String;
  created_at: String;
  response: String;

  done: Boolean;
  context: Number[];

  total_duration: String;
  prompt_eval_count: Number;
  prompt_eval_duration: String;
  eval_count: Number;
  eval_duration: String;
}

const context = ref<Number[]>([]);
const working = ref(false);
const prompt = ref("");
const messages = ref<msg[]>([]);

async function scrollBottom() {
  // scroll to bottom of list after delay
  setTimeout(() => {
    const messagesDiv = document.querySelector(".v-sheet");
    if (messagesDiv) {
      messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }
  }, 100);
}

async function submit(line: String) {
  if (!(line && line.trim().length > 0)) {
    return;
  }
  // working.value = true;
  line = line.trim();
  messages.value.push({
    text: line,
    from: "clovyr",
    timestamp: new Date(),
  });
  scrollBottom();

  fetch("/api/generate",
    { method: "POST",
      body: JSON.stringify({
        model: "llama2",
        prompt: line,
        context: [],
      }),
    }).then(async (res) => {
      const data: GenRes = await res.json();
      console.log(data);
      messages.value.push({
        text: data.response,
        from: "otto",
        timestamp: new Date(),
      });
      scrollBottom();
      context.value = data.context; // save it
      working.value = false;
    }).catch((err) => {
      console.log(err);
      working.value = false;
    });

  // messages.value.push({
  //   text: "reply",
  //   from: "otto",
  //   timestamp: new Date(),
  // });


}

async function onKeypress(e: KeyboardEvent) {
  if (working.value) {
    return;
  }
  // check if user pressed enter
  if (e && e.target && e.code === "Enter") {
    submit(prompt.value);
    prompt.value = "";
  }
}

async function onClickSend() {
  if (working.value) {
    return;
  }
  submit(prompt.value);
  prompt.value = "";
}
</script>

<template>
  <v-container class="fill-height">
    <v-responsive class="align-top text-center fill-height">
      <v-img height="100" src="@/assets/clovyr-logo.svg" />

      <div class="py-14" />

      <v-sheet :elevation="10" rounded class="messages-sheet mx-auto">
        <div class="messages mx-auto">

          <v-list>
            <v-list-item
              v-for="(msg, i) in messages"
              :key="i"
              :value="msg"
              color="primary"
              rounded="shaped"
            >
              <template v-slot:prepend>
                <v-avatar
                >
                  <v-img v-if="msg.from === 'clovyr'" src="@/assets/clovyr-icon.svg" />
                  <v-img v-else="msg.from === 'otto'" src="@/assets/otto_headshot.webp" />
                </v-avatar>
              </template>

              <v-list-item-title v-text="msg.text" class="msg-text"></v-list-item-title>
            </v-list-item>
          </v-list>

        </div>
      </v-sheet>

      <div class="py-14" />

      <v-row class="d-flex align-center justify-center">
        <v-col cols="auto">
          <v-text-field v-model="prompt" variant="outlined" label="Enter Prompt" class="prompt" hide-details @keypress="onKeypress" :disabled="working"></v-text-field>
        </v-col>

        <v-col cols="auto">
          <v-btn v-if="!working" class="ma-2" color="primary" icon="mdi-send" @click="onClickSend" />
          <v-progress-circular v-else indeterminate color="primary" />
        </v-col>

      </v-row>
    </v-responsive>
  </v-container>
</template>

<style scoped lang="scss">
.messages-sheet {
  min-height: 20dvh;
  max-height: 60dvh;
  min-width: 40%;
  max-width: 75%;
  overflow-y: scroll;

  .messages {
    height: 100%;
    width: 100%;

    .msg-text {
      text-align: left;
    }
  }
}
.prompt {
  width: 50vw;
}
</style>
