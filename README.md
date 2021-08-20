# EtCa.sh
EtCa.sh is an Etisalat Cash wrapper example for Linux, written in bash script.

![carbon](https://user-images.githubusercontent.com/23267401/130256267-558c361f-2460-4b7c-8314-61f7c993b7fa.png)

               #**********#
               # Consider #
               #**********#****************************************************************
                * 1. This script still in beta and there is no any kind of                *
                *   guarantee, so use at your own risk.                                   *
                * 2. Known issues will be mentioned in readme file, and before using this *
                * script please refer to service provider for their TOS.                  *
                * 3. contact author by mail mamdouh.saeed.eg@gmail.com                    *
                ***************************************************************************

**Supported Features:**
* Send money to any wallet in Egypt.
* Check wallet balance.
* Create virtual credit card VCC.
* List transactions history


**Known Issues**
* Most important server responses are handled well but not all.
* `updateCookies` function needs some improvements to check cookies expiration and reupdate it.

**How to**
first set read/write/execute permissions to script
`chmod 777 ./EtCa.sh`

**[OPTIONS]**

`--wallet`         
wallet number in local format e.g. 01123456789.

`--auth`           
to authenticate for first time login or if cookies expired (consider `updateCookies` function). this is a must to request and verify OTP.

`--otp`            
One-Time-Password included in SMS that you recieved for verification.

`--pin`            
wallet pin code should be 6 digits. contact service provider for more info. pin code is a must to take any actions/inquiries.

`--balance`        
check wallet balance, `--pin` code needed.

`--vcc`            
create VCC virtual credit card. card details will be sent in SMS. `--pin`, `--amount` are needed.

`--amount`         
specify amount when using `--sendto` and `--vcc`.

`--transactions`   
list transactions history in XML format.

`--signout` or `--logout`
session logout and clean up local session & cookies files.

**Examples**

1) Authentication:
`./EtCa.sh --wallet 01123456789 --auth`
2) Verify recieved OTP:
`./EtCa.sh --wallet 01123456789 --auth --otp 123456`
3) Send money to another wallet:
`./EtCa.sh --wallet 01123456789 --sendto 01123456788 --amount 500 --pin 654321`
4) Check balance:
`./EtCa.sh --wallet 01123456789 --balance --pin 654321`
5) Create virtual credit card:
`./EtCa.sh --wallet 01123456789 --vcc --amount 500 --pin 654321`
6) List transactions history:
`./EtCa.sh --wallet 01123456789 --transactions --pin 654321`

to prettify XML output pipe it to any XML parser like tidy as shown below:
`./EtCa.sh --wallet 01123456789 --transactions --pin 654321 | tidy -xml -i -q`





