Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JyDex-00071O-5R
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 00:16:52 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Matthias Schwarzott <zzam@gentoo.org>
In-Reply-To: <200805191334.59710.zzam@gentoo.org>
References: <617be8890805171034t539f9c67qe339f7b4f79d8e62@mail.gmail.com>
	<36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
	<1211060299.2592.10.camel@pc10.localdom.local>
	<200805191334.59710.zzam@gentoo.org>
Date: Tue, 20 May 2008 00:15:44 +0200
Message-Id: <1211235344.3241.39.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
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

Am Montag, den 19.05.2008, 13:34 +0200 schrieb Matthias Schwarzott:
> On Samstag, 17. Mai 2008, hermann pitton wrote:
> > Hello,
> >
> > Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
> > > Hi,
> > > thank you for your answer,
> > >
> > > may i ask,
> > >
> > > what is meant by "analog  input", it is mentioned on logs that:" only
> > > analog inputs supported yet.." like that..
> > > is that mean: s-video, composit ?
> >
> > yes, only s-video and composite is enabled there.
> > Better we would have print only external analog inputs.
> >
> Should we patch this to print a more clear log message.

It is up to you. Mauro might pick it up later.

To print something was already a good service, but seems people try on
everything as soon there is the slightest hope without looking into the
logs and doing "hg export 7507".

Here even I think the confusion is mostly caused by the reason the users
can't override the tuner defined on the card anymore on current stuff.

That happened after your patches.

And if TUNER_ABSENT is on the card nothing is printed anymore and they
sit in the dark without at least tuner debug enabled to have an idea,
that tuner modules are not sharp in this case I guess.

Cheers,
Hermann


Faking that card here and even trying to set a tuner results on
saa7134[3] in

saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:5000, board: Avermedia DVB-S Hybrid+FM A700 [card=141,insmod option]
saa7134[3]: board init: gpio is 4c68100
saa7134[3]: Avermedia DVB-S Hybrid+FM A700: hybrid analog/dvb card
saa7134[3]: Sorry, only the analog inputs are supported for now.
saa6752hs 5-0020: saa6752hs: chip found @ 0x40
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner' 5-0043: type set to tda9887
tuner' 5-0043: tv freq set to 0.00
tuner' 5-0043: TV freq (0.00) out of range (44-958)
tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for 0x0e
tuner' 5-0061: Setting mode_mask to 0x0e
tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
tuner' 5-0061: tuner 0x61: Tuner type absent   <------- for all the same, only visible with tuner debug enabled.

saa7134[3]: i2c eeprom 00: be 16 00 50 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 6c 02 51 96 2b
saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock

Nothing about the tuner is visible. OK no tuner.

------------------------------------------

Using card=4 for the same saa7134[3], tuner changed to 63 in the source code ... !

saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
tuner' 4-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:5000, board: EMPRESS [card=4,insmod option]
saa7134[3]: board init: gpio is c68100   <------------------ that was you ;)

saa6752hs 5-0020: saa6752hs: chip found @ 0x40
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner' 5-0043: type set to tda9887
tuner' 5-0043: tv freq set to 0.00
tuner' 5-0043: TV freq (0.00) out of range (44-958)
tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for 0x0e
tuner' 5-0061: Setting mode_mask to 0x0e
tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
tuner' 5-0061: tuner 0x61: Tuner type absent
saa7134[3]: i2c eeprom 00: be 16 00 50 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 6c 02 51 96 2b
saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 5-0043: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 5-0043: set addr discarded for type 74, mask e. Asked to change tuner at addr 0xff, with mask e
tuner' 5-0061: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 5-0061: defining GPIO callback
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner-simple 5-0061: tuner 0 atv rf input will be autoselected
tuner-simple 5-0061: tuner 0 dtv rf input will be autoselected
tuner' 5-0061: type set to Philips FMD1216ME M
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0061: saa7134[3] tuner' I2C addr 0xc2 with type 63 used for 0x0e
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
tuner' 5-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
tuner' 5-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
saa7134[3]/empress: saa7134[3]: empress_init
saa7134[3]: registered device video4 [mpeg]
saa7134[3]/empress: no video signal
tuner' 2-004b: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 2-004b: tv freq set to 400.00
tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
tuner' 5-0043: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 5-0043: switching to v4l2
tuner' 5-0061: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 5-0061: switching to v4l2
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0061: tv freq set to 400.00
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 400.00 (6400), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
tuner' 5-0043: tv freq set to 48.25
tuner' 5-0061: tv freq set to 48.25
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 48.25 (772), range = 0, config = 0x86, cb = 0x51
tuner-simple 5-0061: Freq= 48.25 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=1395
tuner-simple 5-0061: tv 0x05 0x73 0x86 0x51
tuner' 5-0043: tv freq set to 182.25
tuner' 5-0061: tv freq set to 182.25
tuner-simple 5-0061: using tuner params #0 (pal)
tuner-simple 5-0061: freq = 182.25 (2916), range = 1, config = 0x86, cb = 0x52
tuner-simple 5-0061: Freq= 182.25 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=3539
tuner-simple 5-0061: tv 0x0d 0xd3 0x86 0x52
saa7134[3]/empress: no video signal
saa7134[3]/empress: no video signal
saa7134[3]/empress: video signal acquired
saa7134[3]/empress: open minor=4





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
