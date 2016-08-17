Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46375 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbcHQG35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:29:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/7] ov7670: fix g/s_parm
Date: Wed, 17 Aug 2016 08:29:39 +0200
Message-Id: <1471415383-38531-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
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
index 26ad1a2..fe527b2 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1047,7 +1047,6 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	memset(cp, 0, sizeof(struct v4l2_captureparm));
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	info->devtype->get_framerate(sd, &cp->timeperframe);
 
@@ -1062,9 +1061,8 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (cp->extendedmode != 0)
-		return -EINVAL;
 
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	return info->devtype->set_framerate(sd, tpf);
 }
 
-- 
2.8.1

