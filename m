Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FIeahi006226
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 14:40:37 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FIeJTH010247
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 14:40:20 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans-Peter Diettrich <DrDiettrich1@aol.com>, video4linux-list@redhat.com
In-Reply-To: <48540B1E.3020908@aol.com>
References: <485273BB.6040608@aol.com>
	<1213387999.2758.65.camel@pc10.localdom.local>
	<48540B1E.3020908@aol.com>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 20:39:08 +0200
Message-Id: <1213555148.2683.61.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Medion problem
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Samstag, den 14.06.2008, 20:17 +0200 schrieb Hans-Peter Diettrich:
> hermann pitton schrieb:
> 
> > The Nvidia binary drivers are in most cases fine, on latest cards even
> > needed, since only VESA support else, that would work with xawtv in its
> > default overlay preview mode, but that is not supported on the binary
> > drivers anymore. Therefore you would like to force it to
> > grabdisplay/mmapped mode with "xawtv -nodga -remote -c /dev/video0"
> 
> Close, but here's what really works so far:
> 
> dodi@noname:~> xawtv -nodga -remote -c /dev/video1
> This is xawtv-3.95, running on Linux/x86_64 (2.6.22.17-0.1-default)
> xinerama 0: 1280x1024+1680+0
> xinerama 1: 1680x1050+0+0

it is because the 16be:0005 device is detected at first now on the PCI
bus and thus 16be:0003 becomes /dev/video1.

> Only the sound is missing :-(
> Even modprobe (tuner and saa7134) didn't help.

The card has usually also internally a red MPC2 style analog audio out
connector. Since about the md8383 this is not connected anymore to AUX
or CD-in of the soundchip of the board. You can use a cdrom audio cable
for that.

The other option is to load saa7134-alsa for dma sound.
Have a look at the v4l wiki at linuxtv.org for usage hints.

A quick start is:
"sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp"

> The -nodga seems to have no effect, -remote is required, as well as -c.

The -remote forces grabdisplay mode, since overlay preview is not
supported with the binary drivers, -c sets the video device, since the
Nvidia cards have some own videoport, which confuses xawtv.
Likely -nodga is not required, since you are in xinerama mode and are
using the videoblitter.

> 
> > Please post the relevant part of "dmesg" after that.
> 
> Here's a possibly incomplete snippet:
> 
> saa7134[0]: found at 0000:02:00.0, rev: 1, irq: 16, latency: 84, mmio: 
> 0xfddff000
> saa7134[0]: subsystem: 16be:0005, board: Medion 7134 Bridge #2 
> [card=93,autodetected]
> saa7134[0]: board init: gpio is 0
> saa7134[0]: Medion 7134 Bridge #2: dual saa713x broadcast decoders
> saa7134[0]: Sorry, none of the inputs to this chip are supported yet.
> saa7134[0]: Dual decoder functionality is disabled for now, use the 
> other chip.
> saa7134[0]: i2c eeprom 00: be 16 05 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
> saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 21 02 51 96 2b
> saa7134[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
> saa7134[0]: i2c eeprom 40: ff 24 00 c0 ff 1c 00 ff ff ff fd 79 44 9f c2 8f
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 17 (level, low) -> IRQ 17
> saa7134[1]: found at 0000:02:01.0, rev: 1, irq: 17, latency: 8, mmio: 
> 0xfddfe000
> PCI: Setting latency timer of device 0000:02:01.0 to 64
> saa7134[1]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
> saa7134[1]: board init: gpio is 0
> tuner 2-0043: chip found @ 0x86 (saa7134[1])
> tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner)
> tuner 2-0060: All bytes are equal. It is not a TEA5767
> tuner 2-0060: chip found @ 0xc0 (saa7134[1])
> tuner 2-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> tuner 2-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> saa7134[1]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> saa7134[1]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> saa7134[1]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[1] Tuner type is 38
> saa7134[1]: registered device video1 [v4l2]
> saa7134[1]: registered device vbi1
> saa7134[1]: registered device radio0
> saa7134[1]/dvb: frontend initialization failed
> 

Thanks, this did confuse me a little last night,
but on a second look it really might mean that you have a new and
undocumented card type/revision under 16be:0003 and I start some
guessing.

It is all about if you really have the detected, but not loaded analog
only tuner=38 (FM1216ME/I H-3) or the hybrid with analog and DVB-T
support tuner=63 (FMD1216ME/I H-3).

It seems it is the analog only tuner.
The hybrid one comes also with an external Philips tda10046 channel
decoder chip.
If you would enable "i2c_scan=1" on loading the saa7134 it should be
found at i2c address 0x10 in dmesg, but frontend attach fails already
and the tda10046 is also not present in the eeprom.

Is DVB-T announced at all? Best would be to take the card out, look at
the CTX???_V? type and revision, read the tuner label and report if the
tda10046 is there.

If it has the FM1216ME/I H-3 analog only, some pictures would be welcome
as well, since not yet documented.
The version of the ISL chip for the 12Volt supply of the LNB would also
be interesting. On the known one it is isl6405er.
In case you send pics, please off list or load them up somewhere.

The likely correct tuner=38 would be set again with current v4l-dvb.
There was a regression in the eeprom tuner detection, which is fixed
now. Both tuners are not fully compatible for analog. With a wrong one
set, you lose some channels and on low VHF they might be noisy/snowy.

To escape the broken eeprom detected tuner setup, you can use the
compatible card=5 and force the tuner type there for the 16be:0003
section.
"modprobe -v saa7134 card=93,5 tuner=4,38 latency=64 gbuffers=32"
something. The -v is important to see if there is something from YAST
overriding your command line.

Please keep the list in reply.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
