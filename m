Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34129 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbbCIPqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/29] vivid-tpg: separate planes and buffers
Date: Mon,  9 Mar 2015 16:44:31 +0100
Message-Id: <1425915891-1017-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new field that contains the number of buffers. This may be
less than the number of planes in case multiple planes are combined
into one buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 3 +++
 drivers/media/platform/vivid/vivid-tpg.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index c1476a2..7463f78 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -170,7 +170,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 {
 	tpg->fourcc = fourcc;
 	tpg->planes = 1;
+	tpg->buffers = 1;
 	tpg->recalc_colors = true;
+
 	switch (fourcc) {
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
@@ -190,6 +192,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		break;
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
+		tpg->buffers = 2;
 		tpg->planes = 2;
 		/* fall-through */
 	case V4L2_PIX_FMT_YUYV:
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index e796a54..9ce2d01 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -138,6 +138,7 @@ struct tpg_data {
 	enum tpg_pixel_aspect		pix_aspect;
 	unsigned			rgb_range;
 	unsigned			real_rgb_range;
+	unsigned			buffers;
 	unsigned			planes;
 	/* Used to store the colors in native format, either RGB or YUV */
 	u8				colors[TPG_COLOR_MAX][3];
@@ -327,6 +328,11 @@ static inline u32 tpg_g_quantization(const struct tpg_data *tpg)
 	return tpg->quantization;
 }
 
+static inline unsigned tpg_g_buffers(const struct tpg_data *tpg)
+{
+	return tpg->buffers;
+}
+
 static inline unsigned tpg_g_planes(const struct tpg_data *tpg)
 {
 	return tpg->planes;
-- 
2.1.4

