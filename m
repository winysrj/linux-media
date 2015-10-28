Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12390 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965491AbbJ1Jmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 05:42:55 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] v4l2-clk: add new definition: V4L2_CLK_NAME_SIZE
Date: Wed, 28 Oct 2015 17:48:54 +0800
Message-ID: <1446025735-26849-4-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
References: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make all v4l2-clk's clock name use V4L2_CLK_NAME_SIZE definition.

In future, if the string increased we just need to change the
V4L2_CLK_NAME_SIZE once.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/soc_camera.c | 6 +++---
 drivers/media/usb/em28xx/em28xx-camera.c       | 2 +-
 include/media/v4l2-clk.h                       | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 673f1d4..506a569 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1362,7 +1362,7 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 	struct soc_camera_host_desc *shd = &sdesc->host_desc;
 	struct i2c_adapter *adap;
 	struct v4l2_subdev *subdev;
-	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	int ret;
 
 	/* First find out how we link the main client */
@@ -1528,7 +1528,7 @@ static int scan_async_group(struct soc_camera_host *ici,
 	struct soc_camera_async_client *sasc;
 	struct soc_camera_device *icd;
 	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
-	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	unsigned int i;
 	int ret;
 
@@ -1634,7 +1634,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	struct soc_camera_async_client *sasc;
 	struct soc_of_info *info;
 	struct i2c_client *client;
-	char clk_name[V4L2_SUBDEV_NAME_SIZE + 32];
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	int ret;
 
 	/* allocate a new subdev and add match info to it */
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index ed0b3a8..121cdfc 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -322,7 +322,7 @@ int em28xx_detect_sensor(struct em28xx *dev)
 
 int em28xx_init_camera(struct em28xx *dev)
 {
-	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 	struct i2c_adapter *adap = &dev->i2c_adap[dev->def_i2c_bus];
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
index 34891ea..2b94662 100644
--- a/include/media/v4l2-clk.h
+++ b/include/media/v4l2-clk.h
@@ -65,6 +65,8 @@ static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
 	return __v4l2_clk_register_fixed(dev_id, rate, THIS_MODULE);
 }
 
+#define V4L2_CLK_NAME_SIZE 64
+
 #define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \
 			  "%d-%04x", adap, client)
 
-- 
1.9.1

