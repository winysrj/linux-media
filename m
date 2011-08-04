Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HDHOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:31 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 20/21] [staging] tm6000: Enable radio mode for Cinergy Hybrid XE.
Date: Thu,  4 Aug 2011 09:14:18 +0200
Message-Id: <1312442059-23935-21-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/tm6000/tm6000-cards.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 94fd138..ab3aa2c 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -469,6 +469,7 @@ static struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 			.has_remote   = 1,
+			.has_radio    = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_2,
@@ -494,6 +495,10 @@ static struct tm6000_board tm6000_boards[] = {
 			.amux	= TM6000_AMUX_ADC2,
 			},
 		},
+		.rinput = {
+			.type = TM6000_INPUT_RADIO,
+			.amux = TM6000_AMUX_SIF1,
+		},
 	},
 	[TM5600_BOARD_TERRATEC_GRABSTER] = {
 		.name         = "Terratec Grabster AV 150/250 MX",
-- 
1.7.6

