Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37333 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbeCZSIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 14:08:32 -0400
Received: by mail-pg0-f65.google.com with SMTP id n11so7569836pgp.4
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 11:08:32 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 4/5] dvb-usb-v2/gl861: use usleep_range() for short delay
Date: Tue, 27 Mar 2018 03:06:51 +0900
Message-Id: <20180326180652.5385-5-tskd08@gmail.com>
In-Reply-To: <20180326180652.5385-1-tskd08@gmail.com>
References: <20180326180652.5385-1-tskd08@gmail.com>
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
 drivers/media/usb/dvb-usb-v2/gl861.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index bc18ca33649..a57afb12e84 100644
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
2.16.2
