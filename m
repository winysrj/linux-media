Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52344 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935769AbeFMOHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:19 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 3/9] media: cedrus: Add a macro to check for the validity of a control
Date: Wed, 13 Jun 2018 16:07:08 +0200
Message-Id: <20180613140714.1686-4-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During our frame decoding setup, we need to check a number of controls to
make sure that they are properly filled before trying to access them.

It's not too bad with MPEG2 since there's just a single one, but with the
upcoming increase of codecs, and the integration of more complex codecs,
this logic will be duplicated a significant number of times. H264 for
example uses 4 different controls.

Add a macro that expands to the proper check in order to reduce the
duplication.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../platform/sunxi/cedrus/sunxi_cedrus_dec.c     | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
index 8c92af34ebeb..c19acf9626c4 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
@@ -110,15 +110,16 @@ void sunxi_cedrus_device_run(void *priv)
 
 	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
 
+#define CHECK_CONTROL(ctx, ctrl)					\
+	if (!ctx->ctrls[(ctrl)]) {					\
+		v4l2_err(&(ctx)->dev->v4l2_dev, "Invalid " #ctrl " control\n"); \
+		(ctx)->job_abort = 1;					\
+		goto unlock_complete;					\
+	}
+
 	switch (ctx->vpu_src_fmt->fourcc) {
 	case V4L2_PIX_FMT_MPEG2_FRAME:
-		if (!ctx->ctrls[SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR]) {
-			v4l2_err(&ctx->dev->v4l2_dev,
-				 "Invalid MPEG2 frame header control\n");
-			ctx->job_abort = 1;
-			goto unlock_complete;
-		}
-
+		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
 		run.mpeg2.hdr = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
 		sunxi_cedrus_mpeg2_setup(ctx, &run);
 
@@ -128,6 +129,7 @@ void sunxi_cedrus_device_run(void *priv)
 	default:
 		ctx->job_abort = 1;
 	}
+#undef CHECK_CONTROL
 
 unlock_complete:
 	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
-- 
2.17.0
