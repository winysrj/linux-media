Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.242]:49073
	"HELO nm2-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753152Ab1IDTiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 15:38:19 -0400
Message-ID: <4E63D3A6.3010505@yahoo.com>
Date: Sun, 04 Sep 2011 20:38:14 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/1] EM28xx - Fix memory leak on disconnect or error.
Content-Type: multipart/mixed;
 boundary="------------060705040009050508050601"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060705040009050508050601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

This patch seems to have been missed, so I'm resending it.

Release the dev->alt_max_pkt_size buffer in all cases.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

Cheers,
Chris

--------------060705040009050508050601
Content-Type: text/x-patch;
 name="EM28xx-video-leak.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-video-leak.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-04 20:30:14.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-04 20:28:59.000000000 +0100
@@ -3200,6 +3200,7 @@
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
 		mutex_unlock(&dev->lock);
+		kfree(dev->alt_max_pkt_size);
 		kfree(dev);
 		goto err;
 	}
--- linux/drivers/media/video/em28xx/em28xx-video.c.orig	2011-09-04 20:16:52.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-video.c	2011-09-04 20:27:41.000000000 +0100
@@ -2200,6 +2200,7 @@
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
+			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
 			return 0;
 		}

--------------060705040009050508050601--
