Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway06.websitewelcome.com ([67.18.1.11]:50042 "HELO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757592AbZIRSuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 14:50:15 -0400
Received: from [66.15.212.169] (port=30683 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi7H-0002n2-VM
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:32 -0500
Subject: [PATCH 8/9] go7007: convert printks to v4l2_info
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:35 -0700
Message-Id: <1253298215.4314.572.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_info and v4l2_err where appropriate.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r beaab56c3599 -r 1cb2c7d3fa12 linux/drivers/staging/go7007/go7007-driver.c
--- a/linux/drivers/staging/go7007/go7007-driver.c	Fri Sep 18 10:40:54 2009 -0700
+++ b/linux/drivers/staging/go7007/go7007-driver.c	Fri Sep 18 10:59:26 2009 -0700
@@ -49,7 +49,7 @@
 	go->hpi_ops->read_interrupt(go);
 	if (wait_event_timeout(go->interrupt_waitq,
 				go->interrupt_available, 5*HZ) < 0) {
-		printk(KERN_ERR "go7007: timeout waiting for read interrupt\n");
+		v4l2_err(go->video_dev, "timeout waiting for read interrupt\n");
 		return -1;
 	}
 	if (!go->interrupt_available)
@@ -97,13 +97,12 @@
 	u16 intr_val, intr_data;
 
 	if (request_firmware(&fw_entry, fw_name, go->dev)) {
-		printk(KERN_ERR
-			"go7007: unable to load firmware from file \"%s\"\n",
-			fw_name);
+		v4l2_err(go, "unable to load firmware from file "
+			"\"%s\"\n", fw_name);
 		return -1;
 	}
 	if (fw_entry->size < 16 || memcmp(fw_entry->data, "WISGO7007FW", 11)) {
-		printk(KERN_ERR "go7007: file \"%s\" does not appear to be "
+		v4l2_err(go, "file \"%s\" does not appear to be "
 				"go7007 firmware\n", fw_name);
 		release_firmware(fw_entry);
 		return -1;
@@ -111,7 +110,7 @@
 	fw_len = fw_entry->size - 16;
 	bounce = kmalloc(fw_len, GFP_KERNEL);
 	if (bounce == NULL) {
-		printk(KERN_ERR "go7007: unable to allocate %d bytes for "
+		v4l2_err(go, "unable to allocate %d bytes for "
 				"firmware transfer\n", fw_len);
 		release_firmware(fw_entry);
 		return -1;
@@ -122,7 +121,7 @@
 			go7007_send_firmware(go, bounce, fw_len) < 0 ||
 			go7007_read_interrupt(go, &intr_val, &intr_data) < 0 ||
 			(intr_val & ~0x1) != 0x5a5a) {
-		printk(KERN_ERR "go7007: error transferring firmware\n");
+		v4l2_err(go, "error transferring firmware\n");
 		rv = -1;
 	}
 	kfree(bounce);
@@ -316,7 +315,7 @@
 
 	if (go7007_send_firmware(go, fw, fw_len) < 0 ||
 			go7007_read_interrupt(go, &intr_val, &intr_data) < 0) {
-		printk(KERN_ERR "go7007: error transferring firmware\n");
+		v4l2_err(go->video_dev, "error transferring firmware\n");
 		rv = -1;
 		goto start_error;
 	}
@@ -325,7 +324,7 @@
 	go->parse_length = 0;
 	go->seen_frame = 0;
 	if (go7007_stream_start(go) < 0) {
-		printk(KERN_ERR "go7007: error starting stream transfer\n");
+		v4l2_err(go->video_dev, "error starting stream transfer\n");
 		rv = -1;
 		goto start_error;
 	}
@@ -421,7 +420,7 @@
 	for (i = 0; i < length; ++i) {
 		if (go->active_buf != NULL &&
 			    go->active_buf->bytesused >= GO7007_BUF_SIZE - 3) {
-			printk(KERN_DEBUG "go7007: dropping oversized frame\n");
+			v4l2_info(go->video_dev, "dropping oversized frame\n");
 			go->active_buf->offset -= go->active_buf->bytesused;
 			go->active_buf->bytesused = 0;
 			go->active_buf->modet_active = 0;
@@ -669,8 +668,8 @@
 		if (i2c_del_adapter(&go->i2c_adapter) == 0)
 			go->i2c_adapter_online = 0;
 		else
-			printk(KERN_ERR
-				"go7007: error removing I2C adapter!\n");
+			v4l2_err(go->video_dev,
+				"error removing I2C adapter!\n");
 	}
 
 	if (go->audio_enabled)


