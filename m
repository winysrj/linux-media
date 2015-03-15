Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56460 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbCOW6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:04 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/10] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
Date: Sun, 15 Mar 2015 23:57:48 +0100
Message-Id: <1426460275-3766-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Astrometa device has issues with i2c transfers. Lowering the
poll time somehow makes these errors disappear.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 77dcfdf..ea75b3a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1611,7 +1611,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 	rc->allowed_protos = RC_BIT_ALL;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->query = rtl2832u_rc_query;
-	rc->interval = 400;
+	rc->interval = 200;
 
 	return 0;
 }
-- 
2.1.0

