Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:58704 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754062Ab0BIK7T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 05:59:19 -0500
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH] mt9t031: use runtime pm support to restore ADDRESS_MODE registers
Date: Tue,  9 Feb 2010 11:59:12 +0100
Message-Id: <1265713152-19440-1-git-send-email-valentin.longchamp@epfl.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the platform hooks are provided, soc_camera powers off the device
on close and powers it on on open. This resets the ADDRESS_MODE registers
which then can be different to the value the driver has computed for them.

This patch setups runtime pm usage for mt9t031 and uses the resume function
to write the ADDRESS_MODE registers in order to fix the above described
problem.

This patch depends the pm runtime management in soc_camera, provided in this
patch:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15686

Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
---
 drivers/media/video/mt9t031.c |   66 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index a9061bf..bc2ecd5 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -8,14 +8,16 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/videodev2.h>
-#include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
 
-#include <media/v4l2-subdev.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * mt9t031 i2c address 0x5d
@@ -681,12 +683,66 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 }
 
 /*
+ * Power Management:
+ * This function does nothing for now but must be present for pm to work
+ */
+static int mt9t031_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+/*
+ * Power Management:
+ * COLUMN_ADDRESS_MODE and ROW_ADDRESS_MODE are not rewritten if unchanged
+ * they are however changed at reset if the platform hook is present
+ * thus we rewrite them with the values stored by the driver
+ */
+static int mt9t031_runtime_resume(struct device *dev)
+{
+	struct video_device *vdev = to_video_device(dev);
+	struct soc_camera_device *icd = container_of(vdev->parent,
+		struct soc_camera_device, dev);
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+
+	int ret;
+	u16 xbin, ybin;
+
+	xbin = min(mt9t031->xskip, (u16)3);
+	ybin = min(mt9t031->yskip, (u16)3);
+
+	ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
+		((xbin-1)<<4) | (mt9t031->xskip-1));
+	if (ret < 0)
+		return ret;
+
+	ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
+		((ybin-1)<<4) | (mt9t031->yskip-1));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct dev_pm_ops mt9t031_dev_pm_ops = {
+	.runtime_suspend	= mt9t031_runtime_suspend,
+	.runtime_resume		= mt9t031_runtime_resume,
+};
+
+static struct device_type mt9t031_dev_type = {
+	.name	= "MT9T031",
+	.pm	= &mt9t031_dev_pm_ops,
+};
+
+/*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
 static int mt9t031_video_probe(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
 	s32 data;
 	int ret;
 
@@ -712,6 +768,8 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	ret = mt9t031_idle(client);
 	if (ret < 0)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
+	else
+		vdev->dev.type = &mt9t031_dev_type;
 
 	/* mt9t031_idle() has reset the chip to default. */
 	mt9t031->exposure = 255;
-- 
1.6.3.3

