Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab0G1CWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 22:22:51 -0400
Date: Tue, 27 Jul 2010 22:22:48 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] IR/imon: remove bad ir_input_dev use
Message-ID: <20100728022248.GA5345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir_input_dev gets filled in by __ir_input_register, the one
allocated in imon_init_idev was being overwritten by the correct one
shortly after it was initialized (ultimately resulting in a memory
leak). Additionally, there was an ill-advised memcpy into that
extraneous ir_input_dev which gets fixed by this.

Ill-advised memcpy pointed out by Dmitry Torokhov, bad usage of
ir_input_dev pointed out by Maxim Levitsky (in mceusb.c, which copied the
bug from here).

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 08dff8c..433dca6 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -87,7 +87,6 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 struct imon_context {
 	struct device *dev;
 	struct ir_dev_props *props;
-	struct ir_input_dev *ir;
 	/* Newer devices have two interfaces */
 	struct usb_device *usbdev_intf0;
 	struct usb_device *usbdev_intf1;
@@ -1656,7 +1655,6 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 {
 	struct input_dev *idev;
 	struct ir_dev_props *props;
-	struct ir_input_dev *ir;
 	int ret, i;
 
 	idev = input_allocate_device();
@@ -1671,12 +1669,6 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 		goto props_alloc_failed;
 	}
 
-	ir = kzalloc(sizeof(struct ir_input_dev), GFP_KERNEL);
-	if (!ir) {
-		dev_err(ictx->dev, "remote ir input dev allocation failed\n");
-		goto ir_dev_alloc_failed;
-	}
-
 	snprintf(ictx->name_idev, sizeof(ictx->name_idev),
 		 "iMON Remote (%04x:%04x)", ictx->vendor, ictx->product);
 	idev->name = ictx->name_idev;
@@ -1706,14 +1698,9 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	props->change_protocol = imon_ir_change_protocol;
 	ictx->props = props;
 
-	ictx->ir = ir;
-	memcpy(&ir->dev, ictx->dev, sizeof(struct device));
-
 	usb_to_input_id(ictx->usbdev_intf0, &idev->id);
 	idev->dev.parent = ictx->dev;
 
-	input_set_drvdata(idev, ir);
-
 	ret = ir_input_register(idev, RC_MAP_IMON_PAD, props, MOD_NAME);
 	if (ret < 0) {
 		dev_err(ictx->dev, "remote input dev register failed\n");
@@ -1723,8 +1710,6 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	return idev;
 
 idev_register_failed:
-	kfree(ir);
-ir_dev_alloc_failed:
 	kfree(props);
 props_alloc_failed:
 	input_free_device(idev);
-- 
1.7.1.1

-- 
Jarod Wilson
jarod@redhat.com

