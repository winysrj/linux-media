Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1MMeaOT011342
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 17:40:36 -0500
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1MMe3iM025198
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 17:40:04 -0500
Received: by gv-out-0910.google.com with SMTP id l14so315553gvf.13
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 14:40:03 -0800 (PST)
Date: Fri, 22 Feb 2008 14:39:33 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080222223933.GA26113@plankton>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: v4lm <v4l-dvb-maintainer@linuxtv.org>, v4l <video4linux-list@redhat.com>
Subject: [PATCH][RFC] make kernel-links compile by adding version.h
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Many people have been complaining about kernel-links not working with
UVC.  I tried to look into it but I couldn't even get kernel-links to
compile on 2.6.25-rc2 without these changes... am I doing something
wrong?

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
diff --git a/linux/drivers/media/video/compat_ioctl32.c b/linux/drivers/media/video/compat_ioctl32.c
--- a/linux/drivers/media/video/compat_ioctl32.c
+++ b/linux/drivers/media/video/compat_ioctl32.c
@@ -12,6 +12,7 @@
  * ioctls.
  */
 
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 #include <linux/compat.h>
 #include <linux/videodev.h>
diff --git a/linux/drivers/media/video/cpia.c b/linux/drivers/media/video/cpia.c
--- a/linux/drivers/media/video/cpia.c
+++ b/linux/drivers/media/video/cpia.c
@@ -37,6 +37,7 @@
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <asm/io.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
 #endif
diff --git a/linux/drivers/media/video/cx2341x.c b/linux/drivers/media/video/cx2341x.c
--- a/linux/drivers/media/video/cx2341x.c
+++ b/linux/drivers/media/video/cx2341x.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
 #include <linux/slab.h>
 #endif
diff --git a/linux/drivers/media/video/cx88/cx88-blackbird.c b/linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <linux/device.h>
 #endif
diff --git a/linux/drivers/media/video/cx88/cx88-mpeg.c b/linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c
@@ -24,6 +24,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 #include <linux/device.h>
 #endif
diff --git a/linux/drivers/media/video/cx88/cx88-tvaudio.c b/linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c
@@ -37,6 +37,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 #include <linux/suspend.h>
 #else
diff --git a/linux/drivers/media/video/msp3400-kthreads.c b/linux/drivers/media/video/msp3400-kthreads.c
--- a/linux/drivers/media/video/msp3400-kthreads.c
+++ b/linux/drivers/media/video/msp3400-kthreads.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 23)
 #include <linux/freezer.h>
 #endif
diff --git a/linux/drivers/media/video/pvrusb2/pvrusb2-context.h b/linux/drivers/media/video/pvrusb2/pvrusb2-context.h
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-context.h
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-context.h
@@ -20,6 +20,7 @@
 #ifndef __PVRUSB2_BASE_H
 #define __PVRUSB2_BASE_H
 
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,16)
 #include <linux/mutex.h>
 #else
diff --git a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
@@ -36,6 +36,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,16)
 #include <linux/mutex.h>
 #else
diff --git a/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
@@ -25,6 +25,7 @@
 #include "pvrusb2-fx2-cmd.h"
 #include "pvrusb2.h"
 #include "compat.h"
+#include <linux/version.h>
 
 #define trace_i2c(...) pvr2_trace(PVR2_TRACE_I2C,__VA_ARGS__)
 
diff --git a/linux/drivers/media/video/pvrusb2/pvrusb2-io.c b/linux/drivers/media/video/pvrusb2/pvrusb2-io.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-io.c
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-io.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,16)
 #include <linux/mutex.h>
 #else
diff --git a/linux/drivers/media/video/pvrusb2/pvrusb2-io.h b/linux/drivers/media/video/pvrusb2/pvrusb2-io.h
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-io.h
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-io.h
@@ -23,6 +23,7 @@
 
 #include <linux/usb.h>
 #include <linux/list.h>
+#include <linux/version.h>
 
 typedef void (*pvr2_stream_callback)(void *);
 
diff --git a/linux/drivers/media/video/saa6588.c b/linux/drivers/media/video/saa6588.c
--- a/linux/drivers/media/video/saa6588.c
+++ b/linux/drivers/media/video/saa6588.c
@@ -31,6 +31,7 @@
 #include <linux/wait.h>
 #include <asm/uaccess.h>
 
+#include <linux/version.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 #include "i2c-compat.h"
 #endif
diff --git a/linux/drivers/media/video/saa7134/saa7134-alsa.c b/linux/drivers/media/video/saa7134/saa7134-alsa.c
--- a/linux/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0)
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/linux/drivers/media/video/saa7134/saa7134-core.c b/linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c
@@ -29,6 +29,7 @@
 #include <linux/sound.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
 #endif
diff --git a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/linux/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/linux/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 #include <linux/freezer.h>
 #endif
diff --git a/linux/drivers/media/video/tda7432.c b/linux/drivers/media/video/tda7432.c
--- a/linux/drivers/media/video/tda7432.c
+++ b/linux/drivers/media/video/tda7432.c
@@ -46,7 +46,7 @@
 #include <linux/slab.h>
 #include <linux/videodev.h>
 #include <linux/i2c.h>
-
+#include <linux/version.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 #include "i2c-compat.h"
 #else
diff --git a/linux/drivers/media/video/tuner-xc2028.c b/linux/drivers/media/video/tuner-xc2028.c
--- a/linux/drivers/media/video/tuner-xc2028.c
+++ b/linux/drivers/media/video/tuner-xc2028.c
@@ -14,6 +14,7 @@
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <media/tuner.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 16)
 #include <linux/mutex.h>
 #else
diff --git a/linux/drivers/media/video/tvaudio.c b/linux/drivers/media/video/tvaudio.c
--- a/linux/drivers/media/video/tvaudio.c
+++ b/linux/drivers/media/video/tvaudio.c
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kthread.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 #include <linux/freezer.h>
 #endif
diff --git a/linux/drivers/media/video/tveeprom.c b/linux/drivers/media/video/tveeprom.c
--- a/linux/drivers/media/video/tveeprom.c
+++ b/linux/drivers/media/video/tveeprom.c
@@ -36,6 +36,7 @@
 #include <linux/types.h>
 #include <linux/videodev.h>
 #include <linux/i2c.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
 #include <linux/slab.h>
 #endif
diff --git a/linux/drivers/media/video/usbvideo/konicawc.c b/linux/drivers/media/video/usbvideo/konicawc.c
--- a/linux/drivers/media/video/usbvideo/konicawc.c
+++ b/linux/drivers/media/video/usbvideo/konicawc.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,18)
 #include <linux/usb/input.h>
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,13)
diff --git a/linux/drivers/media/video/usbvideo/quickcam_messenger.c b/linux/drivers/media/video/usbvideo/quickcam_messenger.c
--- a/linux/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/linux/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,18)
 #include <linux/usb/input.h>
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,13)
diff --git a/linux/drivers/media/video/usbvideo/vicam.c b/linux/drivers/media/video/usbvideo/vicam.c
--- a/linux/drivers/media/video/usbvideo/vicam.c
+++ b/linux/drivers/media/video/usbvideo/vicam.c
@@ -42,6 +42,7 @@
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
 #endif
diff --git a/linux/drivers/media/video/videodev.c b/linux/drivers/media/video/videodev.c
--- a/linux/drivers/media/video/videodev.c
+++ b/linux/drivers/media/video/videodev.c
@@ -27,6 +27,7 @@
 		if (vfd->debug & V4L2_DEBUG_IOCTL_ARG)			\
 			printk (KERN_DEBUG "%s: " fmt, vfd->name, ## arg);
 
+#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/linux/drivers/media/video/w9968cf.h b/linux/drivers/media/video/w9968cf.h
--- a/linux/drivers/media/video/w9968cf.h
+++ b/linux/drivers/media/video/w9968cf.h
@@ -31,6 +31,7 @@
 #include <linux/param.h>
 #include <linux/types.h>
 #include <linux/rwsem.h>
+#include <linux/version.h>
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)
 #include <linux/mutex.h>
 #else
diff --git a/linux/include/media/v4l2-dev.h b/linux/include/media/v4l2-dev.h
--- a/linux/include/media/v4l2-dev.h
+++ b/linux/include/media/v4l2-dev.h
@@ -8,6 +8,8 @@
  */
 #ifndef _V4L2_DEV_H
 #define _V4L2_DEV_H
+
+#include <linux/version.h>
 
 #define OBSOLETE_OWNER   1 /* to be removed soon */
 #define OBSOLETE_DEVDATA 1 /* to be removed soon */
diff --git a/linux/include/media/videobuf-core.h b/linux/include/media/videobuf-core.h
--- a/linux/include/media/videobuf-core.h
+++ b/linux/include/media/videobuf-core.h
@@ -18,6 +18,7 @@
 #include <linux/videodev.h>
 #endif
 #include <linux/videodev2.h>
+#include <linux/version.h>
 
 #define UNSET (-1U)
 
diff --git a/v4l/compat.h b/v4l/compat.h
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1,6 +1,8 @@
 /*
  * $Id: compat.h,v 1.44 2006/01/15 09:35:16 mchehab Exp $
  */
+
+#include <linux/version.h>
 
 #ifndef _COMPAT_H
 #define _COMPAT_H

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
