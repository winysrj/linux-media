Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34223 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbHSVCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 17:02:20 -0400
Received: by laba3 with SMTP id a3so10882769lab.1
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2015 14:02:19 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] rcar_vin: propagate querystd() error upstream
Date: Thu, 20 Aug 2015 00:02:17 +0300
Message-ID: <1650569.JYNQd5Bi8T@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rcar_vin_set_fmt() defaults to  PAL when the subdevice's querystd() method call
fails (e.g. due to I2C error).  This doesn't work very well when a camera being
used  outputs NTSC which has different order of fields and resolution.  Let  us
stop  pretending and return the actual error (which would prevent video capture
on at least Renesas Henninger/Porter board where I2C seems particularly buggy).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'media_tree.git' repo's 'fixes' branch.

 drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
===================================================================
--- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
+++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1592,7 +1592,7 @@ static int rcar_vin_set_fmt(struct soc_c
 		/* Query for standard if not explicitly mentioned _TB/_BT */
 		ret = v4l2_subdev_call(sd, video, querystd, &std);
 		if (ret < 0)
-			std = V4L2_STD_625_50;
+			return ret;
 
 		field = std & V4L2_STD_625_50 ? V4L2_FIELD_INTERLACED_TB :
 						V4L2_FIELD_INTERLACED_BT;

