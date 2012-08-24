Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51897 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab2HXJKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 05:10:38 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: [PATCH 2/3] mt9v022: fix the V4L2_CID_EXPOSURE control
Date: Fri, 24 Aug 2012 11:10:30 +0200
Message-Id: <1345799431-29426-3-git-send-email-agust@denx.de>
In-Reply-To: <1345799431-29426-1-git-send-email-agust@denx.de>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the MT9V022_TOTAL_SHUTTER_WIDTH register is controlled in manual
mode by V4L2_CID_EXPOSURE control, it shouldn't be written directly in
mt9v022_s_crop(). In manual mode this register should be set to the
V4L2_CID_EXPOSURE control value. Changing this register directly and
outside of the actual control function means that the register value
is not in sync with the corresponding control value. Thus, the following
problem is observed:

    - setting this control initially succeeds
    - VIDIOC_S_CROP ioctl() overwrites the MT9V022_TOTAL_SHUTTER_WIDTH
      register
    - setting this control to the same value again doesn't
      result in setting the register since the control value
      was previously cached and doesn't differ

Fix it by always setting the register to the controlled value, when
in manual mode.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/i2c/soc_camera/mt9v022.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index d13c8c4..d26c071 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -274,9 +274,9 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 		if (ret & 1) /* Autoexposure */
 			ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
 					rect.height + mt9v022->y_skip_top + 43);
-		else
-			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
-					rect.height + mt9v022->y_skip_top + 43);
+		else /* Set to the manually controlled value */
+			ret = v4l2_ctrl_s_ctrl(mt9v022->exposure,
+					       mt9v022->exposure->val);
 	}
 	/* Setup frame format: defaults apart from width and height */
 	if (!ret)
-- 
1.7.1

