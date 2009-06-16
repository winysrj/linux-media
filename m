Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:51433 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbZFPNLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 09:11:07 -0400
Received: by fxm7 with SMTP id 7so623868fxm.37
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 06:11:07 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 15:11:07 +0200
Message-ID: <268161120906160611q32ac27a8r1574d4a9ffa63829@mail.gmail.com>
Subject: [PATCH] USB interrupt support for radio-si470x FM radio driver
From: Edouard Lafargue <edouard@lafargue.name>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please find below my attempt at removing 'manual' polling from the
radio-si470x USB FM radio driver, by moving to URB interrupt callback
handlers.

This code significantly improves RDS reception - radiotext in
particular - and improves audio quality on my Silabs FM USB dongle, as
lots of pops and clicks have now disappeared. Your mileage may vary.
Issues remain when userspace programs do V4L ioctl calls to the
dongle: this creates clicks in the audio.

I am by no means a professional driver writer and the code below is
most probably in need of a proper review by someone more experienced
than me in writing Linux USB drivers. It does not raise issues on the
machines where I have tested it, but this is hardly proof it's good.
Any help will be much appreciated. It is only tested on the dongle I
own, a Silabs "Reference Design" FM receiver dongle.

Last: there are a few bits left commented out in my patched version,
those are kept to help code review if someone wants to help, they
should probably be removed from a final release.

Thanks for your feedback!

Signed-off-by: Edouard Lafargue <edouard@lafargue.name>

diff -Nur ../radio-si470x.c radio-si470x.c
--- ../radio-si470x.c	2008-12-25 00:26:37.000000000 +0100
+++ radio-si470x.c	2009-06-16 14:20:07.000000000 +0200
@@ -97,9 +97,14 @@
  * 		- add support for KWorld USB FM Radio FM700
  * 		- blacklisted KWorld radio in hid-core.c and hid-ids.h
  *
+ * 2009-06-16   Edouard Lafargue <edouard@lafargue.name>
+ *		Version 1.0.9
+ *		- add support for interrupt mode for RDS endpoint, instead of polling.
+ *
  * ToDo:
  * - add firmware download/update support
- * - RDS support: interrupt mode, instead of polling
+ * - RDS support: debug interrupt mode and use of URBs further!
+ * - Use URBs for all USB communications
  * - add LED status output (check if that's not already done in firmware)
  */

@@ -107,10 +112,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 8)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 9)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.8"
+#define DRIVER_VERSION "1.0.9"


 /* kernel includes */
@@ -207,13 +212,14 @@
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");

 /* RDS poll frequency */
-static unsigned int rds_poll_time = 40;
+/* TODO: remove this since not used anymore as we now use the interrupt URB */
+/* static unsigned int rds_poll_time = 40; */
 /* 40 is used by the original USBRadio.exe */
 /* 50 is used by radio-cadet */
 /* 75 should be okay */
 /* 80 is the usual RDS receive interval */
-module_param(rds_poll_time, uint, 0644);
-MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*");
+/* module_param(rds_poll_time, uint, 0644); */
+/* MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*"); */



@@ -440,6 +446,12 @@
 	struct usb_interface *intf;
 	struct video_device *videodev;

+	/* Interrupt endpoint handling */
+	char 				*int_in_buffer;
+	struct usb_endpoint_descriptor *int_in_endpoint;
+	struct urb 			*int_in_urb;
+	int				int_in_running;
+	
 	/* driver management */
 	unsigned int users;
 	unsigned char disconnected;
@@ -578,37 +590,6 @@
 }


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

 /*
  * si470x_set_chan - set the channel
@@ -882,105 +863,118 @@
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
+			printk(KERN_WARNING DRIVER_NAME ": non-zero urb status (%d)\n",
urb->status);
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
-		return;
+		goto resubmit;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
-		return;
+		goto resubmit;

-	si470x_rds(radio);
-	schedule_delayed_work(&radio->work, msecs_to_jiffies(rds_poll_time));
-}
+	if (urb->actual_length > 0) {
+		/* Update RDS registers with URB data */
+		buf[0] = RDS_REPORT;
+		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
+			radio->registers[STATUSRSSI + regnr] =
+				get_unaligned_be16(
+				&radio->int_in_buffer[regnr * RADIO_REGISTER_SIZE + 1]);
+		/* get rds blocks */
+		if ((radio->registers[STATUSRSSI] & STATUSRSSI_RDSR) == 0) {
+			/* No RDS group ready */
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

+resubmit:
+	/* Resubmit if we're still running. */
+	if (radio->int_in_running && radio->usbdev) {
+		retval = usb_submit_urb(radio->int_in_urb, GFP_ATOMIC);
+		if (retval) {
+			printk(KERN_WARNING DRIVER_NAME ": resubmitting urb failed (%d)", retval);
+			radio->int_in_running = 0;
+		}
+	}

+}

 /**************************************************************************
  * File Operations Interface
@@ -999,8 +993,6 @@
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_delayed_work(&radio->work,
-			msecs_to_jiffies(rds_poll_time));
 	}

 	/* block if no new data available */
@@ -1059,8 +1051,6 @@
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
 		si470x_rds_on(radio);
-		schedule_delayed_work(&radio->work,
-			msecs_to_jiffies(rds_poll_time));
 	}

 	poll_wait(file, &radio->read_queue, pts);
@@ -1090,10 +1080,34 @@
 		goto done;
 	}

+	printk(KERN_INFO DRIVER_NAME ": Opened radio (users now: %i)\n",radio->users);
+
 	if (radio->users == 1) {
 		retval = si470x_start(radio);
-		if (retval < 0)
+		if (retval < 0) {			
+			usb_autopm_put_interface(radio->intf);
+			goto done;
+		}
+
+		/* Initialize interrupt URB. */
+		usb_fill_int_urb(radio->int_in_urb, radio->usbdev,
+				usb_rcvintpipe(radio->usbdev, radio->int_in_endpoint->bEndpointAddress),
+				radio->int_in_buffer,
+				le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize),
+				si470x_int_in_callback,
+				radio,
+				radio->int_in_endpoint->bInterval);
+	
+		radio->int_in_running = 1;
+		mb();
+	
+		retval = usb_submit_urb(radio->int_in_urb, GFP_KERNEL);
+		if (retval) {
+			printk(KERN_INFO DRIVER_NAME ": submitting int urb failed (%d)\n", retval);
+			radio->int_in_running = 0;
 			usb_autopm_put_interface(radio->intf);
+			goto done;
+		}
 	}

 done:
@@ -1118,6 +1132,7 @@

 	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
+	printk(KERN_INFO DRIVER_NAME ": Closed radio (remaining
users:%i)\n",radio->users);
 	if (radio->users == 0) {
 		if (radio->disconnected) {
 			video_unregister_device(radio->videodev);
@@ -1126,8 +1141,12 @@
 			goto unlock;
 		}

-		/* stop rds reception */
-		cancel_delayed_work_sync(&radio->work);
+		/* Shutdown Interrupt handler */
+		if (radio->int_in_running) {
+			radio->int_in_running = 0;
+		if (radio->int_in_urb)
+			usb_kill_urb(radio->int_in_urb);
+		}

 		/* cancel read processes */
 		wake_up_interruptible(&radio->read_queue);
@@ -1580,7 +1599,9 @@
 		const struct usb_device_id *id)
 {
 	struct si470x_device *radio;
-	int retval = 0;
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	int i,int_end_size,retval = 0;

 	/* private data allocation and initialization */
 	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
@@ -1595,6 +1616,39 @@
 	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);

+	iface_desc = intf->cur_altsetting;
+
+	/* Set up interrupt endpoint information. */
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		if (((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
+				&& ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+					USB_ENDPOINT_XFER_INT))
+			radio->int_in_endpoint = endpoint;
+
+	}
+	if (! radio->int_in_endpoint) {
+		printk(KERN_INFO DRIVER_NAME ": could not find interrupt in endpoint\n");
+		goto err_radio;
+	}
+
+	int_end_size = le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize);
+
+	radio->int_in_buffer = kmalloc(int_end_size, GFP_KERNEL);
+	if (! radio->int_in_buffer) {
+		printk(KERN_INFO DRIVER_NAME "could not allocate int_in_buffer");
+		retval = -ENOMEM;
+		goto err_radio;
+	}
+
+	radio->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (! radio->int_in_urb) {
+		printk(KERN_INFO DRIVER_NAME "could not allocate int_in_urb");
+		retval = -ENOMEM;
+		goto err_radio;
+	}
+
 	/* video device allocation and initialization */
 	radio->videodev = video_device_alloc();
 	if (!radio->videodev) {
@@ -1645,9 +1699,6 @@
 	radio->rd_index = 0;
 	init_waitqueue_head(&radio->read_queue);

-	/* prepare rds work function */
-	INIT_DELAYED_WORK(&radio->work, si470x_work);
-
 	/* register video device */
 	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr);
 	if (retval) {
@@ -1674,12 +1725,10 @@
 static int si470x_usb_driver_suspend(struct usb_interface *intf,
 		pm_message_t message)
 {
-	struct si470x_device *radio = usb_get_intfdata(intf);
-
+/*	struct si470x_device *radio = usb_get_intfdata(intf);
+ */
 	printk(KERN_INFO DRIVER_NAME ": suspending now...\n");

-	cancel_delayed_work_sync(&radio->work);
-
 	return 0;
 }

@@ -1689,16 +1738,17 @@
  */
 static int si470x_usb_driver_resume(struct usb_interface *intf)
 {
-	struct si470x_device *radio = usb_get_intfdata(intf);
-
+/*	struct si470x_device *radio = usb_get_intfdata(intf);
+ */
 	printk(KERN_INFO DRIVER_NAME ": resuming now...\n");

-	mutex_lock(&radio->lock);
+/*	mutex_lock(&radio->lock);
 	if (radio->users && radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS)
 		schedule_delayed_work(&radio->work,
 			msecs_to_jiffies(rds_poll_time));
-	mutex_unlock(&radio->lock);

+	mutex_unlock(&radio->lock);
+*/
 	return 0;
 }

@@ -1712,13 +1762,19 @@

 	mutex_lock(&radio->disconnect_lock);
 	radio->disconnected = 1;
-	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
-	if (radio->users == 0) {
-		video_unregister_device(radio->videodev);
-		kfree(radio->buffer);
-		kfree(radio);
-	}
+/*	if (radio->users == 0) { */
+
+	/* Free data structures. */
+	if (radio->int_in_urb)
+		usb_free_urb(radio->int_in_urb);
+
+	kfree(radio->int_in_buffer);
+	video_unregister_device(radio->videodev);
+	kfree(radio->buffer);
+	kfree(radio);
+/*	} */
+
 	mutex_unlock(&radio->disconnect_lock);
 }
