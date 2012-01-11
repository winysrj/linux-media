Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0MEKd024947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] [media] cx231xx: Fix unregister logic
Date: Tue, 10 Jan 2012 22:20:24 -0200
Message-Id: <1326241226-6734-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several weirdness at the unregister logic.

First of all, IR has a poll thread. This thread needs to be
removed, as it uses some resources associated to the main driver.
So, the driver needs to explicitly unregister the I2C client for
ir-kbd-i2c.

If, for some reason, the driver needs to wait for a close()
to happen, not all memories will be freed, because the free
logic were in the wrong place.

Also, v4l2_device_unregister() seems to be called too early,
as devices are still using it.

Finally, even with the device disconnected, there is one
USB function call that will still try to talk with it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |   29 ++++++++++++++------------
 drivers/media/video/cx231xx/cx231xx-core.c  |    3 ++
 drivers/media/video/cx231xx/cx231xx-input.c |    5 +++-
 drivers/media/video/cx231xx/cx231xx.h       |    1 +
 drivers/media/video/ir-kbd-i2c.c            |    8 -------
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2a28882..bd82f01 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -843,15 +843,25 @@ void cx231xx_release_resources(struct cx231xx *dev)
 
 	cx231xx_remove_from_devlist(dev);
 
+	cx231xx_ir_exit(dev);
+
 	/* Release I2C buses */
 	cx231xx_dev_uninit(dev);
 
-	cx231xx_ir_exit(dev);
+	/* delete v4l2 device */
+	v4l2_device_unregister(&dev->v4l2_dev);
 
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
 	cx231xx_devused &= ~(1 << dev->devno);
+
+	kfree(dev->video_mode.alt_max_pkt_size);
+	kfree(dev->vbi_mode.alt_max_pkt_size);
+	kfree(dev->sliced_cc_mode.alt_max_pkt_size);
+	kfree(dev->ts1_mode.alt_max_pkt_size);
+	kfree(dev);
+	dev = NULL;
 }
 
 /*
@@ -1329,9 +1339,6 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 
 	flush_request_modules(dev);
 
-	/* delete v4l2 device */
-	v4l2_device_unregister(&dev->v4l2_dev);
-
 	/* wait until all current v4l2 io is finished then deallocate
 	   resources */
 	mutex_lock(&dev->lock);
@@ -1344,6 +1351,9 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 		     "deallocation are deferred on close.\n",
 		     video_device_node_name(dev->vdev));
 
+		/* Even having users, it is safe to remove the RC i2c driver */
+		cx231xx_ir_exit(dev);
+
 		dev->state |= DEV_MISCONFIGURED;
 		if (dev->USE_ISO)
 			cx231xx_uninit_isoc(dev);
@@ -1354,21 +1364,14 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 		wake_up_interruptible(&dev->wait_stream);
 	} else {
 		dev->state |= DEV_DISCONNECTED;
-		cx231xx_release_resources(dev);
 	}
 
 	cx231xx_close_extension(dev);
 
 	mutex_unlock(&dev->lock);
 
-	if (!dev->users) {
-		kfree(dev->video_mode.alt_max_pkt_size);
-		kfree(dev->vbi_mode.alt_max_pkt_size);
-		kfree(dev->sliced_cc_mode.alt_max_pkt_size);
-		kfree(dev->ts1_mode.alt_max_pkt_size);
-		kfree(dev);
-		dev = NULL;
-	}
+	if (!dev->users)
+		cx231xx_release_resources(dev);
 }
 
 static struct usb_driver cx231xx_usb_driver = {
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index d4457f9..39e9878 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -166,6 +166,9 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 	u8 _i2c_nostop = 0;
 	u8 _i2c_reserve = 0;
 
+	if (dev->state & DEV_DISCONNECTED)
+		return -ENODEV;
+
 	/* Get the I2C period, nostop and reserve parameters */
 	_i2c_period = i2c_bus->i2c_period;
 	_i2c_nostop = i2c_bus->i2c_nostop;
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 8a75a90..96176e9 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -106,11 +106,14 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	ir_i2c_bus = cx231xx_boards[dev->model].ir_i2c_master;
 	dev_dbg(&dev->udev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
 		ir_i2c_bus, info.addr);
-	i2c_new_device(&dev->i2c_bus[ir_i2c_bus].i2c_adap, &info);
+	dev->ir_i2c_client = i2c_new_device(&dev->i2c_bus[ir_i2c_bus].i2c_adap, &info);
 
 	return 0;
 }
 
 void cx231xx_ir_exit(struct cx231xx *dev)
 {
+	if (dev->ir_i2c_client)
+		i2c_unregister_device(dev->ir_i2c_client);
+	dev->ir_i2c_client = NULL;
 }
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 2000bc6..5d498a4 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -621,6 +621,7 @@ struct cx231xx {
 
 	/* For I2C IR support */
 	struct IR_i2c_init_data    init_data;
+	struct i2c_client          *ir_i2c_client;
 
 	unsigned int stream_on:1;	/* Locks streams */
 	unsigned int vbi_stream_on:1;	/* Locks streams for VBI */
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 37d0c20..a7c41d3 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -498,11 +498,3 @@ static void __exit ir_fini(void)
 
 module_init(ir_init);
 module_exit(ir_fini);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.7.7.5

