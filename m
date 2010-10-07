Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab0JGB5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 21:57:00 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o971v0Op023237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:57:00 -0400
Received: from pedra (vpn-225-141.phx2.redhat.com [10.3.225.141])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o971uuB6028164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:56:59 -0400
Date: Wed, 6 Oct 2010 22:56:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] V4L/DVB: saa7134-input can't be a module right now
Message-ID: <20101006225645.10ef58e3@pedra>
In-Reply-To: <ecc736735ecf922d7f31d34417f7c42f8ec9eb67.1286416568.git.mchehab@redhat.com>
References: <ecc736735ecf922d7f31d34417f7c42f8ec9eb67.1286416568.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are some symbols at saa7134-input that are used on saa7134
and vice-versa. Due to that, module install fails.

So, partially revert commit 9f495cf7d691c99bf7bdcec9f35fcfdad2cf9ae9.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 892b0b1..3fe71be 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -25,15 +25,12 @@ config VIDEO_SAA7134_ALSA
 	  module will be called saa7134-alsa.
 
 config VIDEO_SAA7134_RC
-	tristate "Philips SAA7134 Remote Controller support"
+	bool "Philips SAA7134 Remote Controller support"
 	depends on VIDEO_IR
 	depends on VIDEO_SAA7134
 	default y
 	---help---
-	  Enables Remote Controller support for saa7134.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa7134-rc.
+	  Enables Remote Controller support on saa7134 driver.
 
 config VIDEO_SAA7134_DVB
 	tristate "DVB/ATSC Support for saa7134 based TV cards"
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 5624468..2a2047b 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -1,9 +1,8 @@
 
-saa7134-objs :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o	\
-		saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
-		saa7134-video.o
-
-saa7134-rc-objs := saa7134-input.o
+saa7134-y :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
+saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
+saa7134-y +=	saa7134-video.o
+saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-rc.o
 
 obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
 
@@ -11,8 +10,6 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
-obj-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-rc.o
-
 EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index a6ac462..3a0ea56 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -28,7 +28,7 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 
-#define MODULE_NAME "saa7134-rc"
+#define MODULE_NAME "saa7134"
 
 static unsigned int disable_ir;
 module_param(disable_ir, int, 0444);
@@ -1211,6 +1211,3 @@ static int saa7134_nec_irq(struct saa7134_dev *dev)
 
 	return 1;
 }
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 99f122b..d3b6a19 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -810,7 +810,7 @@ void saa7134_irq_oss_done(struct saa7134_dev *dev, unsigned long status);
 /* ----------------------------------------------------------- */
 /* saa7134-input.c                                             */
 
-#if defined(CONFIG_VIDEO_SAA7134_RC) || (defined(CONFIG_VIDEO_SAA7134_RC_MODULE) && defined(MODULE))
+#if defined(CONFIG_VIDEO_SAA7134_RC)
 int  saa7134_input_init1(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
-- 
1.7.1


