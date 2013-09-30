Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3I3NfB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 09/10] [media] coda: v4l2-compliance fix: implement try_decoder_cmd
Date: Mon, 30 Sep 2013 15:34:52 +0200
Message-Id: <1380548093-22313-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement try_decoder_cmd to let userspace determine available commands
and flags.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 1572929..2bf8175 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -835,23 +835,34 @@ static int coda_streamoff(struct file *file, void *priv,
 	return ret;
 }
 
-static int coda_decoder_cmd(struct file *file, void *fh,
-				   struct v4l2_decoder_cmd *dc)
+static int coda_try_decoder_cmd(struct file *file, void *fh,
+				struct v4l2_decoder_cmd *dc)
 {
-	struct coda_ctx *ctx = fh_to_ctx(fh);
-
 	if (dc->cmd != V4L2_DEC_CMD_STOP)
 		return -EINVAL;
 
-	if ((dc->flags & V4L2_DEC_CMD_STOP_TO_BLACK) ||
-	    (dc->flags & V4L2_DEC_CMD_STOP_IMMEDIATELY))
+	if (dc->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
 		return -EINVAL;
 
-	if (dc->stop.pts != 0)
+	if (!(dc->flags & V4L2_DEC_CMD_STOP_IMMEDIATELY) && (dc->stop.pts != 0))
 		return -EINVAL;
 
+	return 0;
+}
+
+static int coda_decoder_cmd(struct file *file, void *fh,
+			    struct v4l2_decoder_cmd *dc)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	int ret;
+
+	ret = coda_try_decoder_cmd(file, fh, dc);
+	if (ret < 0)
+		return ret;
+
+	/* Ignore decoder stop command silently in encoder context */
 	if (ctx->inst_type != CODA_INST_DECODER)
-		return -EINVAL;
+		return 0;
 
 	/* Set the strem-end flag on this context */
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
@@ -894,6 +905,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_streamon	= coda_streamon,
 	.vidioc_streamoff	= coda_streamoff,
 
+	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
 	.vidioc_decoder_cmd	= coda_decoder_cmd,
 
 	.vidioc_subscribe_event = coda_subscribe_event,
-- 
1.8.4.rc3

