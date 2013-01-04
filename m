Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3ADVQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
Date: Fri,  4 Jan 2013 19:15:52 -0200
Message-Id: <1357334152-3811-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ebbb0aa..5b3292c 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -483,6 +483,7 @@ static void em28xx_register_i2c_ir(struct em28xx *dev)
 		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 		dev->init_data.get_key = em28xx_get_key_em_haup;
 		dev->init_data.name = "WinTV USB2";
+		dev->init_data.type = RC_BIT_RC5;
 		break;
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
-- 
1.7.11.7

