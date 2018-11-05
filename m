Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40143 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730107AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 11/15] media: coda: fail S_SELECTION for read-only targets
Date: Mon,  5 Nov 2018 16:25:09 +0100
Message-Id: <20181105152513.26345-11-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compose complains if S_SELECTION returns 0 for read-only targets.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 51 +++++++++++++----------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c4d48069606c..fd9bc19cd79b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -938,32 +938,39 @@ static int coda_s_selection(struct file *file, void *fh,
 	struct coda_ctx *ctx = fh_to_ctx(fh);
 	struct coda_q_data *q_data;
 
-	if (ctx->inst_type == CODA_INST_ENCODER &&
-	    s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    s->target == V4L2_SEL_TGT_CROP) {
-		q_data = get_q_data(ctx, s->type);
-		if (!q_data)
-			return -EINVAL;
-
-		s->r.left = 0;
-		s->r.top = 0;
-		s->r.width = clamp(s->r.width, 2U, q_data->width);
-		s->r.height = clamp(s->r.height, 2U, q_data->height);
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (ctx->inst_type == CODA_INST_ENCODER &&
+		    s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			q_data = get_q_data(ctx, s->type);
+			if (!q_data)
+				return -EINVAL;
 
-		if (s->flags & V4L2_SEL_FLAG_LE) {
-			s->r.width = round_up(s->r.width, 2);
-			s->r.height = round_up(s->r.height, 2);
-		} else {
-			s->r.width = round_down(s->r.width, 2);
-			s->r.height = round_down(s->r.height, 2);
-		}
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = clamp(s->r.width, 2U, q_data->width);
+			s->r.height = clamp(s->r.height, 2U, q_data->height);
+
+			if (s->flags & V4L2_SEL_FLAG_LE) {
+				s->r.width = round_up(s->r.width, 2);
+				s->r.height = round_up(s->r.height, 2);
+			} else {
+				s->r.width = round_down(s->r.width, 2);
+				s->r.height = round_down(s->r.height, 2);
+			}
 
-		q_data->rect = s->r;
+			q_data->rect = s->r;
 
-		return 0;
+			return 0;
+		}
+		/* else fall through */
+	case V4L2_SEL_TGT_NATIVE_SIZE:
+	case V4L2_SEL_TGT_COMPOSE:
+		return coda_g_selection(file, fh, s);
+	default:
+		/* v4l2-compliance expects this to fail for read-only targets */
+		return -EINVAL;
 	}
-
-	return coda_g_selection(file, fh, s);
 }
 
 static int coda_try_encoder_cmd(struct file *file, void *fh,
-- 
2.19.1
