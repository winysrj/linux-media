Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:33721 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbcBIIJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 03:09:39 -0500
From: Philippe Valembois <lephilousophe@users.sourceforge.net>
Cc: Philippe Valembois <lephilousophe@users.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Fix AverMedia RM-KS remote keymap
Date: Tue,  9 Feb 2016 09:09:32 +0100
Message-Id: <1455005372-25546-1-git-send-email-lephilousophe@users.sourceforge.net>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix AverMedia RM-KS keymap using user guide to meet LinuxTV wiki rules.
The remote command didn't seem to change in itself since its creation: it's
just to make keys more standard and remove the FIXME.

Signed-off-by: Philippe Valembois <lephilousophe@users.sourceforge.net>
---
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c | 56 +++++++++++++--------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 8344bcc..2583400 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -23,35 +23,35 @@
 
 /* Initial keytable is from Jose Alberto Reguero <jareguero@telefonica.net>
    and Felipe Morales Moreno <felipe.morales.moreno@gmail.com> */
-/* FIXME: mappings are not 100% correct? */
+/* Keytable fixed by Philippe Valembois <lephilousophe@users.sourceforge.net> */
 static struct rc_map_table avermedia_rm_ks[] = {
-	{ 0x0501, KEY_POWER2 },
-	{ 0x0502, KEY_CHANNELUP },
-	{ 0x0503, KEY_CHANNELDOWN },
-	{ 0x0504, KEY_VOLUMEUP },
-	{ 0x0505, KEY_VOLUMEDOWN },
-	{ 0x0506, KEY_MUTE },
-	{ 0x0507, KEY_RIGHT },
-	{ 0x0508, KEY_RED },
-	{ 0x0509, KEY_1 },
-	{ 0x050a, KEY_2 },
-	{ 0x050b, KEY_3 },
-	{ 0x050c, KEY_4 },
-	{ 0x050d, KEY_5 },
-	{ 0x050e, KEY_6 },
-	{ 0x050f, KEY_7 },
-	{ 0x0510, KEY_8 },
-	{ 0x0511, KEY_9 },
-	{ 0x0512, KEY_0 },
-	{ 0x0513, KEY_AUDIO },
-	{ 0x0515, KEY_EPG },
-	{ 0x0516, KEY_PLAY },
-	{ 0x0517, KEY_RECORD },
-	{ 0x0518, KEY_STOP },
-	{ 0x051c, KEY_BACK },
-	{ 0x051d, KEY_FORWARD },
-	{ 0x054d, KEY_LEFT },
-	{ 0x0556, KEY_ZOOM },
+	{ 0x0501, KEY_POWER2 }, /* Power (RED POWER BUTTON) */
+	{ 0x0502, KEY_CHANNELUP }, /* Channel+ */
+	{ 0x0503, KEY_CHANNELDOWN }, /* Channel- */
+	{ 0x0504, KEY_VOLUMEUP }, /* Volume+ */
+	{ 0x0505, KEY_VOLUMEDOWN }, /* Volume- */
+	{ 0x0506, KEY_MUTE }, /* Mute */
+	{ 0x0507, KEY_AGAIN }, /* Recall */
+	{ 0x0508, KEY_VIDEO }, /* Source */
+	{ 0x0509, KEY_1 }, /* 1 */
+	{ 0x050a, KEY_2 }, /* 2 */
+	{ 0x050b, KEY_3 }, /* 3 */
+	{ 0x050c, KEY_4 }, /* 4 */
+	{ 0x050d, KEY_5 }, /* 5 */
+	{ 0x050e, KEY_6 }, /* 6 */
+	{ 0x050f, KEY_7 }, /* 7 */
+	{ 0x0510, KEY_8 }, /* 8 */
+	{ 0x0511, KEY_9 }, /* 9 */
+	{ 0x0512, KEY_0 }, /* 0 */
+	{ 0x0513, KEY_AUDIO }, /* Audio */
+	{ 0x0515, KEY_EPG }, /* EPG */
+	{ 0x0516, KEY_PLAYPAUSE }, /* Play/Pause */
+	{ 0x0517, KEY_RECORD }, /* Record */
+	{ 0x0518, KEY_STOP }, /* Stop */
+	{ 0x051c, KEY_BACK }, /* << */
+	{ 0x051d, KEY_FORWARD }, /* >> */
+	{ 0x054d, KEY_INFO }, /* Display information */
+	{ 0x0556, KEY_ZOOM }, /* Fullscreen */
 };
 
 static struct rc_map_list avermedia_rm_ks_map = {
-- 
2.5.0

