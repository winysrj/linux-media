Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1AXP0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:21 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFQLqP017355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:26:21 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARs027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:26:20 -0500
Date: Mon, 24 Jan 2011 13:18:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/13] [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
Message-ID: <20110124131839.766969d3@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Using xev and testing the "Windows" key on a normal keyboard, it
is mapped as KEY_LEFTMETA. So, as this is the standard code for
it, use it, instead of a generic, meaningless KEY_PROG1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index cb67184..937a819 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -111,7 +111,7 @@ static struct rc_map_table imon_mce[] = {
 	{ 0x800ff44d, KEY_TITLE },
 
 	{ 0x800ff40c, KEY_POWER },
-	{ 0x800ff40d, KEY_PROG1 }, /* Windows MCE button */
+	{ 0x800ff40d, KEY_LEFTMETA }, /* Windows MCE button */
 
 };
 
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index eef46b7..63d42bd 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -125,7 +125,7 @@ static struct rc_map_table imon_pad[] = {
 	{ 0x2b8195b7, KEY_CONTEXT_MENU }, /* Left Menu*/
 	{ 0x02000065, KEY_COMPOSE }, /* RightMenu */
 	{ 0x28b715b7, KEY_COMPOSE }, /* RightMenu */
-	{ 0x2ab195b7, KEY_PROG1 }, /* Go or MultiMon */
+	{ 0x2ab195b7, KEY_LEFTMETA }, /* Go or MultiMon */
 	{ 0x29b715b7, KEY_DASHBOARD }, /* AppLauncher */
 };
 
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index e45f0b8..08d1831 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -17,7 +17,7 @@
  */
 
 static struct rc_map_table kworld_plus_tv_analog[] = {
-	{ 0x0c, KEY_PROG1 },		/* Kworld key */
+	{ 0x0c, KEY_LEFTMETA },		/* Kworld key */
 	{ 0x16, KEY_CLOSECD },		/* -> ) */
 	{ 0x1d, KEY_POWER2 },
 
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 3bf3337..eb90ad7 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -27,7 +27,7 @@ static struct rc_map_table rc6_mce[] = {
 	{ 0x800f040a, KEY_DELETE },
 	{ 0x800f040b, KEY_ENTER },
 	{ 0x800f040c, KEY_POWER },		/* PC Power */
-	{ 0x800f040d, KEY_PROG1 },		/* Windows MCE button */
+	{ 0x800f040d, KEY_LEFTMETA },		/* Windows MCE button */
 	{ 0x800f040e, KEY_MUTE },
 	{ 0x800f040f, KEY_INFO },
 
-- 
1.7.1


