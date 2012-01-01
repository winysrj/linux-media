Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBNl0009026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/9] [media] dvb: Initialize all cache values
Date: Sun,  1 Jan 2012 18:11:10 -0200
Message-Id: <1325448678-13001-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By default, initialize the frontend current delivery system with
the first one. This warrants that a DVBv3 application will be able
to tune to it, after the removal of ops->init.type filling at
the drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d030cd3..b72b87e 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -873,17 +873,22 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	memset(c, 0, sizeof(struct dtv_frontend_properties));
 
 	c->state = DTV_CLEAR;
-	c->delivery_system = SYS_UNDEFINED;
-	c->inversion = INVERSION_AUTO;
-	c->fec_inner = FEC_AUTO;
+
+	c->delivery_system = fe->ops.delsys[0];
+
 	c->transmission_mode = TRANSMISSION_MODE_AUTO;
-	c->bandwidth_hz = BANDWIDTH_AUTO;
+	c->bandwidth_hz = 0;	/* AUTO */
 	c->guard_interval = GUARD_INTERVAL_AUTO;
 	c->hierarchy = HIERARCHY_AUTO;
-	c->symbol_rate = QAM_AUTO;
+	c->symbol_rate = 0;
 	c->code_rate_HP = FEC_AUTO;
 	c->code_rate_LP = FEC_AUTO;
+	c->fec_inner = FEC_AUTO;
 	c->rolloff = ROLLOFF_AUTO;
+	c->voltage = SEC_VOLTAGE_OFF;
+	c->modulation = QAM_AUTO;
+	c->sectone = SEC_TONE_OFF;
+	c->pilot = PILOT_AUTO;
 
 	c->isdbt_partial_reception = -1;
 	c->isdbt_sb_mode = -1;
@@ -898,6 +903,9 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 		c->layer[i].segment_count = -1;
 	}
 
+	c->isdbs_ts_id = 0;
+	c->dvbt2_plp_id = 0;
+
 	return 0;
 }
 
-- 
1.7.8.352.g876a6

