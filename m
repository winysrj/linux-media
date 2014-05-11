Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:22387 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757805AbaEKLTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:19:02 -0400
Date: 11 May 2014 07:19:01 -0400
Message-ID: <20140511111901.15187.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 10/10] ati_remote: Better default keycodes
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This tries to make them more like other remotes, and/or
the button labels.

Notably, the (>>) button is made KEY_FASTFORWARD, which is the
correct opposite of (<<)'s KEY_REVERSE.  (It was KEY_FORWARD,
something else entirely.)

Likewise, KEY_STOP is the Sun keyboard "interrupt program" key;
the media key is KEY_STOPCD.

A restriction is that I try to avoid keycodes above 255, as the X11
client/server protocol is limited to 8-bit key codes.  If not for
this, I would have used the KEY_NUMERIC_x codes for the numbers.

Signed-off-by: George Spelvin <linux@horizon.com>
---
As mentioned earlier, this constitutes a user-visible kernel change and
thus possibly a regression, so it's probably a non-starter, but what the heck.

 drivers/media/rc/keymaps/rc-ati-x10.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index df8968eb1f..b924265b32 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -57,6 +57,11 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x0b, KEY_CHANNELUP },  /* CH + */
 	{ 0x0c, KEY_CHANNELDOWN },/* CH - */
 
+	/*
+	 * We could use KEY_NUMERIC_x for these, but the X11 protocol
+	 * has problems with keycodes greater than 255, so avoid those high
+	 * keycodes in default maps.
+	 */
 	{ 0x0d, KEY_1 },
 	{ 0x0e, KEY_2 },
 	{ 0x0f, KEY_3 },
@@ -67,39 +72,44 @@ static struct rc_map_table ati_x10[] = {
 	{ 0x14, KEY_8 },
 	{ 0x15, KEY_9 },
 	{ 0x16, KEY_MENU },       /* "menu": DVD root menu */
+				  /* KEY_NUMERIC_STAR? */
 	{ 0x17, KEY_0 },
-	{ 0x18, KEY_KPENTER },    /* "check": DVD setup menu */
+	{ 0x18, KEY_SETUP },      /* "check": DVD setup menu */
+				  /* KEY_NUMERIC_POUND? */
 
 	/* DVD navigation buttons */
 	{ 0x19, KEY_C },
 	{ 0x1a, KEY_UP },         /* up */
 	{ 0x1b, KEY_D },
 
-	{ 0x1c, KEY_COFFEE },     /* "timer" */
+	{ 0x1c, KEY_PROPS },      /* "timer" Should be Data On Screen */
+				  /* Symbol is "circle nailed to box" */
 	{ 0x1d, KEY_LEFT },       /* left */
 	{ 0x1e, KEY_OK },         /* "OK" */
 	{ 0x1f, KEY_RIGHT },      /* right */
-	{ 0x20, KEY_FRONT },      /* "max" */
-
+	{ 0x20, KEY_SCREEN },     /* "max" (X11 warning: 0x177) */
+				  /* Should be AC View Toggle, but
+				     that's not in <input/input.h>.
+				     KEY_ZOOM (0x174)? */
 	{ 0x21, KEY_E },
 	{ 0x22, KEY_DOWN },       /* down */
 	{ 0x23, KEY_F },
 	/* Play/stop/pause buttons */
 	{ 0x24, KEY_REWIND },     /* (<<) Rewind */
-	{ 0x25, KEY_PLAY },       /* ( >) Play */
-	{ 0x26, KEY_FORWARD },    /* (>>) Fast forward */
+	{ 0x25, KEY_PLAY },       /* ( >) Play (KEY_PLAYCD?) */
+	{ 0x26, KEY_FASTFORWARD }, /* (>>) Fast forward */
 
 	{ 0x27, KEY_RECORD },     /* ( o) red */
-	{ 0x28, KEY_STOP },       /* ([]) Stop */
-	{ 0x29, KEY_PAUSE },      /* ('') Pause */
+	{ 0x28, KEY_STOPCD },     /* ([]) Stop  (KEY_STOP is something else!) */
+	{ 0x29, KEY_PAUSE },      /* ('') Pause (KEY_PAUSECD?) */
 
 	/* Extra keys, not on the original ATI remote */
 	{ 0x2a, KEY_NEXT },       /* (>+) */
 	{ 0x2b, KEY_PREVIOUS },   /* (<-) */
-	{ 0x2d, KEY_INFO },       /* PLAYING */
+	{ 0x2d, KEY_INFO },       /* PLAYING  (X11 warning: 0x166) */
 	{ 0x2e, KEY_HOME },       /* TOP */
 	{ 0x2f, KEY_END },        /* END */
-	{ 0x30, KEY_SELECT },     /* SELECT */
+	{ 0x30, KEY_SELECT },     /* SELECT  (X11 warning: 0x161) */
 };
 
 static struct rc_map_list ati_x10_map = {
-- 
1.9.2

