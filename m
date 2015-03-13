Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43179 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbbCMLQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:16:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 32/39] vivid: add support for [A|X]RGB555X
Date: Fri, 13 Mar 2015 12:16:10 +0100
Message-Id: <1426245377-17704-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Only RGB555X was supported, add support for the other two variants.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 10 ++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c | 18 +++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index fcb2486..e4d461a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -197,6 +197,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_XRGB555:
 	case V4L2_PIX_FMT_ARGB555:
 	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_XRGB555X:
+	case V4L2_PIX_FMT_ARGB555X:
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 	case V4L2_PIX_FMT_RGB32:
@@ -274,6 +276,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_XRGB555:
 	case V4L2_PIX_FMT_ARGB555:
 	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_XRGB555X:
+	case V4L2_PIX_FMT_ARGB555X:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
@@ -718,6 +722,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		case V4L2_PIX_FMT_XRGB555:
 		case V4L2_PIX_FMT_ARGB555:
 		case V4L2_PIX_FMT_RGB555X:
+		case V4L2_PIX_FMT_XRGB555X:
+		case V4L2_PIX_FMT_ARGB555X:
 			r >>= 7;
 			g >>= 7;
 			b >>= 7;
@@ -885,6 +891,10 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset + 1] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
 		break;
 	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_XRGB555X:
+		alpha = 0;
+		/* fall through */
+	case V4L2_PIX_FMT_ARGB555X:
 		buf[0][offset] = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
 		buf[0][offset + 1] = (g_u << 5) | b_v;
 		break;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 453a5ad..81e6c82 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -230,7 +230,23 @@ struct vivid_fmt vivid_formats[] = {
 		.bit_depth = { 16 },
 		.planes   = 1,
 		.buffers = 1,
-		.can_do_overlay = true,
+	},
+	{
+		.name     = "XRGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_XRGB555X, /* xrrrrrgg gggbbbbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "ARGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_ARGB555X, /* arrrrrgg gggbbbbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0x0080,
 	},
 	{
 		.name     = "RGB24 (LE)",
-- 
2.1.4

