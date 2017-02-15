Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37084 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdBOM0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 07:26:33 -0500
Date: Wed, 15 Feb 2017 15:25:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Anholt <eric@anholt.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] staging: bcm2835-camera: free first element in array
Message-ID: <20170215122523.GA12198@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should free gdev[0] so the > should be >=.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a698e018..9bcd8e546a14 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -1998,7 +1998,7 @@ static int __init bm2835_mmal_init(void)
 free_dev:
 	kfree(dev);
 
-	for ( ; camera > 0; camera--) {
+	for ( ; camera >= 0; camera--) {
 		bcm2835_cleanup_instance(gdev[camera]);
 		gdev[camera] = NULL;
 	}
