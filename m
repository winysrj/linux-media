Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab0I2SK3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 14:10:29 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8TIASTr010984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 14:10:29 -0400
Received: from [10.3.224.84] (vpn-224-84.phx2.redhat.com [10.3.224.84])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8THrnwg015087
	for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 13:53:50 -0400
Message-ID: <4CA37D2C.1040608@redhat.com>
Date: Wed, 29 Sep 2010 14:53:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L/DVB: saa7134: split RC code into a different module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This allows the removal of CONFIG_INPUT from saa7134, and
helps to create a better Kconfig dependency hierarchy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index fda005e..892b0b1 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -1,8 +1,7 @@
 config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C
 	select VIDEOBUF_DMA_SG
-	depends on VIDEO_IR
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select CRC32
@@ -25,6 +24,17 @@ config VIDEO_SAA7134_ALSA
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7134-alsa.
 
+config VIDEO_SAA7134_RC
+	tristate "Philips SAA7134 Remote Controller support"
+	depends on VIDEO_IR
+	depends on VIDEO_SAA7134
+	default y
+	---help---
+	  Enables Remote Controller support for saa7134.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa7134-rc.
+
 config VIDEO_SAA7134_DVB
 	tristate "DVB/ATSC Support for saa7134 based TV cards"
 	depends on VIDEO_SAA7134 && DVB_CORE
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 604158a..5624468 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -1,7 +1,9 @@
 
 saa7134-objs :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o	\
 		saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
-		saa7134-video.o saa7134-input.o
+		saa7134-video.o
+
+saa7134-rc-objs := saa7134-input.o
 
 obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
 
@@ -9,6 +11,8 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
+obj-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-rc.o
+
 EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 3a0ea56..a6ac462 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -28,7 +28,7 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 
-#define MODULE_NAME "saa7134"
+#define MODULE_NAME "saa7134-rc"
 
 static unsigned int disable_ir;
 module_param(disable_ir, int, 0444);
@@ -1211,3 +1211,6 @@ static int saa7134_nec_irq(struct saa7134_dev *dev)
 
 	return 1;
 }
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index c040a18..99f122b 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -810,16 +810,18 @@ void saa7134_irq_oss_done(struct saa7134_dev *dev, unsigned long status);
 /* ----------------------------------------------------------- */
 /* saa7134-input.c                                             */
 
+#if defined(CONFIG_VIDEO_SAA7134_RC) || (defined(CONFIG_VIDEO_SAA7134_RC_MODULE) && defined(MODULE))
 int  saa7134_input_init1(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
 int saa7134_ir_start(struct saa7134_dev *dev);
 void saa7134_ir_stop(struct saa7134_dev *dev);
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
+#else
+#define saa7134_input_init1(dev)	(0)
+#define saa7134_input_fini(dev)		(0)
+#define saa7134_input_irq(dev)		(0)
+#define saa7134_probe_i2c_ir(dev)	(0)
+#define saa7134_ir_start(dev)		(0)
+#define saa7134_ir_stop(dev)		(0)
+#endif
-- 
1.7.1

