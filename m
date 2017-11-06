Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.60]:31159 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752726AbdKFPMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 10:12:08 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id EAA3C12317
        for <linux-media@vger.kernel.org>; Mon,  6 Nov 2017 08:22:19 -0600 (CST)
Date: Mon, 6 Nov 2017 08:22:18 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] usb: dvb-usb-v2: dvb_usb_core: remove redundant code in
 dvb_usb_fe_sleep
Message-ID: <20171106142218.GA18994@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check on return value and goto instruction is redundant as the code
that follows is the goto label err.

Addresses-Coverity-ID: 1268783
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 096bb75..2bf3bd8 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -628,8 +628,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 	}
 
 	ret = dvb_usbv2_device_power_ctrl(d, 0);
-	if (ret < 0)
-		goto err;
+
 err:
 	if (!adap->suspend_resume_active) {
 		adap->active_fe = -1;
-- 
2.7.4
