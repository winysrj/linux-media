Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39405 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbeFUPv0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 11:51:26 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7] helo=dude.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1fW1ro-0007h8-Nl
        for linux-media@vger.kernel.org; Thu, 21 Jun 2018 17:51:24 +0200
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: coda: add h.264 level 4.2
Date: Thu, 21 Jun 2018 17:51:23 +0200
Message-Id: <20180621155123.21939-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables reordering support for h.264 main profile level 4.2
streams.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-h264.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 0e27412e01f5..945c6a582e37 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -108,6 +108,7 @@ int coda_h264_level(int level_idc)
 	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
 	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
 	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+	case 42: return V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
 	default: return -EINVAL;
 	}
 }
-- 
2.17.1
