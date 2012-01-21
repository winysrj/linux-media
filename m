Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4kAa021387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 33/35] [media] az6007: Use the right keycode for Terratec H7
Date: Sat, 21 Jan 2012 14:04:35 -0200
Message-Id: <1327161877-16784-34-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-33-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
 <1327161877-16784-27-git-send-email-mchehab@redhat.com>
 <1327161877-16784-28-git-send-email-mchehab@redhat.com>
 <1327161877-16784-29-git-send-email-mchehab@redhat.com>
 <1327161877-16784-30-git-send-email-mchehab@redhat.com>
 <1327161877-16784-31-git-send-email-mchehab@redhat.com>
 <1327161877-16784-32-git-send-email-mchehab@redhat.com>
 <1327161877-16784-33-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a fake keycode, just for testing, use the
right one, for Terratec H7.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c                 |    2 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   52 ++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 2288916..14733b8 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -521,7 +521,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 
 	.rc.core = {
 		.rc_interval      = 400,
-		.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
+		.rc_codes         = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 		.module_name	  = "az6007",
 		.rc_query         = az6007_rc_query,
 		.allowed_protos   = RC_TYPE_NEC,
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index f3b86c8..8d4dae2 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -18,6 +18,8 @@
  */
 
 static struct rc_map_table nec_terratec_cinergy_xs[] = {
+
+	/* Terratec Grey IR, with most keys in orange */
 	{ 0x1441, KEY_HOME},
 	{ 0x1401, KEY_POWER2},
 
@@ -78,6 +80,56 @@ static struct rc_map_table nec_terratec_cinergy_xs[] = {
 	{ 0x144e, KEY_REWIND},
 	{ 0x144f, KEY_FASTFORWARD},
 	{ 0x145c, KEY_NEXT},
+
+	/* Terratec Black IR, with most keys in black */
+	{ 0x04eb01, KEY_POWER2},
+
+	{ 0x04eb02, KEY_1},
+	{ 0x04eb03, KEY_2},
+	{ 0x04eb04, KEY_3},
+	{ 0x04eb05, KEY_4},
+	{ 0x04eb06, KEY_5},
+	{ 0x04eb07, KEY_6},
+	{ 0x04eb08, KEY_7},
+	{ 0x04eb09, KEY_8},
+	{ 0x04eb0a, KEY_9},
+	{ 0x04eb0c, KEY_0},
+
+	{ 0x04eb0b, KEY_TEXT},		/* TXT */
+	{ 0x04eb0d, KEY_REFRESH},	/* Refresh */
+
+	{ 0x04eb0e, KEY_HOME},
+	{ 0x04eb0f, KEY_EPG},
+
+	{ 0x04eb10, KEY_UP},
+	{ 0x04eb11, KEY_LEFT},
+	{ 0x04eb12, KEY_OK},
+	{ 0x04eb13, KEY_RIGHT},
+	{ 0x04eb14, KEY_DOWN},
+
+	{ 0x04eb15, KEY_BACKSPACE},
+	{ 0x04eb16, KEY_INFO},
+
+	{ 0x04eb17, KEY_RED},
+	{ 0x04eb18, KEY_GREEN},
+	{ 0x04eb19, KEY_YELLOW},
+	{ 0x04eb1a, KEY_BLUE},
+
+	{ 0x04eb1c, KEY_VOLUMEUP},
+	{ 0x04eb1e, KEY_VOLUMEDOWN},
+
+	{ 0x04eb1d, KEY_MUTE},
+
+	{ 0x04eb1b, KEY_CHANNELUP},
+	{ 0x04eb1f, KEY_CHANNELDOWN},
+
+	{ 0x04eb40, KEY_RECORD},
+	{ 0x04eb4c, KEY_PLAY},
+	{ 0x04eb58, KEY_PAUSE},
+
+	{ 0x04eb54, KEY_REWIND},
+	{ 0x04eb48, KEY_STOP},
+	{ 0x04eb5c, KEY_NEXT},
 };
 
 static struct rc_map_list nec_terratec_cinergy_xs_map = {
-- 
1.7.8

