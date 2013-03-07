Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47559 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3CGQUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 11:20:08 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so1188462wgl.30
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 08:20:06 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] cx231xx: fix undefined function cx231xx_g_chip_ident()
Date: Thu,  7 Mar 2013 17:19:29 +0100
Message-Id: <1362673169-23668-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch:
http://git.linuxtv.org/media_tree.git/commit/b86d15440b683f8634c0cb26fc0861a5bc4913ac
is missing a chunk when compared to an older version:
https://patchwork.kernel.org/patch/2063281/
probably because of an unresolved merging conflict.
This causes the following error: 
WARNING: "cx231xx_g_chip_ident" [/home/jena/media_build/v4l/cx231xx.ko] undefined!

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 41c5c99..ac62008 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1227,7 +1227,7 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	return rc;
 }
 
-int vidioc_g_chip_ident(struct file *file, void *fh,
+int cx231xx_g_chip_ident(struct file *file, void *fh,
 			struct v4l2_dbg_chip_ident *chip)
 {
 	chip->ident = V4L2_IDENT_NONE;
-- 
1.8.1.5

