Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936303Ab3DRVgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:36:01 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 11/24] soc-camera: completely remove struct soc_camera_link
Date: Thu, 18 Apr 2013 23:35:32 +0200
Message-Id: <1366320945-21591-12-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This updates the last user of struct soc_camera_link and finally removes it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/video4linux/soc-camera.txt |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c |   12 +++++--
 include/media/soc_camera.h               |   48 ------------------------------
 3 files changed, 9 insertions(+), 53 deletions(-)

diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/video4linux/soc-camera.txt
index f62fcdb..04da87a 100644
--- a/Documentation/video4linux/soc-camera.txt
+++ b/Documentation/video4linux/soc-camera.txt
@@ -85,7 +85,7 @@ respective V4L2 operations.
 Camera API
 ----------
 
-Sensor drivers can use struct soc_camera_link, typically provided by the
+Sensor drivers can use struct soc_camera_desc, typically provided by the
 platform, and used to specify to which camera host bus the sensor is connected,
 and optionally provide platform .power and .reset methods for the camera. This
 struct is provided to the camera driver via the I2C client device platform data
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 73cc50a..365b601 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -43,10 +43,14 @@ static unsigned short omnivision_sensor_addrs[] = {
 };
 
 
-static struct soc_camera_link camlink = {
-	.bus_id = 0,
-	.flags = 0,
-	.module_name = "em28xx",
+static struct soc_camera_desc camlink = {
+	.subdev_desc	= {
+		.flags = 0,
+	},
+	.host_desc	= {
+		.bus_id = 0,
+		.module_name = "em28xx",
+	},
 };
 
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 1331278..a2a3b4f 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -190,54 +190,6 @@ struct soc_camera_desc {
 };
 
 /* Prepare to replace this struct: don't change its layout any more! */
-struct soc_camera_link {
-	/*
-	 * Subdevice part - keep at top and compatible to
-	 * struct soc_camera_subdev_desc
-	 */
-
-	/* Per camera SOCAM_SENSOR_* bus flags */
-	unsigned long flags;
-
-	void *priv;
-
-	/* Optional callbacks to power on or off and reset the sensor */
-	int (*power)(struct device *, int);
-	int (*reset)(struct device *);
-	/*
-	 * some platforms may support different data widths than the sensors
-	 * native ones due to different data line routing. Let the board code
-	 * overwrite the width flags.
-	 */
-	int (*set_bus_param)(struct soc_camera_link *, unsigned long flags);
-	unsigned long (*query_bus_param)(struct soc_camera_link *);
-	void (*free_bus)(struct soc_camera_link *);
-
-	/* Optional regulators that have to be managed on power on/off events */
-	struct regulator_bulk_data *regulators;
-	int num_regulators;
-
-	void *host_priv;
-
-	/*
-	 * Host part - keep at bottom and compatible to
-	 * struct soc_camera_host_desc
-	 */
-
-	/* Camera bus id, used to match a camera and a bus */
-	int bus_id;
-	int i2c_adapter_id;
-	struct i2c_board_info *board_info;
-	const char *module_name;
-
-	/*
-	 * For non-I2C devices platform has to provide methods to add a device
-	 * to the system and to remove it
-	 */
-	int (*add_device)(struct soc_camera_device *);
-	void (*del_device)(struct soc_camera_device *);
-};
-
 static inline struct soc_camera_host *to_soc_camera_host(
 	const struct device *dev)
 {
-- 
1.7.2.5

