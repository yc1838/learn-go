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

		local_dir := strings.Split(dir, "/")[len(strings.Split(dir, "/"))-1]
		if dir == u.HomeDir {
			local_dir = "~"
		}

		// 使用 24-bit (RGB) ANSI 颜色代码 - Lesbian Flag 主题
		// \033[38;2;R;G;Bm
		// 第二深的橙色 (Arrow): R=239, G=118, B=39
		// 淡粉色 (Username): R=229, G=139, B=189
		// 深粉色 (Directory): R=213, G=45, B=86
		// 暗紫色 ($): R=128, G=0, B=100
		// 淡紫色 (User Input): R=193, G=151, B=210
		fmt.Printf("\033[38;2;239;118;39m➜ \033[38;2;229;139;189m%s \033[38;2;213;45;86m%s \033[38;2;128;0;100m$ \033[38;2;193;151;210m", userName, local_dir)
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
