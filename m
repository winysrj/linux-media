Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51480 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaGKJgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:36:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 07/32] [media] coda: remove BUG() in get_q_data
Date: Fri, 11 Jul 2014 11:36:18 +0200
Message-Id: <1405071403-1859-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows us to get rid of the now superfluous v4l2_m2m_get_vq check
in G_FMT. Also, we can use this to check the buffer type in G_SELECTION
later.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 94654cf..59f16ac 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -326,9 +326,8 @@ static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return &(ctx->q_data[V4L2_M2M_DST]);
 	default:
-		BUG();
+		return NULL;
 	}
-	return NULL;
 }
 
 /*
@@ -571,15 +570,12 @@ static int coda_enum_fmt_vid_out(struct file *file, void *priv,
 static int coda_g_fmt(struct file *file, void *priv,
 		      struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct coda_q_data *q_data;
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
 
 	f->fmt.pix.field	= V4L2_FIELD_NONE;
 	f->fmt.pix.pixelformat	= q_data->fourcc;
@@ -628,6 +624,8 @@ static int coda_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
 		break;
 	default:
 		q_data = get_q_data(ctx, f->type);
+		if (!q_data)
+			return -EINVAL;
 		f->fmt.pix.pixelformat = q_data->fourcc;
 	}
 
-- 
2.0.0

