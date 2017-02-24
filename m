Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:42298 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXSLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 13:11:20 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, swarren@wwwdotorg.org,
        lee@kernel.org, eric@anholt.net, arnd@arndb.de
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] staging: bcm2835-camera: Fix a memory leak in error handling path in 'bm2835_mmal_init()'
Date: Fri, 24 Feb 2017 19:09:42 +0100
Message-Id: <20170224180942.17048-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If 'kzalloc()' fails, we should release resources allocated so far, just as
done in all other cases in this function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Not sure that the error handling path is correct.
Is 'gdev[0]' freed? Should it be?


v2: Rename patch to include '-camera' in the subject
---
 drivers/staging/media/platform/bcm2835/bcm2835-camera.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index ca15a698e018..9651b9bc3439 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -1914,8 +1914,10 @@ static int __init bm2835_mmal_init(void)
 
 	for (camera = 0; camera < num_cameras; camera++) {
 		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
-		if (!dev)
-			return -ENOMEM;
+		if (!dev) {
+			ret = -ENOMEM;
+			goto free_dev;
+		}
 
 		dev->camera_num = camera;
 		dev->max_width = resolutions[camera][0];
-- 
2.9.3
