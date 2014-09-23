Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIWP42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 11:56:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] saa7134: Fix compilation breakage when go7007 is not selected
Date: Tue, 23 Sep 2014 12:56:05 -0300
Message-Id: <413ffebb2c681c83b044df0ab8953fa6f4dcd0cf.1411487694.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All error/warnings:

   drivers/built-in.o: In function `saa7134_go7007_fini':
>> saa7134-go7007.c:(.text+0x3b628b): undefined reference to `go7007_snd_remove'
   drivers/built-in.o: In function `saa7134_go7007_interface_reset':
>> saa7134-go7007.c:(.text+0x3b659a): undefined reference to `go7007_read_interrupt'
   drivers/built-in.o: In function `saa7134_go7007_init':
>> saa7134-go7007.c:(.text+0x3b65fa): undefined reference to `go7007_alloc'
>> saa7134-go7007.c:(.text+0x3b66ed): undefined reference to `go7007_boot_encoder'
>> saa7134-go7007.c:(.text+0x3b66fe): undefined reference to `go7007_register_encoder'
   drivers/built-in.o: In function `saa7134_go7007_irq_ts_done':
>> saa7134-go7007.c:(.text+0x3b6c2a): undefined reference to `go7007_parse_video_stream'
>> saa7134-go7007.c:(.text+0x3b6c86): undefined reference to `go7007_parse_video_stream'

Whis happens when VIDEO_GO7007 is not selected, but saa7134
is selected.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---

This is not as smart as it should be, as, for now, to select go7007,
USB needs to be selected, with is weird for a PCI device.

diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index 18ae75546302..a10b5fd1a226 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -63,3 +63,10 @@ config VIDEO_SAA7134_DVB
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7134-dvb.
+
+config VIDEO_SAA7134_GO7007
+	tristate "go7007 support for saa7134 based TV cards"
+	depends on VIDEO_SAA7134
+	depends on VIDEO_GO7007
+	---help---
+	  Enables saa7134 driver supports for boards with go7007.
diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
index b55bd9afda11..09c43da67588 100644
--- a/drivers/media/pci/saa7134/Makefile
+++ b/drivers/media/pci/saa7134/Makefile
@@ -4,7 +4,8 @@ saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
 saa7134-y +=	saa7134-video.o
 saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o saa7134-empress.o saa7134-go7007.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134_GO7007) += saa7134-go7007.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
-- 
1.9.3

