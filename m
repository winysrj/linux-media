Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:35044 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab0FUFUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 01:20:13 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] soc_camera_platform: add set_fmt callback
Date: Mon, 21 Jun 2010 08:19:57 +0300
Message-Id: <266c646d111590fda11bd3bbecfe49dea6789e4e.1277097465.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows the platform camera to arrange a change in the capture format.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/soc_camera_platform.c |    3 +++
 include/media/soc_camera_platform.h       |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 248c986..208fd42 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -61,6 +61,9 @@ static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
+	if (p->try_fmt)
+		return p->try_fmt(p, mf);
+
 	mf->width	= p->format.width;
 	mf->height	= p->format.height;
 	mf->code	= p->format.code;
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 0ecefe2..0558ffc 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -22,6 +22,8 @@ struct soc_camera_platform_info {
 	struct v4l2_mbus_framefmt format;
 	unsigned long bus_param;
 	struct device *dev;
+	int (*try_fmt)(struct soc_camera_platform_info *info,
+			struct v4l2_mbus_framefmt *mf);
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
 
-- 
1.7.1

