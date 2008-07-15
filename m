Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wp025.webpack.hosteurope.de ([80.237.132.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <julian@summer06.de>) id 1KIuNH-0002OU-RC
	for linux-dvb@linuxtv.org; Wed, 16 Jul 2008 01:56:04 +0200
Message-ID: <487D38EE.6000007@summer06.de>
Date: Wed, 16 Jul 2008 01:55:26 +0200
From: Julian Picht <julian@summer06.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------090502090102020609010700"
Cc: abraham.manu@gmail.com
Subject: [linux-dvb] Initial work on: TerraTec Cinergy S PCI [14f1:8800]
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

This is a multi-part message in MIME format.
--------------090502090102020609010700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi List,

if is there anybody with a TerraTec Cinergy S PCI please try the 
attached patch (against current hg) to test if the vertical transponders 
work. Voltage switching is not implemented so horizontal transponders 
won't work.

With this patch applied I can tune. On some channels a signal is 
detected but FE_LOCK fails. I never used this satellite receiver 
installation before, so I don't know if it actually works. I would be 
REALLY happy if ANYONE could try this!

Many thanks to Manu Abraham for his mb86a16 tuner driver implementation, 
which actually seems to work with the cx88 driver with no problems.

ATTENTION: This patch is a hack! Don't use it if you don't know what you 
are doing. Don't expect it to add real support for the mentioned pci 
card. This driver is very experimental and in a very early state of 
development.

Regards,
Julian Picht

--------------090502090102020609010700
Content-Type: text/x-patch;
 name="s_pci.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s_pci.diff"

diff -r 0ebffe1cc136 linux/drivers/media/dvb/frontends/Kconfig
--- a/linux/drivers/media/dvb/frontends/Kconfig	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/Kconfig	Mon Jul 14 16:16:54 2008 +0200
@@ -394,4 +394,11 @@
 	help
 	  An SEC control chip.
 
+config DVB_MB86A16
+	tristate "Fujitsu MB86A16 based"
+	depends on DVB_CORE && I2C
+	default m
+	help
+	  A DVB-S/DSS tuner module. Say Y when you want to support this frontend.
+
 endmenu
diff -r 0ebffe1cc136 linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/Makefile	Mon Jul 14 16:16:54 2008 +0200
@@ -48,3 +48,4 @@
 obj-$(CONFIG_DVB_AU8522) += au8522.o
 obj-$(CONFIG_DVB_TDA10048) += tda10048.o
 obj-$(CONFIG_DVB_S5H1411) += s5h1411.o
+obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
diff -r 0ebffe1cc136 linux/drivers/media/video/cx88/Kconfig
--- a/linux/drivers/media/video/cx88/Kconfig	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/cx88/Kconfig	Mon Jul 14 16:16:54 2008 +0200
@@ -59,6 +59,7 @@
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
+	select DVB_MB86A16 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB/ATSC cards based on the
 	  Conexant 2388x chip.
diff -r 0ebffe1cc136 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Mon Jul 14 16:16:54 2008 +0200
@@ -1701,6 +1701,26 @@
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	/* Nothing working :(
+	 */
+	[CX88_BOARD_TERRATEC_S_PCI] = {
+		.name           = "TerraTec CINERGY S PCI",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2050,6 +2070,10 @@
 		.subvendor = 0x17de,
 		.subdevice = 0x08c1,
 		.card      = CX88_BOARD_KWORLD_ATSC_120,
+	}, {
+		.subvendor = 0x153b,
+		.subdevice = 0x117a,
+		.card      = CX88_BOARD_TERRATEC_S_PCI,
 	},
 };
 
diff -r 0ebffe1cc136 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Jul 14 16:16:54 2008 +0200
@@ -49,6 +49,7 @@
 #include "tuner-simple.h"
 #include "tda9887.h"
 #include "s5h1411.h"
+#include "mb86a16.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -487,6 +488,16 @@
 	.tuner_callback = cx88_tuner_callback,
 };
 
+int mb86_cx88_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	return 0;
+};
+
+static struct mb86a16_config cinergy_s_pci_config = {
+	.demod_address = 0x08,
+	.set_voltage   = mb86_cx88_set_voltage,
+};
+
 static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 {
 	struct dvb_frontend *fe;
@@ -891,6 +902,11 @@
 				goto frontend_detach;
 		}
 		break;
+	case CX88_BOARD_TERRATEC_S_PCI:
+		dev->dvb.frontend = dvb_attach(mb86a16_attach,
+					       &cinergy_s_pci_config,
+					       &core->i2c_adap);
+		break;
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       core->name);
diff -r 0ebffe1cc136 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Mon Jul 14 16:16:54 2008 +0200
@@ -222,6 +222,7 @@
 #define CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD 65
 #define CX88_BOARD_PROLINK_PV_8000GT       66
 #define CX88_BOARD_KWORLD_ATSC_120         67
+#define CX88_BOARD_TERRATEC_S_PCI          68
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--------------090502090102020609010700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090502090102020609010700--
