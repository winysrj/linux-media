Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:55366 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbbCLH1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 03:27:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C72322A0082
	for <linux-media@vger.kernel.org>; Thu, 12 Mar 2015 08:27:43 +0100 (CET)
Message-ID: <55013FEF.3070606@xs4all.nl>
Date: Thu, 12 Mar 2015 08:27:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] rtl2832: fix compiler warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From the daily build:

rtl2832.c: In function 'rtl2832_read_status':
rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function [-Wmaybe-uninitialized]
  } else if (tmp == 10) {
            ^

The code is OK, it's just the compiler that cannot figure out what's
going on. So just init 'tmp' to 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

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
 
