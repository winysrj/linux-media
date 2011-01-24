Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1AXP2Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:28:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFSOsX008904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:28:24 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARu027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:28:23 -0500
Date: Mon, 24 Jan 2011 13:18:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/13] [media] opera1: Use multimedia keys instead of an
 app-specific mapping
Message-ID: <20110124131841.2b572fcc@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This driver uses an app-specific keymap for one of the tables. This
is wrong. Instead, use the standard keycodes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 1f1b7d6..7e569f4 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -342,23 +342,22 @@ static struct rc_map_table rc_map_opera1_table[] = {
 	{0x49b6, KEY_8},
 	{0x05fa, KEY_9},
 	{0x45ba, KEY_0},
-	{0x09f6, KEY_UP},	/*chanup */
-	{0x1be5, KEY_DOWN},	/*chandown */
-	{0x5da3, KEY_LEFT},	/*voldown */
-	{0x5fa1, KEY_RIGHT},	/*volup */
-	{0x07f8, KEY_SPACE},	/*tab */
-	{0x1fe1, KEY_ENTER},	/*play ok */
-	{0x1be4, KEY_Z},	/*zoom */
-	{0x59a6, KEY_M},	/*mute */
-	{0x5ba5, KEY_F},	/*tv/f */
-	{0x19e7, KEY_R},	/*rec */
-	{0x01fe, KEY_S},	/*Stop */
-	{0x03fd, KEY_P},	/*pause */
-	{0x03fc, KEY_W},	/*<- -> */
-	{0x07f9, KEY_C},	/*capture */
-	{0x47b9, KEY_Q},	/*exit */
-	{0x43bc, KEY_O},	/*power */
-
+	{0x09f6, KEY_CHANNELUP},	/*chanup */
+	{0x1be5, KEY_CHANNELDOWN},	/*chandown */
+	{0x5da3, KEY_VOLUMEDOWN},	/*voldown */
+	{0x5fa1, KEY_VOLUMEUP},		/*volup */
+	{0x07f8, KEY_SPACE},		/*tab */
+	{0x1fe1, KEY_OK},		/*play ok */
+	{0x1be4, KEY_ZOOM},		/*zoom */
+	{0x59a6, KEY_MUTE},		/*mute */
+	{0x5ba5, KEY_RADIO},		/*tv/f */
+	{0x19e7, KEY_RECORD},		/*rec */
+	{0x01fe, KEY_STOP},		/*Stop */
+	{0x03fd, KEY_PAUSE},		/*pause */
+	{0x03fc, KEY_SCREEN},		/*<- -> */
+	{0x07f9, KEY_CAMERA},		/*capture */
+	{0x47b9, KEY_ESC},		/*exit */
+	{0x43bc, KEY_POWER2},		/*power */
 };
 
 static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
-- 
1.7.1


