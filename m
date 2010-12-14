Return-path: <mchehab@gaivota>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:52717 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab0LNKhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:37:11 -0500
Received: by bwz16 with SMTP id 16so585044bwz.4
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 02:37:10 -0800 (PST)
Date: Tue, 14 Dec 2010 13:36:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sergej Pupykin <pupykin.s@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [patch v2] [media] bttv: take correct lock in bttv_open()
Message-ID: <20101214103658.GL1620@bicker>
References: <20101210033304.GX10623@bicker>
 <4D01D4BE.1080000@gmail.com>
 <20101212165812.GG10623@bicker>
 <4D054FE9.80000@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <4D054FE9.80000@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 13, 2010 at 01:42:49AM +0300, Sergej Pupykin wrote:
> mutex_lock(&btv->lock);
> *fh = btv->init;
> mutex_unlock(&btv->lock);
> 
> Probably it is overkill and may be incorrect, but it starts working.
>

Mauro would be the one to know for sure.
 
> Also I found another issue: tvtime hangs on exit in D-state, so it
> looks like there is a problem near bttv_release function or
> something like this.

Speaking of other bugs in this driver, I submitted a another fix
that hasn't been merged yet.  I've attached it.  Don't know if it's
related at all to the other bug you noticed but it can't hurt.

regards,
dan carpenter

--MfFXiAuoTsnnDAfZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="bt8xx.diff"

>From error27@gmail.com Thu Nov 18 07:19:15 2010
Date: Thu, 18 Nov 2010 06:55:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] bt8xx: missing unlock in bttv_overlay()
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO

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


--MfFXiAuoTsnnDAfZ--
