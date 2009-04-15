Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757945AbZDOMRV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 08:17:21 -0400
Date: Wed, 15 Apr 2009 14:17:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	eric miao <eric.y.miao@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/5] soc-camera: add a free_bus method to struct soc_camera_link
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904151358070.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently pcm990 camera bus-width management functions request a GPIO and never
free it again. With this approach the GPIO extender driver cannot be unloaded
once camera drivers have been loaded, also unloading theb i2c-pxa bus driver
produces errors, because the GPIO extender driver cannot unregister properly.
Another problem is, that if camera drivers are once loaded before the GPIO
extender driver, the platform code marks the GPIO unavailable and only a reboot
helps to recover. Adding an explicit free_bus method and using it in mt9m001
and mt9v022 drivers fixes these problems.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Eric, need your ack for the arch/arm/mach-pxa part. Sascha's wouldn't hurt 
either:-)

 arch/arm/mach-pxa/pcm990-baseboard.c |   23 ++++++++++++++++-------
 drivers/media/video/mt9m001.c        |    3 +++
 drivers/media/video/mt9v022.c        |    3 +++
 include/media/soc_camera.h           |    1 +
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 6c12b5a..9ce1ef2 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -380,12 +380,12 @@ static struct pca953x_platform_data pca9536_data = {
 	.gpio_base	= NR_BUILTIN_GPIO,
 };
 
-static int gpio_bus_switch;
+static int gpio_bus_switch = -EINVAL;
 
 static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
-		unsigned long flags)
+				       unsigned long flags)
 {
-	if (gpio_bus_switch <= 0) {
+	if (gpio_bus_switch < 0) {
 		if (flags == SOCAM_DATAWIDTH_10)
 			return 0;
 		else
@@ -404,25 +404,34 @@ static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
 {
 	int ret;
 
-	if (!gpio_bus_switch) {
+	if (gpio_bus_switch < 0) {
 		ret = gpio_request(NR_BUILTIN_GPIO, "camera");
 		if (!ret) {
 			gpio_bus_switch = NR_BUILTIN_GPIO;
 			gpio_direction_output(gpio_bus_switch, 0);
-		} else
-			gpio_bus_switch = -EINVAL;
+		}
 	}
 
-	if (gpio_bus_switch > 0)
+	if (gpio_bus_switch >= 0)
 		return SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_10;
 	else
 		return SOCAM_DATAWIDTH_10;
 }
 
+static void pcm990_camera_free_bus(struct soc_camera_link *link)
+{
+	if (gpio_bus_switch < 0)
+		return;
+
+	gpio_free(gpio_bus_switch);
+	gpio_bus_switch = -EINVAL;
+}
+
 static struct soc_camera_link iclink = {
 	.bus_id	= 0, /* Must match with the camera ID above */
 	.query_bus_param = pcm990_camera_query_bus_param,
 	.set_bus_param = pcm990_camera_set_bus_param,
+	.free_bus = pcm990_camera_free_bus,
 };
 
 /* Board I2C devices. */
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 684f62f..3838ff7 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -604,10 +604,13 @@ ei2c:
 static void mt9m001_video_remove(struct soc_camera_device *icd)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 
 	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9m001->client->addr,
 		icd->dev.parent, icd->vdev);
 	soc_camera_video_stop(icd);
+	if (icl->free_bus)
+		icl->free_bus(icl);
 }
 
 static int mt9m001_probe(struct i2c_client *client,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 4d3b481..412b399 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -735,10 +735,13 @@ ei2c:
 static void mt9v022_video_remove(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 
 	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9v022->client->addr,
 		icd->dev.parent, icd->vdev);
 	soc_camera_video_stop(icd);
+	if (icl->free_bus)
+		icl->free_bus(icl);
 }
 
 static int mt9v022_probe(struct i2c_client *client,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 3701368..396c325 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -107,6 +107,7 @@ struct soc_camera_link {
 	 */
 	int (*set_bus_param)(struct soc_camera_link *, unsigned long flags);
 	unsigned long (*query_bus_param)(struct soc_camera_link *);
+	void (*free_bus)(struct soc_camera_link *);
 };
 
 static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
-- 
1.5.4

