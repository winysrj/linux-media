Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab1L0BJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:43 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19h76017912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 69/91] [media] staging/as102: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:57 -0200
Message-Id: <1324948159-23709-70-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-69-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
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
 drivers/staging/media/as102/as102_fe.c    |   78 ++++++++++++++--------------
 drivers/staging/media/as102/as10x_cmd.c   |    4 +-
 drivers/staging/media/as102/as10x_types.h |    4 +-
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index b0c5128..d6472ea 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -23,15 +23,15 @@
 #include "as10x_types.h"
 #include "as10x_cmd.h"
 
-static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
+static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *dst,
 					 struct as10x_tps *src);
 
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
-					  struct dvb_frontend_parameters *src);
+					  struct dtv_frontend_properties *src);
 
-static int as102_fe_set_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *params)
+static int as102_fe_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret = 0;
 	struct as102_dev_t *dev;
 	struct as10x_tune_args tune_args = { 0 };
@@ -45,7 +45,7 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe,
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
 		return -EBUSY;
 
-	as102_fe_copy_tune_parameters(&tune_args, params);
+	as102_fe_copy_tune_parameters(&tune_args, p);
 
 	/* send abilis command: SET_TUNE */
 	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
@@ -59,7 +59,8 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe,
 }
 
 static int as102_fe_get_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p) {
+				 struct dtv_frontend_properties *p)
+{
 	int ret = 0;
 	struct as102_dev_t *dev;
 	struct as10x_tps tps = { 0 };
@@ -278,6 +279,7 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 }
 
 static struct dvb_frontend_ops as102_fe_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Unknown AS102 device",
 		.type			= FE_OFDM,
@@ -296,8 +298,8 @@ static struct dvb_frontend_ops as102_fe_ops = {
 			| FE_CAN_MUTE_TS
 	},
 
-	.set_frontend_legacy	= as102_fe_set_frontend,
-	.get_frontend_legacy	= as102_fe_get_frontend,
+	.set_frontend		= as102_fe_set_frontend,
+	.get_frontend		= as102_fe_get_frontend,
 	.get_tune_settings	= as102_fe_get_tune_settings,
 
 	.read_status		= as102_fe_read_status,
@@ -344,38 +346,36 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
 	return errno;
 }
 
-static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
+static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
 					 struct as10x_tps *as10x_tps)
 {
 
-	struct dvb_ofdm_parameters *fe_tps = &dst->u.ofdm;
-
 	/* extract consteallation */
-	switch (as10x_tps->constellation) {
+	switch (as10x_tps->modulation) {
 	case CONST_QPSK:
-		fe_tps->constellation = QPSK;
+		fe_tps->modulation = QPSK;
 		break;
 	case CONST_QAM16:
-		fe_tps->constellation = QAM_16;
+		fe_tps->modulation = QAM_16;
 		break;
 	case CONST_QAM64:
-		fe_tps->constellation = QAM_64;
+		fe_tps->modulation = QAM_64;
 		break;
 	}
 
 	/* extract hierarchy */
 	switch (as10x_tps->hierarchy) {
 	case HIER_NONE:
-		fe_tps->hierarchy_information = HIERARCHY_NONE;
+		fe_tps->hierarchy = HIERARCHY_NONE;
 		break;
 	case HIER_ALPHA_1:
-		fe_tps->hierarchy_information = HIERARCHY_1;
+		fe_tps->hierarchy = HIERARCHY_1;
 		break;
 	case HIER_ALPHA_2:
-		fe_tps->hierarchy_information = HIERARCHY_2;
+		fe_tps->hierarchy = HIERARCHY_2;
 		break;
 	case HIER_ALPHA_4:
-		fe_tps->hierarchy_information = HIERARCHY_4;
+		fe_tps->hierarchy = HIERARCHY_4;
 		break;
 	}
 
@@ -473,7 +473,7 @@ static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
 }
 
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
-			  struct dvb_frontend_parameters *params)
+			  struct dtv_frontend_properties *params)
 {
 
 	/* set frequency */
@@ -482,21 +482,21 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 	/* fix interleaving_mode */
 	tune_args->interleaving_mode = INTLV_NATIVE;
 
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_8_MHZ:
+	switch (params->bandwidth_hz) {
+	case 8000000:
 		tune_args->bandwidth = BW_8_MHZ;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		tune_args->bandwidth = BW_7_MHZ;
 		break;
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		tune_args->bandwidth = BW_6_MHZ;
 		break;
 	default:
 		tune_args->bandwidth = BW_8_MHZ;
 	}
 
-	switch (params->u.ofdm.guard_interval) {
+	switch (params->guard_interval) {
 	case GUARD_INTERVAL_1_32:
 		tune_args->guard_interval = GUARD_INT_1_32;
 		break;
@@ -515,22 +515,22 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 		break;
 	}
 
-	switch (params->u.ofdm.constellation) {
+	switch (params->modulation) {
 	case QPSK:
-		tune_args->constellation = CONST_QPSK;
+		tune_args->modulation = CONST_QPSK;
 		break;
 	case QAM_16:
-		tune_args->constellation = CONST_QAM16;
+		tune_args->modulation = CONST_QAM16;
 		break;
 	case QAM_64:
-		tune_args->constellation = CONST_QAM64;
+		tune_args->modulation = CONST_QAM64;
 		break;
 	default:
-		tune_args->constellation = CONST_UNKNOWN;
+		tune_args->modulation = CONST_UNKNOWN;
 		break;
 	}
 
-	switch (params->u.ofdm.transmission_mode) {
+	switch (params->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		tune_args->transmission_mode = TRANS_MODE_2K;
 		break;
@@ -541,7 +541,7 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 		tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
 	}
 
-	switch (params->u.ofdm.hierarchy_information) {
+	switch (params->hierarchy) {
 	case HIERARCHY_NONE:
 		tune_args->hierarchy = HIER_NONE;
 		break;
@@ -569,19 +569,19 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 	 * if HP/LP are both set to FEC_NONE, HP will be selected.
 	 */
 	if ((tune_args->hierarchy != HIER_NONE) &&
-		       ((params->u.ofdm.code_rate_LP == FEC_NONE) ||
-			(params->u.ofdm.code_rate_HP == FEC_NONE))) {
+		       ((params->code_rate_LP == FEC_NONE) ||
+			(params->code_rate_HP == FEC_NONE))) {
 
-		if (params->u.ofdm.code_rate_LP == FEC_NONE) {
+		if (params->code_rate_LP == FEC_NONE) {
 			tune_args->hier_select = HIER_HIGH_PRIORITY;
 			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+			   as102_fe_get_code_rate(params->code_rate_HP);
 		}
 
-		if (params->u.ofdm.code_rate_HP == FEC_NONE) {
+		if (params->code_rate_HP == FEC_NONE) {
 			tune_args->hier_select = HIER_LOW_PRIORITY;
 			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
+			   as102_fe_get_code_rate(params->code_rate_LP);
 		}
 
 		dprintk(debug, "\thierarchy: 0x%02x  "
@@ -594,6 +594,6 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			tune_args->code_rate);
 	} else {
 		tune_args->code_rate =
-			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+			as102_fe_get_code_rate(params->code_rate_HP);
 	}
 }
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 0387bb8..262bb94 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -141,7 +141,7 @@ int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
 	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
 	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
-	preq->body.set_tune.req.args.constellation = ptune->constellation;
+	preq->body.set_tune.req.args.modulation = ptune->modulation;
 	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
 	preq->body.set_tune.req.args.interleaving_mode  =
 		ptune->interleaving_mode;
@@ -279,7 +279,7 @@ int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 		goto out;
 
 	/* Response OK -> get response data */
-	ptps->constellation = prsp->body.get_tps.rsp.tps.constellation;
+	ptps->modulation = prsp->body.get_tps.rsp.tps.modulation;
 	ptps->hierarchy = prsp->body.get_tps.rsp.tps.hierarchy;
 	ptps->interleaving_mode = prsp->body.get_tps.rsp.tps.interleaving_mode;
 	ptps->code_rate_HP = prsp->body.get_tps.rsp.tps.code_rate_HP;
diff --git a/drivers/staging/media/as102/as10x_types.h b/drivers/staging/media/as102/as10x_types.h
index c40c812..fde8140 100644
--- a/drivers/staging/media/as102/as10x_types.h
+++ b/drivers/staging/media/as102/as10x_types.h
@@ -112,7 +112,7 @@
 #define CFG_MODE_AUTO	2
 
 struct as10x_tps {
-	uint8_t constellation;
+	uint8_t modulation;
 	uint8_t hierarchy;
 	uint8_t interleaving_mode;
 	uint8_t code_rate_HP;
@@ -132,7 +132,7 @@ struct as10x_tune_args {
 	/* hierarchy selection */
 	uint8_t hier_select;
 	/* constellation */
-	uint8_t constellation;
+	uint8_t modulation;
 	/* hierarchy */
 	uint8_t hierarchy;
 	/* interleaving mode */
-- 
1.7.8.352.g876a6

