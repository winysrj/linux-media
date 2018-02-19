Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:60537 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752004AbeBSAuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 19:50:13 -0500
From: Quytelda Kahja <quytelda@tamalin.org>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Quytelda Kahja <quytelda@tamalin.org>
Subject: [PATCH] Staging: bcm2048: Fix function argument alignment in radio-bcm2048.c.
Date: Sun, 18 Feb 2018 16:44:46 -0800
Message-Id: <20180219004446.28771-1-quytelda@tamalin.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a coding style problem.

Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 06d1920150da..94141a11e51b 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1846,6 +1846,7 @@ static int bcm2048_deinit(struct bcm2048_device *bdev)
 static int bcm2048_probe(struct bcm2048_device *bdev)
 {
 	int err;
+	u8 default_threshold = BCM2048_DEFAULT_RSSI_THRESHOLD;
 
 	err = bcm2048_set_power_state(bdev, BCM2048_POWER_ON);
 	if (err < 0)
@@ -1863,8 +1864,7 @@ static int bcm2048_probe(struct bcm2048_device *bdev)
 	if (err < 0)
 		goto unlock;
 
-	err = bcm2048_set_fm_search_rssi_threshold(bdev,
-					BCM2048_DEFAULT_RSSI_THRESHOLD);
+	err = bcm2048_set_fm_search_rssi_threshold(bdev, default_threshold);
 	if (err < 0)
 		goto unlock;
 
@@ -1942,9 +1942,9 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
  */
 #define property_write(prop, type, mask, check)				\
 static ssize_t bcm2048_##prop##_write(struct device *dev,		\
-					struct device_attribute *attr,	\
-					const char *buf,		\
-					size_t count)			\
+				      struct device_attribute *attr,	\
+				      const char *buf,			\
+				      size_t count)			\
 {									\
 	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
 	type value;							\
@@ -1966,8 +1966,8 @@ static ssize_t bcm2048_##prop##_write(struct device *dev,		\
 
 #define property_read(prop, mask)					\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
-					struct device_attribute *attr,	\
-					char *buf)			\
+				     struct device_attribute *attr,	\
+				     char *buf)				\
 {									\
 	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
 	int value;							\
@@ -1985,8 +1985,8 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 
 #define property_signed_read(prop, size, mask)				\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
-					struct device_attribute *attr,	\
-					char *buf)			\
+				     struct device_attribute *attr,	\
+				     char *buf)				\
 {									\
 	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
 	size value;							\
@@ -2005,8 +2005,8 @@ property_read(prop, mask)						\
 
 #define property_str_read(prop, size)					\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
-					struct device_attribute *attr,	\
-					char *buf)			\
+				     struct device_attribute *attr,	\
+				     char *buf)				\
 {									\
 	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
 	int count;							\
@@ -2175,7 +2175,7 @@ static int bcm2048_fops_release(struct file *file)
 }
 
 static __poll_t bcm2048_fops_poll(struct file *file,
-				      struct poll_table_struct *pts)
+				  struct poll_table_struct *pts)
 {
 	struct bcm2048_device *bdev = video_drvdata(file);
 	__poll_t retval = 0;
-- 
2.16.2
