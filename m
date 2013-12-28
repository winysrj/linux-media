Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 06/24] em28xx-cards: remove a now dead code
Date: Sat, 28 Dec 2013 10:15:58 -0200
Message-Id: <1388232976-20061-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

As V4L2 registration now occurs asynchronously, the code doesn't
fail there anymore.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4fccbed539f9..d1c75e66554c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2972,7 +2972,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	if (retval < 0) {
 		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 			__func__, retval);
-		goto unregister_dev;
+		return retval;
 	}
 
 	/* register i2c bus 1 */
@@ -2986,7 +2986,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
-			goto unregister_dev;
+			return retval;
 		}
 	}
 
@@ -2994,16 +2994,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	em28xx_card_setup(dev);
 
 	return 0;
-
-	if (dev->def_i2c_bus)
-		em28xx_i2c_unregister(dev, 1);
-	em28xx_i2c_unregister(dev, 0);
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-
-unregister_dev:
-	v4l2_device_unregister(&dev->v4l2_dev);
-
-	return retval;
 }
 
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
-- 
1.8.3.1

