Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab2FNNm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:42:56 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/4] radio-si470x: Always use interrupt to wait for tune/seek completion
Date: Thu, 14 Jun 2012 15:43:12 +0200
Message-Id: <1339681394-11348-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since USB receives STATUS_RSSI updates through the interrupt endpoint,
there is no need to poll with USB, so get rid of the polling.

Note this also changes the order in which the probing of USB devices is done,
to avoid si470x_set_chan getting called before the interrupt endpoint is being
monitored.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   56 +++++-----------------
 drivers/media/radio/si470x/radio-si470x-i2c.c    |    5 +-
 drivers/media/radio/si470x/radio-si470x-usb.c    |   25 ++++++----
 drivers/media/radio/si470x/radio-si470x.h        |    1 -
 4 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 5dbb897..9f8b675 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -164,7 +164,6 @@ MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
 static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 {
 	int retval;
-	unsigned long timeout;
 	bool timed_out = 0;
 
 	/* start tuning */
@@ -174,26 +173,12 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 	if (retval < 0)
 		goto done;
 
-	/* currently I2C driver only uses interrupt way to tune */
-	if (radio->stci_enabled) {
-		INIT_COMPLETION(radio->completion);
-
-		/* wait till tune operation has completed */
-		retval = wait_for_completion_timeout(&radio->completion,
-				msecs_to_jiffies(tune_timeout));
-		if (!retval)
-			timed_out = true;
-	} else {
-		/* wait till tune operation has completed */
-		timeout = jiffies + msecs_to_jiffies(tune_timeout);
-		do {
-			retval = si470x_get_register(radio, STATUSRSSI);
-			if (retval < 0)
-				goto stop;
-			timed_out = time_after(jiffies, timeout);
-		} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-				&& (!timed_out));
-	}
+	/* wait till tune operation has completed */
+	INIT_COMPLETION(radio->completion);
+	retval = wait_for_completion_timeout(&radio->completion,
+			msecs_to_jiffies(tune_timeout));
+	if (!retval)
+		timed_out = true;
 
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
 		dev_warn(&radio->videodev.dev, "tune does not complete\n");
@@ -201,7 +186,6 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 		dev_warn(&radio->videodev.dev,
 			"tune timed out after %u ms\n", tune_timeout);
 
-stop:
 	/* stop tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
 	retval = si470x_set_register(radio, CHANNEL);
@@ -312,7 +296,6 @@ static int si470x_set_seek(struct si470x_device *radio,
 		unsigned int wrap_around, unsigned int seek_upward)
 {
 	int retval = 0;
-	unsigned long timeout;
 	bool timed_out = 0;
 
 	/* start seeking */
@@ -329,26 +312,12 @@ static int si470x_set_seek(struct si470x_device *radio,
 	if (retval < 0)
 		return retval;
 
-	/* currently I2C driver only uses interrupt way to seek */
-	if (radio->stci_enabled) {
-		INIT_COMPLETION(radio->completion);
-
-		/* wait till seek operation has completed */
-		retval = wait_for_completion_timeout(&radio->completion,
-				msecs_to_jiffies(seek_timeout));
-		if (!retval)
-			timed_out = true;
-	} else {
-		/* wait till seek operation has completed */
-		timeout = jiffies + msecs_to_jiffies(seek_timeout);
-		do {
-			retval = si470x_get_register(radio, STATUSRSSI);
-			if (retval < 0)
-				goto stop;
-			timed_out = time_after(jiffies, timeout);
-		} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-				&& (!timed_out));
-	}
+	/* wait till tune operation has completed */
+	INIT_COMPLETION(radio->completion);
+	retval = wait_for_completion_timeout(&radio->completion,
+			msecs_to_jiffies(seek_timeout));
+	if (!retval)
+		timed_out = true;
 
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
 		dev_warn(&radio->videodev.dev, "seek does not complete\n");
@@ -356,7 +325,6 @@ static int si470x_set_seek(struct si470x_device *radio,
 		dev_warn(&radio->videodev.dev,
 			"seek failed / band limit reached\n");
 
-stop:
 	/* stop seeking */
 	radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
 	retval = si470x_set_register(radio, POWERCFG);
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index a80044c..fb401a2 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -351,6 +351,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 
 	radio->client = client;
 	mutex_init(&radio->lock);
+	init_completion(&radio->completion);
 
 	/* video device initialization */
 	radio->videodev = si470x_viddev_template;
@@ -406,10 +407,6 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);
 
-	/* mark Seek/Tune Complete Interrupt enabled */
-	radio->stci_enabled = true;
-	init_completion(&radio->completion);
-
 	retval = request_threaded_irq(client->irq, NULL, si470x_i2c_interrupt,
 			IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);
 	if (retval) {
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 0da5c98..66b1ba8 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -406,6 +406,9 @@ static void si470x_int_in_callback(struct urb *urb)
 	radio->registers[STATUSRSSI] =
 		get_unaligned_be16(&radio->int_in_buffer[1]);
 
+	if (radio->registers[STATUSRSSI] & STATUSRSSI_STC)
+		complete(&radio->completion);
+
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS)) {
 		/* Update RDS registers with URB data */
 		for (regnr = 1; regnr < RDS_REGISTER_NUM; regnr++)
@@ -539,13 +542,6 @@ static int si470x_start_usb(struct si470x_device *radio)
 {
 	int retval;
 
-	/* start radio */
-	retval = si470x_start(radio);
-	if (retval < 0)
-		return retval;
-
-	v4l2_ctrl_handler_setup(&radio->hdl);
-
 	/* initialize interrupt urb */
 	usb_fill_int_urb(radio->int_in_urb, radio->usbdev,
 			usb_rcvintpipe(radio->usbdev,
@@ -566,6 +562,14 @@ static int si470x_start_usb(struct si470x_device *radio)
 		radio->int_in_running = 0;
 	}
 	radio->status_rssi_auto_update = radio->int_in_running;
+
+	/* start radio */
+	retval = si470x_start(radio);
+	if (retval < 0)
+		return retval;
+
+	v4l2_ctrl_handler_setup(&radio->hdl);
+
 	return retval;
 }
 
@@ -594,6 +598,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
 	mutex_init(&radio->lock);
+	init_completion(&radio->completion);
 
 	iface_desc = intf->cur_altsetting;
 
@@ -704,9 +709,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			"linux-media@vger.kernel.org\n");
 	}
 
-	/* set initial frequency */
-	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
-
 	/* set led to connect state */
 	si470x_set_led_state(radio, BLINK_GREEN_LED);
 
@@ -729,6 +731,9 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	if (retval < 0)
 		goto err_all;
 
+	/* set initial frequency */
+	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
+
 	/* register video device */
 	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
 			radio_nr);
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 2a0a46f..fbf713d 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -160,7 +160,6 @@ struct si470x_device {
 	unsigned int wr_index;
 
 	struct completion completion;
-	bool stci_enabled;		/* Seek/Tune Complete Interrupt */
 	bool status_rssi_auto_update;	/* Does RSSI get updated automatic? */
 
 #if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
-- 
1.7.10.2

