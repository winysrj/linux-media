Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:41305 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0IKB0l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 21:26:41 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 4/6] SoC Camera: add support for g_parm / s_parm operations
Date: Sat, 11 Sep 2010 03:26:16 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201009110317.54899.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009110326.17244.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch adds support for g_parm / s_parm operations to the SoC Camera 
framework. It is usefull for checking/setting camera frame rate.

Example usage can be found in the previous patch from this series, 
"SoC Camera: add driver for OV6650 sensor".

Created and tested against linux-2.6.36-rc3 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
v1->v2 changes:
- no functional changes,
- refreshed against linux-2.6.36-rc3.


 drivers/media/video/soc_camera.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff -upr linux-2.6.36-rc3.orig/drivers/media/video/soc_camera.c linux-2.6.36-rc3/drivers/media/video/soc_camera.c
--- linux-2.6.36-rc3.orig/drivers/media/video/soc_camera.c	2010-09-03 22:29:44.000000000 +0200
+++ linux-2.6.36-rc3/drivers/media/video/soc_camera.c	2010-09-03 22:34:03.000000000 +0200
@@ -1148,6 +1148,20 @@ static int default_s_crop(struct soc_cam
 	return v4l2_subdev_call(sd, video, s_crop, a);
 }
 
+static int default_g_parm(struct soc_camera_device *icd,
+			  struct v4l2_streamparm *parm)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	return v4l2_subdev_call(sd, video, g_parm, parm);
+}
+
+static int default_s_parm(struct soc_camera_device *icd,
+			  struct v4l2_streamparm *parm)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	return v4l2_subdev_call(sd, video, s_parm, parm);
+}
+
 static void soc_camera_device_init(struct device *dev, void *pdata)
 {
 	dev->platform_data	= pdata;
@@ -1179,6 +1193,10 @@ int soc_camera_host_register(struct soc_
 		ici->ops->get_crop = default_g_crop;
 	if (!ici->ops->cropcap)
 		ici->ops->cropcap = default_cropcap;
+	if (!ici->ops->set_parm)
+		ici->ops->set_parm = default_s_parm;
+	if (!ici->ops->get_parm)
+		ici->ops->get_parm = default_g_parm;
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
