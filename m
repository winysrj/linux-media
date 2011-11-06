Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:27 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:26 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 08/13] staging: as102: Replace printk(KERN_<LEVEL> witk pr_<level>
Date: Sun,  6 Nov 2011 21:31:45 +0100
Message-Id: <1320611510-3326-9-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While at it also correct some spelling errors.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_fw.c      |   26 +++++++++++++-------------
 drivers/staging/media/as102/as102_usb_drv.c |   10 +++++-----
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index ab7dcdb..fa56939 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -58,7 +58,7 @@ static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
 	unsigned char *src, dst;
 
 	if (*fw_data++ != ':') {
-		printk(KERN_ERR "invalid firmware file\n");
+		pr_err("invalid firmware file\n");
 		return -EFAULT;
 	}
 
@@ -191,21 +191,21 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
 	/* request kernel to locate firmware file: part1 */
 	errno = request_firmware(&firmware, fw1, &dev->dev);
 	if (errno < 0) {
-		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
-				 DRIVER_NAME, fw1);
+		pr_err("%s: unable to locate firmware file: %s\n",
+		       DRIVER_NAME, fw1);
 		goto error;
 	}
 
 	/* initiate firmware upload */
 	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
 	if (errno < 0) {
-		printk(KERN_ERR "%s: error during firmware upload part1\n",
-				 DRIVER_NAME);
+		pr_err("%s: error during firmware upload part1\n",
+		       DRIVER_NAME);
 		goto error;
 	}
 
-	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
-			 DRIVER_NAME, fw1);
+	pr_info("%s: firmware: %s loaded with success\n",
+		DRIVER_NAME, fw1);
 	release_firmware(firmware);
 
 	/* wait for boot to complete */
@@ -214,21 +214,21 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
 	/* request kernel to locate firmware file: part2 */
 	errno = request_firmware(&firmware, fw2, &dev->dev);
 	if (errno < 0) {
-		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
-				 DRIVER_NAME, fw2);
+		pr_err("%s: unable to locate firmware file: %s\n",
+		       DRIVER_NAME, fw2);
 		goto error;
 	}
 
 	/* initiate firmware upload */
 	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
 	if (errno < 0) {
-		printk(KERN_ERR "%s: error during firmware upload part2\n",
-				 DRIVER_NAME);
+		pr_err("%s: error during firmware upload part2\n",
+		       DRIVER_NAME);
 		goto error;
 	}
 
-	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
-			DRIVER_NAME, fw2);
+	pr_info("%s: firmware: %s loaded with success\n",
+		DRIVER_NAME, fw2);
 error:
 	/* free data buffer */
 	kfree(cmd_buf);
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index e0c3854..3ded7d6 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -337,7 +337,7 @@ static void as102_usb_disconnect(struct usb_interface *intf)
 	/* decrement usage counter */
 	kref_put(&as102_dev->kref, as102_usb_release);
 
-	printk(KERN_INFO "%s: device has been disconnected\n", DRIVER_NAME);
+	pr_info("%s: device has been disconnected\n", DRIVER_NAME);
 
 	LEAVE();
 }
@@ -360,7 +360,7 @@ static int as102_usb_probe(struct usb_interface *intf,
 	/* This should never actually happen */
 	if ((sizeof(as102_usb_id_table) / sizeof(struct usb_device_id)) !=
 	    (sizeof(as102_device_names) / sizeof(const char *))) {
-		printk(KERN_ERR "Device names table invalid size");
+		pr_err("Device names table invalid size");
 		return -EINVAL;
 	}
 
@@ -399,7 +399,7 @@ static int as102_usb_probe(struct usb_interface *intf,
 		goto failed;
 	}
 
-	printk(KERN_INFO "%s: device has been detected\n", DRIVER_NAME);
+	pr_info("%s: device has been detected\n", DRIVER_NAME);
 
 	/* request buffer allocation for streaming */
 	ret = as102_alloc_usb_stream_buffer(as102_dev);
@@ -432,8 +432,8 @@ static int as102_open(struct inode *inode, struct file *file)
 	/* fetch device from usb interface */
 	intf = usb_find_interface(&as102_usb_driver, minor);
 	if (intf == NULL) {
-		printk(KERN_ERR "%s: can't find device for minor %d\n",
-				__func__, minor);
+		pr_err("%s: can't find device for minor %d\n",
+		       __func__, minor);
 		ret = -ENODEV;
 		goto exit;
 	}
-- 
1.7.5.4

