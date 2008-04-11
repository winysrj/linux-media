Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail9.tpgi.com.au ([203.12.160.104])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dvb-t@iinet.com.au>) id 1JkB7r-0007nQ-AX
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 06:44:40 +0200
Received: from crappyxpbox (60-242-2-157.static.tpgi.com.au [60.242.2.157])
	by mail9.tpgi.com.au (envelope-from dvb-t@iinet.com.au) (8.14.2/8.14.2)
	with SMTP id m3B4iNqw000577
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 14:44:25 +1000
Message-ID: <01e801c89b8e$b9031f30$3500a8c0@crappyxpbox>
From: "David Porter" <dvb-t@iinet.com.au>
To: <linux-dvb@linuxtv.org>
References: <015201c89859$bc7821c0$3500a8c0@crappyxpbox>
Date: Fri, 11 Apr 2008 14:44:24 +1000
MIME-Version: 1.0
Subject: Re: [linux-dvb] TechnoTrend T-3000 DVB-T PCI Hybrid Card
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

Hi

In the absence of any replies to my original request for help with this I 
did some more searching for any Linux information relating to this card.
I found a post from 11 November 06 containing the tuner and decoder 
information which I have pasted in below.

I'm hoping this may jog someone's memory as it seems odd that this card has 
been unsupported for so long.

Thank you
David Porter
--------------------------------------

Re: Unsupported Video Card
[Date Prev][Date Next][Thread Prev][Thread Next][Date Index][Thread Index]

    * Subject: Re: Unsupported Video Card
    * From: "Leonce Pflieger"
    * Date: Sat, 11 Nov 2006 15:52:38 +0100
    * In-reply-to: 
<43a0ce660611110608q34d2184fhc3802f217692b3ad@xxxxxxxxxxxxxx>
    * References: 
<43a0ce660611110608q34d2184fhc3802f217692b3ad@xxxxxxxxxxxxxx>

Hello,

Same question for the following board. It is a Technotrend T-3000
DVB-T Hybrid. It seems there are a few cards that are still
unrecognized even if the hardware embedded is well known and
supported. :-\
Mine is :
01:01.0 Multimedia controller: Philips Semiconductors SAA7133 Video
Broadcast Decoder (rev f0)
       Subsystem: Technotrend Systemtechnik GmbH Unknown device 2804
       Flags: bus master, medium devsel, latency 64, IRQ 18
       Memory at fa7ff000 (32-bit, non-prefetchable) [size=2K]
       Capabilities: [40] Power Management version 2

and the dmesg output shows :

saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 18
saa7133[0]: found at 0000:01:01.0, rev: 240, irq: 18, latency: 64,
mmio: 0xfa7ff000
saa7133[0]: subsystem: 13c2:2804, board: UNKNOWN/GENERIC 
[card=0,autodetected]
saa7133[0]: board init: gpio is c50000
saa7133[0]: i2c eeprom 00: c2 13 04 28 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 00 00 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 03 01 08 ff 01 b7 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff de 00 c6 86 10 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video1 [v4l2]
saa7133[0]: registered device vbi2


saa7134-dvb gives nothing, but if saa7134 was starded with card=69 and
tuner=67 (tuner on the board is a TD1316A/SIHP / 3112 297 14251L# /
0448 SV20 000000) it returns :

saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 18
saa7133[0]: found at 0000:01:01.0, rev: 240, irq: 18, latency: 64,
mmio: 0xfa7ff000
saa7133[0]: subsystem: 13c2:2804, board: Philips EUROPA V3 reference
design [card=69,insmod option]
saa7133[0]: board init: gpio is c50000
saa7133[0]: i2c eeprom 00: c2 13 04 28 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 00 00 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 03 01 08 ff 01 b7 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff de 00 c6 86 10 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tda9887 2-0043: chip found @ 0x86 (saa7133[0])
saa7133[0]: registered device video1 [v4l2]
saa7133[0]: registered device vbi2
DVB: registering new adapter (saa7133[0]).
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...

which seems quite good, but is followed by...

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: booting from eeprom
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: firmware upload failed

:-(
Could someone help ? Am I the only guy on earth trying to make a T3000
work on Linux ??

Thanks for your attention !


----- Original Message ----- 
From: "David Porter" <dvb-t@iinet.com.au>
To: <linux-dvb@linuxtv.org>
Sent: Monday, April 07, 2008 12:47 PM
Subject: [linux-dvb] TechnoTrend T-3000 DVB-T PCI Hybrid Card


> Hi
>
> I have searched the wiki, forums and threads and cannot find any 
> information
> about getting this card to work in Linux.
> Does anyone have any experience with it?
> It is one of their "budget" range that has no hardware mpeg decoder.
>
> I'm only interested in getting DVB-T working, not analogue.
>
> There is a good picture of it here:-
> http://www.dvbmagic.de/tv-karten/technotrend-budget-t-3000.htm
>
> Thanks
> David Porter
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
