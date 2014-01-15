Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38371 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAOCtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 21:49:24 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so518748bkz.38
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 18:49:23 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 10:49:23 +0800
Message-ID: <CAPgLHd8En9DSWqr10FFRXgus1C0S589zcv8NPGwEL4gUKBRhbQ@mail.gmail.com>
Subject: [PATCH -next] [media] au0828: Fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, ttmesterr@gmail.com,
	dheitmueller@kernellabs.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/media/usb/au0828/au0828-dvb.c:36:5: warning:
 symbol 'preallocate_big_buffers' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/au0828/au0828-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 19fe049..4ae8b10 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -33,7 +33,7 @@
 #include "mxl5007t.h"
 #include "tda18271.h"
 
-int preallocate_big_buffers;
+static int preallocate_big_buffers;
 module_param_named(preallocate_big_buffers, preallocate_big_buffers, int, 0644);
 MODULE_PARM_DESC(preallocate_big_buffers, "Preallocate the larger transfer buffers at module load time");
 

