Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37210 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3CZFv4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 01:51:56 -0400
Received: by mail-bk0-f46.google.com with SMTP id je9so1142714bkc.33
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 22:51:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 13:51:54 +0800
Message-ID: <CAPgLHd-1FxJWLBQaOsiXajaSXAhogydG3QS-Fqi1P5kxBQMPrw@mail.gmail.com>
Subject: [PATCH -next] [media] tw9906: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, hans.verkuil@cisco.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/tw9906.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index 2263a91..d94325b 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>

