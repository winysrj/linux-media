Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35249 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3GQCBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 22:01:13 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so517055bkh.25
        for <linux-media@vger.kernel.org>; Tue, 16 Jul 2013 19:01:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Jul 2013 10:01:12 +0800
Message-ID: <CAPgLHd_LfPJe+qoVzVjjnSzBpUbKqbW_P52thHFfNX3HYwbQew@mail.gmail.com>
Subject: [PATCH -next] [media] usbtv: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, hans.verkuil@cisco.com, lkundrak@v3.sk
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/usbtv/usbtv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index bf43f87..68fe97f 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>

