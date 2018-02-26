Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44963 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbeBZQjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 11:39:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: vb2: Makefile: place vb2-trace together with vb2-core
Date: Mon, 26 Feb 2018 11:39:42 -0500
Message-Id: <7dbdd16a79a9d27d7dca0a49029fc8966dcfecc5.1519663175.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't want a separate module for vb2-trace.

That fixes this warning:

	WARNING: modpost: missing MODULE_LICENSE() in drivers/media/common/videobuf2/vb2-trace.o

When building as module.

While here, add a SPDX header.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/videobuf2/Makefile | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/Makefile b/drivers/media/common/videobuf2/Makefile
index 067badb1aaa7..77bebe8b202f 100644
--- a/drivers/media/common/videobuf2/Makefile
+++ b/drivers/media/common/videobuf2/Makefile
@@ -1,11 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0
+videobuf2-common-objs := videobuf2-core.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
+ifeq ($(CONFIG_TRACEPOINTS),y)
+  videobuf2-common-objs += vb2-trace.o
+endif
+
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-common.o
 obj-$(CONFIG_VIDEOBUF2_V4L2) += videobuf2-v4l2.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 obj-$(CONFIG_VIDEOBUF2_DVB) += videobuf2-dvb.o
-ifeq ($(CONFIG_TRACEPOINTS),y)
-  obj-$(CONFIG_VIDEOBUF2_CORE) += vb2-trace.o
-endif
-- 
2.14.3
