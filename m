Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([67.18.14.14]:43733 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750776Ab0DLSMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 14:12:19 -0400
Date: Mon, 12 Apr 2010 11:05:37 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: [PATCH] s2255drv: firmware reload on timeout
To: linux-media@vger.kernel.org
Message-ID: <tkrat.2ea419ae585217f5@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <linux-dev@sensoray.com>
# Date 1271095297 25200
# Node ID 88db759d6bdf2f352acf3763a8db3787ba8f7215
# Parent  686a2330f4a6a4c79e299a17663f0f150031098e
s2255drv: firmware reload on timeout

From: Dean Anderson <linux-dev@sensoray.com>

Firmware retry on timeout

Priority: normal

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff -r 686a2330f4a6 -r 88db759d6bdf linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Mon Apr 12 10:15:23 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Mon Apr 12 11:01:37 2010 -0700
@@ -58,7 +58,7 @@
 #include "compat.h"
 
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	19
+#define S2255_MINOR_VERSION	20
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -1753,7 +1753,7 @@
 				     == S2255_FW_SUCCESS) ||
 				    (atomic_read(&dev->fw_data->fw_state)
 				     == S2255_FW_DISCONNECTING)),
-			msecs_to_jiffies(S2255_LOAD_TIMEOUT));
+				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
 		/* state may have changed, re-read */
 		state = atomic_read(&dev->fw_data->fw_state);
 		break;
@@ -1761,27 +1761,38 @@
 	default:
 		break;
 	}
-	mutex_unlock(&dev->open_lock);
 	/* state may have changed in above switch statement */
 	switch (state) {
 	case S2255_FW_SUCCESS:
 		break;
 	case S2255_FW_FAILED:
 		printk(KERN_INFO "2255 firmware load failed.\n");
+		mutex_unlock(&dev->open_lock);
 		return -ENODEV;
 	case S2255_FW_DISCONNECTING:
 		printk(KERN_INFO "%s: disconnecting\n", __func__);
+		mutex_unlock(&dev->open_lock);
 		return -ENODEV;
 	case S2255_FW_LOADED_DSPWAIT:
 	case S2255_FW_NOTLOADED:
 		printk(KERN_INFO "%s: firmware not loaded yet"
 		       "please try again later\n",
 		       __func__);
+		/*
+		 * Timeout on firmware load means device unusable.
+		 * Set firmware failure state.
+		 * On next s2255_open the firmware will be reloaded.
+		 */
+		atomic_set(&dev->fw_data->fw_state,
+			   S2255_FW_FAILED);
+		mutex_unlock(&dev->open_lock);
 		return -EAGAIN;
 	default:
 		printk(KERN_INFO "%s: unknown state\n", __func__);
+		mutex_unlock(&dev->open_lock);
 		return -EFAULT;
 	}
+	mutex_unlock(&dev->open_lock);
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh)
@@ -2074,7 +2085,6 @@
 					dprintk(5, "setmode ready %d\n", cc);
 					break;
 				case S2255_RESPONSE_FW:
-
 					dev->chn_ready |= (1 << cc);
 					if ((dev->chn_ready & 0x0f) != 0x0f)
 						break;

