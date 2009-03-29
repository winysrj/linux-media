Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:24990 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZC2XUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 19:20:00 -0400
Received: by mu-out-0910.google.com with SMTP id g7so749504muf.1
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 16:19:57 -0700 (PDT)
Subject: [patch 2/2 review] pci-isa radios: remove open and release
 functions
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain
Date: Mon, 30 Mar 2009 03:19:54 +0400
Message-Id: <1238368794.21620.36.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexey Klimov <klimov.linux@gmail.com>

Patch removes empty open and release functions in pci and isa radio
drivers, setting them to NULL. V4L module doesn't call for them due to
previous patch.

Priority: normal

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r a38076781c9a linux/drivers/media/radio/radio-aimslab.c
--- a/linux/drivers/media/radio/radio-aimslab.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-aimslab.c	Mon Mar 30 02:05:12 2009 +0400
@@ -356,20 +356,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int rtrack_open(struct file *file)
-{
-	return 0;
-}
-
-static int rtrack_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations rtrack_fops = {
 	.owner		= THIS_MODULE,
-	.open           = rtrack_open,
-	.release        = rtrack_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-aztech.c
--- a/linux/drivers/media/radio/radio-aztech.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-aztech.c	Mon Mar 30 02:05:12 2009 +0400
@@ -319,20 +319,8 @@
 	return -EINVAL;
 }
 
-static int aztech_open(struct file *file)
-{
-	return 0;
-}
-
-static int aztech_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations aztech_fops = {
 	.owner		= THIS_MODULE,
-	.open           = aztech_open,
-	.release        = aztech_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-gemtek-pci.c
--- a/linux/drivers/media/radio/radio-gemtek-pci.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-gemtek-pci.c	Mon Mar 30 02:05:12 2009 +0400
@@ -357,20 +357,8 @@
 
 MODULE_DEVICE_TABLE(pci, gemtek_pci_id);
 
-static int gemtek_pci_open(struct file *file)
-{
-	return 0;
-}
-
-static int gemtek_pci_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations gemtek_pci_fops = {
 	.owner		= THIS_MODULE,
-	.open           = gemtek_pci_open,
-	.release        = gemtek_pci_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-gemtek.c
--- a/linux/drivers/media/radio/radio-gemtek.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-gemtek.c	Mon Mar 30 02:05:12 2009 +0400
@@ -376,20 +376,9 @@
 /*
  * Video 4 Linux stuff.
  */
-static int gemtek_open(struct file *file)
-{
-	return 0;
-}
-
-static int gemtek_release(struct file *file)
-{
-	return 0;
-}
 
 static const struct v4l2_file_operations gemtek_fops = {
 	.owner		= THIS_MODULE,
-	.open		= gemtek_open,
-	.release	= gemtek_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-maestro.c
--- a/linux/drivers/media/radio/radio-maestro.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-maestro.c	Mon Mar 30 02:05:12 2009 +0400
@@ -293,20 +293,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int maestro_open(struct file *file)
-{
-	return 0;
-}
-
-static int maestro_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations maestro_fops = {
 	.owner		= THIS_MODULE,
-	.open           = maestro_open,
-	.release        = maestro_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-maxiradio.c
--- a/linux/drivers/media/radio/radio-maxiradio.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-maxiradio.c	Mon Mar 30 02:05:12 2009 +0400
@@ -340,20 +340,8 @@
 	return -EINVAL;
 }
 
-static int maxiradio_open(struct file *file)
-{
-	return 0;
-}
-
-static int maxiradio_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations maxiradio_fops = {
 	.owner		= THIS_MODULE,
-	.open           = maxiradio_open,
-	.release        = maxiradio_release,
 	.ioctl          = video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-rtrack2.c
--- a/linux/drivers/media/radio/radio-rtrack2.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-rtrack2.c	Mon Mar 30 02:05:12 2009 +0400
@@ -261,20 +261,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int rtrack2_open(struct file *file)
-{
-	return 0;
-}
-
-static int rtrack2_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations rtrack2_fops = {
 	.owner		= THIS_MODULE,
-	.open           = rtrack2_open,
-	.release        = rtrack2_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-sf16fmi.c
--- a/linux/drivers/media/radio/radio-sf16fmi.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-sf16fmi.c	Mon Mar 30 02:05:12 2009 +0400
@@ -261,20 +261,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int fmi_open(struct file *file)
-{
-	return 0;
-}
-
-static int fmi_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
-	.open           = fmi_open,
-	.release        = fmi_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-sf16fmr2.c
--- a/linux/drivers/media/radio/radio-sf16fmr2.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-sf16fmr2.c	Mon Mar 30 02:05:12 2009 +0400
@@ -378,20 +378,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int fmr2_open(struct file *file)
-{
-	return 0;
-}
-
-static int fmr2_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations fmr2_fops = {
 	.owner          = THIS_MODULE,
-	.open           = fmr2_open,
-	.release        = fmr2_release,
 	.ioctl          = video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-terratec.c
--- a/linux/drivers/media/radio/radio-terratec.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-terratec.c	Mon Mar 30 02:05:12 2009 +0400
@@ -333,20 +333,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int terratec_open(struct file *file)
-{
-	return 0;
-}
-
-static int terratec_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations terratec_fops = {
 	.owner		= THIS_MODULE,
-	.open           = terratec_open,
-	.release        = terratec_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-trust.c
--- a/linux/drivers/media/radio/radio-trust.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-trust.c	Mon Mar 30 02:05:12 2009 +0400
@@ -339,20 +339,8 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int trust_open(struct file *file)
-{
-	return 0;
-}
-
-static int trust_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations trust_fops = {
 	.owner		= THIS_MODULE,
-	.open           = trust_open,
-	.release        = trust_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-typhoon.c
--- a/linux/drivers/media/radio/radio-typhoon.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-typhoon.c	Mon Mar 30 02:05:12 2009 +0400
@@ -315,20 +315,8 @@
 	return 0;
 }
 
-static int typhoon_open(struct file *file)
-{
-	return 0;
-}
-
-static int typhoon_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations typhoon_fops = {
 	.owner		= THIS_MODULE,
-	.open           = typhoon_open,
-	.release        = typhoon_release,
 	.ioctl		= video_ioctl2,
 };
 
diff -r a38076781c9a linux/drivers/media/radio/radio-zoltrix.c
--- a/linux/drivers/media/radio/radio-zoltrix.c	Mon Mar 30 01:14:44 2009 +0400
+++ b/linux/drivers/media/radio/radio-zoltrix.c	Mon Mar 30 02:05:12 2009 +0400
@@ -371,21 +371,9 @@
 	return a->index ? -EINVAL : 0;
 }
 
-static int zoltrix_open(struct file *file)
-{
-	return 0;
-}
-
-static int zoltrix_release(struct file *file)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations zoltrix_fops =
 {
 	.owner		= THIS_MODULE,
-	.open           = zoltrix_open,
-	.release        = zoltrix_release,
 	.ioctl		= video_ioctl2,
 };
 


-- 
Best regards, Klimov Alexey

