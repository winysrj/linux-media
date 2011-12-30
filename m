Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RsN009105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 28/94] [media] dvb_dummy_fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:25 -0200
Message-Id: <1325257711-12274-29-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/dvb_dummy_fe.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index 31e1dd6..b5e2a70 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -68,12 +68,13 @@ static int dvb_dummy_fe_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int dvb_dummy_fe_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int dvb_dummy_fe_get_frontend(struct dvb_frontend *fe,
+				     struct dtv_frontend_properties *c)
 {
 	return 0;
 }
 
-static int dvb_dummy_fe_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int dvb_dummy_fe_set_frontend(struct dvb_frontend* fe)
 {
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
@@ -171,7 +172,7 @@ error:
 }
 
 static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Dummy DVB-T",
 		.type			= FE_OFDM,
@@ -192,8 +193,8 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
+	.set_frontend = dvb_dummy_fe_set_frontend,
+	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
@@ -203,7 +204,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 };
 
 static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
-
+	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name			= "Dummy DVB-C",
 		.type			= FE_QAM,
@@ -222,8 +223,8 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
+	.set_frontend = dvb_dummy_fe_set_frontend,
+	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
@@ -233,7 +234,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 };
 
 static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Dummy DVB-S",
 		.type			= FE_QPSK,
@@ -254,8 +255,8 @@ static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.init = dvb_dummy_fe_init,
 	.sleep = dvb_dummy_fe_sleep,
 
-	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
+	.set_frontend = dvb_dummy_fe_set_frontend,
+	.get_frontend = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
-- 
1.7.8.352.g876a6

