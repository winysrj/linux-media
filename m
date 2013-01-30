Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52880 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3JPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 04:15:42 -0500
Received: by mail-bk0-f45.google.com with SMTP id i18so702248bkv.18
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 01:15:40 -0800 (PST)
From: Vadim Frolov <fralik@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Vadim Frolov <fralik@gmail.com>
Subject: [PATCH 1/1] [media] saa7134: Add capture card Hawell HW-9004V1
Date: Wed, 30 Jan 2013 13:14:59 +0400
Message-Id: <1359537299-6534-1-git-send-email-fralik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new capture board Hawell HW-9004V1. This card has 4 SAA71300 chips. In order to work it is needed to initialize its registers (gpio mask and value). The value of these registers were dumped under Windows using flytest.

Signed-off-by: Vadim Frolov <fralik@gmail.com>
---
 Documentation/video4linux/CARDLIST.saa7134 |    1 +
 drivers/media/pci/saa7134/saa7134-cards.c  |   17 +++++++++++++++++
 drivers/media/pci/saa7134/saa7134.h        |    1 +
 3 files changed, 19 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 94d9025..b3ad683 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -189,3 +189,4 @@
 188 -> Sensoray 811/911                         [6000:0811,6000:0911]
 189 -> Kworld PC150-U                           [17de:a134]
 190 -> Asus My Cinema PS3-100                   [1043:48cd]
+191 -> Hawell HW-9004V1
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index bc08f1d..dc68cf1 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5773,6 +5773,23 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio	= 0x0000000,
 		},
 	},
+	[SAA7134_BOARD_HAWELL_HW_9004V1] = {
+		/* Hawell HW-9004V1 */
+		/* Vadim Frolov <fralik@gmail.com> */
+		.name         = "Hawell HW-9004V1",
+		.audio_clock   = 0x00200000,
+		.tuner_type    = UNSET,
+		.radio_type    = UNSET,
+		.tuner_addr   = ADDR_UNSET,
+		.radio_addr   = ADDR_UNSET,
+		.gpiomask      = 0x618E700,
+		.inputs       = {{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x6010000,
+		} },
+	},
 
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 6eae432..6d92a59 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -333,6 +333,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_SENSORAY811_911       188
 #define SAA7134_BOARD_KWORLD_PC150U         189
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
+#define SAA7134_BOARD_HAWELL_HW_9004V1      191
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
1.7.9.5

