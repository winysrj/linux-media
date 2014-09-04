Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15807 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaIDNFW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 09:05:22 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] hdpvr: reduce memory footprint when debugging
Date: Thu,  4 Sep 2014 16:04:38 +0300
Message-Id: <1409835878-12617-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to use hex_dump_to_buffer() since we have a kernel helper to
dump up to 64 bytes just via printk().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/usb/hdpvr/hdpvr-control.c | 21 ++++++---------------
 drivers/media/usb/hdpvr/hdpvr-core.c    | 27 ++++++---------------------
 2 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index 6053661..6e86032 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -59,13 +59,10 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 			      1000);
 
 #ifdef HDPVR_DEBUG
-	if (hdpvr_debug & MSG_INFO) {
-		char print_buf[15];
-		hex_dump_to_buffer(dev->usbc_buf, 5, 16, 1, print_buf,
-				   sizeof(print_buf), 0);
+	if (hdpvr_debug & MSG_INFO)
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-			 "get video info returned: %d, %s\n", ret, print_buf);
-	}
+			 "get video info returned: %d, %5ph\n", ret,
+			 dev->usbc_buf);
 #endif
 	mutex_unlock(&dev->usbc_mutex);
 
@@ -82,9 +79,6 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
 
 int get_input_lines_info(struct hdpvr_device *dev)
 {
-#ifdef HDPVR_DEBUG
-	char print_buf[9];
-#endif
 	int ret, lines;
 
 	mutex_lock(&dev->usbc_mutex);
@@ -96,13 +90,10 @@ int get_input_lines_info(struct hdpvr_device *dev)
 			      1000);
 
 #ifdef HDPVR_DEBUG
-	if (hdpvr_debug & MSG_INFO) {
-		hex_dump_to_buffer(dev->usbc_buf, 3, 16, 1, print_buf,
-				   sizeof(print_buf), 0);
+	if (hdpvr_debug & MSG_INFO)
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-			 "get input lines info returned: %d, %s\n", ret,
-			 print_buf);
-	}
+			 "get input lines info returned: %d, %3ph\n", ret,
+			 dev->usbc_buf);
 #else
 	(void)ret;	/* suppress compiler warning */
 #endif
diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index c563896..42b4cdf 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -124,14 +124,6 @@ static int device_authorization(struct hdpvr_device *dev)
 	int ret, retval = -ENOMEM;
 	char request_type = 0x38, rcv_request = 0x81;
 	char *response;
-#ifdef HDPVR_DEBUG
-	size_t buf_size = 46;
-	char *print_buf = kzalloc(5*buf_size+1, GFP_KERNEL);
-	if (!print_buf) {
-		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-		return retval;
-	}
-#endif
 
 	mutex_lock(&dev->usbc_mutex);
 	ret = usb_control_msg(dev->udev,
@@ -147,11 +139,9 @@ static int device_authorization(struct hdpvr_device *dev)
 	}
 #ifdef HDPVR_DEBUG
 	else {
-		hex_dump_to_buffer(dev->usbc_buf, 46, 16, 1, print_buf,
-				   5*buf_size+1, 0);
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-			 "Status request returned, len %d: %s\n",
-			 ret, print_buf);
+			 "Status request returned, len %d: %46ph\n",
+			 ret, dev->usbc_buf);
 	}
 #endif
 
@@ -189,15 +179,13 @@ static int device_authorization(struct hdpvr_device *dev)
 
 	response = dev->usbc_buf+38;
 #ifdef HDPVR_DEBUG
-	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
-	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, "challenge: %s\n",
-		 print_buf);
+	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, "challenge: %8ph\n",
+		 response);
 #endif
 	challenge(response);
 #ifdef HDPVR_DEBUG
-	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
-	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, " response: %s\n",
-		 print_buf);
+	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, " response: %8ph\n",
+		 response);
 #endif
 
 	msleep(100);
@@ -213,9 +201,6 @@ static int device_authorization(struct hdpvr_device *dev)
 	retval = ret != 8;
 unlock:
 	mutex_unlock(&dev->usbc_mutex);
-#ifdef HDPVR_DEBUG
-	kfree(print_buf);
-#endif
 	return retval;
 }
 
-- 
2.1.0

