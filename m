Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:52536 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754082AbcJQWMl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 18:12:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: [PATCH 12/28] [media] rc: print correct variable for z8f0811
Date: Tue, 18 Oct 2016 00:12:08 +0200
Message-Id: <20161017221233.1826832-1-arnd@arndb.de>
In-Reply-To: <20161017220342.1627073-1-arnd@arndb.de>
References: <20161017220342.1627073-1-arnd@arndb.de>
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

