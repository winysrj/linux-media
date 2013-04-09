Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51217 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935034Ab3DIJoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:44:30 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so3574528bkc.30
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:44:29 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 17:44:29 +0800
Message-ID: <CAPgLHd8m8gfR5GH_dOEsNr1DOa-Kfr2pCus+YQrAKxOFBR-1pA@mail.gmail.com>
Subject: [PATCH] [media] rc: nuvoton-cir: fix potential double free in nvt_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, matthijs@stdin.nl, david@hardeman.nu,
	jarod@redhat.com, ben@decadent.org.uk
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
 drivers/media/rc/nuvoton-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 40125d7..21ee0dc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1107,6 +1107,7 @@ exit_release_cir_addr:
 	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
 exit_unregister_device:
 	rc_unregister_device(rdev);
+	rdev = NULL;
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(nvt);

