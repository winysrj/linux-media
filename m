Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49561 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbbCMLRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 36/39] vivid: add support for BGR666
Date: Fri, 13 Mar 2015 12:16:14 +0100
Message-Id: <1426245377-17704-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the four byte BGR666 format.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 13 +++++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index ec9ffc4..059e98e 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -200,6 +200,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_RGB555X:
 	case V4L2_PIX_FMT_XRGB555X:
 	case V4L2_PIX_FMT_ARGB555X:
+	case V4L2_PIX_FMT_BGR666:
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 	case V4L2_PIX_FMT_RGB32:
@@ -299,6 +300,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_BGR24:
 		tpg->twopixelsize[0] = 2 * 3;
 		break;
+	case V4L2_PIX_FMT_BGR666:
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_BGR32:
 	case V4L2_PIX_FMT_XRGB32:
@@ -749,6 +751,11 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			g >>= 7;
 			b >>= 7;
 			break;
+		case V4L2_PIX_FMT_BGR666:
+			r >>= 6;
+			g >>= 6;
+			b >>= 6;
+			break;
 		default:
 			r >>= 4;
 			g >>= 4;
@@ -944,6 +951,12 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset + 1] = g_u;
 		buf[0][offset + 2] = r_y;
 		break;
+	case V4L2_PIX_FMT_BGR666:
+		buf[0][offset] = (b_v << 2) | (g_u >> 4);
+		buf[0][offset + 1] = (g_u << 4) | (r_y >> 2);
+		buf[0][offset + 2] = r_y << 6;
+		buf[0][offset + 3] = 0;
+		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 		alpha = 0;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 9e8c06a..58b42d2 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -291,6 +291,14 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.name     = "BGR666",
+		.fourcc   = V4L2_PIX_FMT_BGR666, /* bbbbbbgg ggggrrrr rrxxxxxx */
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.name     = "RGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB32, /* xrgb */
 		.vdownsampling = { 1 },
-- 
2.1.4

