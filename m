Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4035 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223Ab2B2Jue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 04:50:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add missing slab.h to fix linux-next compile errors
Date: Wed, 29 Feb 2012 10:50:27 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202291050.27369.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 862dfce..98e0c8c 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 8117fdf..177bcbd 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 9d7fdae..2e639ce 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -29,6 +29,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include "radio-isa.h"
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 02bcead..06f9063 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index 2b82dd7..be10a80 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -26,6 +26,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 0703a80..26a8c60 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -21,6 +21,7 @@
 #include <linux/ioport.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index 145d10c..eb72a4d 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -33,6 +33,7 @@
 #include <linux/ioport.h>	/* request_region		  */
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/io.h>		/* outb, outb_p                   */
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index 33dc089..026e88e 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -45,6 +45,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p                   */
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
