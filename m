Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:53979 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933709AbcJ0QEO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 12:04:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc: print correct variable for z8f0811
Date: Thu, 27 Oct 2016 18:03:37 +0200
Message-Id: <20161027160349.557473-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent rework accidentally left a debugging printk untouched
while changing the meaning of the variables, leading to an
uninitialized variable being printed:

drivers/media/i2c/ir-kbd-i2c.c: In function 'get_key_haup_common':
drivers/media/i2c/ir-kbd-i2c.c:62:2: error: 'toggle' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This prints the correct one instead, as we did before the patch.

Fixes: 00bb820755ed ("[media] rc: Hauppauge z8f0811 can decode RC6")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/ir-kbd-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I'd like to see this patch make it into v4.9 so we can enable the warning
again by default. Can you give me an Ack for it or apply it to the
fixes tree?

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index f95a6bc..cede397 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -118,7 +118,7 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 			*protocol = RC_TYPE_RC6_MCE;
 			dev &= 0x7f;
 			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
-						toggle, vendor, dev, code);
+						*ptoggle, vendor, dev, code);
 		} else {
 			*ptoggle = 0;
 			*protocol = RC_TYPE_RC6_6A_32;
-- 
2.9.0

