Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35719 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbcBPCdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 21:33:14 -0500
From: Insu Yun <wuninsu@gmail.com>
To: sean@mess.org, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] rc: correctly handling failed allocation
Date: Mon, 15 Feb 2016 21:33:11 -0500
Message-Id: <1455589991-7795-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since rc_allocate_device() uses kmalloc,
it can returns NULL, so need to check, 
otherwise, NULL derefenrece can be happened.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/rc/igorplugusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index b36e515..df37cd5 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -191,6 +191,8 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	usb_make_path(udev, ir->phys, sizeof(ir->phys));
 
 	rc = rc_allocate_device();
+	if (!rc)
+		goto fail;
 	rc->input_name = DRIVER_DESC;
 	rc->input_phys = ir->phys;
 	usb_to_input_id(udev, &rc->input_id);
@@ -213,6 +215,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	ir->rc = rc;
 	ret = rc_register_device(rc);
 	if (ret) {
+fail:
 		dev_err(&intf->dev, "failed to register rc device: %d", ret);
 		rc_free_device(rc);
 		usb_free_urb(ir->urb);
-- 
1.9.1

