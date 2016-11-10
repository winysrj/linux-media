Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57642 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752287AbcKJHpa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 02:45:30 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] ir-kbd-i2c: fix uninitialized variable reference
Message-ID: <c149b7bf-fd3f-678e-64d4-c4b752bed3d2@xs4all.nl>
Date: Thu, 10 Nov 2016 08:45:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix compiler warning about uninitialized variable reference:

ir-kbd-i2c.c: In function 'get_key_haup_common.isra.3':
ir-kbd-i2c.c:62:2: warning: 'toggle' may be used uninitialized in this function [-Wmaybe-uninitialized]
  printk(KERN_DEBUG MODULE_NAME ": " fmt , ## arg)
  ^~~~~~
ir-kbd-i2c.c:70:20: note: 'toggle' was declared here
  int start, range, toggle, dev, code, ircode, vendor;
                    ^~~~~~

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
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
