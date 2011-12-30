Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UZ2026577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 60/94] [media] tda10071: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:57 -0200
Message-Id: <1325257711-12274-61-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10071.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index e9e00ea..68dcce6 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -636,8 +636,7 @@ error:
 	return ret;
 }
 
-static int tda10071_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int tda10071_set_frontend(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
 	struct tda10071_cmd cmd;
@@ -778,7 +777,7 @@ error:
 }
 
 static int tda10071_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+	struct dtv_frontend_properties *p)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1217,6 +1216,7 @@ error:
 EXPORT_SYMBOL(tda10071_attach);
 
 static struct dvb_frontend_ops tda10071_ops = {
+	.delsys = { SYS_DVBT, SYS_DVBT2 },
 	.info = {
 		.name = "NXP TDA10071",
 		.type = FE_QPSK,
@@ -1247,8 +1247,8 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.init = tda10071_init,
 	.sleep = tda10071_sleep,
 
-	.set_frontend_legacy = tda10071_set_frontend,
-	.get_frontend_legacy = tda10071_get_frontend,
+	.set_frontend = tda10071_set_frontend,
+	.get_frontend = tda10071_get_frontend,
 
 	.read_status = tda10071_read_status,
 	.read_snr = tda10071_read_snr,
-- 
1.7.8.352.g876a6

