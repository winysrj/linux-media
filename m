Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1G1TFN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 15:05:13 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ5DsJ001327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:13 -0400
Received: from localhost.localdomain (vpn-8-21.rdu.redhat.com [10.11.8.21])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ58KE026840
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:12 -0400
Date: Thu, 28 Jul 2011 16:04:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] tda18271c2dd: Fix saw filter configuration for DVB-6 @
 6MHz
Message-ID: <20110728160434.39dccf67@redhat.com>
In-Reply-To: <cover.1311879724.git.mchehab@redhat.com>
References: <cover.1311879724.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the driver assumes that all QAM carriers are spaced with
8MHz. This is wrong, and may decrease QoS on Countries like Brazil,
that have DVB-C carriers with 6MHz-spaced.

Fortunately, both ITU-T J-83 and EN 300 429 specifies a way to
associate the symbol rate with the bandwidth needed for it.

For ITU-T J-83 2007 annex A, the maximum symbol rate for 6 MHz is:
	6 MHz / 1.15 = 5217391 Bauds
For  ITU-T J-83 2007 annex C, the maximum symbol rate for 6 MHz is:
	6 MHz / 1.13 = 5309735 Bauds.

As this tuner is currently used only for DRX-K, and it is currently
hard-coded to annex A, I've opted to use the roll-off factor of 0.15,
instead of 0.13.

If we ever support annex C, the better would be to add a DVB S2API
call to allow changing between Annex A and C, and add the 0.13 roll-off
factor to it.

This code is currently being used on other frontends, so I think we
should later add a core function with this code, to warrant that
it will be properly implemented everywhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 2eb3a31..9aa4c09 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1123,6 +1123,21 @@ static int release(struct dvb_frontend *fe)
 	return 0;
 }
 
+/*
+ * As defined on EN 300 429 Annex A and on ITU-T J.83 annex A, the DVB-C
+ * roll-off factor is 0.15.
+ * According with the specs, the amount of the needed bandwith is given by:
+ * 	Bw = Symbol_rate * (1 + 0.15)
+ * As such, the maximum symbol rate supported by 6 MHz is
+ *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
+ *NOTE: For ITU-T J.83 Annex C, the roll-off factor is 0.13. So:
+ *	max_symbol_rate = 6 MHz / 1.13 = 5309735 Baud
+ *	That means that an adjustment is needed for Japan,
+ *	but, as currently DRX-K is hardcoded to Annex A, let's stick
+ *	with 0.15 roll-off factor.
+ */
+#define MAX_SYMBOL_RATE_6MHz	5217391
+
 static int set_params(struct dvb_frontend *fe,
 		      struct dvb_frontend_parameters *params)
 {
@@ -1146,7 +1161,10 @@ static int set_params(struct dvb_frontend *fe,
 			break;
 		}
 	else if (fe->ops.info.type == FE_QAM) {
-		Standard = HF_DVBC_8MHZ;
+		if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz)
+			Standard = HF_DVBC_6MHZ;
+		else
+			Standard = HF_DVBC_8MHZ;
 	} else
 		return -EINVAL;
 	do {
-- 
1.7.1

