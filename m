Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55915 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751111AbdIOOvu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 1/2] v4l2-tpg: add Y10 and Y12 support
Date: Fri, 15 Sep 2017 16:51:44 +0200
Message-Id: <20170915145145.44097-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Support the 10 and 12 bit luma formats.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index a772976cfe26..f96968c11312 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -238,6 +238,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->color_enc = TGP_COLOR_ENC_RGB;
 		break;
 	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y10:
+	case V4L2_PIX_FMT_Y12:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
 		tpg->color_enc = TGP_COLOR_ENC_LUMA;
@@ -352,6 +354,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
+	case V4L2_PIX_FMT_Y10:
+	case V4L2_PIX_FMT_Y12:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
 		tpg->twopixelsize[0] = 2 * 2;
@@ -1056,6 +1060,14 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_GREY:
 		buf[0][offset] = r_y_h;
 		break;
+	case V4L2_PIX_FMT_Y10:
+		buf[0][offset] = (r_y_h << 2) & 0xff;
+		buf[0][offset+1] = r_y_h >> 6;
+		break;
+	case V4L2_PIX_FMT_Y12:
+		buf[0][offset] = (r_y_h << 4) & 0xff;
+		buf[0][offset+1] = r_y_h >> 4;
+		break;
 	case V4L2_PIX_FMT_Y16:
 		/*
 		 * Ideally both bytes should be set to r_y_h, but then you won't
-- 
2.14.1
