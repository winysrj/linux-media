Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43740 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2A3MTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:19:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: javier.martin@vista-silicon.com
Subject: [PATCH] mt9p031: Remove unused xskip and yskip fields in struct mt9p031
Date: Mon, 30 Jan 2012 13:19:56 +0100
Message-Id: <1327925996-18459-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields are set but never used, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 93c3ec7..0bdddbb 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -115,8 +115,6 @@ struct mt9p031 {
 	struct mt9p031_platform_data *pdata;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
-	u16 xskip;
-	u16 yskip;
 
 	const struct mt9p031_pll_divs *pll;
 
@@ -785,8 +783,6 @@ static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	format->field = V4L2_FIELD_NONE;
 	format->colorspace = V4L2_COLORSPACE_SRGB;
 
-	mt9p031->xskip = 1;
-	mt9p031->yskip = 1;
 	return mt9p031_set_power(subdev, 1);
 }
 
-- 
Regards,

Laurent Pinchart

