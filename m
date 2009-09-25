Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41580 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIYVQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 17:16:15 -0400
Received: by fxm18 with SMTP id 18so2521088fxm.17
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 14:16:18 -0700 (PDT)
Date: Sat, 26 Sep 2009 00:16:21 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] cx25840 6.5MHz carrier detection fixes
Message-ID: <20090925211621.GA15452@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx25840:
Disable 6.5MHz carrier autodetection for PAL, always assume its DK.
Only try to autodetect 6.5MHz carrier for SECAM if user accepts both
system DK and L.

Signed-off-by: Aleksandr V. Piskunov <alexandr.v.piskunov@gmail.com>

diff --git a/linux/drivers/media/video/cx25840/cx25840-core.c b/linux/drivers/media/video/cx25840/cx25840-core.c
--- a/linux/drivers/media/video/cx25840/cx25840-core.c
+++ b/linux/drivers/media/video/cx25840/cx25840-core.c
@@ -647,13 +647,30 @@
                }
                cx25840_write(client, 0x80b, 0x00);
        } else if (std & V4L2_STD_PAL) {
-               /* Follow tuner change procedure for PAL */
+               /* Autodetect audio standard and audio system */
                cx25840_write(client, 0x808, 0xff);
-               cx25840_write(client, 0x80b, 0x10);
+               /* Since system PAL-L is pretty much non-existant and
+                  not used by any public broadcast network, force
+                  6.5 MHz carrier to be interpreted as System DK,
+                  this avoids DK audio detection instability */
+               cx25840_write(client, 0x80b, 0x00);
        } else if (std & V4L2_STD_SECAM) {
-               /* Select autodetect for SECAM */
+               /* Autodetect audio standard and audio system */
                cx25840_write(client, 0x808, 0xff);
-               cx25840_write(client, 0x80b, 0x10);
+               /* If only one of SECAM-DK / SECAM-L is required, then force
+                  6.5MHz carrier, else autodetect it */
+               if ((std & V4L2_STD_SECAM_DK) &&
+                   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
+                       /* 6.5 MHz carrier to be interpreted as System DK */
+                       cx25840_write(client, 0x80b, 0x00);
+               } else if (!(std & V4L2_STD_SECAM_DK) &&
+                          (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
+                       /* 6.5 MHz carrier to be interpreted as System L */
+                       cx25840_write(client, 0x80b, 0x08);
+               } else {
+                       /* 6.5 MHz carrier to be autodetected */
+                       cx25840_write(client, 0x80b, 0x10);
+               }
        }

        cx25840_and_or(client, 0x810, ~0x01, 0);

