Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:60645 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZGNFLp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 01:11:45 -0400
Received: from epmmp1 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMR00K34AFK5F@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:44 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMR0007KAFKUF@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jul 2009 14:11:44 +0900 (KST)
Date: Tue, 14 Jul 2009 14:11:44 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 2/4] radio-si470x: change to dev_* macro from printk
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com, klimov.linux@gmail.com
Message-id: <4A5C1390.8090409@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is for using dev_* macro instead of printk.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 .../media/radio/si470x/radio-si470x-common.c       |   50 +++++++++---------
 .../drivers/media/radio/si470x/radio-si470x-usb.c  |   58 +++++++++-----------
 2 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/linux/drivers/media/radio/si470x/radio-si470x-common.c b/linux/drivers/media/radio/si470x/radio-si470x-common.c
index d2dc1ff..2be22bd 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c
@@ -184,10 +184,10 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
 		(!timed_out));
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-		printk(KERN_WARNING DRIVER_NAME ": tune does not complete\n");
+		dev_warn(&radio->videodev->dev, "tune does not complete\n");
 	if (timed_out)
-		printk(KERN_WARNING DRIVER_NAME
-			": tune timed out after %u ms\n", tune_timeout);
+		dev_warn(&radio->videodev->dev,
+			"tune timed out after %u ms\n", tune_timeout);
 
 stop:
 	/* stop tuning */
@@ -320,13 +320,13 @@ static int si470x_set_seek(struct si470x_device *radio,
 	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
 		(!timed_out));
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-		printk(KERN_WARNING DRIVER_NAME ": seek does not complete\n");
+		dev_warn(&radio->videodev->dev, "seek does not complete\n");
 	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
-		printk(KERN_WARNING DRIVER_NAME
-			": seek failed / band limit reached\n");
+		dev_warn(&radio->videodev->dev,
+			"seek failed / band limit reached\n");
 	if (timed_out)
-		printk(KERN_WARNING DRIVER_NAME
-			": seek timed out after %u ms\n", seek_timeout);
+		dev_warn(&radio->videodev->dev,
+			"seek timed out after %u ms\n", seek_timeout);
 
 stop:
 	/* stop seeking */
@@ -435,6 +435,7 @@ int si470x_rds_on(struct si470x_device *radio)
 static int si470x_vidioc_queryctrl(struct file *file, void *priv,
 		struct v4l2_queryctrl *qc)
 {
+	struct si470x_device *radio = video_drvdata(file);
 	int retval = -EINVAL;
 
 	/* abort if qc->id is below V4L2_CID_BASE */
@@ -458,8 +459,8 @@ static int si470x_vidioc_queryctrl(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": query controls failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"query controls failed with %d\n", retval);
 	return retval;
 }
 
@@ -494,8 +495,8 @@ static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": get control failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"get control failed with %d\n", retval);
 	return retval;
 }
 
@@ -534,8 +535,8 @@ static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set control failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"set control failed with %d\n", retval);
 	return retval;
 }
 
@@ -632,8 +633,8 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": get tuner failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"get tuner failed with %d\n", retval);
 	return retval;
 }
 
@@ -671,8 +672,8 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set tuner failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"set tuner failed with %d\n", retval);
 	return retval;
 }
 
@@ -701,8 +702,8 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": get frequency failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"get frequency failed with %d\n", retval);
 	return retval;
 }
 
@@ -730,8 +731,8 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set frequency failed with %d\n", retval);
+		dev_warn(&radio->videodev->dev,
+			"set frequency failed with %d\n", retval);
 	return retval;
 }
 
@@ -759,9 +760,8 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 
 done:
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": set hardware frequency seek failed with %d\n",
-			retval);
+		dev_warn(&radio->videodev->dev,
+			"set hardware frequency seek failed with %d\n", retval);
 	return retval;
 }
 
diff --git a/linux/drivers/media/radio/si470x/radio-si470x-usb.c b/linux/drivers/media/radio/si470x/radio-si470x-usb.c
index f3d805f..6508161 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -223,8 +223,8 @@ static int si470x_get_report(struct si470x_device *radio, void *buf, int size)
 		buf, size, usb_timeout);
 
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": si470x_get_report: usb_control_msg returned %d\n",
+		dev_warn(&radio->intf->dev,
+			"si470x_get_report: usb_control_msg returned %d\n",
 			retval);
 	return retval;
 }
@@ -246,8 +246,8 @@ static int si470x_set_report(struct si470x_device *radio, void *buf, int size)
 		buf, size, usb_timeout);
 
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME
-			": si470x_set_report: usb_control_msg returned %d\n",
+		dev_warn(&radio->intf->dev,
+			"si470x_set_report: usb_control_msg returned %d\n",
 			retval);
 	return retval;
 }
@@ -358,7 +358,7 @@ static int si470x_get_scratch_page_versions(struct si470x_device *radio)
 	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
 
 	if (retval < 0)
-		printk(KERN_WARNING DRIVER_NAME ": si470x_get_scratch: "
+		dev_warn(&radio->intf->dev, "si470x_get_scratch: "
 			"si470x_get_report returned %d\n", retval);
 	else {
 		radio->software_version = buf[1];
@@ -396,8 +396,8 @@ static void si470x_int_in_callback(struct urb *urb)
 				urb->status == -ESHUTDOWN) {
 			return;
 		} else {
-			printk(KERN_WARNING DRIVER_NAME
-			 ": non-zero urb status (%d)\n", urb->status);
+			dev_warn(&radio->intf->dev,
+			 "non-zero urb status (%d)\n", urb->status);
 			goto resubmit; /* Maybe we can recover. */
 		}
 	}
@@ -482,8 +482,8 @@ resubmit:
 	if (radio->int_in_running && radio->usbdev) {
 		retval = usb_submit_urb(radio->int_in_urb, GFP_ATOMIC);
 		if (retval) {
-			printk(KERN_WARNING DRIVER_NAME
-			       ": resubmitting urb failed (%d)", retval);
+			dev_warn(&radio->intf->dev,
+			       "resubmitting urb failed (%d)", retval);
 			radio->int_in_running = 0;
 		}
 	}
@@ -616,8 +616,8 @@ static int si470x_fops_open(struct file *file)
 
 		retval = usb_submit_urb(radio->int_in_urb, GFP_KERNEL);
 		if (retval) {
-			printk(KERN_INFO DRIVER_NAME
-				 ": submitting int urb failed (%d)\n", retval);
+			dev_info(&radio->intf->dev,
+				 "submitting int urb failed (%d)\n", retval);
 			radio->int_in_running = 0;
 			usb_autopm_put_interface(radio->intf);
 		}
@@ -753,8 +753,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			radio->int_in_endpoint = endpoint;
 	}
 	if (!radio->int_in_endpoint) {
-		printk(KERN_INFO DRIVER_NAME
-			": could not find interrupt in endpoint\n");
+		dev_info(&intf->dev, "could not find interrupt in endpoint\n");
 		retval = -EIO;
 		goto err_radio;
 	}
@@ -763,15 +762,14 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
 	radio->int_in_buffer = kmalloc(int_end_size, GFP_KERNEL);
 	if (!radio->int_in_buffer) {
-		printk(KERN_INFO DRIVER_NAME
-			"could not allocate int_in_buffer");
+		dev_info(&intf->dev, "could not allocate int_in_buffer");
 		retval = -ENOMEM;
 		goto err_radio;
 	}
 
 	radio->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!radio->int_in_urb) {
-		printk(KERN_INFO DRIVER_NAME "could not allocate int_in_urb");
+		dev_info(&intf->dev, "could not allocate int_in_urb");
 		retval = -ENOMEM;
 		goto err_intbuffer;
 	}
@@ -791,7 +789,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 		retval = -EIO;
 		goto err_video;
 	}
-	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
+	dev_info(&intf->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
 
 	/* get software and hardware versions */
@@ -799,23 +797,22 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 		retval = -EIO;
 		goto err_video;
 	}
-	printk(KERN_INFO DRIVER_NAME
-			": software version %d, hardware version %d\n",
+	dev_info(&intf->dev, "software version %d, hardware version %d\n",
 			radio->software_version, radio->hardware_version);
 
 	/* check if device and firmware is current */
 	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE)
 			< RADIO_SW_VERSION_CURRENT) {
-		printk(KERN_WARNING DRIVER_NAME
-			": This driver is known to work with "
+		dev_warn(&intf->dev,
+			"This driver is known to work with "
 			"firmware version %hu,\n", RADIO_SW_VERSION_CURRENT);
-		printk(KERN_WARNING DRIVER_NAME
-			": but the device has firmware version %hu.\n",
+		dev_warn(&intf->dev,
+			"but the device has firmware version %hu.\n",
 			radio->registers[CHIPID] & CHIPID_FIRMWARE);
-		printk(KERN_WARNING DRIVER_NAME
-			": If you have some trouble using this driver,\n");
-		printk(KERN_WARNING DRIVER_NAME
-			": please report to V4L ML at "
+		dev_warn(&intf->dev,
+			"If you have some trouble using this driver,\n");
+		dev_warn(&intf->dev,
+			"please report to V4L ML at "
 			"linux-media@vger.kernel.org\n");
 	}
 
@@ -842,8 +839,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
 			radio_nr);
 	if (retval) {
-		printk(KERN_WARNING DRIVER_NAME
-				": Could not register video device\n");
+		dev_warn(&intf->dev, "Could not register video device\n");
 		goto err_all;
 	}
 	usb_set_intfdata(intf, radio);
@@ -868,7 +864,7 @@ err_initial:
 static int si470x_usb_driver_suspend(struct usb_interface *intf,
 		pm_message_t message)
 {
-	printk(KERN_INFO DRIVER_NAME ": suspending now...\n");
+	dev_info(&intf->dev, "suspending now...\n");
 
 	return 0;
 }
@@ -879,7 +875,7 @@ static int si470x_usb_driver_suspend(struct usb_interface *intf,
  */
 static int si470x_usb_driver_resume(struct usb_interface *intf)
 {
-	printk(KERN_INFO DRIVER_NAME ": resuming now...\n");
+	dev_info(&intf->dev, "resuming now...\n");
 
 	return 0;
 }
-- 
1.6.0.4
