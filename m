Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:33749 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2I0WEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 18:04:44 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 2/3] mt9v022: fix the V4L2_CID_EXPOSURE control
Date: Fri, 28 Sep 2012 00:04:34 +0200
Message-Id: <1348783474-22965-1-git-send-email-agust@denx.de>
In-Reply-To: <1345799431-29426-3-git-send-email-agust@denx.de>
References: <1345799431-29426-3-git-send-email-agust@denx.de>
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

Remove MT9V022_TOTAL_SHUTTER_WIDTH register setting in mt9v022_s_crop()
and add a comment explaining why it is not needed in manual mode.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
Changes since first version:
 - remove setting total shutter width register in mt9v022_s_crop()
   if in manual exposure mode and add a comment explaining why it is
   not needed
 - revise commit log
 - rebase on staging/for_v3.7 branch

 drivers/media/i2c/soc_camera/mt9v022.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 3cb23c6..e0f4cb4 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -272,9 +272,14 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 		if (ret & 1) /* Autoexposure */
 			ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
 					rect.height + mt9v022->y_skip_top + 43);
-		else
-			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
-					rect.height + mt9v022->y_skip_top + 43);
+		/*
+		 * If autoexposure is off, there is no need to set
+		 * MT9V022_TOTAL_SHUTTER_WIDTH here. Autoexposure can be off
+		 * only if the user has set exposure manually, using the
+		 * V4L2_CID_EXPOSURE_AUTO with the value V4L2_EXPOSURE_MANUAL.
+		 * In this case the register MT9V022_TOTAL_SHUTTER_WIDTH
+		 * already contains the correct value.
+		 */
 	}
 	/* Setup frame format: defaults apart from width and height */
 	if (!ret)
-- 
1.7.1

