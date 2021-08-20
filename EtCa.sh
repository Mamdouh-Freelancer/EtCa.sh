        #!/bin/bash
        #        EtCa.sh is unofficial Etisalat Cash wrapper for developers
        #      written in bash script available for Linux.
        #
        #      #**********#
        #      # Consider #
        #      #**********#**************************************************************
        #        * 1. This script still in beta and there is no any kind of
        #        * guarantee, so use at your own risk.
        #        * 2. Known issues will be mentioned in readme file, and before using it
        #        * please refer to service provider for their TOS.
        #        * 3. contact author by mail mamdouh.saeed.eg@gmail.com
        #        ************************************************************************


        # add execute premission to this script
        # chmod +x ./EtCa.sh

        # Showing how to use instructions if -h argument exits.

    usage(){
        cat << EOF

            EtCa.sh is an Etisalat Cash wrapper for Linux shell.

        **Authentication**
            #Authentication [required]
                $0 --wallet 01123456789 --auth
            #OTP Submition [required]
                $0 --wallet 01123456789 --auth --otp 123456

            #Wallet Logout
            #   $0 --wallet 01123456789 --signout

        **Available Features**
            #Send Money
                $0 --wallet 01123456789 --sendto 01123456788 --amount 1500 --pin 123456
            #Check Balance
                $0 --wallet 01123456789 --balance --pin 123456
            #Generate Virtual Credit Card [VCC]
                $0 --wallet 01123456789 --vcc --amount 1000 --pin 123456
            #List Transactions History
                $0 --wallet 01123456789 --transactions --pin 123456
                to prettify using tidy
                $0 --wallet 01123456789 --transactions --pin 123456 | tidy -xml -i -q

EOF
        exit 1
        }

        if [ $# -eq 0 ]; then
            usage;
        fi

        unknown_args=()

        while [ $# -gt 0 ]; do
            case "$1" in
            --wallet)
            if [ $# -gt 1 ] && [ ${2:0:2} != "--" ]; then
            if [[ ${#2} -eq 11 ]] && [[ $2  =~ ^01 ]]; then
            wallet=$2
            shift 2
            else
            echo "$2 is invalid wallet number, please use a valid number e.g. 01123456789"
            exit 1
            fi
            else
            echo "Missing wallet number"
            exit 1
            fi
            ;;
            --signout|--logout)
            app_signout=yes
            shift
            ;;
            --auth)
            auth="yes"
            shift
            ;;
            --otp)
            if [ $# -gt 1 ] && [ ${2:0:2} != "--" ]; then
            otp=$2
            shift 2
            else
            echo "Missing OTP"
            exit 1
            fi
            ;;
            --sendto)
            if [ $# -gt 1 ] && [ ${2:0:2} != "--" ]; then
            if [[ ${#2} -eq 11 ]] && [[ $2  =~ ^01 ]]; then
            sendto=$2
            shift 2
            else
            echo "$2 is invalid reciever wallet number, please use a valid number e.g. 01123456789"
            exit 1
            fi
            else
            echo "Missing argument(s)"
            exit 1
            fi
            ;;
            --amount)
            if [ $# -gt 1 ] && [ ${2:0:2} != "--" ] && [ $2 -gt 0 ]; then
            amount=$2
            shift 2
            else
            echo "Invalid amount $2"
            exit 1
            fi
            ;;
            --pin)
            if [ $# -gt 1 ] && [ ${2:0:2} != "--" ]; then
            pin=$2
            shift 2
            else
            echo "Missing argument(s)"
            exit 1
            fi
            ;;
            --vcc)
            vcc=yes
            shift 1
            ;;
            --transactions)
            transactions=yes
            shift 1
            ;;
            --balance)
            balance=yes
            shift
            ;;
            *)
            unknown_args+=("$1")
            shift
            ;;
            esac
        done

        stRand(){
        head /dev/urandom | tr -dc a-z0-9 | head $@
        }

            BASEDIR=$(dirname $(realpath "$0"))
            cookiesFile=$BASEDIR/cookies-${wallet:0}.txt
            sessionFile=$BASEDIR/session-${wallet:0}.txt
            deviceId=`stRand -c8`-`stRand -c4`-`stRand -c4`-`stRand -c4`-`stRand -c12`
            serverHost=$'\x6d\x61\x62\x2e\x65\x74\x69\x73\x61\x6c\x61\x74\x2e\x63\x6f\x6d\x2e\x65\x67\x3a\x31\x31\x30\x30\x33'

        serverReq(){
            curl  -H "Host: $serverHost" -H "Applicationversion: 2" -H "Applicationname: MAB" -H "Accept: text/xml" -H "App-Buildnumber: 436" -H "App-Version: 22.4.0" -H "Os-Type: Android" -H "Os-Version: 11" -H "App-Store: GOOGLE" -H "Is-Corporate: false" -H "Content-Type: text/xml; charset=UTF-8"  -H "Accept-Encoding: gzip, deflate" -H "User-Agent: okhttp/3.12.8" -H "Adrum_1: isMobile:true" -H "Adrum: isAjax:true" -H "Connection: close" -H "$(echo -n $'\x51\x58\x42\x77\x62\x47\x6c\x6a\x59\x58\x52\x70\x62\x32\x35\x77\x59\x58\x4e\x7a\x64\x32\x39\x79\x5a\x44\x6f\x3d' | $'\x62\x61\x73\x65\x36\x34' -d -w 0) $(echo -n $'\x4d\x52\x4c\x48\x46\x4b\x4b\x4b\x4e\x4a\x34\x4f\x36\x55\x5a\x53\x43\x58\x51\x4f\x43\x48\x37\x35\x56\x4c\x47\x51\x52\x41\x59\x49' | $'\x62\x61\x73\x65\x33\x32' -d | $'\x62\x61\x73\x65\x36\x34' -w 0)" "$@"
        }
        updateCookies()
        {
                    sessionFileStr=$(cat $sessionFile)
                    if [[ -f $sessionFile ]] && [[ $(echo $sessionFileStr | sed -n 's/.*<authb>\([^<]*\)<\/authb>.*/\1/p') ]];then
                        srvpass=$(echo $sessionFileStr | sed -n 's/.*<pass>\([^<]*\)<\/pass>.*/\1/p')
                        deviceId=$(echo $sessionFileStr | sed -n 's/.*<uuid>\([^<]*\)<\/uuid>.*/\1/p')
                        authbasic=$(echo -n "${wallet:1},$deviceId:$srvpass" | base64 -w 0)
                    else
                    echo "No session data found"
                    exit 1
                    fi

                    resp=$(serverReq -c $cookiesFile -i -s -k -X $'POST' -H $"Authorization: Basic $authbasic" -H $'Content-Length: 307' --data-binary $"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><loginWlQuickAccessRequest><firstLoginAttempt>false</firstLoginAttempt><modelType>sdk_gphone_x86_64_arm64</modelType><osVersion>11</osVersion><platform>Android</platform><wlUdid>$deviceId</wlUdid></loginWlQuickAccessRequest>" "https://$serverHost/Saytar/rest/quickAccess/loginQuickAccessWithPlan")
        }

        if [[ $app_signout == "yes" ]]; then
            if [[ -f $sessionFile ]];then
                deviceId=$(cat $sessionFile | sed -n 's/.*<uuid>\([^<]*\)<\/uuid>.*/\1/p')
                resp=$(serverReq -b $cookiesFile -s -k -X $'POST' -H $'Content-Length: 181' --data-binary $"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><logoutQuickAccessRequest><dial>${wallet:1}</dial><udid>$deviceId</udid></logoutQuickAccessRequest>" "https://$serverHost/Saytar/rest/quickAccess/logoutQuickAccess")
                rm -f $cookiesFile $sessionFile
                exit 0
                else
                echo "Already loggedout"
                exit 0
            fi

        fi

        if [[ $auth == "yes" ]]; then
                if [ ! $otp ]; then
                $0 --wallet ${wallet} --logout &>/dev/null
                echo "<uuid>"$deviceId"</uuid>" > $sessionFile
                resp=$(serverReq -s -k -X $'GET' "https://$serverHost/Saytar/rest/quickAccess/sendVerCodeQuickAccessV2?sendVerCodeQuickAccessRequest=%3CsendVerCodeQuickAccessRequest%3E%3Cudid%3E$deviceId%3C%2Fudid%3E%3Cdial%3E${wallet:1}%3C%2Fdial%3E%3C%2FsendVerCodeQuickAccessRequest%3E")

                    if [[ $resp == "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><sendVerCodeQuickAccessResponseV2><status>true</status><dial>${wallet:1}</dial><pattern>(^|\s)([0-9]+)($|\s)</pattern><smsVerificationSender>My Etisalat</smsVerificationSender><verCode></verCode></sendVerCodeQuickAccessResponseV2>" ]];then
                    echo "OTP sent"
                    exit 0
                    else
                        echo "Authentication failed"
                        exit 1
                    fi
            else
                deviceId=`cat $sessionFile | sed -n 's/.*<uuid>\([^<]*\)<\/uuid>.*/\1/p'`
                resp=$(serverReq -s -k -X "POST" -H "Content-Length: 214" --data-binary "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><verifyCodeQuickAccessRequest><dial>${wallet:1}</dial><udid>$deviceId</udid><verCode>$otp</verCode></verifyCodeQuickAccessRequest>" "https://$serverHost/Saytar/rest/quickAccess/verifyCodeQuickAccess")

                    if [[ $resp == *"<message>Invalid code.</message>"* ]];then
                        echo "Invalid code"
                        exit 1
                    elif [[ $resp == "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><verifyCodeQuickAccessResponse><status>true</status><pass>"*"</pass></verifyCodeQuickAccessResponse>" ]];then

                    echo "OTP submited"

                    srvpass=$(echo $resp | sed -n 's/.*<pass>\([^<]*\)<\/pass>.*/\1/p')
                    authbasic=$(echo -n "${wallet:1},$deviceId:$srvpass" | base64 -w 0)
                    echo "<pass>"$srvpass"</pass>" >> $sessionFile
                    echo "<authb>"$authbasic"</authb>" >> $sessionFile
                        updateCookies

                    fi
            fi
        elif [[ $balance == "yes" ]] && [[ $pin ]]; then
            resp=$(serverReq -b $cookiesFile -i -s -k -X $'POST' -H $'Content-Length: 212' --data-binary "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><PaymentRequest><ClientLanguageID>2</ClientLanguageID><MSISDN>${wallet:1}</MSISDN><Password>$pin</Password><Username>${wallet:1}</Username></PaymentRequest>" "https://$serverHost/Saytar/rest/etisalatpay/service/CHECK_BALANCE")

            if [[ $resp == *"Successful your current balance is"* ]];then
                echo $(echo $resp | sed -n 's/.*<Message>\([^<]*\)<\/Message>.*/\1/p')
                exit 0
            elif [[ $resp == *"Pin Code is incorrect"* ]]; then
                echo "Invalid pin code"
                exit 1
            elif [[ $resp == *"Pin Code has been entered incorrectly 3 times SMS will be sent shortly"* ]]; then
            echo "Pin Code has been entered incorrectly 3 times SMS will be sent shortly"
            exit 1
                else
                echo "Not authorized"
                updateCookies
                exit 1
            fi

        elif [ $sendto ] && [ $amount -gt 0 ] && [ $pin ]; then
            if [ $wallet != $sendto ]; then
                    resp=$(serverReq -b $cookiesFile -i -s -k -X $'POST' -H $'Content-Length: 284' --data-binary $"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><PaymentRequest><Amount>$amount</Amount><BNumber>${sendto:1}</BNumber><ClientID>1234</ClientID><ClientLanguageID>2</ClientLanguageID><MSISDN>${wallet:1}</MSISDN><Password>$pin</Password><Username>${wallet:1}</Username></PaymentRequest>" "https://$serverHost/Saytar/rest/etisalatpay/service/TRANSFER")

                    if [[ $resp == *"Transaction can not be completed at the moment, please try again later. Thank you for understanding."* ]]; then
                        echo "Transaction can not be completed at the moment."
                    elif [[ $resp == *"Transfer successful"* ]];then
cat << EOF
            Transfer successful
            Amount: ${amount}EGP
            TransactionID: $(echo $resp | sed -n 's/.*<TransactionID>\([^<]*\)<\/TransactionID>.*/\1/p')
            Balance: $(echo $resp | sed -n 's/.*<Balance>\([^<]*\)<\/Balance>.*/\1/p')EGP
EOF
                        exit 0
                    elif [[ $resp == *"Pin Code is incorrect"* ]]; then
                    echo "Invalid pin code"
                    exit 1
                    elif [[ $resp == *"Pin Code has been entered incorrectly 3 times SMS will be sent shortly"* ]]; then
                    echo "Pin Code has been entered incorrectly 3 times SMS will be sent shortly"
                    exit 1
                    fi
                else
                    echo "Sender and reciever are same"
                    exit 1
            fi
        elif [[ $transactions == "yes" ]] && [[ $pin ]]; then
            resp=$(serverReq -b $cookiesFile -i -s -k -X $'POST' -H $'Content-Length: 237' --data-binary $"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><PaymentRequest><ClientID>1234</ClientID><ClientLanguageID>2</ClientLanguageID><MSISDN>${wallet:1}</MSISDN><Password>$pin</Password><Username>${wallet:1}</Username></PaymentRequest>" "https://$serverHost/Saytar/rest/etisalatpay/service/TRANSACTIONS_HISTORY")
            if [[ $resp == *"Error 401--Unauthorized"* ]];then
            echo "Not authorized"
            updateCookies
            exit 1
            elif [[ $resp == *"Pin Code is incorrect"* ]]; then
            echo "Invalid pin code"
            exit 1
            elif [[ $resp == *"Pin Code has been entered incorrectly 3 times SMS will be sent shortly"* ]]; then
            echo "Pin Code has been entered incorrectly 3 times SMS will be sent shortly"
            exit 1
            fi
            echo $resp
            exit 0

        elif [ $vcc ] && [ $amount -gt 0 ] && [ $pin ]; then
            resp=$(serverReq -b $cookiesFile -i -s -k -X $'POST' -H $'Content-Length: 255' --data-binary $"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><PaymentRequest><Amount>$amount</Amount><ClientID>1234</ClientID><ClientLanguageID>2</ClientLanguageID><MSISDN>${wallet:1}</MSISDN><Password>$pin</Password><Username>${wallet:1}</Username></PaymentRequest>" "https://$serverHost/Saytar/rest/etisalatpay/service/VCN")

                if [[ $resp == *"Card Number Generated Successfully and CVC is"* ]];then
                    echo "TransactionID: "$(echo $resp | sed -n 's/.*<TransactionID>\([^<]*\)<\/TransactionID>.*/\1/p')
                    echo "ServiceFees: "$(echo $resp | sed -n 's/.*<ServiceFees>\([^<]*\)<\/ServiceFees>.*/\1/p')
                    echo "CardNumber: SMS Sent"
                    echo "CVC: "$(echo $resp | sed -n 's/.*<CVC>\([^<]*\)<\/CVC>.*/\1/p')
                    exit 0
                elif [[ $resp == *"Pin Code is incorrect"* ]]; then
                    echo "Invalid pin code"
                    exit 1
                elif [[ $resp == *"Pin Code has been entered incorrectly 3 times SMS will be sent shortly"* ]]; then
                    echo "Pin Code has been entered incorrectly 3 times SMS will be sent shortly"
                    exit 1
                fi
        else
            echo "Invalid/missing argument(s)"
        fi






