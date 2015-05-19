Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbbESLXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 07:23:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 3/3] cx24120: constify static data
Date: Tue, 19 May 2015 08:23:38 -0300
Message-Id: <ed8e1da77d31ecd9f1509d160c9d990c58faae22.1432034614.git.mchehab@osg.samsung.com>
In-Reply-To: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
References: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
In-Reply-To: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
References: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use const on the static data, as gcc may optimize better the
code. Also, would prevent that some code would override the
data there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 2dcd93f63408..2b3f83d5b997 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -704,12 +704,14 @@ static int cx24120_read_status(struct dvb_frontend *fe, fe_status_t *status)
  * Used for decoding the REG_FECMODE register
  * once tuned in.
  */
-static struct cx24120_modfec {
+struct cx24120_modfec {
 	fe_delivery_system_t delsys;
 	fe_modulation_t mod;
 	fe_code_rate_t fec;
 	u8 val;
-} modfec_lookup_table[] = {
+};
+
+static const struct cx24120_modfec modfec_lookup_table[] = {
 	/*delsys     mod    fec       val */
 	{ SYS_DVBS,  QPSK,  FEC_1_2,  0x01 },
 	{ SYS_DVBS,  QPSK,  FEC_2_3,  0x02 },
@@ -784,7 +786,7 @@ static int cx24120_get_fec(struct dvb_frontend *fe)
  * There's probably some way of calculating these but I
  * can't determine the pattern
  */
-static struct cx24120_clock_ratios_table {
+struct cx24120_clock_ratios_table {
 	fe_delivery_system_t delsys;
 	fe_pilot_t pilot;
 	fe_modulation_t mod;
@@ -792,7 +794,9 @@ static struct cx24120_clock_ratios_table {
 	u32 m_rat;
 	u32 n_rat;
 	u32 rate;
-} clock_ratios_table[] = {
+};
+
+static const struct cx24120_clock_ratios_table clock_ratios_table[] = {
 	/*delsys     pilot      mod    fec       m_rat    n_rat   rate */
 	{ SYS_DVBS2, PILOT_OFF, QPSK,  FEC_1_2,  273088,  254505, 274 },
 	{ SYS_DVBS2, PILOT_OFF, QPSK,  FEC_3_5,  17272,   13395,  330 },
@@ -921,12 +925,14 @@ static int cx24120_set_inversion(struct cx24120_state *state,
 }
 
 /* FEC lookup table for tuning */
-static struct cx24120_modfec_table {
+struct cx24120_modfec_table {
 	fe_delivery_system_t delsys;
 	fe_modulation_t mod;
 	fe_code_rate_t fec;
 	u8 val;
-} modfec_table[] = {
+};
+
+static const struct cx24120_modfec_table modfec_table[] = {
 	/*delsys     mod    fec       val */
 	{ SYS_DVBS,  QPSK,  FEC_1_2,  0x2e },
 	{ SYS_DVBS,  QPSK,  FEC_2_3,  0x2f },
-- 
2.1.0

