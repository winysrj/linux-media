Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1KTO4b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuU30021789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 8/8] [media] em28xx: Add IR support for HVR-930C
Date: Sun, 20 Nov 2011 12:56:18 -0200
Message-Id: <1321800978-27912-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-7-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
 <1321800978-27912-3-git-send-email-mchehab@redhat.com>
 <1321800978-27912-4-git-send-email-mchehab@redhat.com>
 <1321800978-27912-5-git-send-email-mchehab@redhat.com>
 <1321800978-27912-6-git-send-email-mchehab@redhat.com>
 <1321800978-27912-7-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/keymaps/rc-hauppauge.c   |   51 +++++++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx-cards.c |    1 +
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index cd3db77..0afb23b 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -182,6 +182,57 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	{ 0x1d3f, KEY_HOME },
 
 	/*
+	 * Keycodes for PT# R-005 remote bundled with Haupauge HVR-930C
+	 * Keycodes start with address = 0x1c
+	 */
+	{ 0x1c3b, KEY_GOTO },
+	{ 0x1c3d, KEY_POWER },
+
+	{ 0x1c14, KEY_UP },
+	{ 0x1c15, KEY_DOWN },
+	{ 0x1c16, KEY_LEFT },
+	{ 0x1c17, KEY_RIGHT },
+	{ 0x1c25, KEY_OK },
+
+	{ 0x1c00, KEY_0 },
+	{ 0x1c01, KEY_1 },
+	{ 0x1c02, KEY_2 },
+	{ 0x1c03, KEY_3 },
+	{ 0x1c04, KEY_4 },
+	{ 0x1c05, KEY_5 },
+	{ 0x1c06, KEY_6 },
+	{ 0x1c07, KEY_7 },
+	{ 0x1c08, KEY_8 },
+	{ 0x1c09, KEY_9 },
+
+	{ 0x1c1f, KEY_EXIT },	/* BACK */
+	{ 0x1c0d, KEY_MENU },
+	{ 0x1c1c, KEY_TV },
+
+	{ 0x1c10, KEY_VOLUMEUP },
+	{ 0x1c11, KEY_VOLUMEDOWN },
+
+	{ 0x1c20, KEY_CHANNELUP },
+	{ 0x1c21, KEY_CHANNELDOWN },
+
+	{ 0x1c0f, KEY_MUTE },
+	{ 0x1c12, KEY_PREVIOUS }, /* Prev */
+
+	{ 0x1c36, KEY_STOP },
+	{ 0x1c37, KEY_RECORD },
+
+	{ 0x1c24, KEY_LAST },           /* <|             */
+	{ 0x1c1e, KEY_NEXT },           /* >|             */
+
+	{ 0x1c0a, KEY_TEXT },
+	{ 0x1c0e, KEY_SUBTITLE },	/* CC */
+
+	{ 0x1c32, KEY_REWIND },
+	{ 0x1c30, KEY_PAUSE },
+	{ 0x1c35, KEY_PLAY },
+	{ 0x1c34, KEY_FASTFORWARD },
+
+	/*
 	 * Keycodes for the old Black Remote Controller
 	 * This one also uses RC-5 protocol
 	 * Keycodes start with address = 0x00
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index d92e0af..f63a715 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -922,6 +922,7 @@ struct em28xx_board em28xx_boards[] = {
 #else
 		.tuner_type   = TUNER_ABSENT,
 #endif
+		.ir_codes     = RC_MAP_HAUPPAUGE,
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
-- 
1.7.7.1

