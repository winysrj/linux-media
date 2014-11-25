Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaKYLT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 06:19:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] [media] lmed04: add missing breaks
Date: Tue, 25 Nov 2014 09:19:16 -0200
Message-Id: <d442b15fb4deb2b5d516e2dae1f569b1d5472399.1416914348.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb-v2/lmedm04.c:828 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
drivers/media/usb/dvb-usb-v2/lmedm04.c:849 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 9f2c5459b73a..99587418f4f0 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -826,6 +826,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
 				break;
 			}
 			st->dvb_usb_lme2510_firmware = TUNER_LG;
+			break;
 		case TUNER_LG:
 			fw_lme = fw_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
@@ -847,6 +848,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
 				break;
 			}
 			st->dvb_usb_lme2510_firmware = TUNER_LG;
+			break;
 		case TUNER_LG:
 			fw_lme = fw_c_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
-- 
1.9.3

