Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36297 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbbICXSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 19:18:08 -0400
Received: by lbcao8 with SMTP id ao8so2365655lbc.3
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2015 16:18:07 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/3] rcar_vin: call g_std() instead of querystd()
Date: Fri, 04 Sep 2015 02:18:05 +0300
Message-ID: <2719391.j5OZOaG8ai@wasted.cogentembedded.com>
In-Reply-To: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
References: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil says: "The only place querystd can be called  is in the QUERYSTD
ioctl, all other ioctls should use the last set standard." So call the g_std()
subdevice method instead of querystd() in the driver's set_fmt() method.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 drivers/media/platform/soc_camera/rcar_vin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
===================================================================
--- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
+++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1589,8 +1589,8 @@ static int rcar_vin_set_fmt(struct soc_c
 		field = pix->field;
 		break;
 	case V4L2_FIELD_INTERLACED:
-		/* Query for standard if not explicitly mentioned _TB/_BT */
-		ret = v4l2_subdev_call(sd, video, querystd, &std);
+		/* Get the last standard if not explicitly mentioned _TB/_BT */
+		ret = v4l2_subdev_call(sd, video, g_std, &std);
 		if (ret == -ENOIOCTLCMD) {
 			field = V4L2_FIELD_NONE;
 		} else if (ret < 0) {

