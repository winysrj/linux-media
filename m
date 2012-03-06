Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030441Ab2CFMJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 07:09:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/5] mt9p031: Remove unused xskip and yskip fields in struct mt9p031
Date: Tue,  6 Mar 2012 13:09:43 +0100
Message-Id: <1331035786-8938-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields are set but never used, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index dd937df..52dd9f8 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -114,8 +114,6 @@ struct mt9p031 {
 	struct mt9p031_platform_data *pdata;
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
-	u16 xskip;
-	u16 yskip;
 
 	const struct mt9p031_pll_divs *pll;
 
@@ -784,8 +782,6 @@ static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	format->field = V4L2_FIELD_NONE;
 	format->colorspace = V4L2_COLORSPACE_SRGB;
 
-	mt9p031->xskip = 1;
-	mt9p031->yskip = 1;
 	return mt9p031_set_power(subdev, 1);
 }
 
-- 
1.7.3.4

