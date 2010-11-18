Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46590 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0KRD4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 22:56:13 -0500
Date: Thu, 18 Nov 2010 06:55:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] bt8xx: missing unlock in bttv_overlay()
Message-ID: <20101118035558.GK31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There is a missing unlock here.  This was introduced as part of BKL
removal in c37db91fd0d4 "V4L/DVB: bttv: fix driver lock and remove
explicit calls to BKL"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 3da6e80..aca755c 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2779,16 +2779,14 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 		mutex_lock(&fh->cap.vb_lock);
 		/* verify args */
 		if (unlikely(!btv->fbuf.base)) {
-			mutex_unlock(&fh->cap.vb_lock);
-			return -EINVAL;
-		}
-		if (unlikely(!fh->ov.setup_ok)) {
+			retval = -EINVAL;
+		} else if (unlikely(!fh->ov.setup_ok)) {
 			dprintk("bttv%d: overlay: !setup_ok\n", btv->c.nr);
 			retval = -EINVAL;
 		}
+		mutex_unlock(&fh->cap.vb_lock);
 		if (retval)
 			return retval;
-		mutex_unlock(&fh->cap.vb_lock);
 	}
 
 	if (!check_alloc_btres_lock(btv, fh, RESOURCE_OVERLAY))
