Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3018 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3CKLq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 24/42] go7007: fix unregister/disconnect handling.
Date: Mon, 11 Mar 2013 12:46:02 +0100
Message-Id: <b52b791d5f1fd3304729507059bee23bfe7fcfcc.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- use the v4l2_device's release() callback
- remove the unnecessary ref_count
- don't free usb data structures on disconnect, only do that in the final
  release callback.

This is the correct way in order to safely handle disconnect and removal
of modules.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c  |   63 +++++++++++++-----------
 drivers/staging/media/go7007/go7007-priv.h    |    4 +-
 drivers/staging/media/go7007/go7007-usb.c     |   64 +++++++++++++++----------
 drivers/staging/media/go7007/go7007-v4l2.c    |   22 +--------
 drivers/staging/media/go7007/saa7134-go7007.c |    7 ++-
 drivers/staging/media/go7007/snd-go7007.c     |    5 +-
 6 files changed, 85 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index db9a4b3..dca85d8 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -221,6 +221,31 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
 }
 
 /*
+ * Detach and unregister the encoder.  The go7007 struct won't be freed
+ * until v4l2 finishes releasing its resources and all associated fds are
+ * closed by applications.
+ */
+static void go7007_remove(struct v4l2_device *v4l2_dev)
+{
+	struct go7007 *go = container_of(v4l2_dev, struct go7007, v4l2_dev);
+
+	v4l2_device_unregister(v4l2_dev);
+	if (go->hpi_ops->release)
+		go->hpi_ops->release(go);
+	if (go->i2c_adapter_online) {
+		if (i2c_del_adapter(&go->i2c_adapter) == 0)
+			go->i2c_adapter_online = 0;
+		else
+			v4l2_err(&go->v4l2_dev,
+				"error removing I2C adapter!\n");
+	}
+
+	kfree(go->boot_fw);
+	go7007_v4l2_remove(go);
+	kfree(go);
+}
+
+/*
  * Finalize the GO7007 hardware setup, register the on-board I2C adapter
  * (if used on this board), load the I2C client driver for the sensor
  * (SAA7115 or whatever) and other devices, and register the ALSA and V4L2
@@ -234,17 +259,17 @@ int go7007_register_encoder(struct go7007 *go, unsigned num_i2c_devs)
 
 	dev_info(go->dev, "go7007: registering new %s\n", go->name);
 
+	go->v4l2_dev.release = go7007_remove;
+	ret = v4l2_device_register(go->dev, &go->v4l2_dev);
+	if (ret < 0)
+		return ret;
+
 	mutex_lock(&go->hw_lock);
 	ret = go7007_init_encoder(go);
 	mutex_unlock(&go->hw_lock);
 	if (ret < 0)
 		return -1;
 
-	/* v4l2 init must happen before i2c subdevs */
-	ret = go7007_v4l2_init(go);
-	if (ret < 0)
-		return ret;
-
 	if (!go->i2c_adapter_online &&
 			go->board_info->flags & GO7007_BOARD_USE_ONBOARD_I2C) {
 		if (go7007_i2c_init(go) < 0)
@@ -269,6 +294,11 @@ int go7007_register_encoder(struct go7007 *go, unsigned num_i2c_devs)
 			v4l2_subdev_call(go->sd_video, video, s_routing,
 					0, 0, go->channel_number + 1);
 	}
+
+	ret = go7007_v4l2_init(go);
+	if (ret < 0)
+		return ret;
+
 	if (go->board_info->flags & GO7007_BOARD_HAS_AUDIO) {
 		go->audio_enabled = 1;
 		go7007_snd_init(go);
@@ -608,7 +638,6 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
 	go->video_dev = NULL;
-	go->ref_count = 0;
 	go->status = STATUS_INIT;
 	memset(&go->i2c_adapter, 0, sizeof(go->i2c_adapter));
 	go->i2c_adapter_online = 0;
@@ -658,26 +687,4 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 }
 EXPORT_SYMBOL(go7007_alloc);
 
-/*
- * Detach and unregister the encoder.  The go7007 struct won't be freed
- * until v4l2 finishes releasing its resources and all associated fds are
- * closed by applications.
- */
-void go7007_remove(struct go7007 *go)
-{
-	if (go->i2c_adapter_online) {
-		if (i2c_del_adapter(&go->i2c_adapter) == 0)
-			go->i2c_adapter_online = 0;
-		else
-			v4l2_err(&go->v4l2_dev,
-				"error removing I2C adapter!\n");
-	}
-
-	if (go->audio_enabled)
-		go7007_snd_remove(go);
-	kfree(go->boot_fw);
-	go7007_v4l2_remove(go);
-}
-EXPORT_SYMBOL(go7007_remove);
-
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index d390120..54cfc0a 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -117,6 +117,7 @@ struct go7007_hpi_ops {
 	int (*stream_stop)(struct go7007 *go);
 	int (*send_firmware)(struct go7007 *go, u8 *data, int len);
 	int (*send_command)(struct go7007 *go, unsigned int cmd, void *arg);
+	void (*release)(struct go7007 *go);
 };
 
 /* The video buffer size must be a multiple of PAGE_SIZE */
@@ -181,7 +182,6 @@ struct go7007 {
 	void *boot_fw;
 	unsigned boot_fw_len;
 	struct v4l2_device v4l2_dev;
-	int ref_count;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
@@ -287,8 +287,6 @@ int go7007_start_encoder(struct go7007 *go);
 void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length);
 struct go7007 *go7007_alloc(struct go7007_board_info *board,
 					struct device *dev);
-void go7007_remove(struct go7007 *go);
-
 /* go7007-fw.c */
 int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen);
 
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index f496720..2d349f4 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -617,6 +617,8 @@ static int go7007_usb_interface_reset(struct go7007 *go)
 	struct go7007_usb *usb = go->hpi_context;
 	u16 intr_val, intr_data;
 
+	if (go->status == STATUS_SHUTDOWN)
+		return -1;
 	/* Reset encoder */
 	if (go7007_write_interrupt(go, 0x0001, 0x0001) < 0)
 		return -1;
@@ -886,6 +888,35 @@ static int go7007_usb_send_firmware(struct go7007 *go, u8 *data, int len)
 					&transferred, timeout);
 }
 
+static void go7007_usb_release(struct go7007 *go)
+{
+	struct go7007_usb *usb = go->hpi_context;
+	struct urb *vurb, *aurb;
+	int i;
+
+	usb_kill_urb(usb->intr_urb);
+
+	/* Free USB-related structs */
+	for (i = 0; i < 8; ++i) {
+		vurb = usb->video_urbs[i];
+		if (vurb) {
+			usb_kill_urb(vurb);
+			kfree(vurb->transfer_buffer);
+			usb_free_urb(vurb);
+		}
+		aurb = usb->audio_urbs[i];
+		if (aurb) {
+			usb_kill_urb(aurb);
+			kfree(aurb->transfer_buffer);
+			usb_free_urb(aurb);
+		}
+	}
+	kfree(usb->intr_urb->transfer_buffer);
+	usb_free_urb(usb->intr_urb);
+
+	kfree(go->hpi_context);
+}
+
 static struct go7007_hpi_ops go7007_usb_ezusb_hpi_ops = {
 	.interface_reset	= go7007_usb_interface_reset,
 	.write_interrupt	= go7007_usb_ezusb_write_interrupt,
@@ -893,6 +924,7 @@ static struct go7007_hpi_ops go7007_usb_ezusb_hpi_ops = {
 	.stream_start		= go7007_usb_stream_start,
 	.stream_stop		= go7007_usb_stream_stop,
 	.send_firmware		= go7007_usb_send_firmware,
+	.release		= go7007_usb_release,
 };
 
 static struct go7007_hpi_ops go7007_usb_onboard_hpi_ops = {
@@ -902,6 +934,7 @@ static struct go7007_hpi_ops go7007_usb_onboard_hpi_ops = {
 	.stream_start		= go7007_usb_stream_start,
 	.stream_stop		= go7007_usb_stream_stop,
 	.send_firmware		= go7007_usb_send_firmware,
+	.release		= go7007_usb_release,
 };
 
 /********************* Driver for EZ-USB I2C adapter *********************/
@@ -1279,34 +1312,15 @@ allocfail:
 static void go7007_usb_disconnect(struct usb_interface *intf)
 {
 	struct go7007 *go = to_go7007(usb_get_intfdata(intf));
-	struct go7007_usb *usb = go->hpi_context;
-	struct urb *vurb, *aurb;
-	int i;
-
-	usb_kill_urb(usb->intr_urb);
-
-	/* Free USB-related structs */
-	for (i = 0; i < 8; ++i) {
-		vurb = usb->video_urbs[i];
-		if (vurb) {
-			usb_kill_urb(vurb);
-			kfree(vurb->transfer_buffer);
-			usb_free_urb(vurb);
-		}
-		aurb = usb->audio_urbs[i];
-		if (aurb) {
-			usb_kill_urb(aurb);
-			kfree(aurb->transfer_buffer);
-			usb_free_urb(aurb);
-		}
-	}
-	kfree(usb->intr_urb->transfer_buffer);
-	usb_free_urb(usb->intr_urb);
 
-	kfree(go->hpi_context);
+	if (go->audio_enabled)
+		go7007_snd_remove(go);
 
 	go->status = STATUS_SHUTDOWN;
-	go7007_remove(go);
+	v4l2_device_disconnect(&go->v4l2_dev);
+	video_unregister_device(go->video_dev);
+
+	v4l2_device_put(&go->v4l2_dev);
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index b470306..53d2cbc 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -100,7 +100,6 @@ static int go7007_open(struct file *file)
 	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
 	if (gofh == NULL)
 		return -ENOMEM;
-	++go->ref_count;
 	gofh->go = go;
 	mutex_init(&gofh->lock);
 	gofh->buf_count = 0;
@@ -120,8 +119,6 @@ static int go7007_release(struct file *file)
 		gofh->buf_count = 0;
 	}
 	kfree(gofh);
-	if (--go->ref_count == 0)
-		kfree(go);
 	file->private_data = NULL;
 	return 0;
 }
@@ -1772,11 +1769,7 @@ static unsigned int go7007_poll(struct file *file, poll_table *wait)
 
 static void go7007_vfl_release(struct video_device *vfd)
 {
-	struct go7007 *go = video_get_drvdata(vfd);
-
 	video_device_release(vfd);
-	if (--go->ref_count == 0)
-		kfree(go);
 }
 
 static struct v4l2_file_operations go7007_fops = {
@@ -1844,7 +1837,8 @@ int go7007_v4l2_init(struct go7007 *go)
 	if (go->video_dev == NULL)
 		return -ENOMEM;
 	*go->video_dev = go7007_template;
-	go->video_dev->parent = go->dev;
+	video_set_drvdata(go->video_dev, go);
+	go->video_dev->v4l2_dev = &go->v4l2_dev;
 	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
 	if (rv < 0) {
 		video_device_release(go->video_dev);
@@ -1856,14 +1850,6 @@ int go7007_v4l2_init(struct go7007 *go)
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_AUDIO);
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUMAUDIO);
 	}
-	rv = v4l2_device_register(go->dev, &go->v4l2_dev);
-	if (rv < 0) {
-		video_device_release(go->video_dev);
-		go->video_dev = NULL;
-		return rv;
-	}
-	video_set_drvdata(go->video_dev, go);
-	++go->ref_count;
 	dev_info(go->dev, "registered device %s [v4l2]\n",
 		 video_device_node_name(go->video_dev));
 
@@ -1883,8 +1869,4 @@ void go7007_v4l2_remove(struct go7007 *go)
 		spin_unlock_irqrestore(&go->spinlock, flags);
 	}
 	mutex_unlock(&go->hw_lock);
-	if (go->video_dev)
-		video_unregister_device(go->video_dev);
-	if (go->status != STATUS_SHUTDOWN)
-		v4l2_device_unregister(&go->v4l2_dev);
 }
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index afe21f3..4c73945 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -499,12 +499,17 @@ static int saa7134_go7007_fini(struct saa7134_dev *dev)
 		return 0;
 
 	go = video_get_drvdata(dev->empress_dev);
+	if (go->audio_enabled)
+		go7007_snd_remove(go);
+
 	saa = go->hpi_context;
 	go->status = STATUS_SHUTDOWN;
 	free_page((unsigned long)saa->top);
 	free_page((unsigned long)saa->bottom);
 	kfree(saa);
-	go7007_remove(go);
+	video_unregister_device(&go->vdev);
+
+	v4l2_device_put(&go->v4l2_dev);
 	dev->empress_dev = NULL;
 
 	return 0;
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index 5af29ff..0e50e22 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -221,8 +221,6 @@ static int go7007_snd_free(struct snd_device *device)
 
 	kfree(go->snd_context);
 	go->snd_context = NULL;
-	if (--go->ref_count == 0)
-		kfree(go);
 	return 0;
 }
 
@@ -285,8 +283,8 @@ int go7007_snd_init(struct go7007 *go)
 
 	gosnd->substream = NULL;
 	go->snd_context = gosnd;
+	v4l2_device_get(&go->v4l2_dev);
 	++dev;
-	++go->ref_count;
 
 	return 0;
 }
@@ -298,6 +296,7 @@ int go7007_snd_remove(struct go7007 *go)
 
 	snd_card_disconnect(gosnd->card);
 	snd_card_free_when_closed(gosnd->card);
+	v4l2_device_put(&go->v4l2_dev);
 	return 0;
 }
 EXPORT_SYMBOL(go7007_snd_remove);
-- 
1.7.10.4

