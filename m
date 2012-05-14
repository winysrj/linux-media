Return-path: <linux-media-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:37341 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2ENODE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 10:03:04 -0400
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] ati_remote: add regular up/down buttons to Medion Digitainer keymap
Date: Mon, 14 May 2012 16:52:38 +0300
Message-Id: <1337003558-30781-2-git-send-email-anssi.hannula@iki.fi>
In-Reply-To: <1337003558-30781-1-git-send-email-anssi.hannula@iki.fi>
References: <1337003558-30781-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are many different Medion X10 remotes that need slightly different
keymaps. We may not yet have all the needed keymaps, in which case a
wrong keymap may be used. This happened with Medion X10 OR2x remotes
before the keymap for them was added, causing the ati_remote driver to
select the Medion Digitainer keymap instead. Unfortunately, the Medion
Digitainer keymap doesn't have the standard X10 up/down scancodes
assigned to KEY_UP and KEY_DOWN keycodes, making wrongly assigned
remotes mostly unusable.

Add the regular KEY_UP and KEY_DOWN scancodes to the Medion X10
Digitainer keymap, making any Medion remote mostly usable even when
wrongly used with that keymap (standard buttons, such as
up/down/left/right, 0-9, play/stop/pause, have the same scancode in all
the X10 remotes).

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/keymaps/rc-medion-x10-digitainer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
index 0a5ce84..966f9b3 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
@@ -86,6 +86,14 @@ static struct rc_map_table medion_x10_digitainer[] = {
 	{ 0x14, KEY_8 },
 	{ 0x15, KEY_9 },
 	{ 0x17, KEY_0 },
+
+	/* these do not actually exist on this remote, but these scancodes
+	 * exist on all other Medion X10 remotes and adding them here allows
+	 * such remotes to be adequately usable with this keymap in case
+	 * this keymap is wrongly used with them (which is quite possible as
+	 * there are lots of different Medion X10 remotes): */
+	{ 0x1a, KEY_UP },
+	{ 0x22, KEY_DOWN },
 };
 
 static struct rc_map_list medion_x10_digitainer_map = {
-- 
1.7.10

