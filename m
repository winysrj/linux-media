Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34002 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBKBKy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 20:10:54 -0500
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        swarren@wwwdotorg.org, lee@kernel.org, eric@anholt.net,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        arnd@arndb.de, robsonde@gmail.com
Cc: bcm-kernel-feedback-list@broadcom.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: platform: bcm2835 - style fix
Date: Sat, 11 Feb 2017 14:10:42 +1300
Message-Id: <20170211011042.13512-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed permissions to octal style
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/media/platform/bcm2835/bcm2835-camera.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a698e018..7ef9147ddef7 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -61,9 +61,9 @@ MODULE_PARM_DESC(video_nr, "videoX start numbers, -1 is autodetect");
 
 static int max_video_width = MAX_VIDEO_MODE_WIDTH;
 static int max_video_height = MAX_VIDEO_MODE_HEIGHT;
-module_param(max_video_width, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(max_video_width, int, 0644);
 MODULE_PARM_DESC(max_video_width, "Threshold for video mode");
-module_param(max_video_height, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(max_video_height, int, 0644);
 MODULE_PARM_DESC(max_video_height, "Threshold for video mode");
 
 /* Gstreamer bug https://bugzilla.gnome.org/show_bug.cgi?id=726521
@@ -76,7 +76,7 @@ MODULE_PARM_DESC(max_video_height, "Threshold for video mode");
  * result).
  */
 static int gst_v4l2src_is_broken;
-module_param(gst_v4l2src_is_broken, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(gst_v4l2src_is_broken, int, 0644);
 MODULE_PARM_DESC(gst_v4l2src_is_broken, "If non-zero, enable workaround for Gstreamer");
 
 /* global device data array */
-- 
2.11.1

