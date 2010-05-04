Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58283 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0EDLhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 07:37:42 -0400
Received: by fxm10 with SMTP id 10so3100733fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 04:37:41 -0700 (PDT)
Date: Tue, 4 May 2010 13:37:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: [patch -next 1/3] media/IR/imon: precendence issue: ! vs ==
Message-ID: <20100504113733.GU29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original condition is always false because ! has higher precedence
than == and neither 0 nor 1 is equal to IMON_DISPLAY_TYPE_VGA.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b65c31a..93b5796 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -975,7 +975,7 @@ static void imon_touch_display_timeout(unsigned long data)
 {
 	struct imon_context *ictx = (struct imon_context *)data;
 
-	if (!ictx->display_type == IMON_DISPLAY_TYPE_VGA)
+	if (ictx->display_type != IMON_DISPLAY_TYPE_VGA)
 		return;
 
 	input_report_abs(ictx->touch, ABS_X, ictx->touch_x);
