Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1LaKXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 05:23:07 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVAN6Ub032138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 05:23:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] af9013: convert get|set_fontend to use DVBv5 parameters
Date: Sat, 31 Dec 2011 08:22:59 -0200
Message-Id: <1325326980-27464-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
References: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/af9013.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 8a8f78a..a70358c 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -572,8 +572,7 @@ static int af9013_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int af9013_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int af9013_set_frontend(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -847,10 +846,9 @@ err:
 }
 
 static int af9013_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+			       struct dtv_frontend_properties *c)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
@@ -1482,6 +1480,7 @@ err:
 EXPORT_SYMBOL(af9013_attach);
 
 static struct dvb_frontend_ops af9013_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9013",
 		.type = FE_OFDM,
@@ -1512,8 +1511,8 @@ static struct dvb_frontend_ops af9013_ops = {
 	.sleep = af9013_sleep,
 
 	.get_tune_settings = af9013_get_tune_settings,
-	.set_frontend_legacy = af9013_set_frontend,
-	.get_frontend_legacy = af9013_get_frontend,
+	.set_frontend = af9013_set_frontend,
+	.get_frontend = af9013_get_frontend,
 
 	.read_status = af9013_read_status,
 	.read_snr = af9013_read_snr,
-- 
1.7.8.352.g876a6

