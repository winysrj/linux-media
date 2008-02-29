Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <johnfdonaghy@gmail.com>) id 1JVBFb-0005gD-4j
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 20:50:35 +0100
Received: by mu-out-0910.google.com with SMTP id w9so5795771mue.6
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 11:50:29 -0800 (PST)
Message-ID: <a6e3d9900802291150l33e8dc7fu39ccbef9310d706c@mail.gmail.com>
Date: Sat, 1 Mar 2008 13:50:29 +1800
From: "John Donaghy" <johnfdonaghy@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb]  xc3028 tuner development status?
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

>>On Nov 13, 2007 11:16 AM, aldebaran <aldebx at yahoo.fr>> wrote:
>>>>
>>>>  I thank you very much for your quick reply Michel, Markus and Mauro!!
>>
>>[snip]
>>
>>  [  789.484000] cx23885 driver version 0.0.1 loaded
>>  [  789.484000] ACPI: PCI Interrupt 0000:04:00.0[A] ->> GSI 17 (level, low)
>> ->> IRQ 17
>>  [  789.484000] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge
>> WinTV-HVR1800lp [card=1,insmod option]
>>  [  789.584000] cx23885[0]: i2c bus 0 registered
>>  [  789.584000] cx23885[0]: i2c bus 1 registered
>>  [  789.584000] cx23885[0]: i2c bus 2 registered
>>  [  789.612000] tveeprom 0-0050: Hauppauge model 77001, rev D4C0, serial#
>> 2335707
>>  [  789.612000] tveeprom 0-0050: MAC address is 00-0D-FE-23-A3-DB
>>  [  789.612000] tveeprom 0-0050: tuner model is Xceive XC3028 (idx 120, type
>> 71)
>>  [  789.612000] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
>> (eeprom 0x88)
>>  [  789.612000] tveeprom 0-0050: audio processor is CX23885 (idx 39)
>>  [  789.612000] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
>>  [  789.612000] tveeprom 0-0050: has no radio, has no IR receiver, has no IR
>> transmitter
>>  [  789.612000] cx23885[0]: hauppauge eeprom: model=77001
>>  [  789.612000] cx23885[0]: cx23885 based dvb card
>>  [  789.624000] cx23885[0]: frontend initialization failed
>>  [  789.624000] cx23885_dvb_register() dvb_register failed err = -1
>>  [  789.624000] cx23885_dev_setup() Failed to register dvb adapters on VID_C
>>  [  789.624000] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 17,
>> latency: 0, mmio: 0xf4000000
>>  [  789.624000] PCI: Setting latency timer of device 0000:04:00.0 to 64
>
>Don't worry about this -- Steve's got it covered:
>
>http://linuxtv.org/pipermail/linux-dvb/2007-November/021863.html
>
>-mike

Hi

I've just joined this list because I have a HP Expresscard
Digital/Analog tuner and it looks like it's the same card referred to
previously in this thread, which apparently is a rebranded Hauppauge
card. So far I havent been able to get it to work but since I dont
really know what I'm doing I though I'd better ask for help. What I've
done so far is as follows:

got the source: hg clone http://linuxtv.org/hg/v4l-dvb
make
make install
reboot
then dmesg gives me this:

[   18.520000] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge
WinTV-HVR1500 [card=6,autodetected]
[   18.628000] cx23885[0]: i2c bus 0 registered
[   18.628000] cx23885[0]: i2c bus 1 registered
[   18.628000] cx23885[0]: i2c bus 2 registered
[   18.652000] tveeprom 0-0050: Hauppauge model 77001, rev D3C0, serial# 837872
[   18.652000] tveeprom 0-0050: MAC address is 00-0D-FE-0C-C8-F0
[   18.652000] tveeprom 0-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[   18.652000] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   18.652000] tveeprom 0-0050: audio processor is CX23885 (idx 39)
[   18.652000] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
[   18.652000] tveeprom 0-0050: has no radio, has no IR receiver, has
no IR transmitter
[   18.652000] cx23885[0]: hauppauge eeprom: model=77001
[   18.652000] cx23885[0]: cx23885 based dvb card
[   18.652000] ipw3945: Intel(R) PRO/Wireless 3945 Network Connection
driver for Linux, 1.2.2mp.ubuntu1
[   18.652000] ipw3945: Copyright(c) 2003-2006 Intel Corporation
[   18.872000] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   18.872000] DVB: registering new adapter (cx23885[0])
[   18.872000] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
[   18.876000] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   18.876000] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 17,
latency: 0, mmio: 0xd8000000
[   18.876000] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   18.876000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 21
[   18.876000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   19.056000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   19.056000] PCI: Setting latency timer of device 0000:02:00.0 to 64

Unlike the previous poster I'm not getting "frontend initialization
failed" which is promising, but when I run:

/usr/bin/scan /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB

I get a bunch of "tuning failed" messages like this:

scanning /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 57028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 57028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!

Am I missing something (like firmware perhaps) or does it not work
yet? Let me know if there's anything I can do to help get it working.

Thanks in advance.

John

PS Also, thanks for all the hard work done so far!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
