Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1AXPZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:25:20 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFPK7e017257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:25:20 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARr027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:25:19 -0500
Date: Mon, 24 Jan 2011 13:18:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/13] [media] rc/keymaps: Fix most KEY_PROG[n] keycodes
Message-ID: <20110124131838.3157c36e@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those KEY_PROG[n] keys were used on places where the developer
didn't know for sure what key should be used. On several cases,
using KEY_RED, KEY_GREEN, KEY_YELLOW would be enough. On others,
there are specific keys for that already.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index 136d395..9a8752f 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -50,9 +50,9 @@ static struct rc_map_table adstech_dvb_t_pci[] = {
 	{ 0x13, KEY_TUNER },		/* Live */
 	{ 0x0a, KEY_A },
 	{ 0x12, KEY_B },
-	{ 0x03, KEY_PROG1 },		/* 1 */
-	{ 0x01, KEY_PROG2 },		/* 2 */
-	{ 0x00, KEY_PROG3 },		/* 3 */
+	{ 0x03, KEY_RED },		/* 1 */
+	{ 0x01, KEY_GREEN },		/* 2 */
+	{ 0x00, KEY_YELLOW },		/* 3 */
 	{ 0x06, KEY_DVD },
 	{ 0x48, KEY_AUX },		/* Photo */
 	{ 0x40, KEY_VIDEO },
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index f4ca1ff..9d68af2 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -31,7 +31,7 @@ static struct rc_map_table avermedia_rm_ks[] = {
 	{ 0x0505, KEY_VOLUMEDOWN },
 	{ 0x0506, KEY_MUTE },
 	{ 0x0507, KEY_RIGHT },
-	{ 0x0508, KEY_PROG1 },
+	{ 0x0508, KEY_RED },
 	{ 0x0509, KEY_1 },
 	{ 0x050a, KEY_2 },
 	{ 0x050b, KEY_3 },
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index 99520ff..cf3a6bf 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -25,7 +25,7 @@ static struct rc_map_table cinergy[] = {
 	{ 0x09, KEY_9 },
 
 	{ 0x0a, KEY_POWER },
-	{ 0x0b, KEY_PROG1 },		/* app */
+	{ 0x0b, KEY_MEDIA },		/* app */
 	{ 0x0c, KEY_ZOOM },		/* zoom/fullscreen */
 	{ 0x0d, KEY_CHANNELUP },	/* channel */
 	{ 0x0e, KEY_CHANNELDOWN },	/* channel- */
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index 1a0e590..e56ac6e 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -77,7 +77,7 @@ static struct rc_map_table encore_enltv[] = {
 	{ 0x50, KEY_SLEEP },		/* shutdown */
 	{ 0x51, KEY_MODE },		/* stereo > main */
 	{ 0x52, KEY_SELECT },		/* stereo > sap */
-	{ 0x53, KEY_PROG1 },		/* teletext */
+	{ 0x53, KEY_TEXT },		/* teletext */
 
 
 	{ 0x59, KEY_RED },		/* AP1 */
-- 
1.7.1


