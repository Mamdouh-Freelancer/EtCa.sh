# EtCa.sh
EtCa.sh is the first Etisalat Cash wrapper for Linux, written in bash script.

![carbon3](https://user-images.githubusercontent.com/23267401/130317864-79c77d16-40db-41cd-8b72-f73c48599c34.png)

## Etisalat Cash service was designed for consumer, So don't use it as payment gateway (for your customers as example), it isn't made for that purpose.


               #**********#
               # Consider #
               #**********#****************************************************************
                * 1. This script still in beta and there is no any kind of                *
                *   guarantee, so use at your own risk.                                   *
                * 2. Known issues will be mentioned in readme file, and before using this *
                * script please refer to service provider for their TOS.                  *
                * 3. contact author by mail mamdouh.saeed.eg@gmail.com                    *
                ***************************************************************************

### Supported Features:
- [x] Send money to any wallet in Egypt.
- [x] Check wallet balance.
- [x] Generate virtual credit card VCC numbers.
- [x] List transactions history
- [x] Donate to 16 charities in Egypt.
- [x] Pay to merchant.
- [x] Reset pin code.  
- [x] Recharge to others (prepaid balance transfer).

### Known Issues
* Most important server responses are handled well but not all.
* `updateCookies` function needs some improvements to check cookies expiration and reupdate it.

### How to 

Download zip file manually or clone using git:

`git clone https://github.com/Mamdouh-Freelancer/EtCa.sh.git`

Set read/write/execute permissions to script
`chmod 777 ./EtCa.sh`
 

### [OPTIONS]

#### `--wallet`         
wallet number in local format e.g. 01123456789.

#### `--sendto`
destination wallet number that will receive money from you, e.g. 01123456789.

#### `--rechargeto`
destination dial number on prepaid rateplan which will receive balance, e.g. 01123456789.

#### `--auth`           
to authenticate for first time login or if cookies expired (consider `updateCookies` function). this is a must to request and verify OTP.

#### `--otp`            
One-Time-Password included in SMS that you recieved for verification.

#### `--pin`            
wallet pin code should be 6 digits. contact service provider for more info. pin code is a must to take any actions/inquiries.

#### `--balance`        
check wallet balance, `--pin` code needed.

#### `--vcc`            
create VCC virtual credit card. card details will be sent in SMS. `--pin`, `--amount` are needed.

#### `--amount`         
specify amount when using `--sendto` and `--vcc`.

#### `--transactions`   
list transactions history in XML format. `--pin` code needed.

#### `--donation`
list all available foundations with their ID's from donations.txt, attach `--org`, `--amount` and `--pin` to pay a donation. check below examples for more info.

#### `--org`
a number represents foundation index in the list.

#### `--merchant`
merchant ID to pay to. `--amount` and `--pin` needed.

#### `--tips`
this is optional amount paid as tip.

#### `--reset-pin`
you must know the old `--pin` to reset to a `--new` one.

#### `--new`
new pin number for wallet.

#### `--signout` or `--logout`
session logout and clean up local session & cookies files.

## Examples

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

to prettify XML output use any XML parser like `tidy`:

`./EtCa.sh --wallet 01123456789 --transactions --pin 654321 | tidy -xml -i -q`

7) Make a donation, to list foundations use:


`./EtCa.sh --wallet 01123456789 --donation`

`Foundations names & ID's`

`     1  Magdy Ya’acoub-Child Operation=9156`

`     2  Magdy Ya’acoub-Medical Equipment=9157`

`     3  Magdi Yacoub Heart Foundation - General Donation=957`

`     4  Magdy Ya’acoub-New Hospital Construction=9155`

`     5  Ahl Masr Foundation=9899`

`     6  Support Day Labor - Food Bank=923`

`     7  Saq Odheya Balady - Food Bank=925`

`     8  Egyptian Food Bank - General Donation=921`

`     9  Food bank - Zakat Al Fetr=927`

`    10  Baheya Foundation=9995`

`    11  Orman Association=990`

`    12  Egyptian Cure Bank=951`

`    13  Saq Mostawrad - Food Bank=966`

`    14  Mersal Foundation=9200`

`    15  Egyptian Clothing Bank=961`

`    16  Bayt Al Zakat - Sadakat=977`
    
    
Choose the index of one of the above items

`#Make a donation to as example Orman Association`

`./EtCa.sh --wallet 01123456789 --donation --org 11 --amount 500`

8) Pay to merchant:

`./EtCa.sh --wallet 01123456789 --merchant 1234567890 --amount 500 --pin 123456`
  
  Pay tips
  
`./EtCa.sh --wallet 01123456789 --merchant 1234567890 --amount 500 --tips 50 --pin 123456`
`

#Notes
 1) Some `curl` headers are encoded, to decode it use `base64` & `base32` and just `echo`.
 2) This repository is useful for automation tasks for your own wallet and as mentioned before don't use it as payment gateway for your customers (as example) coz it doesn't made for this purpose.



