package server

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type ModelConfig struct {
	Model       string `json:"model"`
	Temperature string `json:"temperature"`
}

func handleConfig(c *gin.Context) {
	conf := &ModelConfig{
		Model:       os.Getenv("MODEL"),
		Temperature: os.Getenv("TEMPERATURE"),
	}

	if conf.Model == "" {
		conf.Model = "llama2"
	}
	if conf.Temperature == "" {
		conf.Temperature = "0.8"
	}
	if os.Getenv("SYSTEM_PROMPT") != "" {
		conf.Model = "custom_model"
	}

	c.JSON(http.StatusOK, conf)
}
