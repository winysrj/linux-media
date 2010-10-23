Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab0JWTmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 15:42:52 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJgqfh016661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:42:52 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJgpAt010077
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:42:51 -0400
Date: Sat, 23 Oct 2010 15:42:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] imon: remove redundant change_protocol call
Message-ID: <20101023194251.GD4825@redhat.com>
References: <20101023194107.GB4825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023194107.GB4825@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There was a redundant call to imon_ir_change_protocol -- its already
getting called from ir_input_register. Also do some minor housekeeping
with var names and formatting.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index bcb2826..b4d489d 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -315,7 +315,7 @@ MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
 
 static bool debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
+MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes (default: no)");
 
 /* lcd, vfd, vga or none? should be auto-detected, but can be overridden... */
 static int display_type;
@@ -784,7 +784,7 @@ static struct attribute *imon_display_sysfs_entries[] = {
 	NULL
 };
 
-static struct attribute_group imon_display_attribute_group = {
+static struct attribute_group imon_display_attr_group = {
 	.attrs = imon_display_sysfs_entries
 };
 
@@ -793,7 +793,7 @@ static struct attribute *imon_rf_sysfs_entries[] = {
 	NULL
 };
 
-static struct attribute_group imon_rf_attribute_group = {
+static struct attribute_group imon_rf_attr_group = {
 	.attrs = imon_rf_sysfs_entries
 };
 
@@ -2238,8 +2238,7 @@ static void imon_init_display(struct imon_context *ictx,
 	dev_dbg(ictx->dev, "Registering iMON display with sysfs\n");
 
 	/* set up sysfs entry for built-in clock */
-	ret = sysfs_create_group(&intf->dev.kobj,
-				 &imon_display_attribute_group);
+	ret = sysfs_create_group(&intf->dev.kobj, &imon_display_attr_group);
 	if (ret)
 		dev_err(ictx->dev, "Could not create display sysfs "
 			"entries(%d)", ret);
@@ -2312,7 +2311,7 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	if (ifnum == 0) {
 		if (product == 0xffdc && ictx->rf_device) {
 			sysfs_err = sysfs_create_group(&interface->dev.kobj,
-						       &imon_rf_attribute_group);
+						       &imon_rf_attr_group);
 			if (sysfs_err)
 				pr_err("Could not create RF sysfs entries(%d)\n",
 				       sysfs_err);
@@ -2322,14 +2321,6 @@ static int __devinit imon_probe(struct usb_interface *interface,
 			imon_init_display(ictx, interface);
 	}
 
-	/* set IR protocol/remote type */
-	ret = imon_ir_change_protocol(ictx, ictx->ir_type);
-	if (ret) {
-		dev_warn(dev, "%s: failed to set IR protocol, falling back "
-			 "to standard iMON protocol mode\n", __func__);
-		ictx->ir_type = IR_TYPE_OTHER;
-	}
-
 	dev_info(dev, "iMON device (%04x:%04x, intf%d) on "
 		 "usb<%d:%d> initialized\n", vendor, product, ifnum,
 		 usbdev->bus->busnum, usbdev->devnum);
@@ -2368,10 +2359,8 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 	 * sysfs_remove_group is safe to call even if sysfs_create_group
 	 * hasn't been called
 	 */
-	sysfs_remove_group(&interface->dev.kobj,
-			   &imon_display_attribute_group);
-	sysfs_remove_group(&interface->dev.kobj,
-			   &imon_rf_attribute_group);
+	sysfs_remove_group(&interface->dev.kobj, &imon_display_attr_group);
+	sysfs_remove_group(&interface->dev.kobj, &imon_rf_attr_group);
 
 	usb_set_intfdata(interface, NULL);
 
-- 
1.7.2.3

-- 
Jarod Wilson
jarod@redhat.com

