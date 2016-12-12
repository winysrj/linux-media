Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44088 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752411AbcLLPzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/15] ov7670: fix g/s_parm
Date: Mon, 12 Dec 2016 16:55:08 +0100
Message-Id: <20161212155520.41375-4-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop unnecesary memset. Drop the unnecessary extendedmode check and
set the V4L2_CAP_TIMEPERFRAME capability.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 3f0522f..35b09d2 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1049,7 +1049,6 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	memset(cp, 0, sizeof(struct v4l2_captureparm));
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	info->devtype->get_framerate(sd, &cp->timeperframe);
 
@@ -1064,9 +1063,8 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (cp->extendedmode != 0)
-		return -EINVAL;
 
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	return info->devtype->set_framerate(sd, tpf);
 }
 
-- 
2.10.2

