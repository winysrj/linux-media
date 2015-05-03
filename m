Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35230 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbECNAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 09:00:47 -0400
Received: by lbbuc2 with SMTP id uc2so89475159lbb.2
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 06:00:46 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH v3 4/6] rtl28xxu: add I2C read without write
Date: Sun,  3 May 2015 16:00:21 +0300
Message-Id: <1430658023-17579-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
References: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for I2C read operation without a preceeding write.

While here, change the error code to EOPNOTSUPP in case an
unsupported I2C operation is attempted.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f1a7613..5e0c015 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -232,8 +232,14 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			req.data = msg[0].buf;
 			ret = rtl28xxu_ctrl_msg(d, &req);
 		}
+	} else if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		req.value = (msg[0].addr << 1);
+		req.index = CMD_I2C_DA_RD;
+		req.size = msg[0].len;
+		req.data = msg[0].buf;
+		ret = rtl28xxu_ctrl_msg(d, &req);
 	} else {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 	}
 
 err_mutex_unlock:
-- 
1.9.1

