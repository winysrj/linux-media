Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47511 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0KRD4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 22:56:52 -0500
Date: Thu, 18 Nov 2010 06:56:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@hauppauge.com>,
	Sri Devi <Srinivasa.Deevi@conexant.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx231xx: stray unlock on error path
Message-ID: <20101118035637.GL31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The lock isn't held here and doesn't need to be unlocked.  The code has
been like this since the driver was merged. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 56c2d81..b7b905f 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -731,16 +731,12 @@ static int cx231xx_init_dev(struct cx231xx **devhandle, struct usb_device *udev,
 	retval = cx231xx_register_analog_devices(dev);
 	if (retval < 0) {
 		cx231xx_release_resources(dev);
-		goto fail_reg_devices;
+		return retval;
 	}
 
 	cx231xx_init_extension(dev);
 
 	return 0;
-
-fail_reg_devices:
-	mutex_unlock(&dev->lock);
-	return retval;
 }
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
