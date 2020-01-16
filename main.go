package main

import (
	"github.com/gin-gonic/gin"
	"fmt"
	"net/http"
	"io/ioutil"
	"encoding/json"
)

var ServerInfo string

var Address *AddressInfo

type AddressInfo struct {
	Port string `json:"address"`
}

func init()  {
	data, err := ioutil.ReadFile("./config/server.json")
	if err != nil {
		panic("json file is error")
		return
	}
	ServerInfo = string(data)
	fmt.Println("读取json配置", ServerInfo)
	data, err = ioutil.ReadFile("./config/port.json")
	if err != nil {
		panic("port file is error")
		return
	}
	json.Unmarshal(data, &Address)
	fmt.Println("读取port配置", Address.Port)
}

func main() {
	r := gin.Default()
	r.GET("/gateway_server", func(c *gin.Context) {
		c.String(http.StatusOK, ServerInfo)
	})
	r.Run(Address.Port) // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}