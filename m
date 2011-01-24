Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1AXPa1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:30:27 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFURlo017845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:30:27 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARw027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:30:26 -0500
Date: Mon, 24 Jan 2011 13:18:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/13] [media] rc-winfast: Fix the keycode tables
Message-ID: <20110124131843.7b5c82c7@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

One of the remotes has a picture available at:
	http://lirc.sourceforge.net/remotes/leadtek/Y04G0004.jpg

As there's one variant with a set direction keys plus vol/chann
keys, and the same table is used for both models, change it to
represent all keys, avoiding the usage of weird function keys.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 2747db4..0062ca2 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -27,15 +27,15 @@ static struct rc_map_table winfast[] = {
 	{ 0x0e, KEY_8 },
 	{ 0x0f, KEY_9 },
 
-	{ 0x00, KEY_POWER },
+	{ 0x00, KEY_POWER2 },
 	{ 0x1b, KEY_AUDIO },		/* Audio Source */
 	{ 0x02, KEY_TUNER },		/* TV/FM, not on Y0400052 */
 	{ 0x1e, KEY_VIDEO },		/* Video Source */
 	{ 0x16, KEY_INFO },		/* Display information */
-	{ 0x04, KEY_VOLUMEUP },
-	{ 0x08, KEY_VOLUMEDOWN },
-	{ 0x0c, KEY_CHANNELUP },
-	{ 0x10, KEY_CHANNELDOWN },
+	{ 0x04, KEY_LEFT },
+	{ 0x08, KEY_RIGHT },
+	{ 0x0c, KEY_UP },
+	{ 0x10, KEY_DOWN },
 	{ 0x03, KEY_ZOOM },		/* fullscreen */
 	{ 0x1f, KEY_TEXT },		/* closed caption/teletext */
 	{ 0x20, KEY_SLEEP },
@@ -47,7 +47,7 @@ static struct rc_map_table winfast[] = {
 	{ 0x2e, KEY_BLUE },
 	{ 0x18, KEY_KPPLUS },		/* fine tune + , not on Y040052 */
 	{ 0x19, KEY_KPMINUS },		/* fine tune - , not on Y040052 */
-	{ 0x2a, KEY_MEDIA },		/* PIP (Picture in picture */
+	{ 0x2a, KEY_TV2 },		/* PIP (Picture in picture */
 	{ 0x21, KEY_DOT },
 	{ 0x13, KEY_ENTER },
 	{ 0x11, KEY_LAST },		/* Recall (last channel */
@@ -57,7 +57,7 @@ static struct rc_map_table winfast[] = {
 	{ 0x25, KEY_TIME },		/* Time Shifting */
 	{ 0x26, KEY_STOP },
 	{ 0x27, KEY_RECORD },
-	{ 0x28, KEY_SAVE },		/* Screenshot */
+	{ 0x28, KEY_CAMERA },		/* Screenshot */
 	{ 0x2f, KEY_MENU },
 	{ 0x30, KEY_CANCEL },
 	{ 0x31, KEY_CHANNEL },		/* Channel Surf */
@@ -70,10 +70,10 @@ static struct rc_map_table winfast[] = {
 	{ 0x38, KEY_DVD },
 
 	{ 0x1a, KEY_MODE},		/* change to MCE mode on Y04G0051 */
-	{ 0x3e, KEY_F21 },		/* MCE +VOL, on Y04G0033 */
-	{ 0x3a, KEY_F22 },		/* MCE -VOL, on Y04G0033 */
-	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
-	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
+	{ 0x3e, KEY_VOLUMEUP },		/* MCE +VOL, on Y04G0033 */
+	{ 0x3a, KEY_VOLUMEDOWN },	/* MCE -VOL, on Y04G0033 */
+	{ 0x3b, KEY_CHANNELUP },	/* MCE +CH,  on Y04G0033 */
+	{ 0x3f, KEY_CHANNELDOWN }	/* MCE -CH,  on Y04G0033 */
 };
 
 static struct rc_map_list winfast_map = {
-- 
1.7.1


