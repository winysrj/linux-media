Return-path: <mchehab@gaivota>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:51274 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab1EITyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 07/16] tm6000: remove unused capabilities
Date: Mon,  9 May 2011 21:53:55 +0200
Message-Id: <1304970844-20955-7-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

remove unused capabilities



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    8 --------
 drivers/staging/tm6000/tm6000.h       |    2 --
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 199cc86..19120ed 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -396,8 +396,6 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom     = 1,
 			.has_remote     = 1,
 			.has_radio	= 1.
-			.has_input_comp = 1,
-			.has_input_svid = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
@@ -435,8 +433,6 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom     = 1,
 			.has_remote     = 1,
 			.has_radio	= 1,
-			.has_input_comp = 1,
-			.has_input_svid = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
@@ -568,8 +564,6 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom     = 1,
 			.has_remote     = 0,
 			.has_radio	= 1,
-			.has_input_comp = 0,
-			.has_input_svid = 0,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
@@ -599,8 +593,6 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom     = 1,
 			.has_remote     = 0,
 			.has_radio	= 1,
-			.has_input_comp = 0,
-			.has_input_svid = 0,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index e4ca896..ae6369b 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -143,8 +143,6 @@ struct tm6000_capabilities {
 	unsigned int    has_eeprom:1;
 	unsigned int    has_remote:1;
 	unsigned int    has_radio:1;
-	unsigned int    has_input_comp:1;
-	unsigned int    has_input_svid:1;
 };
 
 struct tm6000_dvb {
-- 
1.7.4.2

