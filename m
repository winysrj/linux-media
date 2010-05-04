Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58798 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0EDLgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 07:36:45 -0400
Received: by fxm10 with SMTP id 10so3099898fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 04:36:43 -0700 (PDT)
Date: Tue, 4 May 2010 13:36:34 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: [patch -next 3/3] media/IR/imon: potential double unlock on error
Message-ID: <20100504113634.GT29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is an error here we should unlock in the caller (which is
imon_init_intf1()).  We can remove this stray unlock. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b65c31a..d48ad6d 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1777,7 +1777,6 @@ static struct input_dev *imon_init_touch(struct imon_context *ictx)
 
 touch_register_failed:
 	input_free_device(ictx->touch);
-	mutex_unlock(&ictx->lock);
 
 touch_alloc_failed:
 	return NULL;
