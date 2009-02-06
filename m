Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n16MRXMU000656
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 17:27:33 -0500
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n16MQxqI010659
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 17:27:00 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: John Pilkington <J.Pilk@tesco.net>
In-Reply-To: <498C3AD4.1070907@tesco.net>
References: <498C3AD4.1070907@tesco.net>
Content-Type: multipart/mixed; boundary="=-lEK8a5QB9weRkznKeNo5"
Date: Fri, 06 Feb 2009 23:19:24 +0100
Message-Id: <1233958764.2466.72.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: v4l_list <video4linux-list@redhat.com>
Subject: Re: Hauppauge HVR-1110 analog audio problem
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


--=-lEK8a5QB9weRkznKeNo5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi John,

Am Freitag, den 06.02.2009, 13:27 +0000 schrieb John Pilkington:
> Hi Hermann:  I last corresponded with you about a year ago.  That was 
> very helpful to me. Now I am having difficulty getting the v4l list 
> system to recognise me, so please forgive me for sending this direct.
> ----------------
> (My apologies - it looks as if I had unsubscribed, not just disabled 
> access.  It's working now.)
> ----------------

have a look at linuxtv.org. We are moving to linux-media@vger.kernel.org

> I have a new(ish) box made by Gateway fitted with a
> 
>   Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected].

That are several slightly different cards.

According to Mike's comments in hauppauge_eeprom in saa7134-cards.c
yours should have RCA (cinch) analog audio in I believe.

I can't tell if on OEM machines the internal white panel connector
forwards analog audio out to the sound card/chip too and if it is
connected at all in your case.

static void hauppauge_eeprom(struct saa7134_dev *dev, u8 *eeprom_data)
{
	struct tveeprom tv;

	tveeprom_hauppauge_analog(&dev->i2c_client, &tv, eeprom_data);

	/* Make sure we support the board model */
	switch (tv.model) {
	case 67019: /* WinTV-HVR1110 (Retail, IR Blaster, hybrid, FM, SVid/Comp, 3.5mm audio in) */
	case 67109: /* WinTV-HVR1000 (Retail, IR Receive, analog, no FM, SVid/Comp, 3.5mm audio in) */
	case 67559: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM, SVid/Comp, RCA aud) */            <-----------------
	case 67569: /* WinTV-HVR1110 (OEM, no IR, hybrid, FM) */
	case 67579: /* WinTV-HVR1110 (OEM, no IR, hybrid, no FM) */
	case 67589: /* WinTV-HVR1110 (OEM, no IR, hybrid, no FM, SVid/Comp, RCA aud) */
	case 67599: /* WinTV-HVR1110 (OEM, no IR, hybrid, no FM, SVid/Comp, RCA aud) */
		break;
	default:
		printk(KERN_WARNING "%s: warning: "
		       "unknown hauppauge model #%d\n", dev->name, tv.model);
		break;
	}

	printk(KERN_INFO "%s: hauppauge eeprom: model=%d\n",
	       dev->name, tv.model);
}


> It works well with DVD-T but I can get no analog audio from it.

That is good to know, on the Pinnacle 310i with the same LNA config = 1
others seem to have some problems with that config on 2.6.27 already.

However, on the HVR1110 Composite/S-Video audio in and the radio was
never tested and I worked with David and Tom to fix it by introducing
gpio switching on the external audio mux and correcting the LINE of
input pairs. Analog TV sound was working by default also previously.

This patch is only in 2.6.28 or mercurial v4l-dvb. (attached)

>   I have 
> tried both the antenna input and Composite.  The picture from tvtime is 
> good.  I see that people have used sox as a workaround but if that is 
> still needed I haven't found the right device name yet. The 'PulseAudio 
> Volume Control' 'Show all input devices' shows only HDA Intel STAC92xx 
> Analog and its Monitor. But there may also be a module problem - if I 
> need the module.

For tvtime it is still needed with saa7134-alsa, only mplayer/mencoder
does support it directly.

sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp

/usr/local/bin/mencoder -v tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:chanlist=europe-west:alsa:adevice=hw.1,0:audiorate=32000:amode=1:forceaudio:volume=95:immediatemode=0:norm=PAL -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=3600 -vf pp=lb -oac mp3lame -lameopts cbr:br=128:mode=0 -o test.avi

/usr/local/bin/mplayer -v tv:// -vf pp=lb -tv driver=v4l2:norm=PAL:input=0:alsa:adevice=hw.1,0:forceaudio:immediatemode=0:audiorate=32000:amode=1:width=640:height=480:outfmt=yuy2:device=/dev/video0:chanlist=europe-west:channel=E6

You might use PAL-I and start with one of your UHF channels.

> '# modprobe saa7134-alsa'  puts
> 
> 'saa7134_alsa: Unknown symbol snd_card_new' into dmesg

But nothing like 'disagrees about symbol version' because of maybe mixed
up modules?

Nothing found in /lib/modules/your_kernel with
less modules.symbols |grep snd_card_new ?

less modules.symbols |grep snd_card_new
alias symbol:snd_card_new snd

The snd_card_new is called from saa7134-alsa for adding the new sound
device and the symbol is exported from snd.

modinfo snd
filename:       /lib/modules/2.6.27.2/kernel/sound/core/snd.ko
alias:          char-major-116-*
license:        GPL
description:    Advanced Linux Sound Architecture driver for soundcards.
author:         Jaroslav Kysela <perex@perex.cz>
srcversion:     D48337942305C9A41A7CC12
depends:        soundcore
vermagic:       2.6.27.2 SMP preempt mod_unload
parm:           slots:Module names assigned to the slots. (array of charp)
parm:           major:Major # for sound driver. (int)
parm:           cards_limit:Count of auto-loadable soundcards. (int)

Hmm, there was a similar report for Intel Corporation ICH10 HD Audio
Controller, but that user did upgrade to alsa-driver-1.0.19 to get his
stuff supported and maybe they did change something. 

> System is Fedora 10 x86_64 fully updated and with the ATrpms repo enabled.

No such problem on my Fedora 10 2.6.27-12-170.2.5.fc10.x86_64 and
2.6.28.2 but already upgraded to recent v4l-dvb. I also have a different
HDA Intel Codec on Fedora 8 with 2.6.27 without such problem.

Did you upgrade to out of official kernel alsa stuff from Axel like
alsa-kmdl-2.6.27.12-170.2.5.fc10-1.0.19-76.fc10.x86_64.rpm ?

Then please try the unchanged Fedora 10 kernel and/or mercurial v4l-dvb
with kernel-devel installed. For the latter, after make, make rmmod,
make rminstall delete remaining older modules
in /lib/modules/your_kernel/kernel/drivers/media or delete just the
media folder.

make install
modprobe -v saa7134 alsa=0  (is new, 1 is default after reboot ...)
modprobe -v saa7134-alsa debug=1

> The dmesg shows that my card differs from the v4l original.  What looks 
> like the relevant part of mine follows.
> 
> I hope this info is useful for you, and hope that you can help me find 
> the missing audio.  Post the message if you like, but please copy any 
> reply to me.
> 
> Best Wishes,
> 
> John Pilkington
> ---------------------------
> Linux video capture interface: v2.00
> firewire_core: created device fw0: GUID 0090270001c0db68, S400
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 32, mmio: 
> 0x92014800
> saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 
> DVB-T/Hybrid [card=104,autodetected]
> saa7133[0]: board init: gpio is 400000
> saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
> saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
> saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
> saa7133[0]: i2c eeprom b0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom c0: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
> saa7133[0]: i2c eeprom d0: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
> saa7133[0]: i2c eeprom e0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
> saa7133[0]: i2c eeprom f0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
> nvidia: module license 'NVIDIA' taints kernel.
> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> tveeprom 1-0050: Hauppauge model 67559, rev B1B4, serial# 1539545
.............................^^^^^^^^^^^

> tveeprom 1-0050: MAC address is 00-0D-FE-17-7D-D9
> tveeprom 1-0050: tuner model is Philips 8275A (idx 114, type 4)
..............type 4 TUNER_ABSENT is not updated to type 54 in tveeprom

> tveeprom 1-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') 
> PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> tveeprom 1-0050: audio processor is SAA7131 (idx 41)
> tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
> tveeprom 1-0050: has radio
> saa7133[0]: hauppauge eeprom: model=67559
> tda829x 1-004b: setting tuner address to 61
> tda829x 1-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> HDA Intel 0000:00:1b.0: setting latency timer to 64
> nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> nvidia 0000:01:00.0: setting latency timer to 64
> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.22  Tue Jan  6 
> 09:15:58 PST 2009
> input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> input: HDA Intel at 0x92220000 irq 22 Line In at Ext Rear Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input7
> input: HDA Intel at 0x92220000 irq 22 Mic at Ext Front Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input8
> tda1004x: setting up plls for 48MHz sampling clock
> input: HDA Intel at 0x92220000 irq 22 Mic at Ext Rear Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input9
> input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input10
> input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input11
> input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input12
> input: HDA Intel at 0x92220000 irq 22 HP Out at Ext Front Jack as 
> /devices/pci0000:00/0000:00:1b.0/input/input13
> -----
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> firmware: requesting dvb-fe-tda10046.fw
> ----------
> tda1004x: found firmware revision 20 -- ok
> ------------
> etc
> 

Good luck John!

Cheers,
Hermann


--=-lEK8a5QB9weRkznKeNo5
Content-Description: 
Content-Disposition: inline;
	filename*0=saa7134_hauppauge-hvr-1110_enable_analog_audio_in_and_radio.p;
	filename*1=atch
Content-Type: text/x-patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r 8e6cda021e0e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Sep 26 11:29:03 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 28 17:21:45 2008 +0200
@@ -3299,6 +3299,7 @@
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1110] = {
 		/* Thomas Genty <tomlohave@gmail.com> */
+		/* David Bentham <db260179@hotmail.com> */
 		.name           = "Hauppauge WinTV-HVR1110 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
@@ -3307,23 +3308,26 @@
 		.radio_addr     = ADDR_UNSET,
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 1,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name   = name_comp1,
-			.vmux   = 3,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		},{
-			.name   = name_svideo,
-			.vmux   = 8,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
+		.gpiomask       = 0x0200100,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000100,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200100,
 		},
 	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {

--=-lEK8a5QB9weRkznKeNo5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-lEK8a5QB9weRkznKeNo5--
