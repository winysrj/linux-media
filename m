Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54043 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbeHKNlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Aug 2018 09:41:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-tpg: add Z16 support
Date: Sat, 11 Aug 2018 13:07:15 +0200
Message-Id: <20180811110715.23872-2-hverkuil@xs4all.nl>
In-Reply-To: <20180811110715.23872-1-hverkuil@xs4all.nl>
References: <20180811110715.23872-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Z16 support is identical to Y16, so that's easy to add.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index e6d13c4fb7b7..f3d9c1140ffa 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -235,6 +235,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_Y12:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
+	case V4L2_PIX_FMT_Z16:
 		tpg->color_enc = TGP_COLOR_ENC_LUMA;
 		break;
 	case V4L2_PIX_FMT_YUV444:
@@ -351,6 +352,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_Y12:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
+	case V4L2_PIX_FMT_Z16:
 		tpg->twopixelsize[0] = 2 * 2;
 		break;
 	case V4L2_PIX_FMT_RGB24:
@@ -1062,6 +1064,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset+1] = r_y_h >> 4;
 		break;
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Z16:
 		/*
 		 * Ideally both bytes should be set to r_y_h, but then you won't
 		 * be able to detect endian problems. So keep it 0 except for
-- 
2.18.0
