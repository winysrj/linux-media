Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:15329 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752243AbdESKFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 06:05:24 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1] [media] atmel-isi: code cleanup
Date: Fri, 19 May 2017 12:04:52 +0200
Message-ID: <1495188292-3113-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495188292-3113-1-git-send-email-hugues.fruchet@st.com>
References: <1495188292-3113-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that ISI is clocked before starting sensor sub device.
Remove un-needed type check in try_fmt().
Use clamp() macro for hardware capabilities.
Fix wrong tabulation to space.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/atmel/atmel-isi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e4867f8..7bf9f7d 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -36,8 +36,8 @@
 
 #include "atmel-isi.h"
 
-#define MAX_SUPPORT_WIDTH		2048
-#define MAX_SUPPORT_HEIGHT		2048
+#define MAX_SUPPORT_WIDTH		2048U
+#define MAX_SUPPORT_HEIGHT		2048U
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
 
@@ -424,6 +424,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct frame_buffer *buf, *node;
 	int ret;
 
+	pm_runtime_get_sync(isi->dev);
+
 	/* Enable stream on the sub device */
 	ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 1);
 	if (ret && ret != -ENOIOCTLCMD) {
@@ -431,8 +433,6 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 		goto err_start_stream;
 	}
 
-	pm_runtime_get_sync(isi->dev);
-
 	/* Reset ISI */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
 	if (ret < 0) {
@@ -455,10 +455,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 err_reset:
-	pm_runtime_put(isi->dev);
 	v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
 
 err_start_stream:
+	pm_runtime_put(isi->dev);
+
 	spin_lock_irq(&isi->irqlock);
 	isi->active = NULL;
 	/* Release all active buffers */
@@ -566,20 +567,15 @@ static int isi_try_fmt(struct atmel_isi *isi, struct v4l2_format *f,
 	};
 	int ret;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
 	isi_fmt = find_format_by_fourcc(isi, pixfmt->pixelformat);
 	if (!isi_fmt) {
 		isi_fmt = isi->user_formats[isi->num_user_formats - 1];
 		pixfmt->pixelformat = isi_fmt->fourcc;
 	}
 
-	/* Limit to Atmel ISC hardware capabilities */
-	if (pixfmt->width > MAX_SUPPORT_WIDTH)
-		pixfmt->width = MAX_SUPPORT_WIDTH;
-	if (pixfmt->height > MAX_SUPPORT_HEIGHT)
-		pixfmt->height = MAX_SUPPORT_HEIGHT;
+	/* Limit to Atmel ISI hardware capabilities */
+	pixfmt->width = clamp(pixfmt->width, 0U, MAX_SUPPORT_WIDTH);
+	pixfmt->height = clamp(pixfmt->height, 0U, MAX_SUPPORT_HEIGHT);
 
 	v4l2_fill_mbus_format(&format.format, pixfmt, isi_fmt->mbus_code);
 	ret = v4l2_subdev_call(isi->entity.subdev, pad, set_fmt,
@@ -1058,7 +1054,7 @@ static int isi_graph_notify_complete(struct v4l2_async_notifier *notifier)
 	struct atmel_isi *isi = notifier_to_isi(notifier);
 	int ret;
 
-	isi->vdev->ctrl_handler	= isi->entity.subdev->ctrl_handler;
+	isi->vdev->ctrl_handler = isi->entity.subdev->ctrl_handler;
 	ret = isi_formats_init(isi);
 	if (ret) {
 		dev_err(isi->dev, "No supported mediabus format found\n");
-- 
1.9.1
