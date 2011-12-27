Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab1L0BJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:39 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19cZ9005486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 28/91] [media] dvb_dummy_fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:16 -0200
Message-Id: <1324948159-23709-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-28-git-send-email-mchehab@redhat.com>
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

