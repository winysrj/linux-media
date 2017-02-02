Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40639 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbdBBXOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 18:14:38 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] mce_kbd: add missing keys from UK layout
Date: Thu,  2 Feb 2017 23:14:36 +0000
Message-Id: <1486077276-14156-2-git-send-email-sean@mess.org>
In-Reply-To: <1486077276-14156-1-git-send-email-sean@mess.org>
References: <1486077276-14156-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UK layout of the Microsoft Remote Keyboard has two missing keys:
the hash key, and the messenger key which is sent using rc6 mce.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 2 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index d809862..5226d51 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -71,7 +71,7 @@ static unsigned char kbd_keycodes[256] = {
 	KEY_6,		KEY_7,		KEY_8,		KEY_9,		KEY_0,
 	KEY_ENTER,	KEY_ESC,	KEY_BACKSPACE,	KEY_TAB,	KEY_SPACE,
 	KEY_MINUS,	KEY_EQUAL,	KEY_LEFTBRACE,	KEY_RIGHTBRACE,	KEY_BACKSLASH,
-	KEY_RESERVED,	KEY_SEMICOLON,	KEY_APOSTROPHE,	KEY_GRAVE,	KEY_COMMA,
+	KEY_BACKSLASH,	KEY_SEMICOLON,	KEY_APOSTROPHE,	KEY_GRAVE,	KEY_COMMA,
 	KEY_DOT,	KEY_SLASH,	KEY_CAPSLOCK,	KEY_F1,		KEY_F2,
 	KEY_F3,		KEY_F4,		KEY_F5,		KEY_F6,		KEY_F7,
 	KEY_F8,		KEY_F9,		KEY_F10,	KEY_F11,	KEY_F12,
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index ef4006f..5be5675 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -86,6 +86,7 @@ static struct rc_map_table rc6_mce[] = {
 	{ 0x800f045e, KEY_BLUE },
 
 	{ 0x800f0465, KEY_POWER2 },	/* TV Power */
+	{ 0x800f0469, KEY_MESSENGER },
 	{ 0x800f046e, KEY_PLAYPAUSE },
 	{ 0x800f046f, KEY_PLAYER },	/* Start media application (NEW) */
 
-- 
2.9.3

