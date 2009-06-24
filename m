Return-path: <linux-media-owner@vger.kernel.org>
Received: from cressida.telkomsa.net ([196.25.211.128]:34282 "EHLO
	telkomsa.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbZFXQiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 12:38:17 -0400
Received: from unknown (HELO webmail.telkomsa.net) ([196.25.69.74])
          (envelope-sender <jhmoodie@telkomsa.net>)
          by O (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 24 Jun 2009 16:31:37 -0000
Message-ID: <2169.41.247.34.89.1245861097.squirrel@webmail.telkomsa.net>
In-Reply-To: <1245791516.4032.52.camel@pc07.localdom.local>
References: <1243024963.14790.1316818399@webmail.messagingengine.com><b5c455cf0906230836q196f6fb3p81014ae2f1322515@mail.gmail.com>
    <1245791516.4032.52.camel@pc07.localdom.local>
Date: Wed, 24 Jun 2009 18:31:37 +0200 (SAST)
Subject: Re: [linux-dvb] Gigabyte GT-P8000 dvb-t / analog / fm radio - pci
From: "John Moodie" <jhmoodie@telkomsa.net>
To: linux-media@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Reply-To: jhmoodie@telkomsa.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> Am Mittwoch, den 24.06.2009, 01:36 +1000 schrieb c kuruwita:
>> Hi
>>
>> You could try using the "card=" option when loading the kernel module
>> and use the cardnumber of a similar supported saa7134 dvb card.
>> you can find a complete list of supported card saa713 dvb cards in
>> "Documentation/video4linux/CARDLIST.saa7134".
>>
>
> that might become a very frustrating experience and it is also not
> without some danger. At least you might get the card in a not further
> responding state and you might need a cold boot in between.
>
> Minimum further to know is the type of the digital demodulator these
> days!
>
> If it is for example a tda10048, there are currently only two cards to
> test on for DVB-T, but likely with slightly different hardware
> configuration.
>
> You also need to know if it needs firmware and which one.
>
> The saa7134 insmod option "i2c_scan=1" should be used to see if at least
> all chips are visible. You might need special gpio switching else to get
> them out of some power saving state.
>
> You also don't know if you need gate control enabled of the tda8290
> analog IF demod built into the saa7131e to initialize and further
> program the tuner.
>
> Tuner, digital demod and analog demod can be on four different i2c
> addresses each. For dvb-t you need to know and set each of those
> addresses correctly. It makes no sense to try on cards having this not
> all the same.
>
> The eeprom, if it is correct on this, says tuner at 0x60, analog demod
> at 0x4b and digital demod at 0x08 in seven bit notation. The tuner at
> 0x60 is rather rare, if you look into saa7134-dvb.c. Makes no sense to
> test on other cards.
>
> Then we always want to have the antenna inputs reported. What shares
> with what an input and what is on a separate one?
> Only this way you can _eventually_ find a card with the same switching
> there and also correct FM switch.
>
> Next, most recent cards do have an additional RF LNA and there are
> different types. All must be correctly set up for analog and digital
> mode or you will have some unpleasant experiences. Seems there is no way
> for us currently to know, if there is one at all or which type of
> configuration it does need.
>
> You must also know or find out, if the card uses serial or parallel TS
> interface.
>
> Even if you succeed with all the above, and that is possible by working
> through step by step, especially with a tda10048 you might need a card
> specific configuration not yet covered by other cards.
>
> Blindly testing on cards without knowing on what you are testing
> exactly, unlikely has good results on recent hybrid cards.
>
> First of all you must know the type of digital demod on that card too.
> The fuzzy picture I found seems to say it has only 48 pins ...
>
> Always recommend to read further on the wiki about how to provide a good
> report for new hardware.
>
> Cheers,
> Hermann
>

Hi,

I did do some blind testing with the card= option, but the only one that
looked promising was card=112 [ASUSTeK P7131 Hybrid]. But dmesg reported
'tda10046: chip is not answering. Giving up'

I have created a page for the card which can be found here:
http://linuxtv.org/wiki/index.php/Gigabyte_GT-P8000

Regards,
John

>>
>> On Sat, May 23, 2009 at 6:42 AM, <jhmoodie@telkomsa.net> wrote:
>> > Does anyone have any information on the support status of this card?
>> Or
>> > perhaps any hints I might try to get it working?
>> >
>> > I have built and installed the latest V4L-DVB kernel driver modules,
>> but
>> > no luck.
>> >
>> > I noticed windows installs Philips 3xhybrid drivers if this helps...
>> >
>> > Product website:
>> > http://www.gigabyte.com.tw/Products/TVCard/Products_Spec.aspx?ClassValue=TV+Card&ProductID=2757&ProductName=GT-P8000
>> >
>> > Tuner NXP 18271
>> > Decoder NXP 7131E
>> >
>> > lspci -vnn:
>> > 00:09.0 Multimedia controller [0480]: Philips Semiconductors
>> > SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>> >        Subsystem: Giga-byte Technology Device [1458:9004]
>> >        Flags: bus master, medium devsel, latency 32, IRQ 11
>> >        Memory at e6000000 (32-bit, non-prefetchable) [size=2K]
>> >        Capabilities: [40] Power Management version 2
>> >        Kernel driver in use: saa7134
>> >        Kernel modules: saa7134
>> >
>> > dmesg output:
>> > [ 3089.801191] saa7130/34: v4l2 driver version 0.2.15 loaded
>> > [ 3089.801419] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 11,
>> > latency: 32, mmio: 0xe6000000
>> > [ 3089.801443] saa7133[0]: subsystem: 1458:9004, board:
>> UNKNOWN/GENERIC
>> > [card=0,autodetected]
>> > [ 3089.801656] saa7133[0]: board init: gpio is 40000
>> > [ 3089.952088] saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43
>> 43
>> > a9
>> > 1c 55 d2 b2 92
>> > [ 3089.952125] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952153] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08
>> ff
>> > 00
>> > b3 ff ff ff ff
>> > [ 3089.952180] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952206] saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5
>> 15
>> > 0e
>> > 00 ff ff ff ff
>> > [ 3089.952233] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952260] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952287] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952314] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952340] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952367] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952394] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952421] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952447] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952474] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.952501] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
>> ff
>> > ff
>> > ff ff ff ff ff
>> > [ 3089.953430] saa7133[0]: registered device video0 [v4l2]
>> > [ 3089.953507] saa7133[0]: registered device vbi0
>> > [ 3090.023006] saa7134 ALSA driver for DMA sound loaded
>> > [ 3090.023158] saa7133[0]/alsa: saa7133[0] at 0xe6000000 irq 11
>> > registered
>> > as card -2
>> >
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

