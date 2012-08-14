Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45576 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2HNG6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 02:58:30 -0400
Date: Tue, 14 Aug 2012 09:58:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Gianluca Gennari <gennarone@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] em28xx: use after free in em28xx_v4l2_close()
Message-ID: <20120814065814.GB4791@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to move the unlock before the kfree(dev);

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index ecb23df..78d6ebd 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2264,9 +2264,9 @@ static int em28xx_v4l2_close(struct file *filp)
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
 			kfree(dev->alt_max_pkt_size);
+			mutex_unlock(&dev->lock);
 			kfree(dev);
 			kfree(fh);
-			mutex_unlock(&dev->lock);
 			return 0;
 		}
 
