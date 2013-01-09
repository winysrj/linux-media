Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45673 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3AIQGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 11:06:07 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so639639wib.5
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 08:06:05 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: enable em28xx-dvb again for old kernels
Date: Wed,  9 Jan 2013 17:05:27 +0100
Message-Id: <1357747527-10305-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx-dvb driver was disabled for old kernels due to lack of support
for gpio_request_one() required by LNA control in the PCTV290e driver.
Instead, this patch introduces a tiny backport patch that disables LNA
control for the PCTV290e USB stick.
The PCTV290e works fine with LNA disabled, and all the other em28xx-dvb
devices can be used again with old kernels.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/backports.txt                     |  1 +
 backports/v2.6.33_no_gpio_request_one.patch | 25 +++++++++++++++++++++++++
 v4l/versions.txt                            |  2 --
 3 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 backports/v2.6.33_no_gpio_request_one.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 73ecbf6..f21cd53 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -60,6 +60,7 @@ add v2.6.34_fix_define_warnings.patch
 [2.6.33]
 add v2.6.33_input_handlers_are_int.patch
 add v2.6.33_pvrusb2_sysfs.patch
+add v2.6.33_no_gpio_request_one.patch
 
 [2.6.32]
 add v2.6.32_kfifo.patch
diff --git a/backports/v2.6.33_no_gpio_request_one.patch b/backports/v2.6.33_no_gpio_request_one.patch
new file mode 100644
index 0000000..a114a6d
--- /dev/null
+++ b/backports/v2.6.33_no_gpio_request_one.patch
@@ -0,0 +1,25 @@
+---
+ drivers/media/usb/em28xx/em28xx-dvb.c | 4 ++--
+ 1 file changed, 2 insertions(+), 2 deletions(-)
+
+--- a/drivers/media/usb/em28xx/em28xx-dvb.c
++++ b/drivers/media/usb/em28xx/em28xx-dvb.c
+@@ -672,7 +672,7 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
+ {
+ 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+ 	struct em28xx *dev = fe->dvb->priv;
+-#ifdef CONFIG_GPIOLIB
++#if 0
+ 	struct em28xx_dvb *dvb = dev->dvb;
+ 	int ret;
+ 	unsigned long flags;
+@@ -1104,7 +1104,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
+ 				goto out_free;
+ 			}
+ 
+-#ifdef CONFIG_GPIOLIB
++#if 0
+ 			/* enable LNA for DVB-T, DVB-T2 and DVB-C */
+ 			result = gpio_request_one(dvb->lna_gpio,
+ 					GPIOF_OUT_INIT_LOW, NULL);
+
diff --git a/v4l/versions.txt b/v4l/versions.txt
index 406c8cf..0873c17 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -69,8 +69,6 @@ VIDEO_MT9P031
 VIDEO_SMIAPP_PLL
 # Depends on VIDEO_SMIAPP_PLL and requires gpio_request_one
 VIDEO_SMIAPP
-# Depends on gpio functions/defines
-VIDEO_EM28XX_DVB
 
 [2.6.33]
 VIDEO_AK881X
-- 
1.8.0.3

