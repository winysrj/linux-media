Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:57666 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757036AbZGCUvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 16:51:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH repost 2/4] V4L: em28xx, fix lock imbalance
Date: Fri,  3 Jul 2009 22:51:34 +0200
Message-Id: <1246654296-23190-2-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1246654296-23190-1-git-send-email-jirislaby@gmail.com>
References: <1246654296-23190-1-git-send-email-jirislaby@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is one omitted unlock in em28xx_usb_probe. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 36abb35..922d21d 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2445,6 +2445,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
 		em28xx_devused &= ~(1<<dev->devno);
+		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;
 	}
-- 
1.6.3.2

