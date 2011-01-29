Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58574 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1A2Hdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 02:33:36 -0500
Date: Fri, 28 Jan 2011 23:33:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] Input: rc-keymap - return KEY_RESERVED for unknown mappings
Message-ID: <20110129073329.GB26915@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Do not respond with -EINVAL to EVIOCGKEYCODE for not-yet-mapped scancodes,
but rather return KEY_RESERVED.

This fixes breakage with Ubuntu's input-kbd utility that stopped returning
full keymaps for remote controls.

Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Mark Lord <kernel@teksavvy.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Linus,

Due to the fact that contents of drivers/media in my 'for-linus' branch
are quite different from mainline/Mauro's trees and I am not planning on
merging this branch until closer to the next merge window I am sending
this regression fix in patch form instead of pull request.

Please consider applying.

Thanks,
Dmitry

 drivers/media/rc/rc-main.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 72be8a0..512a2f4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -458,21 +458,27 @@ static int ir_getkeycode(struct input_dev *idev,
 		index = ir_lookup_by_scancode(rc_map, scancode);
 	}
 
-	if (index >= rc_map->len) {
-		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
-			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-				   scancode);
+	if (index < rc_map->len) {
+		entry = &rc_map->scan[index];
+
+		ke->index = index;
+		ke->keycode = entry->keycode;
+		ke->len = sizeof(entry->scancode);
+		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
+		/*
+		 * We do not really know the valid range of scancodes
+		 * so let's respond with KEY_RESERVED to anything we
+		 * do not have mapping for [yet].
+		 */
+		ke->index = index;
+		ke->keycode = KEY_RESERVED;
+	} else {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	entry = &rc_map->scan[index];
-
-	ke->index = index;
-	ke->keycode = entry->keycode;
-	ke->len = sizeof(entry->scancode);
-	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
-
 	retval = 0;
 
 out:
-- 
1.7.3.5

-- 
Dmitry
