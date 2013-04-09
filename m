Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54968 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:47:43 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg1so3537764bkc.37
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:47:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 17:47:42 +0800
Message-ID: <CAPgLHd8=goobri4=WbVpTLVVZa1XJYJG-OoYyVMG+B0Bv0ZCzQ@mail.gmail.com>
Subject: [PATCH] [media] rc: ene_ir: fix potential double free in ene_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: maximlevitsky@gmail.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since rc_unregister_device() frees its argument, the subsequently
call to rc_free_device() on the same variable will cause a double
free bug. Fix by set argument to NULL, thus when fall through to
rc_free_device(), nothing will be done there.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/rc/ene_ir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index ee6c984..ed184f6 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1098,6 +1098,7 @@ exit_release_hw_io:
 	release_region(dev->hw_io, ENE_IO_SIZE);
 exit_unregister_device:
 	rc_unregister_device(rdev);
+	rdev = NULL;
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(dev);

