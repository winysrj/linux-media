Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:28587 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964855AbdBQXWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 18:22:31 -0500
Date: Sat, 18 Feb 2017 02:20:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] staging: bcm2835-camera: fix error handling in init
Message-ID: <20170217232015.GA26717@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58A44DFB.6090105@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The unwinding here isn't right.  We don't free gdev[0] and instead
free 1 step past what was allocated.  Also we can't allocate "dev" then
we should unwind instead of returning directly.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Change the style to make Walter Harms happy.  Fix some additional
    bugs I missed in the first patch.

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a698e018..c4dad30dd133 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -1901,6 +1901,7 @@ static int __init bm2835_mmal_init(void)
 	unsigned int num_cameras;
 	struct vchiq_mmal_instance *instance;
 	unsigned int resolutions[MAX_BCM2835_CAMERAS][2];
+	int i;
 
 	ret = vchiq_mmal_init(&instance);
 	if (ret < 0)
@@ -1914,8 +1915,10 @@ static int __init bm2835_mmal_init(void)
 
 	for (camera = 0; camera < num_cameras; camera++) {
 		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
-		if (!dev)
-			return -ENOMEM;
+		if (!dev) {
+			ret = -ENOMEM;
+			goto cleanup_gdev;
+		}
 
 		dev->camera_num = camera;
 		dev->max_width = resolutions[camera][0];
@@ -1998,9 +2001,10 @@ static int __init bm2835_mmal_init(void)
 free_dev:
 	kfree(dev);
 
-	for ( ; camera > 0; camera--) {
-		bcm2835_cleanup_instance(gdev[camera]);
-		gdev[camera] = NULL;
+cleanup_gdev:
+	for (i = 0; i < camera; i++) {
+		bcm2835_cleanup_instance(gdev[i]);
+		gdev[i] = NULL;
 	}
 	pr_info("%s: error %d while loading driver\n",
 		BM2835_MMAL_MODULE_NAME, ret);
