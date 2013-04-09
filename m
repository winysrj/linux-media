Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35744 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935034Ab3DIJnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:43:55 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf3so3432755bkc.7
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:43:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 17:43:53 +0800
Message-ID: <CAPgLHd8YYwwvm4oNzbw3Mv_BRrzKsXekGBx-UNj1m0TZOu3U_w@mail.gmail.com>
Subject: [PATCH] [media] rc: ite-cir: fix potential double free in ite_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, matthijs@stdin.nl, ben@decadent.org.uk,
	david@hardeman.nu, jarod@redhat.com
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
 drivers/media/rc/ite-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index dd82373..63b4225 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1613,6 +1613,7 @@ exit_release_cir_addr:
 	release_region(itdev->cir_addr, itdev->params.io_region_size);
 exit_unregister_device:
 	rc_unregister_device(rdev);
+	rdev = NULL;
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(itdev);

