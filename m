Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BYm029482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 39/47] [media] mt2063: don't crash if device is not initialized
Date: Wed,  4 Jan 2012 23:00:50 -0200
Message-Id: <1325725258-27934-40-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of crash, return -ENODEV, if the device is not poperly
initialized.

Also, give a second chance for it to initialize, at set_params
calls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 92653a9..db347d9 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -220,6 +220,8 @@ enum MT2063_Register_Offsets {
 struct mt2063_state {
 	struct i2c_adapter *i2c;
 
+	bool init;
+
 	const struct mt2063_config *config;
 	struct dvb_tuner_ops ops;
 	struct dvb_frontend *frontend;
@@ -1974,6 +1976,8 @@ static int mt2063_init(struct dvb_frontend *fe)
 	if (status < 0)
 		return status;
 
+	state->init = true;
+
 	return 0;
 }
 
@@ -1984,6 +1988,9 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 
 	dprintk(2, "\n");
 
+	if (!state->init)
+		return -ENODEV;
+
 	*tuner_status = 0;
 	status = mt2063_lockStatus(state);
 	if (status < 0)
@@ -2019,6 +2026,12 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 
 	dprintk(2, "\n");
 
+	if (!state->init) {
+		status = mt2063_init(fe);
+		if (status < 0)
+			return status;
+	}
+
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
 		pict_car = 38900000;
@@ -2082,6 +2095,12 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	s32 if_mid;
 	s32 rcvr_mode;
 
+	if (!state->init) {
+		status = mt2063_init(fe);
+		if (status < 0)
+			return status;
+	}
+
 	dprintk(2, "\n");
 
 	if (c->bandwidth_hz == 0)
@@ -2132,6 +2151,9 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 
 	dprintk(2, "\n");
 
+	if (!state->init)
+		return -ENODEV;
+
 	*freq = state->frequency;
 	return 0;
 }
@@ -2142,6 +2164,9 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 
 	dprintk(2, "\n");
 
+	if (!state->init)
+		return -ENODEV;
+
 	*bw = state->AS_Data.f_out_bw - 750000;
 	return 0;
 }
-- 
1.7.7.5

