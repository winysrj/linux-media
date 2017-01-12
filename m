Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34187 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdALOhZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 09:37:25 -0500
Received: by mail-pf0-f196.google.com with SMTP id y143so3833327pfb.1
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2017 06:37:24 -0800 (PST)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] media: usb: tm6000: fix typo in parameter description
Date: Thu, 12 Jan 2017 14:30:47 +0000
Message-Id: <20170112143047.18903-1-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix typo in parameter description.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/usb/tm6000/tm6000-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 7fe00a5..6856674 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -39,7 +39,7 @@ MODULE_PARM_DESC(enable_ir, "enable ir (default is enable)");
 
 static unsigned int ir_clock_mhz = 12;
 module_param(ir_clock_mhz, int, 0644);
-MODULE_PARM_DESC(enable_ir, "ir clock, in MHz");
+MODULE_PARM_DESC(ir_clock_mhz, "ir clock, in MHz");
 
 #define URB_SUBMIT_DELAY	100	/* ms - Delay to submit an URB request on retrial and init */
 #define URB_INT_LED_DELAY	100	/* ms - Delay to turn led on again on int mode */

