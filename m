Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3JBMsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 08:48:06 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] ts2020: keep 1.06 MHz as default value for frequency_div
Date: Wed,  2 Oct 2013 06:46:42 -0300
Message-Id: <1380707202-13530-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 9e8da9e8 added a parameter to specify the frequency
divisor, used by the driver. However, not all places are passing
this parameter. So, preserve the previous default, to avoid breaking
the existing drivers.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/ts2020.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 678f13a..9aba044 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -344,6 +344,9 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 	priv->frequency_div = config->frequency_div;
 	fe->tuner_priv = priv;
 
+	if (!priv->frequency_div)
+		priv->frequency_div = 1060000;
+
 	/* Wake Up the tuner */
 	if ((0x03 & ts2020_readreg(fe, 0x00)) == 0x00) {
 		ts2020_writereg(fe, 0x00, 0x01);
-- 
1.8.3.1

