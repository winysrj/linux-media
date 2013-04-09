Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:52862 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935034Ab3DIJnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 05:43:10 -0400
Received: by mail-bk0-f54.google.com with SMTP id q16so3531940bkw.13
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 02:43:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 17:43:09 +0800
Message-ID: <CAPgLHd-EpQB2HjpH6pGnDLzvLUyKYSmyPfqQyCWa7CPz0V9d=g@mail.gmail.com>
Subject: [PATCH] [media] rc: ttusbir: fix potential double free in ttusbir_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sean@mess.org, mchehab@redhat.com
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
 drivers/media/rc/ttusbir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index cf0d47f..891762d 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -347,6 +347,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	return 0;
 out3:
 	rc_unregister_device(rc);
+	rc = NULL;
 out2:
 	led_classdev_unregister(&tt->led);
 out:

