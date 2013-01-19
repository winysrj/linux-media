Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:36242 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3ASXmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:42:18 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 07/24] usb/gspca: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:14 -0200
Message-Id: <1358638891-4775-8-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
References: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_INPUT) || \
     defined(CONFIG_INPUT_MODULE)
with:
 #if IS_ENABLED(CONFIG_INPUT)

This change was made for: CONFIG_INPUT

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
   Updated subject

 drivers/media/usb/gspca/gspca.c | 10 +++++-----
 drivers/media/usb/gspca/gspca.h |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index e0a431b..3564bdb 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -44,7 +44,7 @@
 
 #include "gspca.h"
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 #include <linux/input.h>
 #include <linux/usb/input.h>
 #endif
@@ -118,7 +118,7 @@ static const struct vm_operations_struct gspca_vm_ops = {
 /*
  * Input and interrupt endpoint handling functions
  */
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static void int_irq(struct urb *urb)
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
@@ -2303,7 +2303,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 
 	return 0;
 out:
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	if (gspca_dev->input_dev)
 		input_unregister_device(gspca_dev->input_dev);
 #endif
@@ -2348,7 +2348,7 @@ EXPORT_SYMBOL(gspca_dev_probe);
 void gspca_disconnect(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	struct input_dev *input_dev;
 #endif
 
@@ -2360,7 +2360,7 @@ void gspca_disconnect(struct usb_interface *intf)
 	gspca_dev->present = 0;
 	destroy_urbs(gspca_dev);
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	gspca_input_destroy_urb(gspca_dev);
 	input_dev = gspca_dev->input_dev;
 	if (input_dev) {
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index 352317d..5559932 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -138,7 +138,7 @@ struct sd_desc {
 	cam_reg_op get_register;
 #endif
 	cam_ident_op get_chip_ident;
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	cam_int_pkt_op int_pkt_scan;
 	/* other_input makes the gspca core create gspca_dev->input even when
 	   int_pkt_scan is NULL, for cams with non interrupt driven buttons */
@@ -167,7 +167,7 @@ struct gspca_dev {
 	struct usb_device *dev;
 	struct file *capt_file;		/* file doing video capture */
 					/* protected by queue_lock */
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	struct input_dev *input_dev;
 	char phys[64];			/* physical device path */
 #endif
@@ -190,7 +190,7 @@ struct gspca_dev {
 #define USB_BUF_SZ 64
 	__u8 *usb_buf;				/* buffer for USB exchanges */
 	struct urb *urb[MAX_NURBS];
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	struct urb *int_urb;
 #endif
 
-- 
1.7.11.7

