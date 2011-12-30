Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9T9T026565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 50/94] [media] si21xx: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:47 -0200
Message-Id: <1325257711-12274-51-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/si21xx.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index badf449..e223f35 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -690,20 +690,7 @@ static int si21xx_setacquire(struct dvb_frontend *fe, int symbrate,
 	return status;
 }
 
-static int si21xx_set_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
-static int si21xx_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
-static int si21xx_set_frontend(struct dvb_frontend *fe,
-					struct dvb_frontend_parameters *dfp)
+static int si21xx_set_frontend(struct dvb_frontend *fe)
 {
 	struct si21xx_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -877,7 +864,7 @@ static void si21xx_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops si21xx_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "SL SI21XX DVB-S",
 		.type			= FE_QPSK,
@@ -908,9 +895,7 @@ static struct dvb_frontend_ops si21xx_ops = {
 	.set_tone = si21xx_set_tone,
 	.set_voltage = si21xx_set_voltage,
 
-	.set_property = si21xx_set_property,
-	.get_property = si21xx_get_property,
-	.set_frontend_legacy = si21xx_set_frontend,
+	.set_frontend = si21xx_set_frontend,
 };
 
 struct dvb_frontend *si21xx_attach(const struct si21xx_config *config,
-- 
1.7.8.352.g876a6

