Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8326 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZDNF34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 01:29:56 -0400
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KI200JH1SLL8J@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Apr 2009 14:29:46 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KI200D0USLMO9@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Apr 2009 14:29:46 +0900 (KST)
Date: Tue, 14 Apr 2009 14:29:45 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <200904132035.57419.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: klimov.linux@gmail.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <49E41F49.8000407@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <49E31480.7050100@samsung.com> <49E31702.8020507@samsung.com>
 <200904132035.57419.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/14/2009 3:35 AM, Tobias Lorenz wrote:
> Hi Joonyoung,
> 
>> I have some problem. There is codes for usb in radio-si470x-common.c file.
> 
>> Hrm, if it cannot be removed, maybe it seems to seperate using ifdef.
> 
>> What do you think about this?
> 
> I moved some more functions from radio-si470x-common.c file to
> radio-si470x-usb.c:
> 
> - si470x_start
> 
> - si470x_stop
> 
> - si470x_fops_open
> 
> - si470x_fops_release
> 
> Now the common file should be free of any USB specific components.
> 
> Please have a look at
> 
> http://linuxtv.org/hg/~tlorenz/v4l-dvb/
> 
> Maybe we can move something back later for optimization. But for now, it
> should be okay.
> 
> Bye,
> 
> Toby
> 

Hi Tobias,

I have some questions.

The i2c device is connected always unlike the usb device, so it doesn't
use disconnected and disconnect_lock of struct si470x_device, these are
usb specific.

Unlike you say, si470x_start and si470x_stop functions exist yet in
radio-si470x-common.c. 

I know from datasheet that software should wait for the powerup time(110ms)
after power up, and i verified it at the si4709 device using i2c interface,
but there is not at your implementation.

I wonder above things, and i send you the patch to fix make warning and build
errors, and for easy work.

=============================================================================
Fix compile warnings and errors of radio-si470x-i2c

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 linux/drivers/media/radio/si470x/Kconfig           |    2 +-
 linux/drivers/media/radio/si470x/Makefile          |    4 +-
 .../drivers/media/radio/si470x/radio-si470x-i2c.c  |  153 +++++++++-----------
 linux/drivers/media/radio/si470x/radio-si470x.h    |    5 +-
 4 files changed, 74 insertions(+), 90 deletions(-)

diff --git a/linux/drivers/media/radio/si470x/Kconfig b/linux/drivers/media/radio/si470x/Kconfig
index 3172e1a..07ac2d3 100644
--- a/linux/drivers/media/radio/si470x/Kconfig
+++ b/linux/drivers/media/radio/si470x/Kconfig
@@ -34,4 +34,4 @@ config I2C_SI470X
 	  computer's I2C port.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called radio-si470x-i2c.
+	  module will be called radio-i2c-si470x.
diff --git a/linux/drivers/media/radio/si470x/Makefile b/linux/drivers/media/radio/si470x/Makefile
index 945e7b1..a4bba94 100644
--- a/linux/drivers/media/radio/si470x/Makefile
+++ b/linux/drivers/media/radio/si470x/Makefile
@@ -3,7 +3,7 @@
 #
 
 radio-si470x-objs	:= radio-si470x-usb.o radio-si470x-common.o
-radio-si470x-i2c-objs	:= radio-si470x-i2c.o radio-si470x-common.o
+radio-i2c-si470x-objs	:= radio-si470x-i2c.o radio-si470x-common.o
 
 obj-$(CONFIG_USB_SI470X) += radio-si470x.o
-obj-$(CONFIG_I2C_SI470X) += radio-si470x-i2c.o
+obj-$(CONFIG_I2C_SI470X) += radio-i2c-si470x.o
diff --git a/linux/drivers/media/radio/si470x/radio-si470x-i2c.c b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
index 7058b84..27a0691 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -57,14 +57,9 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
  */
 int si470x_get_register(struct si470x_device *radio, int regnr)
 {
-	int retval;
+	/* TODO */
 
-	retval = 0; /* TODO */
-
-	if (retval >= 0)
-		radio->registers[regnr] = 0; /* TODO */
-
-	return (retval < 0) ? -EINVAL : 0;
+	return 0;
 }
 
 
@@ -73,13 +68,9 @@ int si470x_get_register(struct si470x_device *radio, int regnr)
  */
 int si470x_set_register(struct si470x_device *radio, int regnr)
 {
-	int retval;
-
-	radio->registers[regnr] = 0; /* TODO */
+	/* TODO */
 
-	retval = 0; /* TODO */
-
-	return (retval < 0) ? -EINVAL : 0;
+	return 0;
 }
 
 
@@ -88,16 +79,9 @@ int si470x_set_register(struct si470x_device *radio, int regnr)
  */
 int si470x_get_all_registers(struct si470x_device *radio)
 {
-	int retval;
-	unsigned char regnr;
-
-	retval = 0; /* TODO */
+	/* TODO */
 
-	if (retval >= 0)
-		for (regnr = 0; regnr < RADIO_REGISTER_NUM; regnr++)
-			radio->registers[regnr] = 0; /* TODO */
-
-	return (retval < 0) ? -EINVAL : 0;
+	return 0;
 }
 
 
@@ -106,17 +90,9 @@ int si470x_get_all_registers(struct si470x_device *radio)
  */
 int si470x_get_rds_registers(struct si470x_device *radio)
 {
-	int retval;
-	int size;
-	unsigned char regnr;
-
-	retval = /* TODO */
+	/* TODO */
 
-	if (retval >= 0)
-		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
-			radio->registers[STATUSRSSI + regnr] = 0; /* TODO */
-
-	return (retval < 0) ? -EINVAL : 0;
+	return 0;
 }
 
 
@@ -131,26 +107,15 @@ int si470x_get_rds_registers(struct si470x_device *radio)
 int si470x_fops_open(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval;
+	int retval = 0;
 
 	lock_kernel();
 	radio->users++;
 
-//	retval = usb_autopm_get_interface(radio->intf);
-//	if (retval < 0) {
-//		radio->users--;
-//		retval = -EIO;
-//		goto done;
-//	}
-//
-	if (radio->users == 1) {
+	if (radio->users == 1)
 		/* start radio */
 		retval = si470x_start(radio);
-		if (retval < 0)
-			usb_autopm_put_interface(radio->intf);
-	}
 
-done:
 	unlock_kernel();
 	return retval;
 }
@@ -170,16 +135,8 @@ int si470x_fops_release(struct file *file)
 		goto done;
 	}
 
-	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
 	if (radio->users == 0) {
-		if (radio->disconnected) {
-			video_unregister_device(radio->videodev);
-			kfree(radio->buffer);
-			kfree(radio);
-			goto unlock;
-		}
-
 		/* stop rds reception */
 		cancel_delayed_work_sync(&radio->work);
 
@@ -188,12 +145,8 @@ int si470x_fops_release(struct file *file)
 
 		/* stop radio */
 		retval = si470x_stop(radio);
-//		usb_autopm_put_interface(radio->intf);
 	}
 
-unlock:
-	mutex_unlock(&radio->disconnect_lock);
-
 done:
 	return retval;
 }
@@ -210,11 +163,8 @@ done:
 int si470x_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *capability)
 {
-	struct si470x_device *radio = video_drvdata(file);
-
 	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
-//	usb_make_path(radio->usbdev, capability->bus_info, sizeof(capability->bus_info));
 	capability->version = DRIVER_KERNEL_VERSION;
 	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
@@ -231,7 +181,8 @@ int si470x_vidioc_querycap(struct file *file, void *priv,
 /*
  * si470x_i2c_driver_probe - probe for the device
  */
-static int si470x_i2c_driver_probe()
+static int si470x_i2c_driver_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
 	struct si470x_device *radio;
 	int retval = 0;
@@ -243,10 +194,6 @@ static int si470x_i2c_driver_probe()
 		goto err_initial;
 	}
 	radio->users = 0;
-	radio->disconnected = 0;
-//	radio->usbdev = interface_to_usbdev(intf);
-	radio->intf = intf;
-	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
 
 	/* video device allocation and initialization */
@@ -267,22 +214,6 @@ static int si470x_i2c_driver_probe()
 	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
 
-	/* check if device and firmware is current */
-	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE)
-			< RADIO_SW_VERSION_CURRENT) {
-		printk(KERN_WARNING DRIVER_NAME
-			": This driver is known to work with "
-			"firmware version %hu,\n", RADIO_SW_VERSION_CURRENT);
-		printk(KERN_WARNING DRIVER_NAME
-			": but the device has firmware version %hu.\n",
-			radio->registers[CHIPID] & CHIPID_FIRMWARE);
-		printk(KERN_WARNING DRIVER_NAME
-			": If you have some trouble using this driver,\n");
-		printk(KERN_WARNING DRIVER_NAME
-			": please report to V4L ML at "
-			"linux-media@vger.kernel.org\n");
-	}
-
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
 
@@ -309,7 +240,6 @@ static int si470x_i2c_driver_probe()
 				": Could not register video device\n");
 		goto err_all;
 	}
-//	usb_set_intfdata(intf, radio);
 
 	return 0;
 err_all:
@@ -322,6 +252,60 @@ err_initial:
 	return retval;
 }
 
+/*
+ * si470x_i2c_driver_remove - remove the device
+ */
+static int si470x_i2c_driver_remove(struct i2c_client *client)
+{
+	/* TODO */
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/*
+ * si470x_i2c_driver_suspend - suspend the device
+ */
+static int si470x_i2c_driver_suspend(struct i2c_client *client,
+		pm_message_t mesg)
+{
+	/* TODO */
+
+	return 0;
+}
+
+/*
+ * si470x_i2c_driver_resume - resume the device
+ */
+static int si470x_i2c_driver_resume(struct i2c_client *client)
+{
+	/* TODO */
+
+	return 0;
+}
+
+#else
+#define si470x_i2c_driver_suspend		NULL
+#define si470x_i2c_driver_resume		NULL
+#endif
+
+static const struct i2c_device_id si470x_i2c_driver_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, si470x_i2c_driver_id);
+
+static struct i2c_driver si470x_i2c_driver = {
+	.driver = {
+		.name = DRIVER_NAME
+	},
+	.probe		= si470x_i2c_driver_probe,
+	.remove		= si470x_i2c_driver_remove,
+	.suspend	= si470x_i2c_driver_suspend,
+	.resume		= si470x_i2c_driver_resume,
+	.id_table	= si470x_i2c_driver_id,
+};
+
 
 
 /**************************************************************************
@@ -333,8 +317,7 @@ err_initial:
  */
 static int __init si470x_module_init(void)
 {
-	printk(KERN_INFO DRIVER_DESC ", Version " DRIVER_VERSION "\n");
-	return 0; /* TODO i2c_register */
+	return i2c_add_driver(&si470x_i2c_driver);
 }
 
 
@@ -343,7 +326,7 @@ static int __init si470x_module_init(void)
  */
 static void __exit si470x_module_exit(void)
 {
-	/* TODO i2c_deregister */
+	i2c_del_driver(&si470x_i2c_driver);
 }
 
 
diff --git a/linux/drivers/media/radio/si470x/radio-si470x.h b/linux/drivers/media/radio/si470x/radio-si470x.h
index 771300e..3953bce 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x.h
+++ b/linux/drivers/media/radio/si470x/radio-si470x.h
@@ -41,6 +41,7 @@
 #include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
+#include <linux/i2c.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/rds.h>
@@ -155,9 +156,9 @@ struct si470x_device {
 	struct usb_interface *intf;
 #endif
 
-#ifdef CONFIG_I2C_SI470X_MODULE
+#if defined (CONFIG_I2C_SI470X) || (CONFIG_I2C_SI470X_MODULE)
 	/* reference to I2C device */
-	/* TODO */
+	struct i2c_client *client;
 #endif
 
 	/* reference to video device */
-- 
1.5.6.3
