Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56302 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbbIUIbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 04:31:25 -0400
Received: from [10.61.104.16] (unknown [173.38.220.50])
	by tschai.lan (Postfix) with ESMTPSA id A94432A00AE
	for <linux-media@vger.kernel.org>; Mon, 21 Sep 2015 10:29:59 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: add 10 and 12 bit Bayer formats
Message-ID: <55FFC057.1000002@xs4all.nl>
Date: Mon, 21 Sep 2015 10:31:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for 10 and 12 bit Bayer formats to the test pattern generator
and the vivid driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 91 +++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c | 56 +++++++++++++++
 2 files changed, 147 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 1458c79..1425614 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -193,6 +193,14 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
 		tpg->interleaved = true;
 		tpg->vdownsampling[1] = 1;
 		tpg->hdownsampling[1] = 1;
@@ -349,6 +357,17 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->twopixelsize[0] = 2;
 		tpg->twopixelsize[1] = 2;
 		break;
+	case V4L2_PIX_FMT_SRGGB10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SBGGR12:
+		tpg->twopixelsize[0] = 4;
+		tpg->twopixelsize[1] = 4;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
@@ -1112,6 +1131,70 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = odd ? g_u : r_y;
 		buf[1][offset] = odd ? b_v : g_u;
 		break;
+	case V4L2_PIX_FMT_SBGGR10:
+		buf[0][offset] = odd ? g_u << 2 : b_v << 2;
+		buf[0][offset + 1] = odd ? g_u >> 6 : b_v >> 6;
+		buf[1][offset] = odd ? r_y << 2 : g_u << 2;
+		buf[1][offset + 1] = odd ? r_y >> 6 : g_u >> 6;
+		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
+		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
+		break;
+	case V4L2_PIX_FMT_SGBRG10:
+		buf[0][offset] = odd ? b_v << 2 : g_u << 2;
+		buf[0][offset + 1] = odd ? b_v >> 6 : g_u >> 6;
+		buf[1][offset] = odd ? g_u << 2 : r_y << 2;
+		buf[1][offset + 1] = odd ? g_u >> 6 : r_y >> 6;
+		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
+		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
+		break;
+	case V4L2_PIX_FMT_SGRBG10:
+		buf[0][offset] = odd ? r_y << 2 : g_u << 2;
+		buf[0][offset + 1] = odd ? r_y >> 6 : g_u >> 6;
+		buf[1][offset] = odd ? g_u << 2 : b_v << 2;
+		buf[1][offset + 1] = odd ? g_u >> 6 : b_v >> 6;
+		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
+		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
+		break;
+	case V4L2_PIX_FMT_SRGGB10:
+		buf[0][offset] = odd ? g_u << 2 : r_y << 2;
+		buf[0][offset + 1] = odd ? g_u >> 6 : r_y >> 6;
+		buf[1][offset] = odd ? b_v << 2 : g_u << 2;
+		buf[1][offset + 1] = odd ? b_v >> 6 : g_u >> 6;
+		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
+		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
+		break;
+	case V4L2_PIX_FMT_SBGGR12:
+		buf[0][offset] = odd ? g_u << 4 : b_v << 4;
+		buf[0][offset + 1] = odd ? g_u >> 4 : b_v >> 4;
+		buf[1][offset] = odd ? r_y << 4 : g_u << 4;
+		buf[1][offset + 1] = odd ? r_y >> 4 : g_u >> 4;
+		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
+		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
+		break;
+	case V4L2_PIX_FMT_SGBRG12:
+		buf[0][offset] = odd ? b_v << 4 : g_u << 4;
+		buf[0][offset + 1] = odd ? b_v >> 4 : g_u >> 4;
+		buf[1][offset] = odd ? g_u << 4 : r_y << 4;
+		buf[1][offset + 1] = odd ? g_u >> 4 : r_y >> 4;
+		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
+		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
+		break;
+	case V4L2_PIX_FMT_SGRBG12:
+		buf[0][offset] = odd ? r_y << 4 : g_u << 4;
+		buf[0][offset + 1] = odd ? r_y >> 4 : g_u >> 4;
+		buf[1][offset] = odd ? g_u << 4 : b_v << 4;
+		buf[1][offset + 1] = odd ? g_u >> 4 : b_v >> 4;
+		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
+		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
+		break;
+	case V4L2_PIX_FMT_SRGGB12:
+		buf[0][offset] = odd ? g_u << 4 : r_y << 4;
+		buf[0][offset + 1] = odd ? g_u >> 4 : r_y >> 4;
+		buf[1][offset] = odd ? b_v << 4 : g_u << 4;
+		buf[1][offset + 1] = odd ? b_v >> 4 : g_u >> 4;
+		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
+		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
+		break;
 	}
 }
 
@@ -1122,6 +1205,14 @@ unsigned tpg_g_interleaved_plane(const struct tpg_data *tpg, unsigned buf_line)
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
+	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SRGGB12:
 		return buf_line & 1;
 	default:
 		return 0;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index fc73927..1678b73 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -390,6 +390,62 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.fourcc   = V4L2_PIX_FMT_SBGGR10, /* Bayer BG/GR */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGBRG10, /* Bayer GB/RG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGRBG10, /* Bayer GR/BG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SRGGB10, /* Bayer RG/GB */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SBGGR12, /* Bayer BG/GR */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGBRG12, /* Bayer GB/RG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGRBG12, /* Bayer GR/BG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SRGGB12, /* Bayer RG/GB */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.fourcc   = V4L2_PIX_FMT_NV16M,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
-- 
2.5.3

