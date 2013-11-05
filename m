Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 01/29] [media] tda9887: remove an warning when compiling for alpha
Date: Tue,  5 Nov 2013 08:01:14 -0200
Message-Id: <1383645702-30636-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to zero the buffer, as if the routine gets an error,
rc will be different than one.
That fixes the following warning:
	drivers/media/tuners/tda9887.c: In function 'tda9887_status':
	drivers/media/tuners/tda9887.c:539:2: warning: value computed is not used [-Wunused-value]

While here, make fix the CodingStyle on this function.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tda9887.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
index 300005c535ba..9823248d743f 100644
--- a/drivers/media/tuners/tda9887.c
+++ b/drivers/media/tuners/tda9887.c
@@ -536,8 +536,8 @@ static int tda9887_status(struct dvb_frontend *fe)
 	unsigned char buf[1];
 	int rc;
 
-	memset(buf,0,sizeof(buf));
-	if (1 != (rc = tuner_i2c_xfer_recv(&priv->i2c_props,buf,1)))
+	rc = tuner_i2c_xfer_recv(&priv->i2c_props, buf, 1);
+	if (rc != 1)
 		tuner_info("i2c i/o error: rc == %d (should be 1)\n", rc);
 	dump_read_message(fe, buf);
 	return 0;
-- 
1.8.3.1

