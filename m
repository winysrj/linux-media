Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <FlyMyPG@gmail.com>) id 1L5Efv-0004y2-2O
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 08:19:04 +0100
Message-ID: <492CF843.5040807@gmail.com>
Date: Tue, 25 Nov 2008 23:18:27 -0800
From: Bob Cunningham <FlyMyPG@gmail.com>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
References: <49287DCC.9040004@gmail.com>
	<37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
	<4929B192.8050707@rogers.com> <4929FE90.2050008@gmail.com>
	<492A328A.7090502@rogers.com> <492B9B98.5060603@gmail.com>
	<492CA816.7000400@rogers.com>
In-Reply-To: <492CA816.7000400@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

CityK wrote:
> Bob Cunningham wrote:
>> CityK wrote:
>>> Bob Cunningham wrote:
>>>> There are 3 chips, from the USB to the cable connector they are:
>>>> AU0828A
>>>> AU8522AA
>>>> MT2131F
>>>>
>>> What tuner is being listed in your dmesg output ?
>> Here's everything from dmesg:
>>
>>    usb 1-2: new high speed USB device using ehci_hcd and address 22
>>    usb 1-2: configuration #1 chosen from 1 choice
>>    au0828: i2c bus registered
>>    tveeprom 4-0050: Encountered bad packet header [ff]. Corrupt or not
>> a Hauppauge eeprom.
>>    hauppauge_eeprom: warning: unknown hauppauge model #0
>>    hauppauge_eeprom: hauppauge eeprom: model=0
>>    tda18271 4-0060: creating new instance
>>    Unknown device detected @ 4-0060, device not supported.
>>    Unknown device detected @ 4-0060, device not supported.
>>    tda18271_attach: error -22 on line 1171
>>    tda18271 4-0060: destroying instance
>>    DVB: registering new adapter (au0828)
>>    DVB: registering adapter 0 frontend 1 (Auvitek AU8522 QAM/8VSB
>> Frontend)...
>>    Registered device AU0828 [Hauppauge Woodbury]
>>    usb 1-2: New USB device found, idVendor=05e1, idProduct=0400
>>    usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>    usb 1-2: Product: USB 2.0 Video Capture Controller
>>    usb 1-2: Manufacturer: Syntek Semiconductor
>>
> 
> Please use 'reply all', so you don't drop the list -- I have cc'ed your
> reply back in (snipping out the unnecessary stuff)
> 
> As can be seen, there is:
> a) a problem with reading from the EEPROM
> b) the device is initially setting up  with a NXP tda18271 tuner ...
> which obviously is not the same as the  MT2131 in your device ...
> understandably, the tuner driver craps out.
> 
> I suspect that when you were attempting to tune, all you were doing was
> polling from the last state the tuner was left in (whatever the tda
> driver's attempt to initialize it was before it crapped out)... and, as
> there is no driver operating further, there is no fine control over the
> tuner ... hence, the scan utility could instruct the frontend to check a
> certain frequency, but all you're getting back is crap from the tuner  
> ....   sort of like an analog radio that's in between stations and
> emitting static -- unless you directly manipulate/have control over the
> tuning knob,  standing 10 feet away and verbally instructing the radio
> to tune this or that frequency is going to produce the same thing being
> emitted all along -- static.
> 

What are the next steps?
1. How much effort will be needed to make this driver work?
2. Do all of the pieces already exist?  (All the chips seem to be mentioned somewhere in the DVB tree.)
3. What new code is needed?
4. How much reverse-engineering needs to be done?  Will a full schematic be needed?

Most importantly:
5. How can I help?

I'm a real-time embedded systems programmer with 25 years experience, though most of what I've written runs on "bare metal", often without an OS.  I know nothing about Linux device drivers.  However, I am very good at getting local hardware to "play nice", first by poking it with a debugger, then generally by scripting through /dev/port.  

I've never worked with hardware across the USB bus, though I have brought up USB interface hardware from the CPU side, and have had to snoop USB traffic to diagnose problems.  Unfortunately, I don't have a Windows system available to use to snoop the USB traffic from the driver provided by the vendor, though I haven't yet tried to get anything to work via Wine.

I'll be taking lots of time off in December, and should have some time to put toward this project.

If anyone else is curious, or wants to help, the product is here: http://www.dealextreme.com/details.dx/sku.15569

I also found a brief description of a reference design here: http://www.auvitek.com/AU8522%20MT%20USB%20TV%20Stick%20Design%20Brief_R1.0.pdf


-BobC

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
