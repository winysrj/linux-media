Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wienczny.de ([83.246.72.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Stephan@wienczny.de>) id 1Lh7bb-0005Ql-Hq
	for linux-dvb@linuxtv.org; Tue, 10 Mar 2009 20:27:12 +0100
Received: from fugo.wienczny.de (ip-78-94-110-176.unitymediagroup.de
	[78.94.110.176])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by wienczny.de (Postfix) with ESMTPSA id 77C692F06
	for <linux-dvb@linuxtv.org>; Tue, 10 Mar 2009 20:26:37 +0100 (CET)
From: Stephan Wienczny <Stephan@wienczny.de>
To: linux-dvb@linuxtv.org
Date: Tue, 10 Mar 2009 20:26:27 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_n7rtJU1EpGQ23o0"
Message-Id: <200903102026.31236.Stephan@wienczny.de>
Subject: [linux-dvb] Patch to add support for Terratec Cinergy HT PCI MKII
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_n7rtJU1EpGQ23o0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

the attachment contains a patch that adds support for Terratec Cinergy HT PCI 
mkII. As this is my first patch here please be gentle ;-P If there is something 
wrong I'll try to fix it.

Best regards
Stephan Wienczny

--Boundary-00=_n7rtJU1EpGQ23o0
Content-Type: text/plain;
  charset="UTF-8";
  name="terratec.export"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="terratec.export"

# HG changeset patch
# User Stephan Wienczny <stephan@wienczny.de>
# Date 1236712323 -3600
# Node ID 6846c359324b1229061b94926d15e3e4395a36d3
# Parent  f7f2fb8805ebfdab6d62c5f0af7c71e7164ef555
Adding support for Terratec Cinergy HT PCI mkII

From: Stephan Wienczny <stephan@wienczny.de>

This patch adds support for Terratec Cinergy HT PCI MKII with card id 79.
Its more or less a copy of Pinnacle Hybrid PCTV.
Thanks to k1ngf1sher on forum.ubuntuusers.de for the idea to copy that card.

Priority: normal

Signed-off-by: Stephan Wienczny <stephan@wienczny.de>

diff -r f7f2fb8805eb -r 6846c359324b linux/Documentation/video4linux/CARDLIST.cx88
--- a/linux/Documentation/video4linux/CARDLIST.cx88	Tue Mar 10 05:31:34 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.cx88	Tue Mar 10 20:12:03 2009 +0100
@@ -77,3 +77,4 @@
  76 -> SATTRADE ST4200 DVB-S/S2                            [b200:4200]
  77 -> TBS 8910 DVB-S                                      [8910:8888]
  78 -> Prof 6200 DVB-S                                     [b022:3022]
+ 79 -> Terratec Cinergy HT PCI MKII                        [153b:1177]
diff -r f7f2fb8805eb -r 6846c359324b linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Mar 10 05:31:34 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Tue Mar 10 20:12:03 2009 +0100
@@ -1967,6 +1967,39 @@
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII] = {
+		.name           = "Terratec Cinergy HT PCI MKII",
+		.tuner_type     = TUNER_XC2028,
+		.tuner_addr     = 0x61,
+		.radio_type     = TUNER_XC2028,
+		.radio_addr     = 0x61,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x004ff,
+			.gpio1  = 0x010ff,
+			.gpio2  = 0x00001,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x004fb,
+			.gpio1  = 0x010ef,
+			.audioroute = 1,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x004fb,
+			.gpio1  = 0x010ef,
+			.audioroute = 1,
+		} },
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x004ff,
+			.gpio1  = 0x010ff,
+			.gpio2  = 0x0ff,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2376,6 +2409,10 @@
 		.subvendor = 0xb200,
 		.subdevice = 0x4200,
 		.card      = CX88_BOARD_SATTRADE_ST4200,
+	}, {
+		.subvendor = 0x153b,
+		.subdevice = 0x1177,
+		.card      = CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII,
 	},
 };
 
@@ -2852,6 +2889,7 @@
 		 */
 		break;
 	case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+	case CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		ctl->mts = 1;
 		break;
diff -r f7f2fb8805eb -r 6846c359324b linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Mar 10 05:31:34 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Mar 10 20:12:03 2009 +0100
@@ -240,6 +240,12 @@
 static struct mt352_config dvico_fusionhdtv_dual = {
 	.demod_address = 0x0f,
 	.demod_init    = dvico_dual_demod_init,
+};
+
+static struct zl10353_config cx88_terratec_cinergy_ht_pci_mkii_config = {
+	.demod_address = (0x1e >> 1),
+	.no_tuner      = 1,
+	.if2           = 45600,
 };
 
 #if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
@@ -1138,6 +1144,16 @@
 		if (fe0->dvb.frontend != NULL)
 			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
 		break;
+	case CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII:
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+					       &cx88_terratec_cinergy_ht_pci_mkii_config,
+					       &core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+			if (attach_xc3028(0x61, dev) < 0)
+				goto frontend_detach;
+		}
+		break;
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       core->name);
diff -r f7f2fb8805eb -r 6846c359324b linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Tue Mar 10 05:31:34 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Tue Mar 10 20:12:03 2009 +0100
@@ -232,6 +232,7 @@
 #define CX88_BOARD_SATTRADE_ST4200         76
 #define CX88_BOARD_TBS_8910                77
 #define CX88_BOARD_PROF_6200               78
+#define CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII 79
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--Boundary-00=_n7rtJU1EpGQ23o0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_n7rtJU1EpGQ23o0--
