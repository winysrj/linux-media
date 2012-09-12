Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2ILPCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:48 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 11/13] media: coda: add horizontal / vertical flipping support
Date: Wed, 12 Sep 2012 17:02:36 +0200
Message-Id: <1347462158-20417-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware can also rotate in 90° steps, but there is no
corresponding V4L2_CID defined yet.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/coda.c |   19 ++++++++++++++++++-
 drivers/media/platform/coda.h |    9 +++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index e8ed427..81e3401 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -141,6 +141,7 @@ struct coda_dev {
 };
 
 struct coda_params {
+	u8			rot_mode;
 	u8			h264_intra_qp;
 	u8			h264_inter_qp;
 	u8			mpeg4_intra_qp;
@@ -695,7 +696,7 @@ static void coda_device_run(void *m2m_priv)
 	}
 
 	/* submit */
-	coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
+	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode, CODA_CMD_ENC_PIC_ROT_MODE);
 	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
 
 
@@ -1271,6 +1272,18 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
 
 	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctrl->val)
+			ctx->params.rot_mode |= CODA_MIR_HOR;
+		else
+			ctx->params.rot_mode &= ~CODA_MIR_HOR;
+		break;
+	case V4L2_CID_VFLIP:
+		if (ctrl->val)
+			ctx->params.rot_mode |= CODA_MIR_VER;
+		else
+			ctx->params.rot_mode &= ~CODA_MIR_VER;
+		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
 		ctx->params.bitrate = ctrl->val / 1000;
 		break;
@@ -1316,6 +1329,10 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
 
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index 3324010..f3f5e43 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -188,6 +188,15 @@
 #define CODA_CMD_ENC_PIC_SRC_ADDR_CR	0x188
 #define CODA_CMD_ENC_PIC_QS		0x18c
 #define CODA_CMD_ENC_PIC_ROT_MODE	0x190
+#define		CODA_ROT_MIR_ENABLE				(1 << 4)
+#define		CODA_ROT_0					(0x0 << 0)
+#define		CODA_ROT_90					(0x1 << 0)
+#define		CODA_ROT_180					(0x2 << 0)
+#define		CODA_ROT_270					(0x3 << 0)
+#define		CODA_MIR_NONE					(0x0 << 2)
+#define		CODA_MIR_VER					(0x1 << 2)
+#define		CODA_MIR_HOR					(0x2 << 2)
+#define		CODA_MIR_VER_HOR				(0x3 << 2)
 #define CODA_CMD_ENC_PIC_OPTION	0x194
 #define CODA_CMD_ENC_PIC_BB_START	0x198
 #define CODA_CMD_ENC_PIC_BB_SIZE	0x19c
-- 
1.7.10.4

