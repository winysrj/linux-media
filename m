Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33340 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbZGSUE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 16:04:26 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090718T135733-267@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
Content-Type: multipart/mixed; boundary="=-KVQiw/t0Tj9scf9B7Fgj"
Date: Sun, 19 Jul 2009 21:59:41 +0200
Message-Id: <1248033581.3667.40.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KVQiw/t0Tj9scf9B7Fgj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Am Samstag, den 18.07.2009, 14:05 +0000 schrieb Avl Jawrowski:
> Hello,
> I have a problem with my Pinnacle PCTV Hybrid Pro PCI using recent kernels. With
>  2.6.29 both dvbscan and MPlayer stopped to work giving:
> 
> dvbscan:
> Unable to query frontend status
> 
> mplayer:
> MPlayer SVN-r29351-4.2.4 (C) 2000-2009 MPlayer Team
> 
> Not able to lock to the signal on the given frequency, timeout: 30
> dvb_tune, TUNING FAILED
> 
> Now with 2.6.30.1 Kaffeine sometimes works and sometimes not, going in timeout.
> This is the hardware:
> 
> 01:02.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Vi
> deo Broadcast Decoder (rev d1)
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
> - <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (63750ns min, 63750ns max)
>         Interrupt: pin A routed to IRQ 22
>         Region 0: Memory at cfddf800 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=3 PME-
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
> 
> dmesg output:
> 
> saa7130/34: v4l2 driver version 0.2.15 loaded
> saa7134 0000:01:02.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> saa7133[0]: found at 0000:01:02.0, rev: 209, irq: 22, latency: 32, mmio: 0xcfddf
> 800
> saa7133[0]: subsystem: ffff:ffff, board: Pinnacle PCTV 310i [card=101,insmod opt
> ion]

i2c fails to read the subsystem from the eeprom.

> saa7133[0]: board init: gpio is 600c000
> IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]: i2c eeprom read error (err=-5)

Confirmed here again for the complete eeprom content.

> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> tda829x 1-004b: setting tuner address to 61
> tda829x 1-004b: type set to tda8290+75a

Nothing about the IR, but at least all tuner modules seem to be
correctly loaded.

> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> saa7134 ALSA driver for DMA sound loaded
> IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xcfddf800 irq 22 registered as card -1
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> 
> Can anyone help me getting my tyner working again?
> Thanks, avljawrowski
> 

What was your last good working kernel and was your eeprom already
failing there too, or is that new?

Usually such is caused by bad contacts of the PCI slot or by a bad PSU,
but we have reports from a Pinnacle 50i with the same i2c remote.

It has i2c troubles (ARB_LOST) and then also problems on loading the
tuner modules correctly. With disable_ir=1 for saa7134 it became at
least somewhat usable again.

But for the 310i is another problem reported starting with kernel
2.6.26.

The 310i and the HVR1110 are the only cards with LowNoiseAmplifier
config = 1. Before 2.6.26 two buffers were sent to the tuner at 0x61,
doing some undocumented LNA configuration, since 2.6.26 they go to the
analog IF demodulator tda8290 at 0x4b.

This was bisected here on the list and is wrong for the 300i.
Thread is "2.6.26 regression ..."

The HVR1110 using the same new configuration seems to come in variants
with and without LNA and nobody knows, how to make a difference for
those cards. At least still no reports about troubles with the new LNA
configuration there.

The attached patch against recent mercurial master v4l-dvb at
linuxtv.org tries to restore the pre 2.6.26 behaviour for DVB-T on the
300i.

It changes also the i2c remote address of the Upmost Purple TV from 0x7a
to 0x3d, since recent i2c on >= 2.6.30 complains about it as invalid
7-bit address, just in case.

Good luck,

Hermann








--=-KVQiw/t0Tj9scf9B7Fgj
Content-Description: 
Content-Disposition: inline; filename=saa7134-try_to_improve_the_310i.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r d277b05c41fe linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Sun Jul 12 11:04:15 2009 -0300
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sun Jul 19 19:44:30 2009 +0200
@@ -601,7 +601,7 @@
 	*/
 
 	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
-	static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
+	static const int probe_saa7134[] = { 0x3d, 0x47, 0x71, 0x2d, -1 };
 	static const int probe_em28XX[] = { 0x30, 0x47, -1 };
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
 	static const int probe_cx23885[] = { 0x6b, -1 };
diff -r d277b05c41fe linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Jul 12 11:04:15 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Jul 19 19:44:30 2009 +0200
@@ -580,6 +580,13 @@
 	.switch_addr = 0x4b
 };
 
+static struct tda827x_config tda827x_cfg_1_310i = {
+	.init = philips_tda827x_tuner_init,
+	.sleep = philips_tda827x_tuner_sleep,
+	.config = 1,
+	.switch_addr = 0x61
+};
+
 static struct tda827x_config tda827x_cfg_2 = {
 	.init = philips_tda827x_tuner_init,
 	.sleep = philips_tda827x_tuner_sleep,
@@ -1139,7 +1146,7 @@
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
-					 &tda827x_cfg_1) < 0)
+					 &tda827x_cfg_1_310i) < 0)
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
diff -r d277b05c41fe linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Jul 12 11:04:15 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Jul 19 19:44:30 2009 +0200
@@ -737,7 +737,7 @@
 	struct i2c_board_info info;
 	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
-		0x7a, 0x47, 0x71, 0x2d,
+		0x3d, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
 	};
 

--=-KVQiw/t0Tj9scf9B7Fgj--

