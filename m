Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42099 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbeDHRW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:22:27 -0400
Received: by mail-pl0-f68.google.com with SMTP id t20-v6so865955ply.9
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:22:27 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v5 4/5] dvb-usb-v2/gl861: use usleep_range() for short delay
Date: Mon,  9 Apr 2018 02:21:37 +0900
Message-Id: <20180408172138.9974-5-tskd08@gmail.com>
In-Reply-To: <20180408172138.9974-1-tskd08@gmail.com>
References: <20180408172138.9974-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

As the kernel doc "timers-howto.txt" reads,
short delay with msleep() can take much longer.
In a case of raspbery-pi platform where CONFIG_HZ_100 was set,
it actually affected the init of Friio devices
since it issues lots of i2c transactions with short delay.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v4:
- none

 drivers/media/usb/dvb-usb-v2/gl861.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index ecff0062bfb..cdd7bfcb883 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -45,7 +45,7 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 		return -EINVAL;
 	}
 
-	msleep(1); /* avoid I2C errors */
+	usleep_range(1000, 2000); /* avoid I2C errors */
 
 	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
 			       value, index, rbuf, rlen, 2000);
-- 
2.17.0
