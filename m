Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1L0BJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:40 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19ei9032649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 29/91] [media] ec100: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:17 -0200
Message-Id: <1324948159-23709-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-29-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/ec100.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb/frontends/ec100.c
index 20decd7..39e0811 100644
--- a/drivers/media/dvb/frontends/ec100.c
+++ b/drivers/media/dvb/frontends/ec100.c
@@ -76,15 +76,15 @@ static int ec100_read_reg(struct ec100_state *state, u8 reg, u8 *val)
 	return 0;
 }
 
-static int ec100_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int ec100_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ec100_state *state = fe->demodulator_priv;
 	int ret;
 	u8 tmp, tmp2;
 
-	deb_info("%s: freq:%d bw:%d\n", __func__, params->frequency,
-		params->u.ofdm.bandwidth);
+	deb_info("%s: freq:%d bw:%d\n", __func__, c->frequency,
+		c->bandwidth_hz);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -108,16 +108,16 @@ static int ec100_set_frontend(struct dvb_frontend *fe,
 	   B 0x1b | 0xb7 | 0x00 | 0x49
 	   B 0x1c | 0x55 | 0x64 | 0x72 */
 
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (c->bandwidth_hz) {
+	case 6000000:
 		tmp = 0xb7;
 		tmp2 = 0x55;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		tmp = 0x00;
 		tmp2 = 0x64;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 	default:
 		tmp = 0x49;
 		tmp2 = 0x72;
@@ -306,6 +306,7 @@ error:
 EXPORT_SYMBOL(ec100_attach);
 
 static struct dvb_frontend_ops ec100_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "E3C EC100 DVB-T",
 		.type = FE_OFDM,
@@ -321,7 +322,7 @@ static struct dvb_frontend_ops ec100_ops = {
 	},
 
 	.release = ec100_release,
-	.set_frontend_legacy = ec100_set_frontend,
+	.set_frontend = ec100_set_frontend,
 	.get_tune_settings = ec100_get_tune_settings,
 	.read_status = ec100_read_status,
 	.read_ber = ec100_read_ber,
-- 
1.7.8.352.g876a6

