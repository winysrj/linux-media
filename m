Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51429 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbbCMLRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 34/39] vivid: add support for PIX_FMT_RGB332
Date: Fri, 13 Mar 2015 12:16:12 +0100
Message-Id: <1426245377-17704-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the one-byte-per-pixel RGB332 format.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 12 ++++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c |  8 ++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 787747b..ec9ffc4 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -188,6 +188,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	tpg->hmask[2] = ~0;
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_RGB332:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
 	case V4L2_PIX_FMT_RGB444:
@@ -274,6 +275,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	}
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_RGB332:
+		tpg->twopixelsize[0] = 2;
+		break;
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
 	case V4L2_PIX_FMT_RGB444:
@@ -717,6 +721,11 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 			b = (b * 219) / 255 + (16 << 4);
 		}
 		switch (tpg->fourcc) {
+		case V4L2_PIX_FMT_RGB332:
+			r >>= 9;
+			g >>= 9;
+			b >>= 10;
+			break;
 		case V4L2_PIX_FMT_RGB565:
 		case V4L2_PIX_FMT_RGB565X:
 			r >>= 7;
@@ -890,6 +899,9 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][0] = b_v;
 		buf[0][2] = g_u;
 		break;
+	case V4L2_PIX_FMT_RGB332:
+		buf[0][offset] = (r_y << 5) | (g_u << 2) | b_v;
+		break;
 	case V4L2_PIX_FMT_RGB565:
 		buf[0][offset] = (g_u << 5) | b_v;
 		buf[0][offset + 1] = (r_y << 3) | (g_u >> 3);
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index aa89850..9e8c06a 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -171,6 +171,14 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.name     = "RGB332",
+		.fourcc   = V4L2_PIX_FMT_RGB332, /* rrrgggbb */
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.vdownsampling = { 1 },
-- 
2.1.4

