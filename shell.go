package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"os/exec"
	"os/user"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	for {
		dir, _ := os.Getwd()
		u, _ := user.Current()
		userName := u.Username
		// 彩蛋：在咱们自己的 Shell 里强行把名字伪装成 lilith
		if userName == "yujingchen" {
			userName = "lilith"
		}

		local_dir := strings.Split(dir, "/")[len(strings.Split(dir, "/"))-1]
		if dir == u.HomeDir {
			local_dir = "~"
		}

		// 使用 24-bit (RGB) ANSI 颜色代码 - Lesbian Flag 主题
		// \033[38;2;R;G;Bm
		// 1. 最深的橙色 (Arrow): R=216, G=75, B=32 (调整为更正宗的深红橙色)
		// 2. 浅色的橙色 (Username): R=239, G=118, B=39 (#EF7627)
		// 3. 白色 (@): R=255, G=255, B=255 (#FFFFFF)
		// 4. 淡粉色 (Directory): R=209, G=98, B=164 (#D162A4)
		// 5. 深粉色 ($): R=163, G=2, B=98 (#A30262)
		// 6. 淡紫色 (User Input): R=193, G=151, B=210 (#C197D2)
		fmt.Printf("\033[38;2;216;75;32m➜ \033[38;2;239;118;39m%s\033[38;2;255;255;255m@\033[38;2;209;98;164m%s \033[38;2;163;2;98m$ \033[38;2;193;151;210m", userName, local_dir)
		input, err := reader.ReadString('\n')
		fmt.Print("\033[0m") // 读取完输入后立刻重置颜色，防止影响外部命令的输出
		if err != nil {
			if err == io.EOF {
				fmt.Println()
				break
			}
			fmt.Fprintln(os.Stderr, err)
			continue
		}
		if err := execInput(input); err != nil {
			fmt.Fprintln(os.Stderr, err)
		}
	}
}

func execInput(input string) error {
	input = strings.TrimSuffix(input, "\n")
	if len(input) == 0 {
		return nil
	}
	args := strings.Split(input, " ")
	if args[0] == "exit" {
		os.Exit(0)
	}
	if args[0] == "cd" && len(args) > 1 {
		return os.Chdir(args[1])
	}
	cmd := exec.Command(args[0], args[1:]...)

	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout

	return cmd.Run()

}

// TODOs:
// Modify the input indicator:
// 	add the working directory
// 	add the machine’s hostname
// 	add the current user
// Browse your input history with the up/down keys
// history
