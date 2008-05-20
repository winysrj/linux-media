Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail16.syd.optusnet.com.au ([211.29.132.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JyGIB-0005zv-EL
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 03:05:29 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail16.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4K15Ede016819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 11:05:19 +1000
Received: from pjama.net (localhost [127.0.0.1])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4K15658007082
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 11:05:07 +1000 (EST)
Message-ID: <57913.192.168.200.51.1211245507.squirrel@pjama.net>
In-Reply-To: <48320E91.3010306@iki.fi>
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
	<48320E91.3010306@iki.fi>
Date: Tue, 20 May 2008 11:05:07 +1000 (EST)
From: "pjama" <pjama@optusnet.com.au>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] IR for Afatech 901x
Reply-To: pjama@optusnet.com.au
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

<snip>

> yes, I fixed one bug that has killed remote. Now it works again.
>
>> I got, compiled and installed the latest (although there's a NEW one
>> just
>> 4 minutes old) code 737994f33e83 to see if there's any action for my IR
>> remote bundled with my DigitalNow TinyTwin USB stick. I'm running
>> mythbuntu 8.04

OK just for fun I've now got, compiled and installed 884d9a07c4e1.

>
> Probably there is wrong ir-table loaded to the device by the driver.
> Ir-table in device and ir-codes from remote should match. Otherwise it
> will not work.

How do I confirm this? Should there be something in dmesg?

>
>> I'm not even sure if I'm on the right track here but entries like the
>> following in dmesg got me excited!
>> input: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
>> dvb-usb: schedule remote query interval to 150 msecs.
>> dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and
>> connected.
>
> Yes, thats correct. AF9015 implements also HID-remote but I have never
> got it working. I think it could be due to hw bug. Luckily there is
> other way to read remote - polling from the driver.

So based on the following dmesg extract I should use input7 which equates
to /dev/input/event7 ?

[   33.019604] input: Afatech DVB-T 2 as
/devices/pci0000:00/0000:00:02.1/usb2/2-2/2-2:1.1/input/input1
[   33.032972] input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on
usb-0000:00:02.1-2
[   33.038411] input: HID 0430:0100 as
/devices/pci0000:00/0000:00:02.0/usb1/1-5/1-5:1.0/input/input2
[   33.048961] input,hidraw1: USB HID v1.00 Mouse [HID 0430:0100] on
usb-0000:00:02.0-5
[   33.054403] input: HID 0430:0005 as
/devices/pci0000:00/0000:00:02.0/usb1/1-6/1-6:1.0/input/input3
[   33.068909] input,hidraw2: USB HID v1.00 Keyboard [HID 0430:0005] on
usb-0000:00:02.0-6
[   33.068930] usbcore: registered new interface driver usbhid
[   33.068936] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c:
v2.6:USB HID core driver
.......
[   47.868646] mxl500x_attach: MXL500x tuner succesfully attached
[   47.868732] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
[   47.889081] dvb-usb: schedule remote query interval to 150 msecs.
[   47.889090] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully
initialized and connected.
[   47.889094] af9015_init:
[   47.889097] af9015_init_endpoint: USB speed:3
[   47.944449] af9015_download_ir_table:
[   48.215278] usbcore: registered new interface driver dvb_usb_af9015

>
>> I'm not having ANY luck extracting any life out of IR though:
>>
>> # sudo irrecord -d
>> /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
>> test.conf
>> irrecord -  application for recording IR-codes for usage with lirc
>> Copyright (C) 1998,1999 Christoph Bartelmus(lirc@bartelmus.de)
>> irrecord: could not get file information for
>> /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
>> irrecord: default_init(): No such file or directory
>> irrecord: could not init hardware (lircd running ? --> close it, check
>> permissions)
>>
>> Same story with /dev/input/event7, I've turned lirc off and irw just
>> refuses  to connect.
>>
>> Is there anything I should try or anything I can test?
>
> I just tested using...
>
> 1)
> [root@localhost ~]# hexdump -v -e '"\t" "0x" 1/1 "%02x " "\n"' <
> /dev/input/by-path/pci-1-5--event-ir

What's this do in the grand scheme of things? I get no output what so ever
and it returns straight to the prompt.

>
> 2)
> [root@localhost ~]# av7110_evtest /dev/input/by-path/pci-1-5--event-ir
> Input driver version is 1.0.0
> Input device ID: bus 0x3 vendor 0x15a4 product 0x9016 version 0x200
> Input device name: "IR-receiver inside an USB DVB receiver"
> Supported events:
>    Event type 0 (Reset)
>      Event code 0 (Reset)
>      Event code 1 (Key)
>    Event type 1 (Key)
>      Event code 2 (1)
>      Event code 3 (2)
>      Event code 4 (3)
>      Event code 5 (4)
>      Event code 6 (5)
>      Event code 7 (6)
>      Event code 8 (7)
>      Event code 9 (8)
>      Event code 10 (9)
>      Event code 11 (0)
>      Event code 113 (Mute)
>      Event code 114 (VolumeDown)
>      Event code 115 (VolumeUp)
>      Event code 116 (Power)
>      Event code 354 (Goto)
>      Event code 372 (Zoom)
>      Event code 402 (ChannelUp)
>      Event code 403 (ChannelDown)
> Testing ... (interrupt to exit)

This looks promising....
$ evtest /dev/input/event7
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x13d3 product 0x3226 version 0x200
Input device name: "IR-receiver inside an USB DVB receiver"
Supported events:
  Event type 0 (Reset)
    Event code 0 (Reset)
    Event code 1 (Key)
  Event type 1 (Key)
    Event code 2 (1)
    Event code 3 (2)
    Event code 4 (3)
    Event code 5 (4)
    Event code 6 (5)
    Event code 7 (6)
    Event code 8 (7)
    Event code 9 (8)
    Event code 10 (9)
    Event code 11 (0)
    Event code 113 (Mute)
    Event code 114 (VolumeDown)
    Event code 115 (VolumeUp)
    Event code 116 (Power)
    Event code 354 (Goto)
    Event code 372 (Zoom)
    Event code 402 (ChannelUp)
    Event code 403 (ChannelDown)
Testing ... (interrupt to exit)

>
> Remember that the HID one does not work at all.

evtest gives me a somewhat extended output from event1.


I'm not actually "at" my PC right now os I can't see what button presses
on the remote do ATM.

So based on the above which device do I use for lirc? /dev/input/event7
(or more stable link to same)?

Cheers
Peter



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
