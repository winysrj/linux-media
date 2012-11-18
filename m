Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42830 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2KRPNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:14 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 7/7] ir-rx51: Fix sparse warnings
Date: Sun, 18 Nov 2012 17:13:09 +0200
Message-Id: <1353251589-26143-8-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing __user annotation to all of the user space memory
accesses. Otherwise sparse is complainign about address space
difference in types.

Also struct lirc_rx51_platform_driver is missing static keyword even
though it should have it.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index edb1562..7ed0616 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -233,7 +233,7 @@ static int lirc_rx51_free_port(struct lirc_rx51 *lirc_rx51)
 	return 0;
 }
 
-static ssize_t lirc_rx51_write(struct file *file, const char *buf,
+static ssize_t lirc_rx51_write(struct file *file, const char __user *buf,
 			  size_t n, loff_t *ppos)
 {
 	int count, i;
@@ -308,13 +308,13 @@ static long lirc_rx51_ioctl(struct file *filep,
 
 	switch (cmd) {
 	case LIRC_GET_SEND_MODE:
-		result = put_user(LIRC_MODE_PULSE, (unsigned long *)arg);
+		result = put_user(LIRC_MODE_PULSE, (unsigned long __user *)arg);
 		if (result)
 			return result;
 		break;
 
 	case LIRC_SET_SEND_MODE:
-		result = get_user(value, (unsigned long *)arg);
+		result = get_user(value, (unsigned long __user *)arg);
 		if (result)
 			return result;
 
@@ -324,7 +324,7 @@ static long lirc_rx51_ioctl(struct file *filep,
 		break;
 
 	case LIRC_GET_REC_MODE:
-		result = put_user(0, (unsigned long *) arg);
+		result = put_user(0, (unsigned long __user *)arg);
 		if (result)
 			return result;
 		break;
@@ -334,7 +334,7 @@ static long lirc_rx51_ioctl(struct file *filep,
 		break;
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
-		result = get_user(ivalue, (unsigned int *) arg);
+		result = get_user(ivalue, (unsigned int __user *)arg);
 		if (result)
 			return result;
 
@@ -348,7 +348,7 @@ static long lirc_rx51_ioctl(struct file *filep,
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
-		result = get_user(ivalue, (unsigned int *) arg);
+		result = get_user(ivalue, (unsigned int __user *)arg);
 		if (result)
 			return result;
 
@@ -363,7 +363,7 @@ static long lirc_rx51_ioctl(struct file *filep,
 
 	case LIRC_GET_FEATURES:
 		result = put_user(LIRC_RX51_DRIVER_FEATURES,
-				  (unsigned long *) arg);
+				(unsigned long __user *)arg);
 		if (result)
 			return result;
 		break;
@@ -484,7 +484,7 @@ static int __exit lirc_rx51_remove(struct platform_device *dev)
 	return lirc_unregister_driver(lirc_rx51_driver.minor);
 }
 
-struct platform_driver lirc_rx51_platform_driver = {
+static struct platform_driver lirc_rx51_platform_driver = {
 	.probe		= lirc_rx51_probe,
 	.remove		= __exit_p(lirc_rx51_remove),
 	.suspend	= lirc_rx51_suspend,
-- 
1.8.0

