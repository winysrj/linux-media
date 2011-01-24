Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1AXPYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:24:19 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFOIsq027441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:24:19 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARq027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:24:17 -0500
Date: Mon, 24 Jan 2011 13:18:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/13] [media] rc/keymaps: Use KEY_VIDEO for Video Source
Message-ID: <20110124131837.199000df@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Each keyboard map were using a different definition for
the Source/Video Source key.
Behold Columbus were the only one using KEY_PROPS.

As we want to standardize those keys at X11 and at
userspace applications, we need to use just one code
for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index 3ddb41b..c25809d 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -26,12 +26,12 @@ static struct rc_map_table avermedia_dvbt[] = {
 	{ 0x16, KEY_8 },		/* '8' / 'down arrow' */
 	{ 0x36, KEY_9 },		/* '9' */
 
-	{ 0x20, KEY_LIST },		/* 'source' */
+	{ 0x20, KEY_VIDEO },		/* 'source' */
 	{ 0x10, KEY_TEXT },		/* 'teletext' */
 	{ 0x00, KEY_POWER },		/* 'power' */
 	{ 0x04, KEY_AUDIO },		/* 'audio' */
 	{ 0x06, KEY_ZOOM },		/* 'full screen' */
-	{ 0x18, KEY_VIDEO },		/* 'display' */
+	{ 0x18, KEY_SWITCHVIDEOMODE },	/* 'display' */
 	{ 0x38, KEY_SEARCH },		/* 'loop' */
 	{ 0x08, KEY_INFO },		/* 'preview' */
 	{ 0x2a, KEY_REWIND },		/* 'backward <<' */
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 4b787fa..8bf058f 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -28,7 +28,7 @@ static struct rc_map_table behold_columbus[] = {
 	 *                             */
 
 	{ 0x13, KEY_MUTE },
-	{ 0x11, KEY_PROPS },
+	{ 0x11, KEY_VIDEO },
 	{ 0x1C, KEY_TUNER },	/* KEY_TV/KEY_RADIO	*/
 	{ 0x12, KEY_POWER },
 
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 0ee1f14..c909a23 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -97,7 +97,7 @@ static struct rc_map_table behold[] = {
 	{ 0x6b861a, KEY_STOP },
 	{ 0x6b860e, KEY_TEXT },
 	{ 0x6b861f, KEY_RED },	/*XXX KEY_AUDIO	*/
-	{ 0x6b861e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
+	{ 0x6b861e, KEY_VIDEO },
 
 	/*  0x1d   0x13     0x19  *
 	 * SLEEP  PREVIEW   DVB   *
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 43912bd..82c0200 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -32,7 +32,7 @@ static struct rc_map_table dntv_live_dvb_t[] = {
 	{ 0x0c, KEY_SEARCH },		/* scan */
 	{ 0x0d, KEY_STOP },
 	{ 0x0e, KEY_PAUSE },
-	{ 0x0f, KEY_LIST },		/* source */
+	{ 0x0f, KEY_VIDEO },		/* source */
 
 	{ 0x10, KEY_MUTE },
 	{ 0x11, KEY_REWIND },		/* backward << */
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index 7d5b00e..b6264f1 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -32,7 +32,7 @@ static struct rc_map_table encore_enltv2[] = {
 	{ 0x64, KEY_LAST },		/* +100 */
 	{ 0x4e, KEY_AGAIN },		/* Recall */
 
-	{ 0x6c, KEY_SWITCHVIDEOMODE },	/* Video Source */
+	{ 0x6c, KEY_VIDEO },		/* Video Source */
 	{ 0x5e, KEY_MENU },
 	{ 0x56, KEY_SCREEN },
 	{ 0x7a, KEY_SETUP },
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index aea2f4a..a8b0f66 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -37,8 +37,8 @@ static struct rc_map_table flydvb[] = {
 	{ 0x13, KEY_CHANNELDOWN },	/* CH- */
 	{ 0x1d, KEY_ENTER },		/* Enter */
 
-	{ 0x1a, KEY_MODE },		/* PIP */
-	{ 0x18, KEY_TUNER },		/* Source */
+	{ 0x1a, KEY_TV2 },		/* PIP */
+	{ 0x18, KEY_VIDEO },		/* Source */
 
 	{ 0x1e, KEY_RECORD },		/* Record/Pause */
 	{ 0x15, KEY_ANGLE },		/* Swap (no label on key) */
diff --git a/drivers/media/rc/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
index b6a12fe..44f3283 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge-new.c
@@ -42,7 +42,7 @@ static struct rc_map_table hauppauge_new[] = {
 	{ 0x15, KEY_DOWN },
 	{ 0x16, KEY_LEFT },
 	{ 0x17, KEY_RIGHT },
-	{ 0x18, KEY_VIDEO },		/* Videos */
+	{ 0x18, KEY_VCR },		/* Videos */
 	{ 0x19, KEY_AUDIO },		/* Music */
 	/* 0x1a: Pictures - presume this means
 	   "Multimedia Home Platform" -
@@ -56,7 +56,7 @@ static struct rc_map_table hauppauge_new[] = {
 	{ 0x1f, KEY_EXIT },		/* back/exit */
 	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
 	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x22, KEY_CHANNEL },		/* source (old black remote) */
+	{ 0x22, KEY_VIDEO },		/* source (old black remote) */
 	{ 0x24, KEY_PREVIOUSSONG },	/* replay |< */
 	{ 0x25, KEY_ENTER },		/* OK */
 	{ 0x26, KEY_SLEEP },		/* minimize (old black remote) */
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index 3ce6ef7..7f33edb 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -17,7 +17,7 @@
 
 static struct rc_map_table kworld_315u[] = {
 	{ 0x6143, KEY_POWER },
-	{ 0x6101, KEY_TUNER },		/* source */
+	{ 0x6101, KEY_VIDEO },		/* source */
 	{ 0x610b, KEY_ZOOM },
 	{ 0x6103, KEY_POWER2 },		/* shutdown */
 
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index fa8fd0a..8e9969d 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -62,7 +62,7 @@ static struct rc_map_table msi_tvanywhere_plus[] = {
 	{ 0x13, KEY_AGAIN },		/* Recall */
 
 	{ 0x1e, KEY_POWER },		/* Power */
-	{ 0x07, KEY_TUNER },		/* Source */
+	{ 0x07, KEY_VIDEO },		/* Source */
 	{ 0x1c, KEY_SEARCH },		/* Scan */
 	{ 0x18, KEY_MUTE },		/* Mute */
 
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index 629ee9d..f1c1281 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -29,7 +29,7 @@ static struct rc_map_table norwood[] = {
 	{ 0x28, KEY_8 },
 	{ 0x29, KEY_9 },
 
-	{ 0x78, KEY_TUNER },		/* Video Source        */
+	{ 0x78, KEY_VIDEO },		/* Video Source        */
 	{ 0x2c, KEY_EXIT },		/* Open/Close software */
 	{ 0x2a, KEY_SELECT },		/* 2 Digit Select      */
 	{ 0x69, KEY_AGAIN },		/* Recall              */
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index fa5ae59..7cdef6e 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -36,7 +36,7 @@ static struct rc_map_table pctv_sedna[] = {
 	{ 0x0e, KEY_STOP },
 	{ 0x0f, KEY_PREVIOUSSONG },
 	{ 0x10, KEY_ZOOM },
-	{ 0x11, KEY_TUNER },	/* Source */
+	{ 0x11, KEY_VIDEO },	/* Source */
 	{ 0x12, KEY_POWER },
 	{ 0x13, KEY_MUTE },
 	{ 0x15, KEY_CHANNELDOWN },
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 8d9f664..125fc39 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -34,7 +34,7 @@ static struct rc_map_table pixelview_mk12[] = {
 	{ 0x866b13, KEY_AGAIN },	/* loop */
 	{ 0x866b10, KEY_DIGITS },	/* +100 */
 
-	{ 0x866b00, KEY_MEDIA },	/* source */
+	{ 0x866b00, KEY_VIDEO },		/* source */
 	{ 0x866b18, KEY_MUTE },		/* mute */
 	{ 0x866b19, KEY_CAMERA },	/* snapshot */
 	{ 0x866b1a, KEY_SEARCH },	/* scan */
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index 777a700..bd78d6a 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -33,7 +33,7 @@ static struct rc_map_table pixelview_new[] = {
 	{ 0x3e, KEY_0 },
 
 	{ 0x1c, KEY_AGAIN },		/* LOOP	*/
-	{ 0x3f, KEY_MEDIA },		/* Source */
+	{ 0x3f, KEY_VIDEO },		/* Source */
 	{ 0x1f, KEY_LAST },		/* +100 */
 	{ 0x1b, KEY_MUTE },
 
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 0ec5988..06187e7 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -15,7 +15,7 @@
 static struct rc_map_table pixelview[] = {
 
 	{ 0x1e, KEY_POWER },	/* power */
-	{ 0x07, KEY_MEDIA },	/* source */
+	{ 0x07, KEY_VIDEO },	/* source */
 	{ 0x1c, KEY_SEARCH },	/* scan */
 
 
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 83a418d..5e8beee 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -46,10 +46,10 @@ static struct rc_map_table pv951[] = {
 	{ 0x0c, KEY_SEARCH },		/* AUTOSCAN */
 
 	/* Not sure what to do with these ones! */
-	{ 0x0f, KEY_SELECT },		/* SOURCE */
+	{ 0x0f, KEY_VIDEO },		/* SOURCE */
 	{ 0x0a, KEY_KPPLUS },		/* +100 */
 	{ 0x14, KEY_EQUAL },		/* SYNC */
-	{ 0x1c, KEY_MEDIA },		/* PC/TV */
+	{ 0x1c, KEY_TV },		/* PC/TV */
 };
 
 static struct rc_map_list pv951_map = {
diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index 2ca825b..a581c86 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -45,7 +45,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1e15, KEY_DOWN },
 	{ 0x1e16, KEY_LEFT },
 	{ 0x1e17, KEY_RIGHT },
-	{ 0x1e18, KEY_VIDEO },		/* Videos */
+	{ 0x1e18, KEY_VCR },		/* Videos */
 	{ 0x1e19, KEY_AUDIO },		/* Music */
 	/* 0x1e1a: Pictures - presume this means
 	   "Multimedia Home Platform" -
@@ -59,7 +59,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1e1f, KEY_EXIT },		/* back/exit */
 	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
 	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1e22, KEY_CHANNEL },		/* source (old black remote) */
+	{ 0x1e22, KEY_VIDEO },		/* source (old black remote) */
 	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
 	{ 0x1e25, KEY_ENTER },		/* OK */
 	{ 0x1e26, KEY_SLEEP },		/* minimize (old black remote) */
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 2d14598..6813d11 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -35,7 +35,7 @@ static struct rc_map_table real_audio_220_32_keys[] = {
 	{ 0x15, KEY_CHANNELDOWN},
 	{ 0x16, KEY_ENTER},
 
-	{ 0x11, KEY_LIST},		/* Source */
+	{ 0x11, KEY_VIDEO},		/* Source */
 	{ 0x0d, KEY_AUDIO},		/* stereo */
 
 	{ 0x0f, KEY_PREVIOUS},		/* Prev */
-- 
1.7.1


