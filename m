Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaBEQl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 22/47] s5p-tv: hdmiphy: Remove deprecated video-level DV timings operation
Date: Wed,  5 Feb 2014 17:42:13 +0100
Message-Id: <1391618558-5580-23-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings operation is deprecated and unused. Remove it.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index ff22320..c2f2e35 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -262,7 +262,6 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
 
 static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
 	.s_dv_timings = hdmiphy_s_dv_timings,
-	.dv_timings_cap = hdmiphy_dv_timings_cap,
 	.s_stream =  hdmiphy_s_stream,
 };
 
-- 
1.8.3.2

