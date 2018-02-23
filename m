Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45438 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750910AbeBWKKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 05:10:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] media: fix build issues with vb2-trace
Date: Fri, 23 Feb 2018 05:10:38 -0500
Message-Id: <ad9dda912622864ead2349eb66a94bb7df18615f.1519380628.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a trouble with vb2-trace: instead of being part of
VB2 core, it was stored at V4L2 videodev. That was wrong,
as it doesn't actually belong to V4L2 core.

Now that vb2 is not part of v4l2-core, its trace functions
should be moved altogether. So, move it to its rightful
place: at videobuf2-core.

That fixes those errors:
	drivers/media/common/videobuf2/videobuf2-core.o: In function `__read_once_size':
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
	./include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x10): undefined reference to `__tracepoint_vb2_buf_queue'
	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x28): undefined reference to `__tracepoint_vb2_buf_done'
	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x40): undefined reference to `__tracepoint_vb2_qbuf'
	drivers/media/common/videobuf2/videobuf2-core.o:(__jump_table+0x58): undefined reference to `__tracepoint_vb2_dqbuf'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/videobuf2/Makefile                   | 3 +++
 drivers/media/{v4l2-core => common/videobuf2}/vb2-trace.c | 0
 drivers/media/v4l2-core/Makefile                          | 3 +--
 3 files changed, 4 insertions(+), 2 deletions(-)
 rename drivers/media/{v4l2-core => common/videobuf2}/vb2-trace.c (100%)

diff --git a/drivers/media/common/videobuf2/Makefile b/drivers/media/common/videobuf2/Makefile
index 7e27bdd44dcc..067badb1aaa7 100644
--- a/drivers/media/common/videobuf2/Makefile
+++ b/drivers/media/common/videobuf2/Makefile
@@ -6,3 +6,6 @@ obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
+ifeq ($(CONFIG_TRACEPOINTS),y)
+  obj-$(CONFIG_VIDEOBUF2_CORE) += vb2-trace.o
+endif
diff --git a/drivers/media/v4l2-core/vb2-trace.c b/drivers/media/common/videobuf2/vb2-trace.c
similarity index 100%
rename from drivers/media/v4l2-core/vb2-trace.c
rename to drivers/media/common/videobuf2/vb2-trace.c
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 80de2cb9c476..7df54582e956 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -13,7 +13,7 @@ ifeq ($(CONFIG_COMPAT),y)
 endif
 obj-$(CONFIG_V4L2_FWNODE) += v4l2-fwnode.o
 ifeq ($(CONFIG_TRACEPOINTS),y)
-  videodev-objs += vb2-trace.o v4l2-trace.o
+  videodev-objs += v4l2-trace.o
 endif
 videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
 
@@ -35,4 +35,3 @@ obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
-
-- 
2.14.3
