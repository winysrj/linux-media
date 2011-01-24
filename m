Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1AXP30 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:29:26 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFTQn8017819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:29:26 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARv027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:29:25 -0500
Date: Mon, 24 Jan 2011 13:18:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/13] [media] a800: Fix a few wrong IR key assignments
Message-ID: <20110124131842.61ceb7dc@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 53b93a4..f8e9bf1 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -38,8 +38,8 @@ static int a800_identify_state(struct usb_device *udev, struct dvb_usb_device_pr
 }
 
 static struct rc_map_table rc_map_a800_table[] = {
-	{ 0x0201, KEY_PROG1 },       /* SOURCE */
-	{ 0x0200, KEY_POWER },       /* POWER */
+	{ 0x0201, KEY_MODE },      /* SOURCE */
+	{ 0x0200, KEY_POWER2 },      /* POWER */
 	{ 0x0205, KEY_1 },           /* 1 */
 	{ 0x0206, KEY_2 },           /* 2 */
 	{ 0x0207, KEY_3 },           /* 3 */
@@ -52,8 +52,8 @@ static struct rc_map_table rc_map_a800_table[] = {
 	{ 0x0212, KEY_LEFT },        /* L / DISPLAY */
 	{ 0x0211, KEY_0 },           /* 0 */
 	{ 0x0213, KEY_RIGHT },       /* R / CH RTN */
-	{ 0x0217, KEY_PROG2 },       /* SNAP SHOT */
-	{ 0x0210, KEY_PROG3 },       /* 16-CH PREV */
+	{ 0x0217, KEY_CAMERA },      /* SNAP SHOT */
+	{ 0x0210, KEY_LAST },        /* 16-CH PREV */
 	{ 0x021e, KEY_VOLUMEDOWN },  /* VOL DOWN */
 	{ 0x020c, KEY_ZOOM },        /* FULL SCREEN */
 	{ 0x021f, KEY_VOLUMEUP },    /* VOL UP */
-- 
1.7.1


