Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:18438 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757719AbaEKLRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:17:38 -0400
Date: 11 May 2014 07:17:37 -0400
Message-ID: <20140511111737.15065.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 09/10] ati_remote: Add comments to keycode table
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A more detailed description of what the buttons look like and
their intended function makes it easier for people to maintain
this code without access to the hardware.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/keymaps/rc-ati-x10.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index 4e2cbbafe9..df8968eb1f 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -26,6 +26,17 @@
 #include <linux/module.h>
 #include <media/rc-map.h>
 
+/*
+ * Intended usage comments below are from vendor-supplied
+ * Source: ATI REMOTE WONDER™ Installation Guide
+ * http://www2.ati.com/manuals/remctrl.pdf
+ *
+ * Scancodes were in strict left-right, top-bottom order on the
+ * original ATI Remote Wonder, but were moved on later models.
+ *
+ * Keys A-F are intended to be user-programmable.
+ */
+
 static struct rc_map_table ati_x10[] = {
 	/* keyboard - Above the cursor pad */
 	{ 0x00, KEY_A },
@@ -35,9 +46,11 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x03, KEY_TV },         /* TV */
 	{ 0x04, KEY_DVD },        /* DVD */
 	{ 0x05, KEY_WWW },        /* WEB */
-	{ 0x06, KEY_BOOKMARKS },  /* "book" */
-	{ 0x07, KEY_EDIT },       /* "hand" */
-	/* Below the cursor pad */
+	{ 0x06, KEY_BOOKMARKS },  /* "book": Open Mdeia Library */
+	{ 0x07, KEY_EDIT },       /* "hand": Toggle left mouse button (grab) */
+
+	/* Mouse emulation pad goes here, handled by driver separately */
+
 	{ 0x09, KEY_VOLUMEDOWN }, /* VOL + */
 	{ 0x08, KEY_VOLUMEUP },   /* VOL - */
 	{ 0x0a, KEY_MUTE },       /* MUTE  */
@@ -53,9 +66,9 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x13, KEY_7 },
 	{ 0x14, KEY_8 },
 	{ 0x15, KEY_9 },
-	{ 0x16, KEY_MENU },       /* "menu" */
+	{ 0x16, KEY_MENU },       /* "menu": DVD root menu */
 	{ 0x17, KEY_0 },
-	{ 0x18, KEY_KPENTER },    /* "check" */
+	{ 0x18, KEY_KPENTER },    /* "check": DVD setup menu */
 
 	/* DVD navigation buttons */
 	{ 0x19, KEY_C },
@@ -72,13 +85,13 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x22, KEY_DOWN },       /* down */
 	{ 0x23, KEY_F },
 	/* Play/stop/pause buttons */
-	{ 0x24, KEY_REWIND },     /* (<<) */
-	{ 0x25, KEY_PLAY },       /* ( >) */
-	{ 0x26, KEY_FORWARD },    /* (>>) */
+	{ 0x24, KEY_REWIND },     /* (<<) Rewind */
+	{ 0x25, KEY_PLAY },       /* ( >) Play */
+	{ 0x26, KEY_FORWARD },    /* (>>) Fast forward */
 
 	{ 0x27, KEY_RECORD },     /* ( o) red */
-	{ 0x28, KEY_STOP },       /* ([]) */
-	{ 0x29, KEY_PAUSE },      /* ('') */
+	{ 0x28, KEY_STOP },       /* ([]) Stop */
+	{ 0x29, KEY_PAUSE },      /* ('') Pause */
 
 	/* Extra keys, not on the original ATI remote */
 	{ 0x2a, KEY_NEXT },       /* (>+) */
-- 
1.9.2

