Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:57227 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdBBLf3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 06:35:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging: bcm2835: mark all symbols as 'static'
Date: Thu,  2 Feb 2017 12:34:11 +0100
Message-Id: <20170202113436.690145-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got a link error in allyesconfig:

drivers/staging/media/platform/bcm2835/bcm2835-camera.o: In function `vidioc_enum_framesizes':
bcm2835-camera.c:(.text.vidioc_enum_framesizes+0x0): multiple definition of `vidioc_enum_framesizes'
drivers/media/platform/vivid/vivid-vid-cap.o:vivid-vid-cap.c:(.text.vidioc_enum_framesizes+0x0): first defined here

While both drivers are equally at fault for this problem, the bcm2835 one was
just added and is easier to fix, as it is only one file, and none of its symbols
need to be globally visible. This marks the three global symbols as static.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/platform/bcm2835/bcm2835-camera.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index 105d88102cd9..ced8eb5de0f0 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -50,7 +50,7 @@ MODULE_AUTHOR("Vincent Sanders");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BM2835_MMAL_VERSION);
 
-int bcm2835_v4l2_debug;
+static int bcm2835_v4l2_debug;
 module_param_named(debug, bcm2835_v4l2_debug, int, 0644);
 MODULE_PARM_DESC(bcm2835_v4l2_debug, "Debug level 0-2");
 
@@ -1312,7 +1312,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return ret;
 }
 
-int vidioc_enum_framesizes(struct file *file, void *fh,
+static int vidioc_enum_framesizes(struct file *file, void *fh,
 			   struct v4l2_frmsizeenum *fsize)
 {
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
@@ -1842,7 +1842,7 @@ static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
 	return 0;
 }
 
-void bcm2835_cleanup_instance(struct bm2835_mmal_dev *dev)
+static void bcm2835_cleanup_instance(struct bm2835_mmal_dev *dev)
 {
 	if (!dev)
 		return;
-- 
2.9.0

