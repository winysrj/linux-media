Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38744 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbBKLKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 06:10:55 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Wed, 11 Feb 2015 11:08:51 +0000
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crop@iki.fi, linux-kernel@vger.kernel.org
Subject: [PATCH v2] rtl2832: remove compiler warning
Message-ID: <20150211110851.GA30505@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleaning up the following compiler warning:
rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function

Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
tmp, this line would never run because we go to err. It is still nice to avoid
compiler warnings.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 5d2d8f4..20fa245 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u32 tmp;
+	u32 uninitialized_var(tmp);
 
 	dev_dbg(&client->dev, "\n");
 
-- 
2.1.3

