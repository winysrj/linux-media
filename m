Return-path: <mchehab@gaivota>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:57280 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab1EITyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:13 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 06/16] tm6000: add eeprom
Date: Mon,  9 May 2011 21:53:54 +0200
Message-Id: <1304970844-20955-6-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

add eeprom


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 9f4daac..199cc86 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -84,6 +84,7 @@ struct tm6000_board {
 
 	struct tm6000_input	vinput[3];
 	struct tm6000_input	rinput;
+
 	char		*ir_codes;
 };
 
@@ -91,7 +92,8 @@ struct tm6000_board tm6000_boards[] = {
 	[TM6000_BOARD_UNKNOWN] = {
 		.name         = "Unknown tm6000 video grabber",
 		.caps = {
-			.has_tuner    = 1,
+			.has_tuner	= 1,
+			.has_eeprom	= 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
@@ -118,6 +120,7 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.caps = {
 			.has_tuner	= 1,
+			.has_eeprom	= 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
@@ -143,7 +146,7 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.caps = {
 			.has_tuner	= 1,
-			.has_dvb	= 1,
+			.has_eeprom	= 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
-- 
1.7.4.2

