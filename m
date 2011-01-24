Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab1AXPTM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:19:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJBfB030947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:19:11 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARl027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:19:10 -0500
Date: Mon, 24 Jan 2011 13:18:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/13] [media] rc-rc5-hauppauge-new: Fix Hauppauge Grey
 mapping
Message-ID: <20110124131845.5801dadd@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The keys for the old black were messed with the ones for the
hauppauge grey. Fix it.

Also, fixes some keycodes and order the keys according with
the way they appear inside the remote controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index 4106008..cb312da 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -24,61 +24,67 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	 * Remote Controller Hauppauge Gray found on modern devices
 	 * Keycodes start with address = 0x1e
 	 */
-	/* Keys 0 to 9 */
-	{ 0x1e00, KEY_0 },
+
+	{ 0x1e3b, KEY_SELECT },		/* GO / house symbol */
+	{ 0x1e3d, KEY_POWER2 },		/* system power (green button) */
+
+	{ 0x1e1c, KEY_TV },
+	{ 0x1e18, KEY_VIDEO },		/* Videos */
+	{ 0x1e19, KEY_AUDIO },		/* Music */
+	{ 0x1e1a, KEY_CAMERA },		/* Pictures */
+
+	{ 0x1e1b, KEY_EPG },		/* Guide */
+	{ 0x1e0c, KEY_RADIO },
+
+	{ 0x1e14, KEY_UP },
+	{ 0x1e15, KEY_DOWN },
+	{ 0x1e16, KEY_LEFT },
+	{ 0x1e17, KEY_RIGHT },
+	{ 0x1e25, KEY_OK },		/* OK */
+
+	{ 0x1e1f, KEY_EXIT },		/* back/exit */
+	{ 0x1e0d, KEY_MENU },
+
+	{ 0x1e10, KEY_VOLUMEUP },
+	{ 0x1e11, KEY_VOLUMEDOWN },
+
+	{ 0x1e12, KEY_PREVIOUS },	/* previous channel */
+	{ 0x1e0f, KEY_MUTE },
+
+	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
+
+	{ 0x1e37, KEY_RECORD },		/* recording */
+	{ 0x1e36, KEY_STOP },
+
+	{ 0x1e32, KEY_REWIND },		/* backward << */
+	{ 0x1e35, KEY_PLAY },
+	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
+
+	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
+	{ 0x1e30, KEY_PAUSE },		/* pause */
+	{ 0x1e1e, KEY_NEXTSONG },	/* skip >| */
+
 	{ 0x1e01, KEY_1 },
 	{ 0x1e02, KEY_2 },
 	{ 0x1e03, KEY_3 },
+
 	{ 0x1e04, KEY_4 },
 	{ 0x1e05, KEY_5 },
 	{ 0x1e06, KEY_6 },
+
 	{ 0x1e07, KEY_7 },
 	{ 0x1e08, KEY_8 },
 	{ 0x1e09, KEY_9 },
 
 	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
+	{ 0x1e00, KEY_0 },
+	{ 0x1e0e, KEY_SUBTITLE },	/* also the Pound key (#) */
+
 	{ 0x1e0b, KEY_RED },		/* red button */
-	{ 0x1e0c, KEY_RADIO },
-	{ 0x1e0d, KEY_MENU },
-	{ 0x1e0e, KEY_SUBTITLE },		/* also the # key */
-	{ 0x1e0f, KEY_MUTE },
-	{ 0x1e10, KEY_VOLUMEUP },
-	{ 0x1e11, KEY_VOLUMEDOWN },
-	{ 0x1e12, KEY_PREVIOUS },		/* previous channel */
-	{ 0x1e14, KEY_UP },
-	{ 0x1e15, KEY_DOWN },
-	{ 0x1e16, KEY_LEFT },
-	{ 0x1e17, KEY_RIGHT },
-	{ 0x1e18, KEY_VCR },		/* Videos */
-	{ 0x1e19, KEY_AUDIO },		/* Music */
-	/* 0x1e1a: Pictures - presume this means
-	   "Multimedia Home Platform" -
-	   no "PICTURES" key in input.h
-	 */
-	{ 0x1e1a, KEY_CAMERA },
-
-	{ 0x1e1b, KEY_EPG },		/* Guide */
-	{ 0x1e1c, KEY_TV },
-	{ 0x1e1e, KEY_NEXTSONG },		/* skip >| */
-	{ 0x1e1f, KEY_EXIT },		/* back/exit */
-	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1e22, KEY_VIDEO },		/* source (old black remote) */
-	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
-	{ 0x1e25, KEY_ENTER },		/* OK */
-	{ 0x1e26, KEY_SLEEP },		/* minimize (old black remote) */
-	{ 0x1e29, KEY_BLUE },		/* blue key */
 	{ 0x1e2e, KEY_GREEN },		/* green button */
-	{ 0x1e30, KEY_PAUSE },		/* pause */
-	{ 0x1e32, KEY_REWIND },		/* backward << */
-	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x1e35, KEY_PLAY },
-	{ 0x1e36, KEY_STOP },
-	{ 0x1e37, KEY_RECORD },		/* recording */
 	{ 0x1e38, KEY_YELLOW },		/* yellow key */
-	{ 0x1e3b, KEY_SELECT },		/* top right button */
-	{ 0x1e3c, KEY_ZOOM },		/* full */
-	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
+	{ 0x1e29, KEY_BLUE },		/* blue key */
 
 	/*
 	 * Old Remote Controller Hauppauge Gray with a golden screen
-- 
1.7.1


