Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:36439 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab0BCUWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:22:38 -0500
Message-ID: <4B69DAEF.8040806@arcor.de>
Date: Wed, 03 Feb 2010 21:22:07 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 7/15] -  tm6000
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -23,12 +23,15 @@
 // Use the tm6000-hack, instead of the proper initialization code
 //#define HACK 1
 
+#include "compat.h"
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
 #include "tm6000-usb-isoc.h"
 #include <linux/i2c.h>
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
+#endif
 #include <media/v4l2-device.h>
 
 
@@ -78,6 +81,10 @@ struct tm6000_dmaqueue {
     /* thread for generating video stream*/
     struct task_struct         *kthread;
     wait_queue_head_t          wq;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+    struct semaphore           *notify;
+    int                        rmmod:1;
+#endif
     /* Counters to control fps rate */
     int                        frame;
     int                        ini_jiffies;

-- 
Stefan Ringel <stefan.ringel@arcor.de>

