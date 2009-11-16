Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway02.websitewelcome.com ([67.18.53.20]:53112 "HELO
	gateway02.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754135AbZKPWZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 17:25:08 -0500
Subject: Re: [PATCH 1/5 v2] go7007: Add struct v4l2_device.
From: Pete Eberlein <pete@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <200911151256.20031.hverkuil@xs4all.nl>
References: <1257880887.21307.1103.camel@pete-desktop>
	 <200911151256.20031.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 16 Nov 2009 08:58:34 -0800
Message-Id: <1258390714.4432.5.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-15 at 12:56 +0100, Hans Verkuil wrote:
> Hi Peter,
> 
> Thanks for this patch series! It's looking much better now.
> 
> I did find one thing though in this patch:
<snip>
> > +	v4l2_device_register(go->dev, &go->v4l2_dev);
> 
> Please check the return code here! 
> 
> You should have seen this warning when you compiled:
> 
> v4l/go7007-v4l2.c: In function 'go7007_v4l2_init':
> v4l/go7007-v4l2.c:1840: warning: ignoring return value of 'v4l2_device_register', declared with attribute warn_unused_result
> 
<snip>
> Other than that single warning it looks good!
> 
> Can you fix and repost this patch? Then I can prepare a pull request containing
> all these changes.
> 
> Thanks,
> 
> 	Hans

Thank you, Hans.  The warning is resolved in this patch:

# HG changeset patch
# User Pete Eberlein <pete@sensoray.com>
# Date 1258390406 28800
# Node ID 1c7d1407257aae2d005d211241e8c617ef3eab93
# Parent  19c0469c02c3b564af14a3d2228aff51de42ccaa
go7007: Add struct v4l2_device.

From: Pete Eberlein <pete@sensoray.com>

This adds a struct v4l2_device to the go7007 device struct and registers
it during v4l2 initialization.  The v4l2_device registration overwrites
the go->dev device_data, which is a struct usb_interface with intfdata set
to the struct go7007.  This changes intfdata to point to the struct
v4l2_device inside struct go7007, which is what v4l2_device_register will
also set it to (and warn about non-null drvdata on register.)  Since usb
disconnect can happen any time, this intfdata should always be present.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 19c0469c02c3 -r 1c7d1407257a linux/drivers/staging/go7007/go7007-driver.c
--- a/linux/drivers/staging/go7007/go7007-driver.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/staging/go7007/go7007-driver.c	Mon Nov 16 08:53:26 2009 -0800
@@ -49,7 +49,7 @@
 	go->hpi_ops->read_interrupt(go);
 	if (wait_event_timeout(go->interrupt_waitq,
 				go->interrupt_available, 5*HZ) < 0) {
-		v4l2_err(go->video_dev, "timeout waiting for read interrupt\n");
+		v4l2_err(&go->v4l2_dev, "timeout waiting for read interrupt\n");
 		return -1;
 	}
 	if (!go->interrupt_available)
@@ -315,7 +315,7 @@
 
 	if (go7007_send_firmware(go, fw, fw_len) < 0 ||
 			go7007_read_interrupt(go, &intr_val, &intr_data) < 0) {
-		v4l2_err(go->video_dev, "error transferring firmware\n");
+		v4l2_err(&go->v4l2_dev, "error transferring firmware\n");
 		rv = -1;
 		goto start_error;
 	}
@@ -324,7 +324,7 @@
 	go->parse_length = 0;
 	go->seen_frame = 0;
 	if (go7007_stream_start(go) < 0) {
-		v4l2_err(go->video_dev, "error starting stream transfer\n");
+		v4l2_err(&go->v4l2_dev, "error starting stream transfer\n");
 		rv = -1;
 		goto start_error;
 	}
@@ -420,7 +420,7 @@
 	for (i = 0; i < length; ++i) {
 		if (go->active_buf != NULL &&
 			    go->active_buf->bytesused >= GO7007_BUF_SIZE - 3) {
-			v4l2_info(go->video_dev, "dropping oversized frame\n");
+			v4l2_info(&go->v4l2_dev, "dropping oversized frame\n");
 			go->active_buf->offset -= go->active_buf->bytesused;
 			go->active_buf->bytesused = 0;
 			go->active_buf->modet_active = 0;
@@ -668,7 +668,7 @@
 		if (i2c_del_adapter(&go->i2c_adapter) == 0)
 			go->i2c_adapter_online = 0;
 		else
-			v4l2_err(go->video_dev,
+			v4l2_err(&go->v4l2_dev,
 				"error removing I2C adapter!\n");
 	}
 
diff -r 19c0469c02c3 -r 1c7d1407257a linux/drivers/staging/go7007/go7007-priv.h
--- a/linux/drivers/staging/go7007/go7007-priv.h	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/staging/go7007/go7007-priv.h	Mon Nov 16 08:53:26 2009 -0800
@@ -21,6 +21,8 @@
  * user-space applications.
  */
 
+#include <media/v4l2-device.h>
+
 struct go7007;
 
 /* IDs to activate board-specific support code */
@@ -167,6 +169,7 @@
 	int channel_number; /* for multi-channel boards like Adlink PCI-MPG24 */
 	char name[64];
 	struct video_device *video_dev;
+	struct v4l2_device v4l2_dev;
 	int ref_count;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
@@ -240,6 +243,11 @@
 	unsigned short interrupt_data;
 };
 
+static inline struct go7007 *to_go7007(struct v4l2_device *v4l2_dev)
+{
+	return container_of(v4l2_dev, struct go7007, v4l2_dev);
+}
+
 /* All of these must be called with the hpi_lock mutex held! */
 #define go7007_interface_reset(go) \
 			((go)->hpi_ops->interface_reset(go))
diff -r 19c0469c02c3 -r 1c7d1407257a linux/drivers/staging/go7007/go7007-usb.c
--- a/linux/drivers/staging/go7007/go7007-usb.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/staging/go7007/go7007-usb.c	Mon Nov 16 08:53:26 2009 -0800
@@ -1057,7 +1057,7 @@
 			usb_rcvintpipe(usb->usbdev, 4),
 			usb->intr_urb->transfer_buffer, 2*sizeof(u16),
 			go7007_usb_readinterrupt_complete, go, 8);
-	usb_set_intfdata(intf, go);
+	usb_set_intfdata(intf, &go->v4l2_dev);
 
 	/* Boot the GO7007 */
 	if (go7007_boot_encoder(go, go->board_info->flags &
@@ -1233,7 +1233,7 @@
 
 static void go7007_usb_disconnect(struct usb_interface *intf)
 {
-	struct go7007 *go = usb_get_intfdata(intf);
+	struct go7007 *go = to_go7007(usb_get_intfdata(intf));
 	struct go7007_usb *usb = go->hpi_context;
 	struct urb *vurb, *aurb;
 	int i;
diff -r 19c0469c02c3 -r 1c7d1407257a linux/drivers/staging/go7007/go7007-v4l2.c
--- a/linux/drivers/staging/go7007/go7007-v4l2.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Mon Nov 16 08:53:26 2009 -0800
@@ -1827,7 +1827,7 @@
 	go->video_dev = video_device_alloc();
 	if (go->video_dev == NULL)
 		return -ENOMEM;
-	memcpy(go->video_dev, &go7007_template, sizeof(go7007_template));
+	*go->video_dev = go7007_template;
 	go->video_dev->parent = go->dev;
 	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
 	if (rv < 0) {
@@ -1835,6 +1835,12 @@
 		go->video_dev = NULL;
 		return rv;
 	}
+	rv = v4l2_device_register(go->dev, &go->v4l2_dev);
+	if (rv < 0) {
+		video_device_release(go->video_dev);
+		go->video_dev = NULL;
+		return rv;
+	}
 	video_set_drvdata(go->video_dev, go);
 	++go->ref_count;
 	printk(KERN_INFO "%s: registered device video%d [v4l2]\n",
@@ -1858,4 +1864,5 @@
 	mutex_unlock(&go->hw_lock);
 	if (go->video_dev)
 		video_unregister_device(go->video_dev);
+	v4l2_device_unregister(&go->v4l2_dev);
 }


