Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNvD019823
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 12/28] [media] mt2060: remove fake implementaion of get_bandwidth()
Date: Thu, 22 Dec 2011 09:20:00 -0200
Message-Id: <1324552816-25704-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-12-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
 <1324552816-25704-9-git-send-email-mchehab@redhat.com>
 <1324552816-25704-10-git-send-email-mchehab@redhat.com>
 <1324552816-25704-11-git-send-email-mchehab@redhat.com>
 <1324552816-25704-12-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver implements a fake get_bandwidth() callback. In
reallity, the tuner driver won't adjust its low-pass
filter based on a bandwidth, and were just providing a fake
method for demods to read whatever was "set".

This code is useless, as none of the drivers that use
this tuner seems to require a get_bandwidth() callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2060.c      |   12 ++----------
 drivers/media/common/tuners/mt2060_priv.h |    1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/common/tuners/mt2060.c b/drivers/media/common/tuners/mt2060.c
index 2ecaa53..6fe2ef9 100644
--- a/drivers/media/common/tuners/mt2060.c
+++ b/drivers/media/common/tuners/mt2060.c
@@ -155,6 +155,7 @@ static int mt2060_spurcheck(u32 lo1,u32 lo2,u32 if2)
 
 static int mt2060_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2060_priv *priv;
 	int ret=0;
 	int i=0;
@@ -176,8 +177,7 @@ static int mt2060_set_params(struct dvb_frontend *fe, struct dvb_frontend_parame
 
 	mt2060_writeregs(priv,b,2);
 
-	freq = params->frequency / 1000; // Hz -> kHz
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
+	freq = c->frequency / 1000; /* Hz -> kHz */
 
 	f_lo1 = freq + if1 * 1000;
 	f_lo1 = (f_lo1 / 250) * 250;
@@ -293,13 +293,6 @@ static int mt2060_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int mt2060_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
-{
-	struct mt2060_priv *priv = fe->tuner_priv;
-	*bandwidth = priv->bandwidth;
-	return 0;
-}
-
 static int mt2060_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	*frequency = IF2 * 1000;
@@ -362,7 +355,6 @@ static const struct dvb_tuner_ops mt2060_tuner_ops = {
 
 	.set_params    = mt2060_set_params,
 	.get_frequency = mt2060_get_frequency,
-	.get_bandwidth = mt2060_get_bandwidth,
 	.get_if_frequency = mt2060_get_if_frequency,
 };
 
diff --git a/drivers/media/common/tuners/mt2060_priv.h b/drivers/media/common/tuners/mt2060_priv.h
index 5eaccde..2b60de6 100644
--- a/drivers/media/common/tuners/mt2060_priv.h
+++ b/drivers/media/common/tuners/mt2060_priv.h
@@ -97,7 +97,6 @@ struct mt2060_priv {
 	struct i2c_adapter   *i2c;
 
 	u32 frequency;
-	u32 bandwidth;
 	u16 if1_freq;
 	u8  fmfreq;
 };
-- 
1.7.8.352.g876a6

