Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:23079 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757719AbaEKLQ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:16:57 -0400
Date: 11 May 2014 07:16:56 -0400
Message-ID: <20140511111656.14985.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 08/10] ati_remote: Sort buttons in top-to-bottom order
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since numerical order corresponds to top-left-to-bottom-right
order on the remote, this makes the table easier to read.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/keymaps/rc-ati-x10.c | 57 +++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index 81506440ed..4e2cbbafe9 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -27,6 +27,23 @@
 #include <media/rc-map.h>
 
 static struct rc_map_table ati_x10[] = {
+	/* keyboard - Above the cursor pad */
+	{ 0x00, KEY_A },
+	{ 0x01, KEY_B },
+	{ 0x02, KEY_POWER },      /* Power */
+
+	{ 0x03, KEY_TV },         /* TV */
+	{ 0x04, KEY_DVD },        /* DVD */
+	{ 0x05, KEY_WWW },        /* WEB */
+	{ 0x06, KEY_BOOKMARKS },  /* "book" */
+	{ 0x07, KEY_EDIT },       /* "hand" */
+	/* Below the cursor pad */
+	{ 0x09, KEY_VOLUMEDOWN }, /* VOL + */
+	{ 0x08, KEY_VOLUMEUP },   /* VOL - */
+	{ 0x0a, KEY_MUTE },       /* MUTE  */
+	{ 0x0b, KEY_CHANNELUP },  /* CH + */
+	{ 0x0c, KEY_CHANNELDOWN },/* CH - */
+
 	{ 0x0d, KEY_1 },
 	{ 0x0e, KEY_2 },
 	{ 0x0f, KEY_3 },
@@ -36,42 +53,36 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x13, KEY_7 },
 	{ 0x14, KEY_8 },
 	{ 0x15, KEY_9 },
+	{ 0x16, KEY_MENU },       /* "menu" */
 	{ 0x17, KEY_0 },
-	{ 0x00, KEY_A },
-	{ 0x01, KEY_B },
+	{ 0x18, KEY_KPENTER },    /* "check" */
+
+	/* DVD navigation buttons */
 	{ 0x19, KEY_C },
+	{ 0x1a, KEY_UP },         /* up */
 	{ 0x1b, KEY_D },
-	{ 0x21, KEY_E },
-	{ 0x23, KEY_F },
 
-	{ 0x18, KEY_KPENTER },    /* "check" */
-	{ 0x16, KEY_MENU },       /* "menu" */
-	{ 0x02, KEY_POWER },      /* Power */
-	{ 0x03, KEY_TV },         /* TV */
-	{ 0x04, KEY_DVD },        /* DVD */
-	{ 0x05, KEY_WWW },        /* WEB */
-	{ 0x06, KEY_BOOKMARKS },  /* "book" */
-	{ 0x07, KEY_EDIT },       /* "hand" */
 	{ 0x1c, KEY_COFFEE },     /* "timer" */
-	{ 0x20, KEY_FRONT },      /* "max" */
 	{ 0x1d, KEY_LEFT },       /* left */
+	{ 0x1e, KEY_OK },         /* "OK" */
 	{ 0x1f, KEY_RIGHT },      /* right */
+	{ 0x20, KEY_FRONT },      /* "max" */
+
+	{ 0x21, KEY_E },
 	{ 0x22, KEY_DOWN },       /* down */
-	{ 0x1a, KEY_UP },         /* up */
-	{ 0x1e, KEY_OK },         /* "OK" */
-	{ 0x09, KEY_VOLUMEDOWN }, /* VOL + */
-	{ 0x08, KEY_VOLUMEUP },   /* VOL - */
-	{ 0x0a, KEY_MUTE },       /* MUTE  */
-	{ 0x0b, KEY_CHANNELUP },  /* CH + */
-	{ 0x0c, KEY_CHANNELDOWN },/* CH - */
-	{ 0x27, KEY_RECORD },     /* ( o) red */
-	{ 0x25, KEY_PLAY },       /* ( >) */
+	{ 0x23, KEY_F },
+	/* Play/stop/pause buttons */
 	{ 0x24, KEY_REWIND },     /* (<<) */
+	{ 0x25, KEY_PLAY },       /* ( >) */
 	{ 0x26, KEY_FORWARD },    /* (>>) */
+
+	{ 0x27, KEY_RECORD },     /* ( o) red */
 	{ 0x28, KEY_STOP },       /* ([]) */
 	{ 0x29, KEY_PAUSE },      /* ('') */
-	{ 0x2b, KEY_PREVIOUS },   /* (<-) */
+
+	/* Extra keys, not on the original ATI remote */
 	{ 0x2a, KEY_NEXT },       /* (>+) */
+	{ 0x2b, KEY_PREVIOUS },   /* (<-) */
 	{ 0x2d, KEY_INFO },       /* PLAYING */
 	{ 0x2e, KEY_HOME },       /* TOP */
 	{ 0x2f, KEY_END },        /* END */
-- 
1.9.2

