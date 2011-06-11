Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54697 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1FKRrH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:07 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 7/8] marvell-cam: Allocate the i2c adapter in the platform driver
Date: Sat, 11 Jun 2011 11:46:48 -0600
Message-Id: <1307814409-46282-8-git-send-email-corbet@lwn.net>
In-Reply-To: <1307814409-46282-1-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The upcoming mmp-camera driver will need an i2c_adapter structure allocated
externally, so change the core adapter to a pointer and require the
platform code to fill it in.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |    9 +++++++--
 drivers/media/video/marvell-ccic/mcam-core.c   |    2 +-
 drivers/media/video/marvell-ccic/mcam-core.h   |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index 3dbc7e5..6a29cc1 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -334,9 +334,13 @@ static struct i2c_algorithm cafe_smbus_algo = {
 
 static int cafe_smbus_setup(struct cafe_camera *cam)
 {
-	struct i2c_adapter *adap = &cam->mcam.i2c_adapter;
+	struct i2c_adapter *adap;
 	int ret;
 
+	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
+	if (adap == NULL)
+		return -ENOMEM;
+	cam->mcam.i2c_adapter = adap;
 	cafe_smbus_enable_irq(cam);
 	adap->owner = THIS_MODULE;
 	adap->algo = &cafe_smbus_algo;
@@ -351,7 +355,8 @@ static int cafe_smbus_setup(struct cafe_camera *cam)
 
 static void cafe_smbus_shutdown(struct cafe_camera *cam)
 {
-	i2c_del_adapter(&cam->mcam.i2c_adapter);
+	i2c_del_adapter(cam->mcam.i2c_adapter);
+	kfree(cam->mcam.i2c_adapter);
 }
 
 
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index d5f18a3..014b70b 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1581,7 +1581,7 @@ int mccic_register(struct mcam_camera *cam)
 	sensor_cfg.use_smbus = cam->use_smbus;
 	cam->sensor_addr = ov7670_info.addr;
 	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
-			&cam->i2c_adapter, &ov7670_info, NULL);
+			cam->i2c_adapter, &ov7670_info, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_unregister;
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index e8a7de0..5effa82 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -37,7 +37,7 @@ struct mcam_camera {
 	 * These fields should be set by the platform code prior to
 	 * calling mcam_register().
 	 */
-	struct i2c_adapter i2c_adapter;
+	struct i2c_adapter *i2c_adapter;
 	unsigned char __iomem *regs;
 	spinlock_t dev_lock;
 	struct device *dev; /* For messages, dma alloc */
-- 
1.7.5.4

