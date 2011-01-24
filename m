Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1AXPca (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:32:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFWUfw001057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:32:30 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJAS0027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:32:29 -0500
Date: Mon, 24 Jan 2011 13:18:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/13] [media] rc-rc5-hauppauge-new: Add support for the old
 Black RC
Message-ID: <20110124131844.541ad787@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans borrowed me an old Black Hauppauge RC. Thanks to that, we
can fix the RC5 table for Hauppauge.

Thanks-to: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index dcbf3bd..4106008 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -82,7 +82,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 
 	/*
 	 * Old Remote Controller Hauppauge Gray with a golden screen
-	 * Keycodes start with address = 0x1d
+	 * Keycodes start with address = 0x1f
 	 */
 	{ 0x1f3d, KEY_POWER2 },		/* system power (green button) */
 	{ 0x1f3b, KEY_SELECT },		/* GO */
@@ -130,6 +130,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 
 	/*
 	 * Keycodes for DSR-0112 remote bundled with Haupauge MiniStick
+	 * Keycodes start with address = 0x1d
 	 */
 	{ 0x1d00, KEY_0 },
 	{ 0x1d01, KEY_1 },
@@ -167,6 +168,39 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1d3b, KEY_GOTO },
 	{ 0x1d3d, KEY_POWER },
 	{ 0x1d3f, KEY_HOME },
+
+	/*
+	 * Keycodes for the old Black Remote Controller
+	 * This one also uses RC-5 protocol
+	 * Keycodes start with address = 0x00
+	 */
+	{ 0x001f, KEY_TV },
+	{ 0x0020, KEY_CHANNELUP },
+	{ 0x000c, KEY_RADIO },
+
+	{ 0x0011, KEY_VOLUMEDOWN },
+	{ 0x002e, KEY_ZOOM },		/* full screen */
+	{ 0x0010, KEY_VOLUMEUP },
+
+	{ 0x000d, KEY_MUTE },
+	{ 0x0021, KEY_CHANNELDOWN },
+	{ 0x0022, KEY_VIDEO },		/* source */
+
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
+	{ 0x0003, KEY_3 },
+
+	{ 0x0004, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0006, KEY_6 },
+
+	{ 0x0007, KEY_7 },
+	{ 0x0008, KEY_8 },
+	{ 0x0009, KEY_9 },
+
+	{ 0x001e, KEY_RED },	/* Reserved */
+	{ 0x0000, KEY_0 },
+	{ 0x0026, KEY_SLEEP },	/* Minimize */
 };
 
 static struct rc_map_list rc5_hauppauge_new_map = {
-- 
1.7.1


