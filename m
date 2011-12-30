Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Q9W024156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 13/94] [media] av7110: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:10 -0200
Message-Id: <1325257711-12274-14-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/ttpci/av7110.c |   13 ++++++-------
 drivers/media/dvb/ttpci/av7110.h |    3 +--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index c615ed7..e0df729 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1971,15 +1971,14 @@ static int av7110_fe_lock_fix(struct av7110* av7110, fe_status_t status)
 	return ret;
 }
 
-static int av7110_fe_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
+static int av7110_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct av7110* av7110 = fe->dvb->priv;
 
 	int ret = av7110_fe_lock_fix(av7110, 0);
-	if (!ret) {
-		av7110->saved_fe_params = *params;
-		ret = av7110->fe_set_frontend(fe, params);
-	}
+	if (!ret)
+		ret = av7110->fe_set_frontend(fe);
+
 	return ret;
 }
 
@@ -2088,7 +2087,7 @@ static void dvb_s_recover(struct av7110* av7110)
 	msleep(20);
 	av7110_fe_set_tone(av7110->fe, av7110->saved_tone);
 
-	av7110_fe_set_frontend(av7110->fe, &av7110->saved_fe_params);
+	av7110_fe_set_frontend(av7110->fe);
 }
 
 static u8 read_pwm(struct av7110* av7110)
@@ -2283,7 +2282,7 @@ static int frontend_init(struct av7110 *av7110)
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_tone, av7110->fe_set_tone, av7110_fe_set_tone);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.dishnetwork_send_legacy_command, av7110->fe_dishnetwork_send_legacy_command, av7110_fe_dishnetwork_send_legacy_command);
-		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend_legacy, av7110->fe_set_frontend, av7110_fe_set_frontend);
+		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend, av7110->fe_set_frontend, av7110_fe_set_frontend);
 
 		ret = dvb_register_frontend(&av7110->dvb_adapter, av7110->fe);
 		if (ret < 0) {
diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/dvb/ttpci/av7110.h
index d85b851..16f0e0e 100644
--- a/drivers/media/dvb/ttpci/av7110.h
+++ b/drivers/media/dvb/ttpci/av7110.h
@@ -272,7 +272,6 @@ struct av7110 {
 
 	/* crash recovery */
 	void				(*recover)(struct av7110* av7110);
-	struct dvb_frontend_parameters	saved_fe_params;
 	fe_sec_voltage_t		saved_voltage;
 	fe_sec_tone_mode_t		saved_tone;
 	struct dvb_diseqc_master_cmd	saved_master_cmd;
@@ -286,7 +285,7 @@ struct av7110 {
 	int (*fe_set_tone)(struct dvb_frontend* fe, fe_sec_tone_mode_t tone);
 	int (*fe_set_voltage)(struct dvb_frontend* fe, fe_sec_voltage_t voltage);
 	int (*fe_dishnetwork_send_legacy_command)(struct dvb_frontend* fe, unsigned long cmd);
-	int (*fe_set_frontend)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
+	int (*fe_set_frontend)(struct dvb_frontend* fe);
 };
 
 
-- 
1.7.8.352.g876a6

