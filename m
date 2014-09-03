Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaICUd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/46] [media] vivid-vid-out: use memdup_user()
Date: Wed,  3 Sep 2014 17:32:36 -0300
Message-Id: <8e3336dbdbd26a56fb6817a4dc7cb31d860e8c5d.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating and coping from __user, do it using
one atomic call. That makes the code simpler. Also,

Found by coccinelle.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c983461f29d5..8ed9f6d9f505 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -897,14 +897,10 @@ int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
 		return ret;
 
 	if (win->bitmap) {
-		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+		new_bitmap = memdup_user(win->bitmap, bitmap_size);
 
-		if (new_bitmap == NULL)
-			return -ENOMEM;
-		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
-			kfree(new_bitmap);
-			return -EFAULT;
-		}
+		if (IS_ERR(new_bitmap))
+			return PTR_ERR(new_bitmap);
 	}
 
 	dev->overlay_out_top = win->w.top;
-- 
1.9.3

