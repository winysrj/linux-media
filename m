Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45545 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbcAGIfl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 03:35:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: retry failed i2c messages
Date: Thu,  7 Jan 2016 10:35:21 +0200
Message-Id: <1452155721-18459-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes i2c transfer fails. That happens especially when large
amount of data is written sequentially eg. firmware download.
Problem arises with both integrated rtl2832 demod and external
mn88472 demod, which is clear indicator it is busy i2c bus issue.
Use i2c core retry logic in order fix the issue by repeating failed
message. Another solution which also works is to add ~100us delay
between i2c messages - but repeating sounds more elegant and does
not cause any extra delay for success cases.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index eb5787a..c4c6e92 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -259,6 +259,10 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		ret = -EOPNOTSUPP;
 	}
 
+	/* Retry failed I2C messages */
+	if (ret == -EPIPE)
+		ret = -EAGAIN;
+
 err_mutex_unlock:
 	mutex_unlock(&d->i2c_mutex);
 
@@ -619,6 +623,10 @@ static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
 	}
 	dev_dbg(&d->intf->dev, "chip_id=%u\n", dev->chip_id);
 
+	/* Retry failed I2C messages */
+	d->i2c_adap.retries = 1;
+	d->i2c_adap.timeout = msecs_to_jiffies(10);
+
 	return WARM;
 err:
 	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
-- 
http://palosaari.fi/

