Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44843 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751073AbeAVKTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:19:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/9] staging: atomisp: mt9m114: Drop empty s_parm callback
Date: Mon, 22 Jan 2018 11:18:54 +0100
Message-Id: <20180122101857.51401-7-hverkuil@xs4all.nl>
In-Reply-To: <20180122101857.51401-1-hverkuil@xs4all.nl>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The s_parm callback in mt9m114 driver did nothing, remove it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index df253a557c76..834fba8c4fa0 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -1684,11 +1684,6 @@ static int mt9m114_t_vflip(struct v4l2_subdev *sd, int value)
 
 	return !!err;
 }
-static int mt9m114_s_parm(struct v4l2_subdev *sd,
-			struct v4l2_streamparm *param)
-{
-	return 0;
-}
 
 static int mt9m114_g_frame_interval(struct v4l2_subdev *sd,
 				   struct v4l2_subdev_frame_interval *interval)
@@ -1781,7 +1776,6 @@ static int mt9m114_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
 }
 
 static const struct v4l2_subdev_video_ops mt9m114_video_ops = {
-	.s_parm = mt9m114_s_parm,
 	.s_stream = mt9m114_s_stream,
 	.g_frame_interval = mt9m114_g_frame_interval,
 };
-- 
2.15.1
