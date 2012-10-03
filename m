Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:50253 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752287Ab2JCJZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 05:25:48 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9033: prevent unintended underflow
Date: Wed, 3 Oct 2012 11:25:40 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210031125.40850.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As spotted by Dan Carpenter <dan.carpenter@oracle.com> (thanks!), we have
improperly used an unsigned variable in a calculation that may result in a
negative number. This may cause an unintended underflow if the interface
frequency of the tuner is > approx. 40MHz.
This patch should resolve the issue, following an approach similar to what is
used in af9013.c.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb-frontends/af9033.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/media/dvb-frontends/af9033.c	2012-09-28 05:45:17.000000000 +0200
+++ b/drivers/media/dvb-frontends/af9033.c	2012-10-03 11:08:18.160894181 +0200
@@ -408,7 +408,7 @@ static int af9033_set_frontend(struct dv
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, spec_inv;
+	int ret, i, spec_inv, sampling_freq;
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency, freq_cw, adc_freq;
 
@@ -465,18 +465,20 @@ static int af9033_set_frontend(struct dv
 		else
 			if_frequency = 0;
 
-		while (if_frequency > (adc_freq / 2))
-			if_frequency -= adc_freq;
+		sampling_freq = if_frequency;
 
-		if (if_frequency >= 0)
+		while (sampling_freq > (adc_freq / 2))
+			sampling_freq -= adc_freq;
+
+		if (sampling_freq >= 0)
 			spec_inv *= -1;
 		else
-			if_frequency *= -1;
+			sampling_freq *= -1;
 
-		freq_cw = af9033_div(state, if_frequency, adc_freq, 23ul);
+		freq_cw = af9033_div(state, sampling_freq, adc_freq, 23ul);
 
 		if (spec_inv == -1)
-			freq_cw *= -1;
+			freq_cw = 0x800000 - freq_cw;
 
 		/* get adc multiplies */
 		ret = af9033_rd_reg(state, 0x800045, &tmp);

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
