Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab1AXP1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:27:23 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFRMVs032422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:27:23 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARt027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:27:21 -0500
Date: Mon, 24 Jan 2011 13:18:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/13] [media] dw2102: Use multimedia keys instead of an
 app-specific mapping
Message-ID: <20110124131840.28802d35@pedra>
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

diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 2c307ba..3544dff 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -949,8 +949,8 @@ static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
 }
 
 static struct rc_map_table rc_map_dw210x_table[] = {
-	{ 0xf80a, KEY_Q },		/*power*/
-	{ 0xf80c, KEY_M },		/*mute*/
+	{ 0xf80a, KEY_POWER2 },		/*power*/
+	{ 0xf80c, KEY_MUTE },		/*mute*/
 	{ 0xf811, KEY_1 },
 	{ 0xf812, KEY_2 },
 	{ 0xf813, KEY_3 },
@@ -961,25 +961,25 @@ static struct rc_map_table rc_map_dw210x_table[] = {
 	{ 0xf818, KEY_8 },
 	{ 0xf819, KEY_9 },
 	{ 0xf810, KEY_0 },
-	{ 0xf81c, KEY_PAGEUP },	/*ch+*/
-	{ 0xf80f, KEY_PAGEDOWN },	/*ch-*/
-	{ 0xf81a, KEY_O },		/*vol+*/
-	{ 0xf80e, KEY_Z },		/*vol-*/
-	{ 0xf804, KEY_R },		/*rec*/
-	{ 0xf809, KEY_D },		/*fav*/
-	{ 0xf808, KEY_BACKSPACE },	/*rewind*/
-	{ 0xf807, KEY_A },		/*fast*/
-	{ 0xf80b, KEY_P },		/*pause*/
-	{ 0xf802, KEY_ESC },	/*cancel*/
-	{ 0xf803, KEY_G },		/*tab*/
+	{ 0xf81c, KEY_CHANNELUP },	/*ch+*/
+	{ 0xf80f, KEY_CHANNELDOWN },	/*ch-*/
+	{ 0xf81a, KEY_VOLUMEUP },	/*vol+*/
+	{ 0xf80e, KEY_VOLUMEDOWN },	/*vol-*/
+	{ 0xf804, KEY_RECORD },		/*rec*/
+	{ 0xf809, KEY_FAVORITES },	/*fav*/
+	{ 0xf808, KEY_REWIND },		/*rewind*/
+	{ 0xf807, KEY_FASTFORWARD },	/*fast*/
+	{ 0xf80b, KEY_PAUSE },		/*pause*/
+	{ 0xf802, KEY_ESC },		/*cancel*/
+	{ 0xf803, KEY_TAB },		/*tab*/
 	{ 0xf800, KEY_UP },		/*up*/
-	{ 0xf81f, KEY_ENTER },	/*ok*/
-	{ 0xf801, KEY_DOWN },	/*down*/
-	{ 0xf805, KEY_C },		/*cap*/
-	{ 0xf806, KEY_S },		/*stop*/
-	{ 0xf840, KEY_F },		/*full*/
-	{ 0xf81e, KEY_W },		/*tvmode*/
-	{ 0xf81b, KEY_B },		/*recall*/
+	{ 0xf81f, KEY_OK },		/*ok*/
+	{ 0xf801, KEY_DOWN },		/*down*/
+	{ 0xf805, KEY_CAMERA },		/*cap*/
+	{ 0xf806, KEY_STOP },		/*stop*/
+	{ 0xf840, KEY_ZOOM },		/*full*/
+	{ 0xf81e, KEY_TV },		/*tvmode*/
+	{ 0xf81b, KEY_LAST },		/*recall*/
 };
 
 static struct rc_map_table rc_map_tevii_table[] = {
-- 
1.7.1


