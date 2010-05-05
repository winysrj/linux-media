Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0EEF7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 01:59:06 -0400
Received: by fxm10 with SMTP id 10so3900022fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 22:59:04 -0700 (PDT)
Date: Wed, 5 May 2010 07:58:57 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch -next] media/mem2mem: dereferencing free memory
Message-ID: <20100505055857.GD27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We dereferenced "ctx" on the error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index baf211b..b161d26 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -871,8 +871,10 @@ static int m2mtest_open(struct file *file)
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
+		int ret = PTR_ERR(ctx->m2m_ctx);
+
 		kfree(ctx);
-		return PTR_ERR(ctx->m2m_ctx);
+		return ret;
 	}
 
 	atomic_inc(&dev->num_inst);
