Zip_File = admin_$(shell date +%Y%m%d_%H%M%S).zip
build_time = $(shell date +%Y/%m/%d_%H:%M:%S)
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
git_email = $(shell git config user.email)
func_name = fitness_pro_dev
hostname = $(shell hostname)
username = $(USER)

print:
	@echo $(build_time)
	@echo $(git_branch)
	@echo $(func_name)
	@echo $(hostname)
	@echo $(username)

update_code:
	rm -f bootstrap
	rm -f *.zip
	GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build \
		 -ldflags "-X 'bankaool_crm/configs.GitBranch=$(git_branch)' \
		 -X 'bankaool_crm/configs.GitEmail=$(git_email)' \
		 -X 'bankaool_crm/configs.BuildTime=$(build_time)' \
		 -X 'bankaool_crm/configs.UserName=$(username)' \
		 -X 'bankaool_crm/configs.HostName=$(hostname)'" \
		-o bootstrap -tags lambda.norpc
	zip $(Zip_File) bootstrap
	aws lambda update-function-code --function-name $(func_name) --zip-file fileb://$(Zip_File) --region us-east-1 --profile AWS-Fitness-pro
