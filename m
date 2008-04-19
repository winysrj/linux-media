Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JnMNQ-00037W-A7
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 01:21:53 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: David Porter <dvb-t@iinet.com.au>
In-Reply-To: <D6E795B1149343418741C00C60CB5AC7@mce>
References: <015201c89859$bc7821c0$3500a8c0@crappyxpbox>
	<01e801c89b8e$b9031f30$3500a8c0@crappyxpbox>
	<1208031413.3708.13.camel@pc08.localdom.local>
	<D6E795B1149343418741C00C60CB5AC7@mce>
Date: Sun, 20 Apr 2008 01:21:36 +0200
Message-Id: <1208647296.3517.24.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi David,

Am Samstag, den 19.04.2008, 15:29 +1000 schrieb David Porter:
> Hi Hermann
> 
> Thank you for your help with this.
> I have been away and today is the first chance I have had to re-visit it.
> 
> It does look like we are getting somewhere....
> 
> After trying your suggestions, it seems that the tuner is located at 0x43 . 
> Please see demesg below.
> 
> The card is installed in a MythTV 8.04 Beta machine and I fired up the 
> backend setup.
> The card is registered o.k. as DVB0 but when I do a channel scan, it cannot 
> find any channels.

mythtv is likely not the best choice for experimenting with unsupported
cards. For analog "tvtime" is quite fine and for DVB-T "tzap -r" is by
far good enough.

> Please let me know what else you would like me to try.
> 
> Thanks & regards
> David
> 
> [ 2072.184027] Linux video capture interface: v2.00
> [ 2072.209134] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 2072.209171] saa7133[0]: found at 0000:01:07.0, rev: 240, irq: 22, 
> latency: 32, mmio: 0xf3005000
> [ 2072.209176] saa7133[0]: subsystem: 13c2:2804, board: Philips EUROPA V3 
> reference design [card=69,insmod option]
> [ 2072.209181] saa7133[0]: board init: gpio is c50000
> [ 2072.269640] saa7133[0]: i2c eeprom 00: c2 13 04 28 54 20 1c 00 43 43 a9 
> 1c 55 d2 b2 92
> [ 2072.269649] saa7133[0]: i2c eeprom 10: 00 00 00 00 ff 20 ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.269655] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 03 01 08 ff 01 
> b7 ff ff ff ff
> [ 2072.269661] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.269667] saa7133[0]: i2c eeprom 40: ff de 00 c6 86 10 ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.269673] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.269679] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.269685] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff
> [ 2072.273726] saa7133[0]: i2c scan: found device @ 0x10  [???]
> [ 2072.278730] saa7133[0]: i2c scan: found device @ 0x86  [tda9887]
> [ 2072.282365] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [ 2072.286000] saa7133[0]: i2c scan: found device @ 0xa2  [???]
> [ 2072.289636] saa7133[0]: i2c scan: found device @ 0xa4  [???]
> [ 2072.293272] saa7133[0]: i2c scan: found device @ 0xa6  [???]
> [ 2072.296908] saa7133[0]: i2c scan: found device @ 0xa8  [???]
> [ 2072.300995] saa7133[0]: i2c scan: found device @ 0xaa  [???]
> [ 2072.304179] saa7133[0]: i2c scan: found device @ 0xac  [???]
> [ 2072.308267] saa7133[0]: i2c scan: found device @ 0xae  [???]

We don't have the tuner PLL chip within the i2c scan and it seems there
are false positives at 0xa*..

> [ 2072.362357] tuner 2-0043: chip found @ 0x86 (saa7133[0])
> [ 2072.362384] tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner)

This is the analog TV IF demodulator and looks OK.

> [ 2072.362386] tuner 2-0043: type set to tda9887
> [ 2072.366444] tuner 2-0063: chip found @ 0xc6 (saa7133[0])

Likely we see this only because the PLL address is forced, but later the
tuner type seems not to be set according to your log?

> [ 2072.367295] saa7133[0]: registered device video0 [v4l2]
> [ 2072.367311] saa7133[0]: registered device vbi0
> [ 2072.424625] DVB: registering new adapter (saa7133[0])
> [ 2072.424632] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> [ 2072.449021] tda1004x: setting up plls for 48MHz sampling clock
> [ 2072.586103] tda1004x: found firmware revision 29 -- ok

You can enable debug for the tuner and should see if the i2c messages
come through to 0xc6/0x63 on tuning attempts.

Try
"modprobe -vr tuner"
"modprobe -v tuner debug=2",
guess you still don't have any.

Then, a reason could be that the tuner is behind the i2c gate of the
tda10046. I don't have any td1316 stuff, but Hartmut has a config for
such a case with saa7134 card=70.

You might try on that one as well, but it also has the tuner address
hard coded at 0x61 and if that fails, you might try to change that too
and see.

BTW, "echo 1 > /sys/module/saa7134/parameters/i2c_debug"
should return something useful on the next tuning attempt as well.

Good luck,
Hermann

> ----- Original Message ----- 
> From: "hermann pitton" <hermann-pitton@arcor.de>
> To: "David Porter" <dvb-t@iinet.com.au>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Sunday, April 13, 2008 6:16 AM
> Subject: Re: [linux-dvb] TechnoTrend T-3000 DVB-T PCI Hybrid Card
> 
> 
> > Hi David,
> >
> > Am Freitag, den 11.04.2008, 14:44 +1000 schrieb David Porter:
> >> Hi
> >>
> >> In the absence of any replies to my original request for help with this I
> >> did some more searching for any Linux information relating to this card.
> >> I found a post from 11 November 06 containing the tuner and decoder
> >> information which I have pasted in below.
> >>
> >> I'm hoping this may jog someone's memory as it seems odd that this card 
> >> has
> >> been unsupported for so long.
> >>
> >> Thank you
> >> David Porter
> >> --------------------------------------
> >
> > we need more information.
> >
> > A TechnoTrend re-branded saa7135chip was not seen so far.
> >
> >>From the eeprom it looks like the tuner is at 0x63.
> >
> > Please "modprobe -vr saa7134-dvb tuner" and then
> > "modprobe -v saa7134 card=69 i2c_scan=1"
> >
> > If it turns out that the tuner is at 0x63, card=69 has the tuner address
> > hardcoded at 0x61 in saa7134-cards.c and saa7134-dvb.c, a first step
> > could be to change that to 0x63.
> >
> > Also you seem to need tda10046 firmware.
> >
> > Cheers,
> > Hermann
> >
> >
> >> Re: Unsupported Video Card
> >> [Date Prev][Date Next][Thread Prev][Thread Next][Date Index][Thread 
> >> Index]
> >>
> >>     * Subject: Re: Unsupported Video Card
> >>     * From: "Leonce Pflieger"
> >>     * Date: Sat, 11 Nov 2006 15:52:38 +0100
> >>     * In-reply-to:
> >> <43a0ce660611110608q34d2184fhc3802f217692b3ad@xxxxxxxxxxxxxx>
> >>     * References:
> >> <43a0ce660611110608q34d2184fhc3802f217692b3ad@xxxxxxxxxxxxxx>
> >>
> >> Hello,
> >>
> >> Same question for the following board. It is a Technotrend T-3000
> >> DVB-T Hybrid. It seems there are a few cards that are still
> >> unrecognized even if the hardware embedded is well known and
> >> supported. :-\
> >> Mine is :
> >> 01:01.0 Multimedia controller: Philips Semiconductors SAA7133 Video
> >> Broadcast Decoder (rev f0)
> >>        Subsystem: Technotrend Systemtechnik GmbH Unknown device 2804
> >>        Flags: bus master, medium devsel, latency 64, IRQ 18
> >>        Memory at fa7ff000 (32-bit, non-prefetchable) [size=2K]
> >>        Capabilities: [40] Power Management version 2
> >>
> >> and the dmesg output shows :
> >>
> >> saa7130/34: v4l2 driver version 0.2.14 loaded
> >> ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 18
> >> saa7133[0]: found at 0000:01:01.0, rev: 240, irq: 18, latency: 64,
> >> mmio: 0xfa7ff000
> >> saa7133[0]: subsystem: 13c2:2804, board: UNKNOWN/GENERIC
> >> [card=0,autodetected]
> >> saa7133[0]: board init: gpio is c50000
> >> saa7133[0]: i2c eeprom 00: c2 13 04 28 54 20 1c 00 43 43 a9 1c 55 d2 b2 
> >> 92
> >> saa7133[0]: i2c eeprom 10: 00 00 00 00 ff 20 ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 03 01 08 ff 01 b7 ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 40: ff de 00 c6 86 10 ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: registered device video1 [v4l2]
> >> saa7133[0]: registered device vbi2
> >>
> >>
> >> saa7134-dvb gives nothing, but if saa7134 was starded with card=69 and
> >> tuner=67 (tuner on the board is a TD1316A/SIHP / 3112 297 14251L# /
> >> 0448 SV20 000000) it returns :
> >>
> >> saa7130/34: v4l2 driver version 0.2.14 loaded
> >> ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 18
> >> saa7133[0]: found at 0000:01:01.0, rev: 240, irq: 18, latency: 64,
> >> mmio: 0xfa7ff000
> >> saa7133[0]: subsystem: 13c2:2804, board: Philips EUROPA V3 reference
> >> design [card=69,insmod option]
> >> saa7133[0]: board init: gpio is c50000
> >> saa7133[0]: i2c eeprom 00: c2 13 04 28 54 20 1c 00 43 43 a9 1c 55 d2 b2 
> >> 92
> >> saa7133[0]: i2c eeprom 10: 00 00 00 00 ff 20 ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 03 01 08 ff 01 b7 ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 40: ff de 00 c6 86 10 ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> >> ff
> >> tda9887 2-0043: chip found @ 0x86 (saa7133[0])
> >> saa7133[0]: registered device video1 [v4l2]
> >> saa7133[0]: registered device vbi2
> >> DVB: registering new adapter (saa7133[0]).
> >> DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
> >>
> >> which seems quite good, but is followed by...
> >>
> >> tda1004x: setting up plls for 48MHz sampling clock
> >> tda1004x: timeout waiting for DSP ready
> >> tda1004x: found firmware revision 0 -- invalid
> >> tda1004x: booting from eeprom
> >> tda1004x: timeout waiting for DSP ready
> >> tda1004x: found firmware revision 0 -- invalid
> >> tda1004x: firmware upload failed
> >>
> >> :-(
> >> Could someone help ? Am I the only guy on earth trying to make a T3000
> >> work on Linux ??
> >>
> >> Thanks for your attention !
> >>
> >>
> >> ----- Original Message ----- 
> >> From: "David Porter" <dvb-t@iinet.com.au>
> >> To: <linux-dvb@linuxtv.org>
> >> Sent: Monday, April 07, 2008 12:47 PM
> >> Subject: [linux-dvb] TechnoTrend T-3000 DVB-T PCI Hybrid Card
> >>
> >>
> >> > Hi
> >> >
> >> > I have searched the wiki, forums and threads and cannot find any
> >> > information
> >> > about getting this card to work in Linux.
> >> > Does anyone have any experience with it?
> >> > It is one of their "budget" range that has no hardware mpeg decoder.
> >> >
> >> > I'm only interested in getting DVB-T working, not analogue.
> >> >
> >> > There is a good picture of it here:-
> >> > http://www.dvbmagic.de/tv-karten/technotrend-budget-t-3000.htm
> >> >
> >> > Thanks
> >> > David Porter
> >> >
> >> >
> >
> > 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
