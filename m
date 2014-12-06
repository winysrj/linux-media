Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:38562 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaLFAZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 19:25:43 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id D68EA61BAE
	for <linux-media@vger.kernel.org>; Sat,  6 Dec 2014 01:25:33 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
Date: Sat,  6 Dec 2014 01:25:31 +0100
Message-Id: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Astrometa device has issues with i2c transfers. Lowering the
poll time somehow makes these errors disappear.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 705c6c3..9ec4223 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1567,7 +1567,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 	rc->allowed_protos = RC_BIT_ALL;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->query = rtl2832u_rc_query;
-	rc->interval = 400;
+	rc->interval = 200;
 
 	return 0;
 }
-- 
1.9.1

