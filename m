Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1ALQ3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 11:29:55 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0CGTt15019453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 11:29:55 -0500
Received: from pedra (vpn-234-205.phx2.redhat.com [10.3.234.205])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0CGSqZQ001348
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 11:29:54 -0500
Date: Wed, 12 Jan 2011 16:28:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] rc-dib0700-nec: Fix keytable for Pixelview
 SBTVD
Message-ID: <20110112162846.4787d116@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

dib0700 now outputs NEC extended keycodes. Fix the keytable to reflect that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index c59851b..7a5f530 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -19,35 +19,35 @@
 
 static struct rc_map_table dib0700_nec_table[] = {
 	/* Key codes for the Pixelview SBTVD remote */
-	{ 0x8613, KEY_MUTE },
-	{ 0x8612, KEY_POWER },
-	{ 0x8601, KEY_1 },
-	{ 0x8602, KEY_2 },
-	{ 0x8603, KEY_3 },
-	{ 0x8604, KEY_4 },
-	{ 0x8605, KEY_5 },
-	{ 0x8606, KEY_6 },
-	{ 0x8607, KEY_7 },
-	{ 0x8608, KEY_8 },
-	{ 0x8609, KEY_9 },
-	{ 0x8600, KEY_0 },
-	{ 0x860d, KEY_CHANNELUP },
-	{ 0x8619, KEY_CHANNELDOWN },
-	{ 0x8610, KEY_VOLUMEUP },
-	{ 0x860c, KEY_VOLUMEDOWN },
+	{ 0x866b13, KEY_MUTE },
+	{ 0x866b12, KEY_POWER },
+	{ 0x866b01, KEY_1 },
+	{ 0x866b02, KEY_2 },
+	{ 0x866b03, KEY_3 },
+	{ 0x866b04, KEY_4 },
+	{ 0x866b05, KEY_5 },
+	{ 0x866b06, KEY_6 },
+	{ 0x866b07, KEY_7 },
+	{ 0x866b08, KEY_8 },
+	{ 0x866b09, KEY_9 },
+	{ 0x866b00, KEY_0 },
+	{ 0x866b0d, KEY_CHANNELUP },
+	{ 0x866b19, KEY_CHANNELDOWN },
+	{ 0x866b10, KEY_VOLUMEUP },
+	{ 0x866b0c, KEY_VOLUMEDOWN },
 
-	{ 0x860a, KEY_CAMERA },
-	{ 0x860b, KEY_ZOOM },
-	{ 0x861b, KEY_BACKSPACE },
-	{ 0x8615, KEY_ENTER },
+	{ 0x866b0a, KEY_CAMERA },
+	{ 0x866b0b, KEY_ZOOM },
+	{ 0x866b1b, KEY_BACKSPACE },
+	{ 0x866b15, KEY_ENTER },
 
-	{ 0x861d, KEY_UP },
-	{ 0x861e, KEY_DOWN },
-	{ 0x860e, KEY_LEFT },
-	{ 0x860f, KEY_RIGHT },
+	{ 0x866b1d, KEY_UP },
+	{ 0x866b1e, KEY_DOWN },
+	{ 0x866b0e, KEY_LEFT },
+	{ 0x866b0f, KEY_RIGHT },
 
-	{ 0x8618, KEY_RECORD },
-	{ 0x861a, KEY_STOP },
+	{ 0x866b18, KEY_RECORD },
+	{ 0x866b1a, KEY_STOP },
 
 	/* Key codes for the EvolutePC TVWay+ remote */
 	{ 0x7a00, KEY_MENU },
-- 
1.7.1


