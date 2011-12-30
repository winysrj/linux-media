Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UKb015918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 62/94] [media] nxt200x: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:59 -0200
Message-Id: <1325257711-12274-63-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/nxt200x.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index efb8e46..b541614 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -528,9 +528,9 @@ static int nxt2004_load_firmware (struct dvb_frontend* fe, const struct firmware
 	return 0;
 };
 
-static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
-					     struct dvb_frontend_parameters *p)
+static int nxt200x_setup_frontend_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct nxt200x_state* state = fe->demodulator_priv;
 	u8 buf[5];
 
@@ -546,7 +546,7 @@ static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
 	}
 
 	/* set additional params */
-	switch (p->u.vsb.modulation) {
+	switch (p->modulation) {
 		case QAM_64:
 		case QAM_256:
 			/* Set punctured clock for QAM */
@@ -576,7 +576,7 @@ static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
 	nxt200x_agc_reset(state);
 
 	/* set target power level */
-	switch (p->u.vsb.modulation) {
+	switch (p->modulation) {
 		case QAM_64:
 		case QAM_256:
 			buf[0] = 0x74;
@@ -620,7 +620,7 @@ static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
 	}
 
 	/* write sdmx input */
-	switch (p->u.vsb.modulation) {
+	switch (p->modulation) {
 		case QAM_64:
 				buf[0] = 0x68;
 				break;
@@ -714,7 +714,7 @@ static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
 	}
 
 	/* write agc ucgp0 */
-	switch (p->u.vsb.modulation) {
+	switch (p->modulation) {
 		case QAM_64:
 				buf[0] = 0x02;
 				break;
@@ -1203,7 +1203,7 @@ error:
 }
 
 static struct dvb_frontend_ops nxt200x_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Nextwave NXT200X VSB/QAM frontend",
 		.type = FE_ATSC,
@@ -1220,7 +1220,7 @@ static struct dvb_frontend_ops nxt200x_ops = {
 	.init = nxt200x_init,
 	.sleep = nxt200x_sleep,
 
-	.set_frontend_legacy = nxt200x_setup_frontend_parameters,
+	.set_frontend = nxt200x_setup_frontend_parameters,
 	.get_tune_settings = nxt200x_get_tune_settings,
 
 	.read_status = nxt200x_read_status,
-- 
1.7.8.352.g876a6

