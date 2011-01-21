Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1AUQlq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 11:41:46 -0500
Date: Fri, 21 Jan 2011 11:41:43 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 1/3 v2] hdpvr: fix up i2c device registration
Message-ID: <20110121164143.GD16585@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
 <1295584225-21210-2-git-send-email-jarod@redhat.com>
 <1295616898.2114.30.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295616898.2114.30.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We have to actually call i2c_new_device() once for each of the rx and tx
addresses. Also improve error-handling and device remove i2c cleanup.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---

v2: address Andy's review comments from v1 -
- wrap i2c_del_adapter with #if defined i2c conditionals in error path
- use function-local non-static i2c_board_info to avoid potential races
- don't bother storing i2c_client pointers in hdpvr device struct

 drivers/media/video/hdpvr/hdpvr-core.c |   24 ++++++++++++++++++++----
 drivers/media/video/hdpvr/hdpvr-i2c.c  |   30 +++++++++++++++++++-----------
 drivers/media/video/hdpvr/hdpvr.h      |    3 ++-
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index a6572e5..a27d93b 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -283,6 +283,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	struct hdpvr_device *dev;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
+	struct i2c_client *client;
 	size_t buffer_size;
 	int i;
 	int retval = -ENOMEM;
@@ -381,13 +382,21 @@ static int hdpvr_probe(struct usb_interface *interface,
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
-		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
+		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
 		goto error;
 	}
 
-	retval = hdpvr_register_i2c_ir(dev);
-	if (retval < 0)
-		v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");
+	client = hdpvr_register_ir_rx_i2c(dev);
+	if (!client) {
+		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
+		goto reg_fail;
+	}
+
+	client = hdpvr_register_ir_tx_i2c(dev);
+	if (!client) {
+		v4l2_err(&dev->v4l2_dev, "i2c IR TX device register failed\n");
+		goto reg_fail;
+	}
 #endif
 
 	/* let the user know what node this device is now attached to */
@@ -395,6 +404,10 @@ static int hdpvr_probe(struct usb_interface *interface,
 		  video_device_node_name(dev->video_dev));
 	return 0;
 
+reg_fail:
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_adapter(&dev->i2c_adapter);
+#endif
 error:
 	if (dev) {
 		/* Destroy single thread */
@@ -424,6 +437,9 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 	mutex_lock(&dev->io_mutex);
 	hdpvr_cancel_queue(dev);
 	mutex_unlock(&dev->io_mutex);
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_adapter(&dev->i2c_adapter);
+#endif
 	video_unregister_device(dev->video_dev);
 	atomic_dec(&dev_nr);
 }
diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index 89b71fa..e53fa55 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -31,26 +31,34 @@
 #define Z8F0811_IR_RX_I2C_ADDR	0x71
 
 
-static struct i2c_board_info hdpvr_i2c_board_info = {
-	I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
-	I2C_BOARD_INFO("ir_rx_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
-};
+struct i2c_client *hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev)
+{
+	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
+	struct i2c_board_info hdpvr_ir_tx_i2c_board_info = {
+		I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
+	};
+
+	init_data->name = "HD-PVR";
+	hdpvr_ir_tx_i2c_board_info.platform_data = init_data;
 
-int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
+	return i2c_new_device(&dev->i2c_adapter, &hdpvr_ir_tx_i2c_board_info);
+}
+
+struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 {
-	struct i2c_client *c;
 	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
+	struct i2c_board_info hdpvr_ir_rx_i2c_board_info = {
+		I2C_BOARD_INFO("ir_rx_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
+	};
 
 	/* Our default information for ir-kbd-i2c.c to use */
 	init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 	init_data->type = RC_TYPE_RC5;
-	init_data->name = "HD PVR";
-	hdpvr_i2c_board_info.platform_data = init_data;
-
-	c = i2c_new_device(&dev->i2c_adapter, &hdpvr_i2c_board_info);
+	init_data->name = "HD-PVR";
+	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
 
-	return (c == NULL) ? -ENODEV : 0;
+	return i2c_new_device(&dev->i2c_adapter, &hdpvr_ir_rx_i2c_board_info);
 }
 
 static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
index ee74e3b..072f23c 100644
--- a/drivers/media/video/hdpvr/hdpvr.h
+++ b/drivers/media/video/hdpvr/hdpvr.h
@@ -313,7 +313,8 @@ int hdpvr_cancel_queue(struct hdpvr_device *dev);
 /* i2c adapter registration */
 int hdpvr_register_i2c_adapter(struct hdpvr_device *dev);
 
-int hdpvr_register_i2c_ir(struct hdpvr_device *dev);
+struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev);
+struct i2c_client *hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev);
 
 /*========================================================================*/
 /* buffer management */
-- 
1.7.3.4

-- 
Jarod Wilson
jarod@redhat.com

