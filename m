Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50227 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932250AbdEKLr1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 07:47:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB: ir-core: fix gcc-7 warning on bool arithmetic
Date: Thu, 11 May 2017 13:46:44 +0200
Message-Id: <20170511114711.2916593-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7 suggests that an expression using a bitwise not and a bitmask
on a 'bool' variable is better written using boolean logic:

drivers/media/rc/imon.c: In function 'imon_incoming_scancode':
drivers/media/rc/imon.c:1725:22: error: '~' on a boolean expression [-Werror=bool-operation]
    ictx->pad_mouse = ~(ictx->pad_mouse) & 0x1;
                      ^
drivers/media/rc/imon.c:1725:22: note: did you mean to use logical not?

I agree.

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/rc/imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3489010601b5..bd76534a2749 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1722,7 +1722,7 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 	if (kc == KEY_KEYBOARD && !ictx->release_code) {
 		ictx->last_keycode = kc;
 		if (!nomouse) {
-			ictx->pad_mouse = ~(ictx->pad_mouse) & 0x1;
+			ictx->pad_mouse = !ictx->pad_mouse;
 			dev_dbg(dev, "toggling to %s mode\n",
 				ictx->pad_mouse ? "mouse" : "keyboard");
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
-- 
2.9.0
