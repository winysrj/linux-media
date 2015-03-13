Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51429 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbbCMLQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:16:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 30/39] vivid: add RGB444 support
Date: Fri, 13 Mar 2015 12:16:08 +0100
Message-Id: <1426245377-17704-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for (A/X)RGB444 formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 21 +++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c | 25 +++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index e7086e1..fcb2486 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -190,6 +190,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	switch (fourcc) {
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XRGB444:
+	case V4L2_PIX_FMT_ARGB444:
 	case V4L2_PIX_FMT_RGB555:
 	case V4L2_PIX_FMT_XRGB555:
 	case V4L2_PIX_FMT_ARGB555:
@@ -264,6 +267,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	switch (fourcc) {
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XRGB444:
+	case V4L2_PIX_FMT_ARGB444:
 	case V4L2_PIX_FMT_RGB555:
 	case V4L2_PIX_FMT_XRGB555:
 	case V4L2_PIX_FMT_ARGB555:
@@ -701,6 +707,13 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			g >>= 6;
 			b >>= 7;
 			break;
+		case V4L2_PIX_FMT_RGB444:
+		case V4L2_PIX_FMT_XRGB444:
+		case V4L2_PIX_FMT_ARGB444:
+			r >>= 8;
+			g >>= 8;
+			b >>= 8;
+			break;
 		case V4L2_PIX_FMT_RGB555:
 		case V4L2_PIX_FMT_XRGB555:
 		case V4L2_PIX_FMT_ARGB555:
@@ -855,6 +868,14 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = (r_y << 3) | (g_u >> 3);
 		buf[0][offset + 1] = (g_u << 5) | b_v;
 		break;
+	case V4L2_PIX_FMT_RGB444:
+	case V4L2_PIX_FMT_XRGB444:
+		alpha = 0;
+		/* fall through */
+	case V4L2_PIX_FMT_ARGB444:
+		buf[0][offset] = (g_u << 4) | b_v;
+		buf[0][offset + 1] = (alpha & 0xf0) | r_y;
+		break;
 	case V4L2_PIX_FMT_RGB555:
 	case V4L2_PIX_FMT_XRGB555:
 		alpha = 0;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 7cb4aa0..cb73c1b 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -171,6 +171,31 @@ struct vivid_fmt vivid_formats[] = {
 		.can_do_overlay = true,
 	},
 	{
+		.name     = "RGB444",
+		.fourcc   = V4L2_PIX_FMT_RGB444, /* xxxxrrrr ggggbbbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "XRGB444",
+		.fourcc   = V4L2_PIX_FMT_XRGB444, /* xxxxrrrr ggggbbbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.name     = "ARGB444",
+		.fourcc   = V4L2_PIX_FMT_ARGB444, /* aaaarrrr ggggbbbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0x00f0,
+	},
+	{
 		.name     = "RGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
 		.vdownsampling = { 1 },
-- 
2.1.4

