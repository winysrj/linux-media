Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59476 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3CJCEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 27/41] af9035: enable remote controller for IT9135 too
Date: Sun, 10 Mar 2013 04:03:19 +0200
Message-Id: <1362881013-5271-27-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no difference towards AF9035 remote controller, so enable it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 7f87b01..ecec69d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1251,10 +1251,6 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	int ret;
 	u8 tmp;
 
-	/* TODO: IT9135 remote control support */
-	if (state->chip_type == 0x9135)
-		return 0;
-
 	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_IR_MODE, &tmp);
 	if (ret < 0)
 		goto err;
-- 
1.7.11.7

