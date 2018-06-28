Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52359 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965425AbeF1LBv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 07:01:51 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH] media: coda: add missing h.264 levels
Date: Thu, 28 Jun 2018 13:01:47 +0200
Message-Id: <20180628110147.24428-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables reordering support for h.264 main profile level 4.2,
5.0, and 5.1 streams. Even though we likely can't play back such
streams at full speed, we should still recognize them correctly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-h264.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 0e27412e01f5..07b4c706504f 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -108,6 +108,9 @@ int coda_h264_level(int level_idc)
 	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
 	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
 	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+	case 42: return V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
+	case 50: return V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
+	case 51: return V4L2_MPEG_VIDEO_H264_LEVEL_5_1;
 	default: return -EINVAL;
 	}
 }
-- 
2.17.1
