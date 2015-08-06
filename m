Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbbHFMiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 08:38:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] v4l2: move tracepoint generation into separate file
Date: Thu,  6 Aug 2015 14:38:02 +0200
Message-Id: <1438864682-29434-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To compile videobuf2-core as a module, the vb2_* tracepoints must be
exported from the videodev module. Instead of exporting vb2 tracepoint
symbols from v4l2-ioctl.c, move the tracepoint generation into a separate
file. This patch fixes the following build error in the modpost stage,
introduced by 2091f5181c66 ("[media] videobuf2: add trace events"):

    ERROR: "__tracepoint_vb2_buf_done" undefined!
    ERROR: "__tracepoint_vb2_dqbuf" undefined!
    ERROR: "__tracepoint_vb2_qbuf" undefined!
    ERROR: "__tracepoint_vb2_buf_queue" undefined!

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/Makefile     |  3 +++
 drivers/media/v4l2-core/v4l2-ioctl.c |  1 -
 drivers/media/v4l2-core/v4l2-trace.c | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-trace.c

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index dc3de00..d1dd440 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -13,6 +13,9 @@ endif
 ifeq ($(CONFIG_OF),y)
   videodev-objs += v4l2-of.o
 endif
+ifeq ($(CONFIG_TRACEPOINTS),y)
+  videodev-objs += v4l2-trace.o
+endif
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 85de455..038d8c0 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -28,7 +28,6 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-core.h>
 
-#define CREATE_TRACE_POINTS
 #include <trace/events/v4l2.h>
 
 /* Zero out the end of the struct pointed to by p.  Everything after, but
diff --git a/drivers/media/v4l2-core/v4l2-trace.c b/drivers/media/v4l2-core/v4l2-trace.c
new file mode 100644
index 0000000..ae10b02
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-trace.c
@@ -0,0 +1,11 @@
+#include <media/v4l2-common.h>
+#include <media/v4l2-fh.h>
+#include <media/videobuf2-core.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/v4l2.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
-- 
2.4.6

