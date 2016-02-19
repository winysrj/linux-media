Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35068 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422898AbcBSOdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 09:33:55 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] [media] igorplugusb: fix leaks in error path
Date: Fri, 19 Feb 2016 14:33:53 +0000
Message-Id: <1455892433-20701-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Insu Yun <wuninsu@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/igorplugusb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index b36e515..e0c531f 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -152,7 +152,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep;
 	struct igorplugusb *ir;
 	struct rc_dev *rc;
-	int ret;
+	int ret = -ENOMEM;
 
 	udev = interface_to_usbdev(intf);
 	idesc = intf->cur_altsetting;
@@ -182,7 +182,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 
 	ir->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!ir->urb)
-		return -ENOMEM;
+		goto fail;
 
 	usb_fill_control_urb(ir->urb, udev,
 		usb_rcvctrlpipe(udev, 0), (uint8_t *)&ir->request,
@@ -191,6 +191,9 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	usb_make_path(udev, ir->phys, sizeof(ir->phys));
 
 	rc = rc_allocate_device();
+	if (!rc)
+		goto fail;
+
 	rc->input_name = DRIVER_DESC;
 	rc->input_phys = ir->phys;
 	usb_to_input_id(udev, &rc->input_id);
@@ -214,9 +217,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	ret = rc_register_device(rc);
 	if (ret) {
 		dev_err(&intf->dev, "failed to register rc device: %d", ret);
-		rc_free_device(rc);
-		usb_free_urb(ir->urb);
-		return ret;
+		goto fail;
 	}
 
 	usb_set_intfdata(intf, ir);
@@ -224,6 +225,12 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	igorplugusb_cmd(ir, SET_INFRABUFFER_EMPTY);
 
 	return 0;
+fail:
+	rc_free_device(ir->rc);
+	usb_free_urb(ir->urb);
+	del_timer(&ir->timer);
+
+	return ret;
 }
 
 static void igorplugusb_disconnect(struct usb_interface *intf)
-- 
2.1.4

