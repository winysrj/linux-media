Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49315 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2E2VTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:19:38 -0400
Received: by bkcji2 with SMTP id ji2so3502633bkc.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 14:19:36 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] [media] em28xx: Add remote control support for Terratec's Cinergy HTC Stick HD
Date: Tue, 29 May 2012 23:19:27 +0200
Message-Id: <1338326368-20108-1-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1338154013-5124-2-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-2-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cinergy HTC Stick HD uses the same remote control as the TerraTec
Cinergy XS products. Thus the same keymap could be re-used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 20a7e24..92da7c2 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -974,6 +974,7 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2884_BOARD_CINERGY_HTC_STICK] = {
 		.name         = "Terratec Cinergy HTC Stick",
 		.has_dvb      = 1,
+		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 #if 0
 		.tuner_type   = TUNER_PHILIPS_TDA8290,
 		.tuner_addr   = 0x41,
-- 
1.7.10.2

