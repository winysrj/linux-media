Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:53102 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbBHWo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2015 17:44:26 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Sun, 8 Feb 2015 22:44:22 +0000
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtl2832: remove compiler warning
Message-ID: <20150208224422.GA22749@turing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleaning the following compiler warning:
rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function

Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
tmp, this line would never run because we go to err. It is still nice to avoid
compiler warnings.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 5d2d8f4..ad36d1c 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u32 tmp;
+	u32 tmp = 0;
 
 	dev_dbg(&client->dev, "\n");
 
-- 
2.1.0

