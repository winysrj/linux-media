Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JyEsv-0002mf-H1
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 01:35:18 +0200
Message-ID: <48320E91.3010306@iki.fi>
Date: Tue, 20 May 2008 02:34:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pjama@optusnet.com.au
References: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
In-Reply-To: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] IR for Afatech 901x
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

pjama wrote:
> Hi,
> I see there's some activity from Antti in the af9015-mxl500x-copy-fw area
> for remotes.

yes, I fixed one bug that has killed remote. Now it works again.

> I got, compiled and installed the latest (although there's a NEW one just
> 4 minutes old) code 737994f33e83 to see if there's any action for my IR
> remote bundled with my DigitalNow TinyTwin USB stick. I'm running
> mythbuntu 8.04

Probably there is wrong ir-table loaded to the device by the driver. 
Ir-table in device and ir-codes from remote should match. Otherwise it 
will not work.

> I'm not even sure if I'm on the right track here but entries like the
> following in dmesg got me excited!
> input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
> dvb-usb: schedule remote query interval to 150 msecs.
> dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and
> connected.

Yes, thats correct. AF9015 implements also HID-remote but I have never 
got it working. I think it could be due to hw bug. Luckily there is 
other way to read remote - polling from the driver.

> I'm not having ANY luck extracting any life out of IR though:
> 
> # sudo irrecord -d /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
> test.conf
> irrecord -  application for recording IR-codes for usage with lirc
> Copyright (C) 1998,1999 Christoph Bartelmus(lirc@bartelmus.de)
> irrecord: could not get file information for
> /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
> irrecord: default_init(): No such file or directory
> irrecord: could not init hardware (lircd running ? --> close it, check
> permissions)
> 
> Same story with /dev/input/event7, I've turned lirc off and irw just
> refuses  to connect.
> 
> Is there anything I should try or anything I can test?

I just tested using...

1)
[root@localhost ~]# hexdump -v -e '"\t" "0x" 1/1 "%02x " "\n"' < 
/dev/input/by-path/pci-1-5--event-ir

2)
[root@localhost ~]# av7110_evtest /dev/input/by-path/pci-1-5--event-ir
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x15a4 product 0x9016 version 0x200
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

Remember that the HID one does not work at all.

> 
> Thanks
> Peter

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
