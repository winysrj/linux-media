Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:55376 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbcB1Uwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 15:52:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] v4l2/dvb: allow v4l2_mc functions to be used by dvb
Date: Sun, 28 Feb 2016 21:51:48 +0100
Message-Id: <1456692724-751344-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In a configuration that supports all DVB drivers but that disables
V4L2 or builds it as a loadable module, we get link errors because
of the recent change to use __v4l2_mc_usb_media_device_init:

drivers/media/built-in.o: In function `dvb_usb_adapter_dvb_init':
:(.text+0xe7966): undefined reference to `__v4l2_mc_usb_media_device_init'
drivers/media/built-in.o: In function `dvb_usbv2_init':
:(.text+0xff1cc): undefined reference to `__v4l2_mc_usb_media_device_init'
drivers/media/built-in.o: In function `smsusb_init_device':
:(.text+0x113be4): undefined reference to `__v4l2_mc_usb_media_device_init'
drivers/media/built-in.o: In function `au0828_usb_probe':
:(.text+0x114d08): undefined reference to `__v4l2_mc_usb_media_device_init'

This patch is one way out, by simply building the v4l2-mc.c file
whenever at least one of VIDEO_V4L2 or DVB_CORE are enabled, including
the case that one of them is a module and the other is built-in, which
leads the MC code to become built-in as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/Makefile           | 2 +-
 drivers/media/v4l2-core/Makefile | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbce0c35..16d471a56c0f 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -19,7 +19,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
 endif
 
 obj-$(CONFIG_VIDEO_DEV) += v4l2-core/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ v4l2-core/
 
 # There are both core and drivers at RC subtree - merge before drivers
 obj-y += rc/
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 795a5352761d..c26472f9950e 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -16,7 +16,11 @@ endif
 ifeq ($(CONFIG_TRACEPOINTS),y)
   videodev-objs += vb2-trace.o v4l2-trace.o
 endif
-videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
+
+ifdef CONFIG_MEDIA_CONTROLLER
+obj-$(CONFIG_VIDEO_V4L2) += v4l2-mc.o
+obj-$(CONFIG_DVB_CORE) += v4l2-mc.o
+endif
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
@@ -28,6 +32,7 @@ obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
 obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash-led-class.o
 
+ifdef CONFIG_VIDEO_V4L2
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
@@ -40,6 +45,7 @@ obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
+endif
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
-- 
2.7.0

