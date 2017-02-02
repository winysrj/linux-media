Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51332 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdBBMQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 07:16:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm2835: don't mark 'bcm2835_v4l2_debug' as static
Date: Thu,  2 Feb 2017 13:15:32 +0100
Message-Id: <20170202121554.1265939-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one unfortunately slipped through my own build testing, my patch
caused a new build error:

bcm2835-camera.c:53:12: error: static declaration of 'bcm2835_v4l2_debug' follows non-static declaration

We want the symbol to be global as it is indeed used in more than one
file and declared 'extern' in a header.

Fixes: 757b9bd074 ("staging: bcm2835: mark all symbols as 'static'")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/platform/bcm2835/bcm2835-camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ced8eb5de0f0..ca15a698e018 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -50,7 +50,7 @@ MODULE_AUTHOR("Vincent Sanders");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BM2835_MMAL_VERSION);
 
-static int bcm2835_v4l2_debug;
+int bcm2835_v4l2_debug;
 module_param_named(debug, bcm2835_v4l2_debug, int, 0644);
 MODULE_PARM_DESC(bcm2835_v4l2_debug, "Debug level 0-2");
 
-- 
2.9.0

