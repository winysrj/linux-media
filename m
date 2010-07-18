Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:56527 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0GRE0f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 00:26:35 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org
Subject: [RFC] [PATCH 4/6] SoC Camera: add support for g_parm / s_parm operations
Date: Sun, 18 Jul 2010 06:26:08 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201007180618.08266.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007180626.11370.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for g_parm / s_parm operations to the SoC Camera 
framework. It is usefull for checking/setting camera frame rate.

Example usage can be found in the previous patch from this series, 
"SoC Camera: add driver for OV6650 sensor".

Created and tested against linux-2.6.35-rc3 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/media/video/soc_camera.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- linux-2.6.35-rc3.orig/drivers/media/video/soc_camera.c	2010-06-26 15:55:34.000000000 +0200
+++ linux-2.6.35-rc3/drivers/media/video/soc_camera.c	2010-06-27 00:04:10.000000000 +0200
@@ -1144,6 +1144,20 @@ static int default_s_crop(struct soc_cam
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
@@ -1175,6 +1189,10 @@ int soc_camera_host_register(struct soc_
 		ici->ops->get_crop = default_g_crop;
 	if (!ici->ops->cropcap)
 		ici->ops->cropcap = default_cropcap;
+	if (!ici->ops->set_parm)
+		ici->ops->set_parm = default_s_parm;
+	if (!ici->ops->get_parm)
+		ici->ops->get_parm = default_g_parm;
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
