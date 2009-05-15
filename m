Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33957 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754512AbZEORT5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:19:57 -0400
Date: Fri, 15 May 2009 19:20:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board() function
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151905440.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce a function similar to v4l2_i2c_new_subdev() but taking a pointer to a
struct i2c_board_info as a parameter instead of a client type and an I2C
address, and make v4l2_i2c_new_subdev() a wrapper around it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Hans, renamed as you requested and updated to a (more) current state.

 drivers/media/video/v4l2-common.c |   30 +++++++++++++++++++-----------
 include/media/v4l2-common.h       |    5 +++++
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index f576ef6..ab190aa 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -758,30 +758,38 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
-
-
 /* Load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr)
 {
-	struct v4l2_subdev *sd = NULL;
-	struct i2c_client *client;
 	struct i2c_board_info info;
 
-	BUG_ON(!v4l2_dev);
-
-	if (module_name)
-		request_module(module_name);
-
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
 	strlcpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
 
+	return v4l2_i2c_subdev_board(v4l2_dev, adapter, module_name, &info);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
+
+/* Load an i2c sub-device using provided struct i2c_board_info. */
+struct v4l2_subdev *v4l2_i2c_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const struct i2c_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client;
+
+	BUG_ON(!v4l2_dev);
+
+	if (module_name)
+		request_module(module_name);
+
 	/* Create the i2c client */
-	client = i2c_new_device(adapter, &info);
+	client = i2c_new_device(adapter, info);
 	/* Note: it is possible in the future that
 	   c->driver is NULL if the driver is still being loaded.
 	   We need better support from the kernel so that we
@@ -808,7 +816,7 @@ error:
 		i2c_unregister_device(client);
 	return sd;
 }
-EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
+EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_board);
 
 /* Probe and load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct v4l2_device *v4l2_dev,
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index c48c24e..a67f5c3 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -131,6 +131,7 @@ struct i2c_driver;
 struct i2c_adapter;
 struct i2c_client;
 struct i2c_device_id;
+struct i2c_board_info;
 struct v4l2_device;
 struct v4l2_subdev;
 struct v4l2_subdev_ops;
@@ -142,6 +143,10 @@ struct v4l2_subdev_ops;
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+/* Same as above but uses user-provided struct i2c_board_info */
+struct v4l2_subdev *v4l2_i2c_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const struct i2c_board_info *info);
 /* Probe and load an i2c module and return an initialized v4l2_subdev struct.
    Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
-- 
1.6.2.4

