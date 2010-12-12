Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0LLQ6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 11:58:22 -0500
Received: by wyb28 with SMTP id 28so5130991wyb.19
        for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 08:58:21 -0800 (PST)
Date: Sun, 12 Dec 2010 19:58:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sergej Pupykin <pupykin.s@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [patch v2] [media] bttv: take correct lock in bttv_open()
Message-ID: <20101212165812.GG10623@bicker>
References: <20101210033304.GX10623@bicker>
 <4D01D4BE.1080000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D01D4BE.1080000@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

We're trying to make sure that no one is writing to the btv->init struct
while we copy it over to the newly allocated "fh" struct.  The original
code doesn't make sense because "fh->cap.vb_lock" hasn't been
initialized and no one else can be writing to it anyway.

Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=24602 

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Sergej could you test this one?

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a529619..6c8f4b0 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3302,9 +3302,9 @@ static int bttv_open(struct file *file)
 	 * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
 	 * with the rest of init, holding btv->lock.
 	 */
-	mutex_lock(&fh->cap.vb_lock);
+	mutex_lock(&btv->init.cap.vb_lock);
 	*fh = btv->init;
-	mutex_unlock(&fh->cap.vb_lock);
+	mutex_unlock(&btv->init.cap.vb_lock);
 
 	fh->type = type;
 	fh->ov.setup_ok = 0;
