Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:51449 "EHLO
        resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932369AbcKGPlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Nov 2016 10:41:20 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, javier@osg.samsung.com, arnd@arndb.de,
        sean@mess.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: Fix get_key_haup_common.isra.4() debug message to print ptoggle value
Date: Mon,  7 Nov 2016 08:41:11 -0700
Message-Id: <20161107154114.26803-1-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the debug message in get_key_haup_common.isra.4() doesn't print the
correct toggle value. Fix it. This shows up as an used uninitialized warn
message:

drivers/media/i2c/ir-kbd-i2c.c: In function ‘get_key_haup_common.isra.4’:
 drivers/media/i2c/ir-kbd-i2c.c:62:2: warning: ‘toggle’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   printk(KERN_DEBUG MODULE_NAME ": " fmt , ## arg)
   ^~~~~~
 drivers/media/i2c/ir-kbd-i2c.c:70:20: note: ‘toggle’ was declared here
   int start, range, toggle, dev, code, ircode, vendor;
                     ^~~~~~

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
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
2.9.3

