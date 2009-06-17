Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48887 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbZFQR2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:12 -0400
Received: by bwz9 with SMTP id 9so518649bwz.37
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 10:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <208cbae30906161448q16a7e00bx31e6d3b3c35111e5@mail.gmail.com>
References: <268161120906160611q32ac27a8r1574d4a9ffa63829@mail.gmail.com>
	 <208cbae30906160947k5ec2f652i3b099c4270e7717d@mail.gmail.com>
	 <268161120906161305u24330118g2f9e35e65eecd04@mail.gmail.com>
	 <208cbae30906161448q16a7e00bx31e6d3b3c35111e5@mail.gmail.com>
Date: Wed, 17 Jun 2009 19:22:21 +0200
Message-ID: <268161120906171022j14645f78yf5e075679c30b57c@mail.gmail.com>
Subject: Re: [PATCH / resubmit] USB interrupt support for radio-si470x FM
	radio driver
From: Edouard Lafargue <edouard@lafargue.name>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org, Tobias Lorenz <tobias.lorenz@gmx.net>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

   Following up on your comments, here is the patch against the
current mercurial tree, still works fine, and indeed, the stereo/mono
and strength indicators work better on this newer version. RDS
reception remains better with my patch :-) Now I just need to bundle
this with icecast to get mp3 streaming with embedded RDS info, but
that's outside of the scope of this list.

   Thanks for all your help, now on to Tobias, I guess!

Best regards,

Signed-off-by: Edouard Lafargue <edouard@lafargue.name>

diff -r b385a43af222 linux/drivers/media/radio/radio-si470x.c
--- a/linux/drivers/media/radio/radio-si470x.c	Tue Jun 16 23:55:44 2009 -0300
+++ b/linux/drivers/media/radio/radio-si470x.c	Wed Jun 17 19:04:25 2009 +0200
@@ -106,20 +106,24 @@
  *		Tobias Lorenz <tobias.lorenz@gmx.net>
  *		- add LED status output
  *		- get HW/SW version from scratchpad
+ * 2009-06-16   Edouard Lafargue <edouard@lafargue.name>
+ *		Version 1.0.10
+ *		- add support for interrupt mode for RDS endpoint,
+ *                instead of polling.
+ *                Improves RDS reception significantly
  *
  * ToDo:
  * - add firmware download/update support
- * - RDS support: interrupt mode, instead of polling
  */


 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 9)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 10)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.9"
+#define DRIVER_VERSION "1.0.10"


 /* kernel includes */
@@ -218,16 +222,6 @@
 module_param(max_rds_errors, ushort, 0644);
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");

-/* RDS poll frequency */
-static unsigned int rds_poll_time = 40;
-/* 40 is used by the original USBRadio.exe */
-/* 50 is used by radio-cadet */
-/* 75 should be okay */
-/* 80 is the usual RDS receive interval */
-module_param(rds_poll_time, uint, 0644);
-MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*");
-
-

 /**************************************************************************
  * Register Definitions
@@ -450,6 +444,12 @@
 	struct usb_interface *intf;
 	struct video_device *videodev;

+	/* Interrupt endpoint handling */
+	char *int_in_buffer;
+	struct usb_endpoint_descriptor *int_in_endpoint;
+	struct urb *int_in_urb;
+	int int_in_running;
+
 	/* driver management */
 	unsigned int users;
 	unsigned char disconnected;
@@ -459,7 +459,6 @@
 	unsigned short registers[RADIO_REGISTER_NUM];

 	/* RDS receive buffer */
-	struct delayed_work work;
 	wait_queue_head_t read_queue;
 	struct mutex lock;		/* buffer locking */
 	unsigned char *buffer;		/* size is always multiple of three */
@@ -865,43 +864,6 @@


 /**************************************************************************
- * General Driver Functions - RDS_REPORT
- **************************************************************************/
-
-/*
- * si470x_get_rds_registers - read rds registers
- */
-static int si470x_get_rds_registers(struct si470x_device *radio)
-{
-	unsigned char buf[RDS_REPORT_SIZE];
-	int retval;
-	int size;
-	unsigned char regnr;
-
-	buf[0] = RDS_REPORT;
-
-	retval = usb_interrupt_msg(radio->usbdev,
-		usb_rcvintpipe(radio->usbdev, 1),
-		(void *) &buf, sizeof(buf), &size, usb_timeout);
-	if (size != sizeof(buf))
-		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
-			"return size differs: %d != %zu\n", size, sizeof(buf));
-	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
-			"usb_interrupt_msg returned %d\n", retval);
-
-	if (retval >= 0)
-		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
-			radio->registers[STATUSRSSI + regnr] =
-				get_unaligned_be16(
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
-
-	return (retval < 0) ? -EINVAL : 0;
-}
-
-
-
-/**************************************************************************
  * General Driver Functions - LED_REPORT
  **************************************************************************/

@@ -959,102 +921,118 @@
  **************************************************************************/

 /*
- * si470x_rds - rds processing function
+ * si470x_int_in_callback - rds callback and processing function
+ *
+ * TODO: do we need to use mutex locks in some sections?
  */
-static void si470x_rds(struct si470x_device *radio)
+static void si470x_int_in_callback(struct urb *urb)
 {
+	struct si470x_device *radio = urb->context;
+	unsigned char buf[RDS_REPORT_SIZE];
+	int retval;
+	unsigned char regnr;
 	unsigned char blocknum;
 	unsigned short bler; /* rds block errors */
 	unsigned short rds;
 	unsigned char tmpbuf[3];

-	/* get rds blocks */
-	if (si470x_get_rds_registers(radio) < 0)
-		return;
-	if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSR) == 0) {
-		/* No RDS group ready */
-		return;
-	}
-	if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSS) == 0) {
-		/* RDS decoder not synchronized */
-		return;
-	}
-
-	/* copy all four RDS blocks to internal buffer */
-	mutex_lock(&radio->lock);
-	for (blocknum = 0; blocknum < 4; blocknum++) {
-		switch (blocknum) {
-		default:
-			bler = (radio->registers[STATUSRSSI] &
-					STATUSRSSI_BLERA) >> 9;
-			rds = radio->registers[RDSA];
-			break;
-		case 1:
-			bler = (radio->registers[READCHAN] &
-					READCHAN_BLERB) >> 14;
-			rds = radio->registers[RDSB];
-			break;
-		case 2:
-			bler = (radio->registers[READCHAN] &
-					READCHAN_BLERC) >> 12;
-			rds = radio->registers[RDSC];
-			break;
-		case 3:
-			bler = (radio->registers[READCHAN] &
-					READCHAN_BLERD) >> 10;
-			rds = radio->registers[RDSD];
-			break;
-		};
-
-		/* Fill the V4L2 RDS buffer */
-		put_unaligned_le16(rds, &tmpbuf);
-		tmpbuf[2] = blocknum;		/* offset name */
-		tmpbuf[2] |= blocknum << 3;	/* received offset */
-		if (bler > max_rds_errors)
-			tmpbuf[2] |= 0x80; /* uncorrectable errors */
-		else if (bler > 0)
-			tmpbuf[2] |= 0x40; /* corrected error(s) */
-
-		/* copy RDS block to internal buffer */
-		memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
-		radio->wr_index += 3;
-
-		/* wrap write pointer */
-		if (radio->wr_index >= radio->buf_size)
-			radio->wr_index = 0;
-
-		/* check for overflow */
-		if (radio->wr_index == radio->rd_index) {
-			/* increment and wrap read pointer */
-			radio->rd_index += 3;
-			if (radio->rd_index >= radio->buf_size)
-				radio->rd_index = 0;
+	if (urb->status) {
+		if (urb->status == -ENOENT ||
+				urb->status == -ECONNRESET ||
+				urb->status == -ESHUTDOWN) {
+			return;
+		} else {
+			printk(KERN_WARNING DRIVER_NAME
+			 ": non-zero urb status (%d)\n", urb->status);
+			goto resubmit; /* Maybe we can recover. */
 		}
 	}
-	mutex_unlock(&radio->lock);
-
-	/* wake up read queue */
-	if (radio->wr_index != radio->rd_index)
-		wake_up_interruptible(&radio->read_queue);
-}
-
-
-/*
- * si470x_work - rds work function
- */
-static void si470x_work(struct work_struct *work)
-{
-	struct si470x_device *radio = container_of(work, struct si470x_device,
-		work.work);

 	/* safety checks */
 	if (radio->disconnected)
 		return;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
-		return;
+		goto resubmit;

-	si470x_rds(radio);
-	schedule_delayed_work(&radio->work, msecs_to_jiffies(rds_poll_time));
+	if (urb->actual_length > 0) {
+		/* Update RDS registers with URB data */
+		buf[0] = RDS_REPORT;
+		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
+			radio->registers[STATUSRSSI + regnr] =
+			    get_unaligned_be16(&radio->int_in_buffer[
+				regnr * RADIO_REGISTER_SIZE + 1]);
+		/* get rds blocks */
+		if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSR) == 0) {
+			/* No RDS group ready, better luck next time */
+			goto resubmit;
+		}
+		if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSS) == 0) {
+			/* RDS decoder not synchronized */
+			goto resubmit;
+		}
+		for (blocknum = 0; blocknum < 4; blocknum++) {
+			switch (blocknum) {
+			default:
+				bler = (radio->registers[STATUSRSSI] &
+						STATUSRSSI_BLERA) >> 9;
+				rds = radio->registers[RDSA];
+				break;
+			case 1:
+				bler = (radio->registers[READCHAN] &
+						READCHAN_BLERB) >> 14;
+				rds = radio->registers[RDSB];
+				break;
+			case 2:
+				bler = (radio->registers[READCHAN] &
+						READCHAN_BLERC) >> 12;
+				rds = radio->registers[RDSC];
+				break;
+			case 3:
+				bler = (radio->registers[READCHAN] &
+						READCHAN_BLERD) >> 10;
+				rds = radio->registers[RDSD];
+				break;
+			};
+
+			/* Fill the V4L2 RDS buffer */
+			put_unaligned_le16(rds, &tmpbuf);
+			tmpbuf[2] = blocknum;		/* offset name */
+			tmpbuf[2] |= blocknum << 3;	/* received offset */
+			if (bler > max_rds_errors)
+				tmpbuf[2] |= 0x80; /* uncorrectable errors */
+			else if (bler > 0)
+				tmpbuf[2] |= 0x40; /* corrected error(s) */
+
+			/* copy RDS block to internal buffer */
+			memcpy(&radio->buffer[radio->wr_index], &tmpbuf, 3);
+			radio->wr_index += 3;
+
+			/* wrap write pointer */
+			if (radio->wr_index >= radio->buf_size)
+				radio->wr_index = 0;
+
+			/* check for overflow */
+			if (radio->wr_index == radio->rd_index) {
+				/* increment and wrap read pointer */
+				radio->rd_index += 3;
+				if (radio->rd_index >= radio->buf_size)
+					radio->rd_index = 0;
+			}
+		}
+		if (radio->wr_index != radio->rd_index)
+			wake_up_interruptible(&radio->read_queue);
+	}
+
+resubmit:
+	/* Resubmit if we're still running. */
+	if (radio->int_in_running && radio->usbdev) {
+		retval = usb_submit_urb(radio->int_in_urb, GFP_ATOMIC);
+		if (retval) {
+			printk(KERN_WARNING DRIVER_NAME
+			       ": resubmitting urb failed (%d)", retval);
+			radio->int_in_running = 0;
+		}
+	}
 }


@@ -1076,8 +1054,6 @@
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_delayed_work(&radio->work,
-			msecs_to_jiffies(rds_poll_time));
 	}

 	/* block if no new data available */
@@ -1136,8 +1112,6 @@
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_delayed_work(&radio->work,
-			msecs_to_jiffies(rds_poll_time));
 	}

 	poll_wait(file, &radio->read_queue, pts);
@@ -1167,11 +1141,37 @@
 		goto done;
 	}

+	printk(KERN_INFO DRIVER_NAME
+		 ": Opened radio (users now: %i)\n", radio->users);
+
 	if (radio->users == 1) {
 		/* start radio */
 		retval = si470x_start(radio);
-		if (retval < 0)
+		if (retval < 0) {
 			usb_autopm_put_interface(radio->intf);
+			goto done;
+		}
+		/* Initialize interrupt URB. */
+		usb_fill_int_urb(radio->int_in_urb, radio->usbdev,
+			usb_rcvintpipe(radio->usbdev,
+			radio->int_in_endpoint->bEndpointAddress),
+			radio->int_in_buffer,
+			le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize),
+			si470x_int_in_callback,
+			radio,
+			radio->int_in_endpoint->bInterval);
+
+		radio->int_in_running = 1;
+		mb();
+
+		retval = usb_submit_urb(radio->int_in_urb, GFP_KERNEL);
+		if (retval) {
+			printk(KERN_INFO DRIVER_NAME
+				 ": submitting int urb failed (%d)\n", retval);
+			radio->int_in_running = 0;
+			usb_autopm_put_interface(radio->intf);
+		}
+
 	}

 done:
@@ -1196,17 +1196,25 @@

 	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
+	printk(KERN_INFO DRIVER_NAME
+		 ": Closed radio (remaining users:%i)\n", radio->users);
 	if (radio->users == 0) {
+
+		/* Shutdown Interrupt handler */
+		if (radio->int_in_running) {
+			radio->int_in_running = 0;
+		if (radio->int_in_urb)
+			usb_kill_urb(radio->int_in_urb);
+		}
+
 		if (radio->disconnected) {
 			video_unregister_device(radio->videodev);
+			kfree(radio->int_in_buffer);
 			kfree(radio->buffer);
 			kfree(radio);
 			goto done;
 		}

-		/* stop rds reception */
-		cancel_delayed_work_sync(&radio->work);
-
 		/* cancel read processes */
 		wake_up_interruptible(&radio->read_queue);

@@ -1658,7 +1666,9 @@
 		const struct usb_device_id *id)
 {
 	struct si470x_device *radio;
-	int retval = 0;
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	int i, int_end_size, retval = 0;

 	/* private data allocation and initialization */
 	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
@@ -1673,11 +1683,45 @@
 	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);

+	iface_desc = intf->cur_altsetting;
+
+	/* Set up interrupt endpoint information. */
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+		if (((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
+		 USB_DIR_IN) && ((endpoint->bmAttributes &
+		 USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT))
+			radio->int_in_endpoint = endpoint;
+	}
+	if (!radio->int_in_endpoint) {
+		printk(KERN_INFO DRIVER_NAME
+			": could not find interrupt in endpoint\n");
+		retval = -EIO;
+		goto err_radio;
+	}
+
+	int_end_size = le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize);
+
+	radio->int_in_buffer = kmalloc(int_end_size, GFP_KERNEL);
+	if (!radio->int_in_buffer) {
+		printk(KERN_INFO DRIVER_NAME
+			"could not allocate int_in_buffer");
+		retval = -ENOMEM;
+		goto err_radio;
+	}
+
+	radio->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!radio->int_in_urb) {
+		printk(KERN_INFO DRIVER_NAME "could not allocate int_in_urb");
+		retval = -ENOMEM;
+		goto err_intbuffer;
+	}
+
 	/* video device allocation and initialization */
 	radio->videodev = video_device_alloc();
 	if (!radio->videodev) {
 		retval = -ENOMEM;
-		goto err_radio;
+		goto err_intbuffer;
 	}
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
@@ -1735,9 +1779,6 @@
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);

-	/* prepare rds work function */
-	INIT_DELAYED_WORK(&radio->work, si470x_work);
-
 	/* register video device */
 	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
 	if (retval) {
@@ -1752,6 +1793,8 @@
 	kfree(radio->buffer);
 err_video:
 	video_device_release(radio->videodev);
+err_intbuffer:
+	kfree(radio->int_in_buffer);
 err_radio:
 	kfree(radio);
 err_initial:
@@ -1765,12 +1808,8 @@
 static int si470x_usb_driver_suspend(struct usb_interface *intf,
 		pm_message_t message)
 {
-	struct si470x_device *radio = usb_get_intfdata(intf);
-
 	printk(KERN_INFO DRIVER_NAME ": suspending now...\n");

-	cancel_delayed_work_sync(&radio->work);
-
 	return 0;
 }

@@ -1780,16 +1819,8 @@
  */
 static int si470x_usb_driver_resume(struct usb_interface *intf)
 {
-	struct si470x_device *radio = usb_get_intfdata(intf);
-
 	printk(KERN_INFO DRIVER_NAME ": resuming now...\n");

-	mutex_lock(&radio->lock);
-	if (radio->users && radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS)
-		schedule_delayed_work(&radio->work,
-			msecs_to_jiffies(rds_poll_time));
-	mutex_unlock(&radio->lock);
-
 	return 0;
 }

@@ -1803,12 +1834,15 @@

 	mutex_lock(&radio->disconnect_lock);
 	radio->disconnected = 1;
-	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
 	if (radio->users == 0) {
 		/* set led to disconnect state */
 		si470x_set_led_state(radio, BLINK_ORANGE_LED);

+		/* Free data structures. */
+		usb_free_urb(radio->int_in_urb);
+
+		kfree(radio->int_in_buffer);
 		video_unregister_device(radio->videodev);
 		kfree(radio->buffer);
 		kfree(radio);
