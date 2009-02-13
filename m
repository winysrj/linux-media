Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:42178 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZBMDIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 22:08:01 -0500
Date: Thu, 12 Feb 2009 21:07:50 -0600
From: David Engel <david@istwok.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090213030750.GA3721@opus.istwok.net>
References: <1234229460.3932.27.camel@pc10.localdom.local> <20090210003520.14426415@pedra.chehab.org> <1234235643.2682.16.camel@pc10.localdom.local> <1234237395.2682.22.camel@pc10.localdom.local> <20090210041512.6d684be3@pedra.chehab.org> <1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com> <20090210102732.5421a296@pedra.chehab.org> <20090211035016.GA3258@opus.istwok.net> <20090211054329.6c54d4ad@pedra.chehab.org> <20090211232149.GA28415@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211232149.GA28415@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2009 at 05:21:49PM -0600, David Engel wrote:
> On Wed, Feb 11, 2009 at 05:43:29AM -0200, Mauro Carvalho Chehab wrote:
> > On Tue, 10 Feb 2009 21:50:16 -0600
> > David Engel <david@istwok.net> wrote:
> > > MythTV eventually worked too, but I had to do the
> > > "unload/reload modules and run tvtime" procedure I reported earlier
> > > when I tried Hans' kworld tree.
> > 
> > Maybe this is a race condition I have here with tda1004x. With tda1004x, the i2c
> > bus shouldn't be used by any other device during the firmware transfers,
> > otherwise the firmware load will fail, and tda1004x goes into an unstable
> > state. With this device, it even affects all subsequent i2c acesses. The only
> > alternative to recover tda1004x is to reboot the card (e. g. with my cardbus
> > device, I have to physically remove it and re-insert).
> > 
> > What happens is that some softwares (including udev) open the device, and send
> > some VIDIOC_G_TUNER in order to check some tuner characteristics. However, this
> > command generates some i2c transfers, to retrieve signal strength. If this
> > happens while the firmware is being loaded, the bug occurs.
> > 
> > In order to fix, a careful review of all locks on the driver is needed. We will
> > likely need to change the demod interface for the boards that have this
> > trouble, in order to be aware of when a firmware transfer started.
> > 
> > This lock review is currently on my TODO list.
> > 
> > To be sure that this is the case, could you please add this on
> > your /etc/modprobe (or at a file inside /etc/modprobe.d):
> > 
> > 	options nxt200x debug=1
> > 	options tuner-simple debug=1
> > 	options tuner debug=1
> > 	options dvb-core frontend_debug=1
> > 
> > And test again, sending us the produced logs when the device works and when it
> > breaks. I guess we'll discover some tuner dmesg's in the middle of the firmware
> > load sequence.
> 
> I will do this, but it will be tomorrow evening before I can get to
> it.

Here are my logs.  They are annoteded in-line with the actions I took.
I need to add that the results with MythTv aren't always consistent.
Sometimes it works right away when I don't expect it to and sometimes
it doesn't work after the reload when I do expect it to.  The results
shown below are what happens most of the time -- MythTV doesn't work
until the modules are reloaded and tvtime is run.

Cold booting.

Feb 12 20:30:54 opus kernel: Linux video capture interface: v2.00
Feb 12 20:30:54 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Feb 12 20:30:54 opus kernel: saa7134 0000:04:07.0: PCI INT A -> Link[LNKB] -> GSI 18 (level, low) -> IRQ 18
Feb 12 20:30:54 opus kernel: saa7133[0]: found at 0000:04:07.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
Feb 12 20:30:54 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,autodetected]
Feb 12 20:30:54 opus kernel: saa7133[0]: board init: gpio is 100
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:30:54 opus kernel: tuner 1-0061: Setting mode_mask to 0x0e
Feb 12 20:30:54 opus kernel: tuner 1-0061: chip found @ 0xc2 (saa7133[0])
Feb 12 20:30:54 opus kernel: tuner 1-0061: tuner 0x61: Tuner type absent
Feb 12 20:30:54 opus kernel: tuner 1-0061: Calling set_type_addr for type=68, addr=0xff, mode=0x0e, config=0x00
Feb 12 20:30:54 opus kernel: tuner 1-0061: defining GPIO callback
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: creating new instance
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tuner 0 atv rf input will be autoselected
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tuner 0 dtv rf input will be autoselected
Feb 12 20:30:54 opus kernel: tuner 1-0061: type set to Philips TUV1236D ATSC/NTSC dual in
Feb 12 20:30:54 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:30:54 opus kernel: tuner 1-0061: saa7133[0] tuner I2C addr 0xc2 with type 68 used for 0x0e
Feb 12 20:30:54 opus kernel: tuner 1-0061: switching to v4l2
Feb 12 20:30:54 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:30:54 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:30:54 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:30:54 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:30:54 opus kernel: saa7133[0]: registered device video2 [v4l2]
Feb 12 20:30:54 opus kernel: saa7133[0]: registered device vbi2
Feb 12 20:30:54 opus kernel: dvb_init() allocating 1 frontend
Feb 12 20:30:54 opus kernel: nxt200x: NXT info: 05 02 09 20 01
Feb 12 20:30:54 opus kernel: nxt200x: NXT2004 Detected
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: attaching existing instance
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tuner 0 atv rf input will be autoselected
Feb 12 20:30:54 opus kernel: tuner-simple 1-0061: tuner 0 dtv rf input will be autoselected
Feb 12 20:30:54 opus kernel: DVB: registering new adapter (saa7133[0])
Feb 12 20:30:54 opus kernel: dvb_register_frontend
Feb 12 20:30:54 opus kernel: DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Feb 12 20:30:54 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
Feb 12 20:30:54 opus kernel: firmware: requesting dvb-fe-nxt2004.fw
Feb 12 20:30:54 opus kernel: nxt2004: Waiting for firmware upload(2)...
Feb 12 20:30:54 opus kernel: nxt200x: nxt2004_load_firmware
Feb 12 20:30:54 opus kernel: nxt200x: Firmware is 9584 bytes
Feb 12 20:30:54 opus kernel: nxt200x: firmware crc is 0xF1 0xB2
Feb 12 20:30:54 opus kernel: nxt2004: Firmware upload complete
Feb 12 20:30:54 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:30:54 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus last message repeated 2 times
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus last message repeated 2 times
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:30:54 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:30:54 opus kernel: saa7134 ALSA driver for DMA sound loaded
Feb 12 20:30:54 opus kernel: saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card 2
Feb 12 20:30:59 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:30:59 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:30:59 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:30:59 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:30:59 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:30:59 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:30:59 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:30:59 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:30:59 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


Starting tvtime.

Feb 12 20:32:14 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:32:14 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:14 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:16 opus kernel: tuner 1-0061: tv freq set to 121.25
Feb 12 20:32:16 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:16 opus kernel: tuner-simple 1-0061: freq = 121.25 (1940), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:16 opus kernel: tuner-simple 1-0061: Freq= 121.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2672
Feb 12 20:32:16 opus kernel: tuner-simple 1-0061: tv 0x0a 0x70 0xce 0x01
Feb 12 20:32:17 opus kernel: tuner 1-0061: tv freq set to 127.25
Feb 12 20:32:17 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:17 opus kernel: tuner-simple 1-0061: freq = 127.25 (2036), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:17 opus kernel: tuner-simple 1-0061: Freq= 127.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2768
Feb 12 20:32:17 opus kernel: tuner-simple 1-0061: tv 0x0a 0xd0 0xce 0x01
Feb 12 20:32:19 opus kernel: tuner 1-0061: tv freq set to 133.25
Feb 12 20:32:19 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:19 opus kernel: tuner-simple 1-0061: freq = 133.25 (2132), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:19 opus kernel: tuner-simple 1-0061: Freq= 133.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2864
Feb 12 20:32:19 opus kernel: tuner-simple 1-0061: tv 0x0b 0x30 0xce 0x01
Feb 12 20:32:20 opus kernel: tuner 1-0061: tv freq set to 139.25
Feb 12 20:32:20 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:20 opus kernel: tuner-simple 1-0061: freq = 139.25 (2228), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:20 opus kernel: tuner-simple 1-0061: Freq= 139.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2960
Feb 12 20:32:20 opus kernel: tuner-simple 1-0061: tv 0x0b 0x90 0xce 0x01
Feb 12 20:32:21 opus kernel: tuner 1-0061: tv freq set to 133.25
Feb 12 20:32:21 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:21 opus kernel: tuner-simple 1-0061: freq = 133.25 (2132), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:21 opus kernel: tuner-simple 1-0061: Freq= 133.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2864
Feb 12 20:32:21 opus kernel: tuner-simple 1-0061: tv 0x0b 0x30 0xce 0x01
Feb 12 20:32:22 opus kernel: tuner 1-0061: tv freq set to 127.25
Feb 12 20:32:22 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:22 opus kernel: tuner-simple 1-0061: freq = 127.25 (2036), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:22 opus kernel: tuner-simple 1-0061: Freq= 127.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2768
Feb 12 20:32:22 opus kernel: tuner-simple 1-0061: tv 0x0a 0xd0 0xce 0x01
Feb 12 20:32:23 opus kernel: tuner 1-0061: tv freq set to 121.25
Feb 12 20:32:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:23 opus kernel: tuner-simple 1-0061: freq = 121.25 (1940), range = 0, config = 0xce, cb = 0x01
Feb 12 20:32:23 opus kernel: tuner-simple 1-0061: Freq= 121.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=2672
Feb 12 20:32:23 opus kernel: tuner-simple 1-0061: tv 0x0a 0x70 0xce 0x01
Feb 12 20:32:24 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:24 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:24 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:24 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:24 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02


Stopping tvtime.

Feb 12 20:32:25 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:32:25 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


tvtime worked fine.  The video was good and changing channels worked.


Starting mythbackend.

Feb 12 20:32:52 opus kernel: dvb_frontend_open
Feb 12 20:32:52 opus kernel: dvb_frontend_start
Feb 12 20:32:52 opus kernel: dvb_frontend_thread
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: DVB: initialising adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Feb 12 20:32:52 opus kernel: dvb_frontend_release
Feb 12 20:32:52 opus kernel: dvb_frontend_open
Feb 12 20:32:52 opus kernel: dvb_frontend_start
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: dvb_frontend_release
Feb 12 20:32:52 opus kernel: dvb_frontend_open
Feb 12 20:32:52 opus kernel: dvb_frontend_start
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: dvb_frontend_get_event
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: dvb_frontend_add_event
Feb 12 20:32:52 opus kernel: dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:0 started_auto_step:0
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:32:52 opus kernel: dvb_frontend_poll
Feb 12 20:32:52 opus kernel: dvb_frontend_ioctl
Feb 12 20:32:52 opus kernel: tuner-simple 1-0061: using tuner params #1 (digital)
Feb 12 20:32:52 opus kernel: tuner-simple 1-0061: freq = 693.00 (11088), range = 2, config = 0xc6, cb = 0x44
Feb 12 20:32:52 opus kernel: tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=11792 | buf=0x2e,0x10,0xc6,0x44
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_writetuner
Feb 12 20:32:52 opus kernel: nxt200x: Tuner Bytes: 2E 10 C6 44
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_agc_reset
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:52 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:53 opus last message repeated 2 times
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:32:53 opus kernel: nxt200x: nxt200x_microcontroller_start
Feb 12 20:32:53 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:32:53 opus kernel: dvb_frontend_release
Feb 12 20:32:53 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: tv freq set to 175.25
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: freq = 175.25 (2804), range = 1, config = 0xce, cb = 0x02
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: Freq= 175.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3536
Feb 12 20:32:53 opus kernel: tuner-simple 1-0061: tv 0x0d 0xd0 0xce 0x02
Feb 12 20:32:53 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:32:53 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


Starting a mythtv recording.

Feb 12 20:34:12 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:34:12 opus kernel: tuner 1-0061: tv freq set to 175.25
Feb 12 20:34:12 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:34:12 opus kernel: tuner-simple 1-0061: freq = 175.25 (2804), range = 1, config = 0xce, cb = 0x02
Feb 12 20:34:12 opus kernel: tuner-simple 1-0061: Freq= 175.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3536
Feb 12 20:34:12 opus kernel: tuner-simple 1-0061: tv 0x0d 0xd0 0xce 0x02
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 175.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: freq = 175.25 (2804), range = 1, config = 0xce, cb = 0x02
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: Freq= 175.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3536
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: tv 0x0d 0xd0 0xce 0x02
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 175.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: freq = 175.25 (2804), range = 1, config = 0xce, cb = 0x02
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: Freq= 175.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3536
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: tv 0x0d 0xd0 0xce 0x02
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:34:13 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:34:13 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:34:13 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01
Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01


Stopping the myth recording.  

Feb 12 20:34:55 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:34:55 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:34:55 opus kernel: tuner 1-0061: Putting tuner to sleep


The mythtv recording failed.  This time, the video was very poor and
from the wrong channel.  Other times, the video is all static.


Stopping mythbackend.


Unloading modules.

Feb 12 20:34:55 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:35:46 opus kernel: saa7134 ALSA driver for DMA sound unloaded
Feb 12 20:35:46 opus kernel: dvb_unregister_frontend
Feb 12 20:35:46 opus kernel: dvb_frontend_stop
Feb 12 20:35:46 opus kernel: tuner-simple 1-000a: destroying instance


Reloading modules 

Feb 12 20:36:03 opus kernel: Linux video capture interface: v2.00
Feb 12 20:36:03 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Feb 12 20:36:03 opus kernel: saa7133[0]: found at 0000:04:07.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
Feb 12 20:36:03 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,autodetected]
Feb 12 20:36:03 opus kernel: saa7133[0]: board init: gpio is 100
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 12 20:36:03 opus kernel: tuner 1-0061: Setting mode_mask to 0x0e
Feb 12 20:36:03 opus kernel: tuner 1-0061: chip found @ 0xc2 (saa7133[0])
Feb 12 20:36:03 opus kernel: tuner 1-0061: tuner 0x61: Tuner type absent
Feb 12 20:36:03 opus kernel: tuner 1-0061: Calling set_type_addr for type=68, addr=0xff, mode=0x0e, config=0x00
Feb 12 20:36:03 opus kernel: tuner 1-0061: defining GPIO callback
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: creating new instance
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tuner 0 atv rf input will be autoselected
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tuner 0 dtv rf input will be autoselected
Feb 12 20:36:03 opus kernel: tuner 1-0061: type set to Philips TUV1236D ATSC/NTSC dual in
Feb 12 20:36:03 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:03 opus kernel: tuner 1-0061: saa7133[0] tuner I2C addr 0xc2 with type 68 used for 0x0e
Feb 12 20:36:03 opus kernel: tuner 1-0061: switching to v4l2
Feb 12 20:36:03 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:03 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:03 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:36:03 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:36:03 opus kernel: saa7133[0]: registered device video2 [v4l2]
Feb 12 20:36:03 opus kernel: saa7133[0]: registered device vbi2
Feb 12 20:36:03 opus kernel: saa7134 ALSA driver for DMA sound loaded
Feb 12 20:36:03 opus kernel: saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card 2
Feb 12 20:36:03 opus kernel: dvb_init() allocating 1 frontend
Feb 12 20:36:03 opus kernel: nxt200x: NXT info: 05 02 09 20 01
Feb 12 20:36:03 opus kernel: nxt200x: NXT2004 Detected
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: attaching existing instance
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tuner 0 atv rf input will be autoselected
Feb 12 20:36:03 opus kernel: tuner-simple 1-0061: tuner 0 dtv rf input will be autoselected
Feb 12 20:36:03 opus kernel: DVB: registering new adapter (saa7133[0])
Feb 12 20:36:03 opus kernel: dvb_register_frontend
Feb 12 20:36:03 opus kernel: DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Feb 12 20:36:03 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
Feb 12 20:36:03 opus kernel: firmware: requesting dvb-fe-nxt2004.fw
Feb 12 20:36:03 opus kernel: nxt2004: Waiting for firmware upload(2)...
Feb 12 20:36:03 opus kernel: nxt200x: nxt2004_load_firmware
Feb 12 20:36:03 opus kernel: nxt200x: Firmware is 9584 bytes
Feb 12 20:36:05 opus kernel: nxt200x: firmware crc is 0xF1 0xB2
Feb 12 20:36:05 opus kernel: nxt2004: Firmware upload complete
Feb 12 20:36:05 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:36:05 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus last message repeated 2 times
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus last message repeated 2 times
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus last message repeated 2 times
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:36:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:36:05 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:36:05 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:05 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:36:05 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:36:05 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:36:05 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:05 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:05 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:36:05 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


Starting tvtime.

Feb 12 20:36:23 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: desired params (pal) undefined for tuner 68
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x1b 0x6f 0xce 0x02
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 400.00
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x1b 0xdc 0xce 0x02
Feb 12 20:36:23 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:36:23 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:36:26 opus kernel: tuner 1-0061: tv freq set to 205.25
Feb 12 20:36:26 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:26 opus kernel: tuner-simple 1-0061: freq = 205.25 (3284), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:26 opus kernel: tuner-simple 1-0061: Freq= 205.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4016
Feb 12 20:36:26 opus kernel: tuner-simple 1-0061: tv 0x0f 0xb0 0xce 0x02
Feb 12 20:36:28 opus kernel: tuner 1-0061: tv freq set to 199.25
Feb 12 20:36:28 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:28 opus kernel: tuner-simple 1-0061: freq = 199.25 (3188), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:28 opus kernel: tuner-simple 1-0061: Freq= 199.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3920
Feb 12 20:36:28 opus kernel: tuner-simple 1-0061: tv 0x0f 0x50 0xce 0x02
Feb 12 20:36:29 opus kernel: tuner 1-0061: tv freq set to 205.25
Feb 12 20:36:29 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:29 opus kernel: tuner-simple 1-0061: freq = 205.25 (3284), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:29 opus kernel: tuner-simple 1-0061: Freq= 205.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4016
Feb 12 20:36:29 opus kernel: tuner-simple 1-0061: tv 0x0f 0xb0 0xce 0x02
Feb 12 20:36:30 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:36:30 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:36:30 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:36:30 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:36:30 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02


Stopping tvtime.  

Feb 12 20:36:35 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:36:35 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


tvtime worked fine, again.  The video was good and changing channels
worked.


Starting mythbackend.

Feb 12 20:37:05 opus kernel: dvb_frontend_open
Feb 12 20:37:05 opus kernel: dvb_frontend_start
Feb 12 20:37:05 opus kernel: dvb_frontend_thread
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: DVB: initialising adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Feb 12 20:37:05 opus kernel: dvb_frontend_release
Feb 12 20:37:05 opus kernel: dvb_frontend_open
Feb 12 20:37:05 opus kernel: dvb_frontend_start
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: dvb_frontend_release
Feb 12 20:37:05 opus kernel: dvb_frontend_open
Feb 12 20:37:05 opus kernel: dvb_frontend_start
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: dvb_frontend_get_event
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: dvb_frontend_add_event
Feb 12 20:37:05 opus kernel: dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:0 started_auto_step:0
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_microcontroller_stop
Feb 12 20:37:05 opus kernel: dvb_frontend_poll
Feb 12 20:37:05 opus kernel: dvb_frontend_ioctl
Feb 12 20:37:05 opus kernel: tuner-simple 1-0061: using tuner params #1 (digital)
Feb 12 20:37:05 opus kernel: tuner-simple 1-0061: freq = 693.00 (11088), range = 2, config = 0xc6, cb = 0x44
Feb 12 20:37:05 opus kernel: tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=11792 | buf=0x2e,0x10,0xc6,0x44
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_writetuner
Feb 12 20:37:05 opus kernel: nxt200x: Tuner Bytes: 2E 10 C6 44
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_agc_reset
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:05 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus last message repeated 2 times
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_readreg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_writereg_multibyte
Feb 12 20:37:06 opus kernel: nxt200x: nxt200x_microcontroller_start
Feb 12 20:37:06 opus kernel: nxt200x: nxt2004_microcontroller_init
Feb 12 20:37:06 opus kernel: dvb_frontend_release
Feb 12 20:37:06 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 211.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 211.25 (3380), range = 1, config = 0xce, cb = 0x02
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 211.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=4112
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x10 0x10 0xce 0x02
Feb 12 20:37:06 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:06 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:06 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:37:06 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV


Starting a mythtv recording.

Feb 12 20:37:48 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:37:48 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:37:48 opus kernel: tuner 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01


Stopping the mythtv recording.  

Feb 12 20:38:43 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:38:43 opus kernel: tuner 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
Feb 12 20:38:43 opus kernel: tuner 1-0061: Putting tuner to sleep
Feb 12 20:38:43 opus kernel: tuner 1-0061: Putting tuner to sleep


The mythtv recording worked fine this time.


David
-- 
David Engel
david@istwok.net
