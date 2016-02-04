Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33777 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcBDXRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 18:17:22 -0500
From: Insu Yun <wuninsu@gmail.com>
To: isely@pobox.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] pvrusb2: correctly handling failed thread run
Date: Thu,  4 Feb 2016 18:09:23 -0500
Message-Id: <1454627363-24300-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since kthread_run returns -ENOMEM if failed,
it needs to be checked whether it is error, not whether it is null.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
index fd888a6..aabdc58 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.c
@@ -196,7 +196,7 @@ int pvr2_context_global_init(void)
 	pvr2_context_thread_ptr = kthread_run(pvr2_context_thread_func,
 					      NULL,
 					      "pvrusb2-context");
-	return (pvr2_context_thread_ptr ? 0 : -ENOMEM);
+	return IS_ERR(pvr2_context_thread_ptr) ? -ENOMEM : 0;
 }
 
 
-- 
1.9.1

