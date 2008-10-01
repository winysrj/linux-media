Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kl653-0003aI-15
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 20:05:46 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K820050UNKKL2H0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 01 Oct 2008 14:05:10 -0400 (EDT)
Date: Wed, 01 Oct 2008 14:05:08 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48E3A687.9000703@gmail.com>
To: Plantain <yellowplantain@gmail.com>
Message-id: <48E3BBD4.8090304@linuxtv.org>
MIME-version: 1.0
References: <48E35E38.9040909@gmail.com> <48E394D0.5010808@linuxtv.org>
	<48E3A687.9000703@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
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

Plantain wrote:
> Steven Toth wrote:
>> Plantain wrote:
>>> Hey,
>>>
>>> I've luckily come across a Leadtek DTV1000S that I'd like to get working
>>> under Linux!
>>>
>>> From reading the Leadtek specifications
>>> (http://leadtek.com/eng/tv_tuner/specification.asp?pronameid=382&lineid=6&act=2),
>>>
>>> I now understand it has contained within it the following chips;
>>> NXP 18271
>>> TDA10048
>> Firmware:
>>
>> http://steventoth.net/linux/hvr1700/
>>
>> Good luck!
>>
>> Regards,
>>
>> - Steve
> Hey,

Either you or I dropped the mailinglist is CC'd. I've added it back. 
Please ensure the mailinglist is CC'd at all times.

> 
> So it doesn't matter at all that they are for different cards even
> though the chipsets are the same?

Correct.

> 
> Even with the firmware, it seems that the tuner is not detected/loaded.
> I've pasted my current modprobe/dmesg below.

If it's not found during an i2c scan then it's probably held in reset by 
a GPIO. YOu'd need to figure out which GPIO needs to be raised. I don't 
know the 7130 framework very well by I suspect running regspy.exe (from 
the dscaler project) on a windows system will probably show you the gpio 
configuration that windows uses when the TV playback software is running.

> 
> plantain@plantain-king ~ $ sudo modprobe saa7134 card=104 tuner=54
> plantain@plantain-king ~ $ dmesg
> ...
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio:
> 0xfc005000
> saa7130[0]: subsystem: 107d:6655, board: Hauppauge WinTV-HVR1110
> DVB-T/Hybrid [card=104,insmod option]
> saa7130[0]: board init: gpio is 222104
> Chip ID is not zero. It is not a TEA5767
> tuner' 2-0060: chip found @ 0xc0 (saa7130[0])
> saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
> saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
> Hauppauge eeprom.
> saa7130[0]: warning: unknown hauppauge model #0
> saa7130[0]: hauppauge eeprom: model=0
> tuner' 2-0060: Tuner has no way to set tv freq
> tuner' 2-0060: Tuner has no way to set tv freq
> saa7130[0]: registered device video0 [v4l2]
> saa7130[0]: registered device vbi0
> saa7130[0]: registered device radio0
> tda10046: chip is not answering. Giving up.
> tuner' 2-0060: Tuner has no way to set tv freq
> plantain@plantain-king ~ $
> 
> 
> I believe I am right with the tuner=54 modprobe option for the NXP 18271?
> I've no idea what to actually set card= to, I just guessed HVR1110 since
> it was similar to the firmware from which I've now taken from. If anyone
> can point me towards a better card= setting, that'd be great!

I don't normally force load drivers with card=X. I typically just start 
patching the [7130] tree with the correct PCI'd, attach structs etc. 
It's easier that guessing - which leads to bad assumptions and mistakes.

You can use the other trees [ cx23885, cx88 ] for reference code to show 
how to attach tuners and demods.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
