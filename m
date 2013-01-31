Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2969 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3AaKZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/18] tlg2300: use correct device parent.
Date: Thu, 31 Jan 2013 11:25:19 +0100
Message-Id: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set the correct parent for v4l2_device_register. Also remove an unnecessary
forward reference and fix two weird looking log messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index 7b1f6eb..c4eb57a 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -55,7 +55,6 @@ MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
 
 #define TLG2300_FIRMWARE "tlg2300_firmware.bin"
 static const char *firmware_name = TLG2300_FIRMWARE;
-static struct usb_driver poseidon_driver;
 static LIST_HEAD(pd_device_list);
 
 /*
@@ -316,7 +315,7 @@ static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
 		if (get_pm_count(pd) <= 0 && !in_hibernation(pd)) {
 			pd->msg.event = PM_EVENT_AUTO_SUSPEND;
 			pd->pm_resume = NULL; /*  a good guard */
-			printk(KERN_DEBUG "\n\t+ TLG2300 auto suspend +\n\n");
+			printk(KERN_DEBUG "TLG2300 auto suspend\n");
 		}
 		return 0;
 	}
@@ -331,7 +330,7 @@ static int poseidon_resume(struct usb_interface *intf)
 
 	if (!pd)
 		return 0;
-	printk(KERN_DEBUG "\n\t ++ TLG2300 resume ++\n\n");
+	printk(KERN_DEBUG "TLG2300 resume\n");
 
 	if (!is_working(pd)) {
 		if (PM_EVENT_AUTO_SUSPEND == pd->msg.event)
@@ -439,7 +438,7 @@ static int poseidon_probe(struct usb_interface *interface,
 		/* register v4l2 device */
 		snprintf(pd->v4l2_dev.name, sizeof(pd->v4l2_dev.name), "%s %s",
 			dev->driver->name, dev_name(dev));
-		ret = v4l2_device_register(NULL, &pd->v4l2_dev);
+		ret = v4l2_device_register(&interface->dev, &pd->v4l2_dev);
 
 		/* register devices in directory /dev */
 		ret = pd_video_init(pd);
@@ -530,7 +529,7 @@ module_init(poseidon_init);
 module_exit(poseidon_exit);
 
 MODULE_AUTHOR("Telegent Systems");
-MODULE_DESCRIPTION("For tlg2300-based USB device ");
+MODULE_DESCRIPTION("For tlg2300-based USB device");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.2");
 MODULE_FIRMWARE(TLG2300_FIRMWARE);
-- 
1.7.10.4

