Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.one.lv ([62.85.54.7]:45432 "HELO mail1.one.lv"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751334AbZDCH2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 03:28:30 -0400
Date: Fri, 3 Apr 2009 10:21:45 +0300 (GMT+03:00)
From: Dakteris Kirurgs <Kirurgs@one.lv>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-ID: <29656576.109901.1238743306188.JavaMail.root@www3.one.lv>
Subject: DTV2000H rev. J support (patch included)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_109898_1854382.1238743305993"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_109898_1854382.1238743305993
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Description: 

Hi!

I have an Leadtek DTV200H rev. J hybrid card, I bought it like a half of year back. It's not the same as regular DTV2000, rev. J was mentioned to be Vista compatible or so, they changed smth, like GPIO values.
There was this guy Zbynek Hrabovsky who made path and posted it to kernel mailing list (I think), but he got quite funny responses and nothing really evolved.
I want to help to support this card out of the box.

I made a patch for 2.6.29 kernel, which differs from Zbynek's patch, however GPIO values were taken from his patch (video ones), I don't know about radio ones at all. I'll attach the patch to this email, I'll attach dmesg output as well.
There are some problems with this card and driver currently. The card works only when computer is started for the second time - from the cold start card doesn't work at all, then I restart computer and card starts working. I suspect this is because of two TV inputs.
The card have 2 TV inputs: one digital + analog and second only analog. This patch works with one TV input only (the first I think), previously I remember to have both of them working, only change in patch was vmux = 0 for both TV inputs. Now I changed them for 0 and 1 respectively. I don't have that knowledge to know what should be what.
I really hope You guys can help with this. I haven't tested digital video and dmesg show funny messages about frontend not to be supported.
I really hope this can be finished finally.
If You will need anything, please ask, I'll do whatever I can to help.

regards
Kirurgs

-------------------------------------------------------------------------------
http://www.one.lv - Tavs mobilais e-pasts!

Tagad lasi savu e-pastu ar mobilo telefonu - wap.one.lv!
------=_Part_109898_1854382.1238743305993
Content-Type: application/octet-stream; name=dmesg_output.txt
Content-Transfer-Encoding: 7bit
Content-Description: dmesg_output.txt
Content-Disposition: attachment; filename=dmesg_output.txt

cx88_audio 0000:00:0c.1: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
cx88[0]: subsystem: 107d:6f2b, board: WinFast DTV2000H J [card=100,autodetected], frontend(s): 1
cx88[0]: TV tuner type 63, Radio tuner type -1
tuner' 0-0043: chip found @ 0x86 (cx88[0])
tuner' 0-0061: chip found @ 0xc2 (cx88[0])
tuner' 0-0063: chip found @ 0xc6 (cx88[0])
input: cx88 IR (WinFast DTV2000H J) as /devices/pci0000:00/0000:00:0c.1/input/input4
IRQ 10/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
cx88[0]/0: found at 0000:00:0c.0, rev: 5, irq: 10, latency: 32, mmio: 0xe4000000
IRQ 10/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:00:0c.2: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
cx88[0]/2: found at 0000:00:0c.2, rev: 5, irq: 10, latency: 32, mmio: 0xe6000000
IRQ 10/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 107d:6f2b, board: WinFast DTV2000H J [card=100]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
cx88[0]/2: The frontend of your DVB/ATSC card isn't supported yet
cx88[0]/2: frontend initialization failed
cx88[0]/2: dvb_register failed (err = -22)
cx88[0]/2: cx8802 probe failed, err = -22

------=_Part_109898_1854382.1238743305993
Content-Type: application/octet-stream; name=add_dtv200hj.patch
Content-Transfer-Encoding: 7bit
Content-Description: add_dtv200hj.patch
Content-Disposition: attachment; filename=add_dtv200hj.patch

diff -rup 28/drivers/media/video/cx88/cx88-cards.c 29/drivers/media/video/cx88/cx88-cards.c
--- 28/drivers/media/video/cx88/cx88-cards.c	2009-03-24 01:12:14.000000000 +0200
+++ 29/drivers/media/video/cx88/cx88-cards.c	2009-03-31 11:56:29.000000000 +0300
@@ -1281,6 +1281,51 @@ static const struct cx88_board cx88_boar
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_WINFAST_DTV2000H_2] = {
+		.name           = "WinFast DTV2000H J",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x00000000,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 1,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2  = 0x00017304,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux = 2,
+			.gpio0 = 0x00018301,
+			.gpio1 = 0x0000f207,
+			.gpio2 = 0x00017304,
+			.gpio3 = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux = 3,
+			.gpio0 = 0x00018301,
+			.gpio1 = 0x0000f207,
+			.gpio2 = 0x00017304,
+			.gpio3 = 0x02000000,
+		}},
+		.radio = {
+			 .type  = CX88_RADIO,
+			 .gpio0 = 0x00015702,
+			 .gpio1 = 0x0000f207,
+			 .gpio2 = 0x00015702,
+			 .gpio3 = 0x02000000,
+		},
+		.mpeg       = CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
 		.name          = "Geniatech DVB-S",
 		.tuner_type    = TUNER_ABSENT,
@@ -2187,6 +2232,10 @@ static const struct cx88_subid cx88_subi
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_2,
+	},{
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -rup 28/drivers/media/video/cx88/cx88-input.c 29/drivers/media/video/cx88/cx88-input.c
--- 28/drivers/media/video/cx88/cx88-input.c	2009-03-24 01:12:14.000000000 +0200
+++ 29/drivers/media/video/cx88/cx88-input.c	2009-03-31 11:56:52.000000000 +0300
@@ -231,6 +231,7 @@ int cx88_ir_init(struct cx88_core *core,
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
diff -rup 28/drivers/media/video/cx88/cx88-mpeg.c 29/drivers/media/video/cx88/cx88-mpeg.c
--- 28/drivers/media/video/cx88/cx88-mpeg.c	2009-03-24 01:12:14.000000000 +0200
+++ 29/drivers/media/video/cx88/cx88-mpeg.c	2009-03-31 11:58:35.000000000 +0300
@@ -92,6 +92,12 @@ static int cx8802_start_dma(struct cx880
 	/* FIXME: this needs a review.
 	 * also: move to cx88-blackbird + cx88-dvb source files? */
 
+	/* switch signal input to antena */
+	/*
+	if ((core->boardnr) == CX88_BOARD_WINFAST_DTV2000H_2)
+		cx_write(MO_GP0_IO, 0x00017300);
+	*/
+
 	dprintk( 1, "core->active_type_id = 0x%08x\n", core->active_type_id);
 
 	if ( (core->active_type_id == CX88_MPEG_DVB) &&
diff -rup 28/drivers/media/video/cx88/cx88.h 29/drivers/media/video/cx88/cx88.h
--- 28/drivers/media/video/cx88/cx88.h	2009-03-24 01:12:14.000000000 +0200
+++ 29/drivers/media/video/cx88/cx88.h	2009-03-31 12:00:04.000000000 +0300
@@ -231,6 +231,7 @@ extern struct sram_channel cx88_sram_cha
 #define CX88_BOARD_SATTRADE_ST4200         76
 #define CX88_BOARD_TBS_8910                77
 #define CX88_BOARD_PROF_6200               78
+#define CX88_BOARD_WINFAST_DTV2000H_2      100
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

------=_Part_109898_1854382.1238743305993--
