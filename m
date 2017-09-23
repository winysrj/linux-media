Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32854 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdIWVN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 17:13:29 -0400
Subject: Re: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label
 documentation, DT example
To: Rob Herring <robh@kernel.org>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
 <20170918102349.8935-5-sakari.ailus@linux.intel.com>
 <20170918105655.GA14591@amd>
 <20170918144923.dnhrxkirle3fvdfo@valkosipuli.retiisi.org.uk>
 <20170918205407.GA1849@amd> <809f7590-7641-e8bc-c009-4fed05d5827c@gmail.com>
 <20170920205327.qmgz65kn45aavomx@rob-hp-laptop>
 <6a6651f9-b5fb-0ec7-1f40-f72b1a630e70@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <4e69932a-18af-416a-b280-16236fc4c2b3@gmail.com>
Date: Sat, 23 Sep 2017 23:12:33 +0200
MIME-Version: 1.0
In-Reply-To: <6a6651f9-b5fb-0ec7-1f40-f72b1a630e70@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2017 11:07 PM, Jacek Anaszewski wrote:
> On 09/20/2017 10:53 PM, Rob Herring wrote:
>> On Tue, Sep 19, 2017 at 11:01:02PM +0200, Jacek Anaszewski wrote:
>>> Hi Pavel,
>>>
>>> On 09/18/2017 10:54 PM, Pavel Machek wrote:
>>>> On Mon 2017-09-18 17:49:23, Sakari Ailus wrote:
>>>>> Hi Pavel,
>>>>>
>>>>> On Mon, Sep 18, 2017 at 12:56:55PM +0200, Pavel Machek wrote:
>>>>>> Hi!
>>>>>>
>>>>>>> Specify the exact label used if the label property is omitted in DT, as
>>>>>>> well as use label in the example that conforms to LED device naming.
>>>>>>>
>>>>>>> @@ -69,11 +73,11 @@ Example
>>>>>>>  			flash-max-microamp = <320000>;
>>>>>>>  			led-max-microamp = <60000>;
>>>>>>>  			ams,input-max-microamp = <1750000>;
>>>>>>> -			label = "as3645a:flash";
>>>>>>> +			label = "as3645a:white:flash";
>>>>>>>  		};
>>>>>>>  		indicator@1 {
>>>>>>>  			reg = <0x1>;
>>>>>>>  			led-max-microamp = <10000>;
>>>>>>> -			label = "as3645a:indicator";
>>>>>>> +			label = "as3645a:red:indicator";
>>>>>>>  		};
>>>>>>>  	};
>>>>>>
>>>>>> Ok, but userspace still has no chance to determine if this is flash
>>>>>> from main camera or flash for front camera; todays smartphones have
>>>>>> flashes on both cameras.
>>>>>>
>>>>>> So.. Can I suggset as3645a:white:main_camera_flash or main_flash or
>>>>>> ....?
>>>>>
>>>>> If there's just a single one in the device, could you use that?
>>>>>
>>>>> Even if we name this so for N9 (and N900), the application still would only
>>>>> work with the two devices.
>>>>
>>>> Well, I'd plan to name it on other devices, too.
>>>>
>>>>> My suggestion would be to look for a flash LED, and perhaps the maximum
>>>>> current as well. That should generally work better than assumptions on the
>>>>> label.
>>>>
>>>> If you just look for flash LED, you don't know if it is front one or
>>>> back one. Its true that if you have just one flash it is usually on
>>>> the back camera, but you can't know if maybe driver is not available
>>>> for the main flash.
>>>>
>>>> Lets get this right, please "main_camera_flash" is 12 bytes more than
>>>> "flash", and it saves application logic.. more than 12 bytes, I'm sure. 
>>>
>>> What you are trying to introduce is yet another level of LED class
>>> device naming standard, one level below devicename:colour:function.
>>> It seems you want also to come up with the set of standarized LED
>>> function names. This would certainly have to be covered for consistency.
>>
>> I really dislike how this naming convention is used for label. label is 
>> supposed to be the phyically identifiable name. Having the devicename 
>> defeats that. Perhaps color, too. We'd be better off with a color 
>> property. It seems we're overloading the naming with too many things. 
>> Now we're adding device association.
> 
> Regarding devicename - there is indeed inconsistency in the way how LED
> DT bindings use label, as some of them use it for defining full LED
> class device name, and the rest fill only colour and function, leaving
> addition of a devicename to the driver.
> 
> The problem is also in current definition of label in LED common
> bindings documentation, which says:
> 
> "It has to uniquely identify a device, i.e. no other LED class device
> can be assigned the same label."
> 
> In view of your above words this is not true, and we probably should
> remove this sentence (it doesn't have DT maintainer ack btw).
> 
>> I do want to see standard names though. On 96boards for example, there 
>> are defined LEDs and locations. The function on some are defined (e.g. 
>> WiFi/BT) and somewhat undefined on others (user{1-4}). I'd like to see 
>> the same label across all boards.
> 
> Currently we have following LED functions (obtained with
> grep label Documentation/devicetree/bindings/leds/* | sed
> s'/^.*label/label/g' | awk -F"=" '{print $2}' | sed '/^$/d' | sed
> s'/.*:\(.*\)";/\1/' | sed '/^\s\{1,\}/d' | sort -u)
> 
> 0
> 1
> 2
> 2g
> 3
> 4
> 5
> 6
> 7
> adsl
> alarm
> alive
> aux
> broadband
> chrg
> dsl
> flash
> green
> indicator
> inet
> keypad
> phone
> power
> red
> sata
> sata0
> sata1
> tel
> tv
> upgrading
> usb
> usr0
> usr1
> usr35
> wan
> white
> wireless
> wps
> yellow
> 
> By extracting numerical pattern names and replacing numbers with N
> we're getting something like this:
> 
> N
> Ng
> colour
> adsl
> alarm
> alive
> aux
> broadband
> chrg
> dsl
> flash
> indicator
> inet
> keypad
> phone
> power
> sataN
> tel
> tv
> upgrading
> usb
> usrN
> wan
> wireless
> wps
> 
> Is this list something you'd like to see as a base of standard LED
> functions? It seems that this list would have to be continuously
> supplemented with new positions.
> 

Even better option is to grep through all *.dts* files in the arch
directory. A slightly modified command chain. which removes numerical
postfixes (there are some not covered corner cases though)

find arch -name "*.dts*" | xargs grep label | sed s'/^.*label/label/g' |
awk -F"=" '{print $2}' | sed s'/.*:\(.*\)";/\1/' | sed '/^\s\{1,\}/d' |
sed s'/\([^0-9]*\)\([0-9]*\)/\1/' | sed '/^$/d' | sort -u

gives following 135 positions (~5 colours percolated due
to some non-covered corner cases), and some of them don't belong
to LED DT nodes unfortunately, as e.g. gpio-keys use also ":" as
a delimiter in their labels, but the whole set gives reasonable
overview I think:

active
activity_led
adsl
alarm
alive
all
amber
app
aux
backup
backup_led
bl
blue
bluetooth
boot
bottom
brick-status
bt
CEL
chrg
COM
copy
core_module
cpu
D
debug
DIA
disk
disk_led
down
dsl
enocean
enter
err
error
esata
ethernet-status
fail
fault
front
func
function
g
ghz
ghz-1
ghz-2
gpio
green
gsm
HD
hdd
hdderr
health
health_led
heart
heartbeat
home
inet
info
internet
keypad
L
lan
led
ledb
left
l_hdd
live
logo
microSD
misc
mmc
nand
network
on
orange
os
panel
pmu_stat
power
power_led
programming
proximitysensor
pulse
pwr
qss
rebuild_led
red
r_hdd
right
router
rs
rx
sata
sata-l
sata-r
sd
SD
sleep
standby
stat
state
status
Status
sw
sys
system
system-status
tel
top
tv
tx
up
usb
USB
usb_1
usb_2
usb_copy
usb-port1
usb-port2
user
USER
usr
wan
white
wifi
wifi_ap
wifi-status
wireless
wlan
wlan_g
wmode
wps
WPS
yellow

-- 
Best regards,
Jacek Anaszewski
