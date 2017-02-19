Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35553 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdBSNCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 08:02:12 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] b2c2: constify nxt200x_config structure
Date: Sun, 19 Feb 2017 18:29:52 +0530
Message-Id: <1487509192-25071-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare nxt200x_config structure as const as it is only passed as
an argument to the function dvb_attach. dvb_attach calls its first
argument on the rest of its arguments. The first argument of
dvb_attach in the changed case is nxt200x_attach and the parameter of
this function to which the object reference is passed is of type
const. So, nxt200x_config structures having this property can be made 
const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   7566	    568	      0	   8134	   1fc6	common/b2c2/flexcop-fe-tuner.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   7582	    536	      0	   8118	   1fb6	common/b2c2/flexcop-fe-tuner.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index f595640..e846a97 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -474,7 +474,7 @@ static int airstar_atsc1_attach(struct flexcop_device *fc,
 
 /* AirStar ATSC 2nd generation */
 #if FE_SUPPORTED(NXT200X) && FE_SUPPORTED(PLL)
-static struct nxt200x_config samsung_tbmv_config = {
+static const struct nxt200x_config samsung_tbmv_config = {
 	.demod_address = 0x0a,
 };
 
-- 
1.9.1
