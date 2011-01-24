Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1AXPb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:31:29 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFVSAV000892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:31:28 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARx027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:31:28 -0500
Date: Mon, 24 Jan 2011 13:18:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/13] [media] rc-rc5-hauppauge-new: Add the old control to
 the table
Message-ID: <20110124131843.28709b42@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adds the old grey remote controller to Hauppauge table.

Hans borrowed me an old gray Hauppauge RC. Thanks to that, we
can fix the RC5 table for Hauppauge.

Thanks-to: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index a581c86..dcbf3bd 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -20,6 +20,10 @@
  */
 
 static struct rc_map_table rc5_hauppauge_new[] = {
+	/*
+	 * Remote Controller Hauppauge Gray found on modern devices
+	 * Keycodes start with address = 0x1e
+	 */
 	/* Keys 0 to 9 */
 	{ 0x1e00, KEY_0 },
 	{ 0x1e01, KEY_1 },
@@ -76,7 +80,57 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1e3c, KEY_ZOOM },		/* full */
 	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
 
-	/* Keycodes for DSR-0112 remote bundled with Haupauge MiniStick */
+	/*
+	 * Old Remote Controller Hauppauge Gray with a golden screen
+	 * Keycodes start with address = 0x1d
+	 */
+	{ 0x1f3d, KEY_POWER2 },		/* system power (green button) */
+	{ 0x1f3b, KEY_SELECT },		/* GO */
+
+	/* Keys 0 to 9 */
+	{ 0x1f00, KEY_0 },
+	{ 0x1f01, KEY_1 },
+	{ 0x1f02, KEY_2 },
+	{ 0x1f03, KEY_3 },
+	{ 0x1f04, KEY_4 },
+	{ 0x1f05, KEY_5 },
+	{ 0x1f06, KEY_6 },
+	{ 0x1f07, KEY_7 },
+	{ 0x1f08, KEY_8 },
+	{ 0x1f09, KEY_9 },
+
+	{ 0x1f1f, KEY_EXIT },		/* back/exit */
+	{ 0x1f0d, KEY_MENU },
+
+	{ 0x1f10, KEY_VOLUMEUP },
+	{ 0x1f11, KEY_VOLUMEDOWN },
+	{ 0x1f20, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1f21, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x1f25, KEY_ENTER },		/* OK */
+
+	{ 0x1f0b, KEY_RED },		/* red button */
+	{ 0x1f2e, KEY_GREEN },		/* green button */
+	{ 0x1f38, KEY_YELLOW },		/* yellow key */
+	{ 0x1f29, KEY_BLUE },		/* blue key */
+
+	{ 0x1f0f, KEY_MUTE },
+	{ 0x1f0c, KEY_RADIO },		/* There's no indicator on this key */
+	{ 0x1f3c, KEY_ZOOM },		/* full */
+
+	{ 0x1f32, KEY_REWIND },		/* backward << */
+	{ 0x1f35, KEY_PLAY },
+	{ 0x1f34, KEY_FASTFORWARD },	/* forward >> */
+
+	{ 0x1f37, KEY_RECORD },		/* recording */
+	{ 0x1f36, KEY_STOP },
+	{ 0x1f30, KEY_PAUSE },		/* pause */
+
+	{ 0x1f24, KEY_PREVIOUSSONG },	/* replay |< */
+	{ 0x1f1e, KEY_NEXTSONG },	/* skip >| */
+
+	/*
+	 * Keycodes for DSR-0112 remote bundled with Haupauge MiniStick
+	 */
 	{ 0x1d00, KEY_0 },
 	{ 0x1d01, KEY_1 },
 	{ 0x1d02, KEY_2 },
-- 
1.7.1


