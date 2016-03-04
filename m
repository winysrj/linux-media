Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45648 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250AbcCDQDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 11:03:11 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] v4l2-ioctl: fix YUV422P pixel format description
Date: Fri,  4 Mar 2016 17:03:00 +0100
Message-Id: <1457107380-18694-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plane order is YUV, not YVU.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8a018c6..52f5ba2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1165,7 +1165,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_YVYU:		descr = "YVYU 4:2:2"; break;
 	case V4L2_PIX_FMT_UYVY:		descr = "UYVY 4:2:2"; break;
 	case V4L2_PIX_FMT_VYUY:		descr = "VYUY 4:2:2"; break;
-	case V4L2_PIX_FMT_YUV422P:	descr = "Planar YVU 4:2:2"; break;
+	case V4L2_PIX_FMT_YUV422P:	descr = "Planar YUV 4:2:2"; break;
 	case V4L2_PIX_FMT_YUV411P:	descr = "Planar YUV 4:1:1"; break;
 	case V4L2_PIX_FMT_Y41P:		descr = "YUV 4:1:1 (Packed)"; break;
 	case V4L2_PIX_FMT_YUV444:	descr = "16-bit A/XYUV 4-4-4-4"; break;
-- 
2.7.0

