Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:59826 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbeJDSDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 14:03:42 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 1/2] media: v4l2-tpg-core: Add 16-bit bayer
Date: Thu,  4 Oct 2018 13:01:13 +0200
Message-Id: <20181004110114.3150-1-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bård Eirik Winther <bwinther@cisco.com>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index f3d9c1140ffa..76b125ebee6d 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -202,6 +202,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		tpg->interleaved = true;
 		tpg->vdownsampling[1] = 1;
 		tpg->hdownsampling[1] = 1;
@@ -394,6 +398,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SRGGB16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SBGGR16:
 		tpg->twopixelsize[0] = 4;
 		tpg->twopixelsize[1] = 4;
 		break;
@@ -1358,6 +1366,22 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
 		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
 		break;
+	case V4L2_PIX_FMT_SBGGR16:
+		buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : b_v;
+		buf[1][offset] = buf[1][offset + 1] = odd ? r_y_h : g_u_s;
+		break;
+	case V4L2_PIX_FMT_SGBRG16:
+		buf[0][offset] = buf[0][offset + 1] = odd ? b_v : g_u_s;
+		buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : r_y_h;
+		break;
+	case V4L2_PIX_FMT_SGRBG16:
+		buf[0][offset] = buf[0][offset + 1] = odd ? r_y_h : g_u_s;
+		buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : b_v;
+		break;
+	case V4L2_PIX_FMT_SRGGB16:
+		buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : r_y_h;
+		buf[1][offset] = buf[1][offset + 1] = odd ? b_v : g_u_s;
+		break;
 	}
 }
 
@@ -1376,6 +1400,10 @@ unsigned tpg_g_interleaved_plane(const struct tpg_data *tpg, unsigned buf_line)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		return buf_line & 1;
 	default:
 		return 0;
-- 
2.17.1
