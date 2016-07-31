Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:32771 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbcGaNHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2016 09:07:50 -0400
Received: by mail-lf0-f52.google.com with SMTP id b199so99085417lfe.0
        for <linux-media@vger.kernel.org>; Sun, 31 Jul 2016 06:07:49 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de
Cc: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: [PATCH] rcar_vin: add support for V4L2_FIELD_ALTERNATE
Date: Sun, 31 Jul 2016 16:07:45 +0300
Message-ID: <4854742.fOvMrCAxeI@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware  can capture both odd and even fields in  the separate buffers,
so  it's possible to support  this field mode. However, if the subdevice
presents data  in this mode,  we prefer to use the hardware deinterlacing...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'master' branch.
This patch needs to be merged before the following ADV7180 driver patch is
merged: http://www.mail-archive.com/linux-media@vger.kernel.org/msg100410.html

 drivers/media/platform/soc_camera/rcar_vin.c |    2 ++
 1 file changed, 2 insertions(+)

Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
===================================================================
--- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
+++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
@@ -585,6 +585,7 @@ static int rcar_vin_setup(struct rcar_vi
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
 	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_ALTERNATE:
 		if (is_continuous_transfer(priv)) {
 			vnmc = VNMC_IM_ODD_EVEN;
 			progressive = true;
@@ -1595,6 +1596,7 @@ static int rcar_vin_set_fmt(struct soc_c
 	case V4L2_FIELD_INTERLACED_BT:
 		field = pix->field;
 		break;
+	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_INTERLACED:
 		/* Query for standard if not explicitly mentioned _TB/_BT */
 		ret = v4l2_subdev_call(sd, video, querystd, &std);

