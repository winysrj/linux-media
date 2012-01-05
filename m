Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05116FW016345
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/47] [media] mt2063: Move code from mt2063_cfg.h
Date: Wed,  4 Jan 2012 23:00:15 -0200
Message-Id: <1325725258-27934-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c     |  129 ++++++++++++++++++++++++++++++
 drivers/media/common/tuners/mt2063_cfg.h |  122 ----------------------------
 2 files changed, 129 insertions(+), 122 deletions(-)
 delete mode 100644 drivers/media/common/tuners/mt2063_cfg.h

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0d64eb8..1d36e51 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -13,6 +13,135 @@
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 
+
+/*****************/
+/* From drivers/media/common/tuners/mt2063_cfg.h */
+
+static unsigned int mt2063_setTune(struct dvb_frontend *fe, UData_t f_in,
+				   UData_t bw_in,
+				   enum MTTune_atv_standard tv_type)
+{
+	//return (int)MT_Tune_atv(h, f_in, bw_in, tv_type);
+
+	struct dvb_frontend_ops *frontend_ops = NULL;
+	struct dvb_tuner_ops *tuner_ops = NULL;
+	struct tuner_state t_state;
+	struct mt2063_state *mt2063State = fe->tuner_priv;
+	int err = 0;
+
+	t_state.frequency = f_in;
+	t_state.bandwidth = bw_in;
+	mt2063State->tv_type = tv_type;
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if ((err =
+		     tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY,
+					  &t_state)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_ops *frontend_ops = &fe->ops;
+	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
+	struct tuner_state t_state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->get_state) {
+		if ((err =
+		     tuner_ops->get_state(fe, DVBFE_TUNER_REFCLOCK,
+					  &t_state)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+	}
+	return err;
+}
+
+static unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_ops *frontend_ops = &fe->ops;
+	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
+	struct tuner_state t_state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if ((err =
+		     tuner_ops->set_state(fe, DVBFE_TUNER_OPEN,
+					  &t_state)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_ops *frontend_ops = &fe->ops;
+	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
+	struct tuner_state t_state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if ((err =
+		     tuner_ops->set_state(fe, DVBFE_TUNER_SOFTWARE_SHUTDOWN,
+					  &t_state)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+static unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_ops *frontend_ops = &fe->ops;
+	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
+	struct tuner_state t_state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if ((err =
+		     tuner_ops->set_state(fe, DVBFE_TUNER_CLEAR_POWER_MASKBITS,
+					  &t_state)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+	}
+
+	return err;
+}
+
+/*****************/
+
+
 //i2c operation
 static int mt2063_writeregs(struct mt2063_state *state, u8 reg1,
 			    u8 * data, int len)
diff --git a/drivers/media/common/tuners/mt2063_cfg.h b/drivers/media/common/tuners/mt2063_cfg.h
deleted file mode 100644
index 5f80f02..0000000
--- a/drivers/media/common/tuners/mt2063_cfg.h
+++ /dev/null
@@ -1,122 +0,0 @@
-
-static unsigned int mt2063_setTune(struct dvb_frontend *fe, UData_t f_in,
-				   UData_t bw_in,
-				   enum MTTune_atv_standard tv_type)
-{
-	//return (int)MT_Tune_atv(h, f_in, bw_in, tv_type);
-
-	struct dvb_frontend_ops *frontend_ops = NULL;
-	struct dvb_tuner_ops *tuner_ops = NULL;
-	struct tuner_state t_state;
-	struct mt2063_state *mt2063State = fe->tuner_priv;
-	int err = 0;
-
-	t_state.frequency = f_in;
-	t_state.bandwidth = bw_in;
-	mt2063State->tv_type = tv_type;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
-
-static unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->get_state) {
-		if ((err =
-		     tuner_ops->get_state(fe, DVBFE_TUNER_REFCLOCK,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-	return err;
-}
-
-static unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_OPEN,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
-
-static unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_SOFTWARE_SHUTDOWN,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
-
-static unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_CLEAR_POWER_MASKBITS,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
-- 
1.7.7.5

