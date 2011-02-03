Return-path: <mchehab@pedra>
Received: from mail.hnelson.de ([87.230.84.188]:51111 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1BCE7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Feb 2011 23:59:33 -0500
Date: Thu, 3 Feb 2011 05:59:29 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: Add support for Terratec Grabster AV 150/250 MX
Message-ID: <alpine.DEB.2.00.1102030550100.14330@nova.crius.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for Terratec Grabster AV 150/250 MX. For now it is 
only possible to use composite input as switching inputs does not work.

Signed-off-by: Holger Nelson <hnelson@hnelson.de>

---
  drivers/staging/tm6000/tm6000-cards.c |   17 +++++++++++++++++
  1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 455038b..078bba4 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -50,6 +50,7 @@
  #define TM6010_BOARD_BEHOLD_VOYAGER		11
  #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
  #define TM6010_BOARD_TWINHAN_TU501		13
+#define TM5600_BOARD_TERRATEC_GRABSTER		14

  #define TM6000_MAXBOARDS        16
  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -303,6 +304,19 @@ struct tm6000_board tm6000_boards[] = {
  			.dvb_led	= TM6010_GPIO_5,
  			.ir		= TM6010_GPIO_0,
  		},
+	},
+	[TM5600_BOARD_TERRATEC_GRABSTER] = {
+		.name         = "Terratec Grabster AV 150/250 MX",
+		.type         = TM5600,
+		.caps = {
+			.has_tuner	= 0,
+			.has_dvb	= 0,
+			.has_zl10353	= 0,
+			.has_eeprom	= 0,
+			.has_remote	= 0,
+		},
+		.gpio = {
+		},
  	}
  };

@@ -325,6 +339,7 @@ struct usb_device_id tm6000_id_table[] = {
  	{ USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
  	{ USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
  	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x0ccd, 0x0079), .driver_info = TM5600_BOARD_TERRATEC_GRABSTER },
  	{ },
  };

@@ -488,6 +503,8 @@ int tm6000_cards_setup(struct tm6000_core *dev)
  	 * the board-specific session.
  	 */
  	switch (dev->model) {
+	case TM5600_BOARD_TERRATEC_GRABSTER:
+		return 0;
  	case TM6010_BOARD_HAUPPAUGE_900H:
  	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
  	case TM6010_BOARD_TWINHAN_TU501:
-- 
1.7.1
