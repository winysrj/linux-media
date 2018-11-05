Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54257 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 09/15] media: coda: implement ENUM_FRAMEINTERVALS
Date: Mon,  5 Nov 2018 16:25:07 +0100
Message-Id: <20181105152513.26345-9-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance complains about S_PARM being supported, but not
ENUM_FRAMEINTERVALS.
Report a continuous frame interval even though the hardware only
supports 16-bit numerator and denominator, with min/max values
that can be programmed into the mailbox registers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 1ba3301b35de..32998da39cac 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1044,6 +1044,38 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 	return 0;
 }
 
+static int coda_enum_frameintervals(struct file *file, void *fh,
+				    struct v4l2_frmivalenum *f)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	int i;
+
+	if (f->index)
+		return -EINVAL;
+
+	/* Disallow YUYV if the vdoa is not available */
+	if (!ctx->vdoa && f->pixel_format == V4L2_PIX_FMT_YUYV)
+		return -EINVAL;
+
+	for (i = 0; i < CODA_MAX_FORMATS; i++) {
+		if (f->pixel_format == ctx->cvd->src_formats[i] ||
+		    f->pixel_format == ctx->cvd->dst_formats[i])
+			break;
+	}
+	if (i == CODA_MAX_FORMATS)
+		return -EINVAL;
+
+	f->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+	f->stepwise.min.numerator = 1;
+	f->stepwise.min.denominator = 65535;
+	f->stepwise.max.numerator = 65536;
+	f->stepwise.max.denominator = 1;
+	f->stepwise.step.numerator = 1;
+	f->stepwise.step.denominator = 1;
+
+	return 0;
+}
+
 static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
@@ -1190,6 +1222,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_g_parm		= coda_g_parm,
 	.vidioc_s_parm		= coda_s_parm,
 
+	.vidioc_enum_frameintervals = coda_enum_frameintervals,
+
 	.vidioc_subscribe_event = coda_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
2.19.1
