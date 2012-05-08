Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2EHVBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 17:01:25 -0400
Date: Tue, 8 May 2012 23:01:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Qing Xu <qingx@marvell.com>
Subject: [PATCH 1/2] V4L: soc-camera: switch to using the existing
 .enum_framesizes()
Message-ID: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recently introduced .enum_mbus_fsizes() v4l2-subdev video operation is
a duplicate of the .enum_framesizes() operation, introduced earlier. Switch
soc-camera over to using the original one.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Qing Xu <qingx@marvell.com>
---
 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b08696f..6707df4 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1259,7 +1259,7 @@ static int default_enum_framesizes(struct soc_camera_device *icd,
 	/* map xlate-code to pixel_format, sensor only handle xlate-code*/
 	fsize_mbus.pixel_format = xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, &fsize_mbus);
+	ret = v4l2_subdev_call(sd, video, enum_framesizes, &fsize_mbus);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.2.5

