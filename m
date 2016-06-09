Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37893 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbcFIUZa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 16:25:30 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] s5p-mfc: use vb2_is_streaming() to check vb2 queue status
Date: Thu,  9 Jun 2016 16:25:14 -0400
Message-Id: <1465503914-22936-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The streaming field in struct vb2_queue is meant to be private and should
not be used by drivers directly, instead the vb2_is_streaming() function
should be used to check the videobuf2 queue streaming status.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 038215c198ac..d3b01e92ee80 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -423,7 +423,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	pix_mp = &f->fmt.pix_mp;
 	if (ret)
 		return ret;
-	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
+	if (vb2_is_streaming(&ctx->vq_src) || vb2_is_streaming(&ctx->vq_dst)) {
 		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
 		ret = -EBUSY;
 		goto out;
@@ -820,7 +820,7 @@ static int vidioc_decoder_cmd(struct file *file, void *priv,
 		if (cmd->flags != 0)
 			return -EINVAL;
 
-		if (!ctx->vq_src.streaming)
+		if (!vb2_is_streaming(&ctx->vq_src))
 			return -EINVAL;
 
 		spin_lock_irqsave(&dev->irqlock, flags);
-- 
2.5.5

