Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0EDLid (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 07:38:33 -0400
Received: by fxm10 with SMTP id 10so3101534fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 04:38:32 -0700 (PDT)
Date: Tue, 4 May 2010 13:38:26 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: [patch -next 2/3] media/IR/imon: testing the wrong variable
Message-ID: <20100504113825.GV29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a typo here.  We meant to test "ir" instead of "props".  The
"props" variable was tested earlier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b65c31a..f2066d0 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1672,7 +1672,7 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	}
 
 	ir = kzalloc(sizeof(struct ir_input_dev), GFP_KERNEL);
-	if (!props) {
+	if (!ir) {
 		dev_err(ictx->dev, "remote ir input dev allocation failed\n");
 		goto ir_dev_alloc_failed;
 	}
