Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:34621 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935034Ab3DIJne (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:43:34 -0400
Received: by mail-bk0-f47.google.com with SMTP id ik5so3445756bkc.20
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:43:33 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 17:43:33 +0800
Message-ID: <CAPgLHd_F+reJCuGeBne9espy9Rokm1iWMH7C=w3VpuobHa5J_w@mail.gmail.com>
Subject: [PATCH] [media] rc: winbond-cir: fix potential double free in wbcir_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: david@hardeman.nu, mchehab@redhat.com
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
 drivers/media/rc/winbond-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 535a18d..87af2d3 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1151,6 +1151,7 @@ exit_release_wbase:
 	release_region(data->wbase, WAKEUP_IOMEM_LEN);
 exit_unregister_device:
 	rc_unregister_device(data->dev);
+	data->dev = NULL;
 exit_free_rc:
 	rc_free_device(data->dev);
 exit_unregister_led:

