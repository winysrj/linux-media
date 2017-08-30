Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34480 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdH3ROF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 13:14:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: staging/imx: Fix uninitialized variable warning
Date: Wed, 30 Aug 2017 20:14:36 +0300
Message-Id: <20170830171436.15838-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ret variable can be returned uninitialized in the
imx_media_create_pad_vdev_lists() function is imxmd->num_vdevs is zero.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index d96f4512224f..b55e5ebba8b4 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -400,10 +400,10 @@ static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
 					struct media_link, list);
 		ret = imx_media_add_vdev_to_pad(imxmd, vdev, link->source);
 		if (ret)
-			break;
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* async subdev complete notifier */
-- 
Regards,

Laurent Pinchart
