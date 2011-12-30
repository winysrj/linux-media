Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9WX4024235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 74/94] [media] friio-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:11 -0200
Message-Id: <1325257711-12274-75-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/friio-fe.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index 7973aaf..375815d 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -283,22 +283,23 @@ static int jdvbt90502_set_property(struct dvb_frontend *fe,
 }
 
 static int jdvbt90502_get_frontend(struct dvb_frontend *fe,
-				   struct dvb_frontend_parameters *p)
+				   struct dtv_frontend_properties *p)
 {
 	p->inversion = INVERSION_AUTO;
-	p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
-	p->u.ofdm.code_rate_HP = FEC_AUTO;
-	p->u.ofdm.code_rate_LP = FEC_AUTO;
-	p->u.ofdm.constellation = QAM_64;
-	p->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
-	p->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
-	p->u.ofdm.hierarchy_information = HIERARCHY_AUTO;
+	p->bandwidth_hz = 6000000;
+	p->code_rate_HP = FEC_AUTO;
+	p->code_rate_LP = FEC_AUTO;
+	p->modulation = QAM_64;
+	p->transmission_mode = TRANSMISSION_MODE_AUTO;
+	p->guard_interval = GUARD_INTERVAL_AUTO;
+	p->hierarchy = HIERARCHY_AUTO;
 	return 0;
 }
 
-static int jdvbt90502_set_frontend(struct dvb_frontend *fe,
-				   struct dvb_frontend_parameters *p)
+static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
 	/**
 	 * NOTE: ignore all the parameters except frequency.
 	 *       others should be fixed to the proper value for ISDB-T,
@@ -438,14 +439,13 @@ error:
 }
 
 static struct dvb_frontend_ops jdvbt90502_ops = {
-
+	.delsys = { SYS_ISDBT },
 	.info = {
 		.name			= "Comtech JDVBT90502 ISDB-T",
 		.type			= FE_OFDM,
 		.frequency_min		= 473000000, /* UHF 13ch, center */
 		.frequency_max		= 767142857, /* UHF 62ch, center */
-		.frequency_stepsize	= JDVBT90502_PLL_CLK /
-							JDVBT90502_PLL_DIVIDER,
+		.frequency_stepsize	= JDVBT90502_PLL_CLK / JDVBT90502_PLL_DIVIDER,
 		.frequency_tolerance	= 0,
 
 		/* NOTE: this driver ignores all parameters but frequency. */
@@ -466,8 +466,8 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 
 	.set_property = jdvbt90502_set_property,
 
-	.set_frontend_legacy = jdvbt90502_set_frontend,
-	.get_frontend_legacy = jdvbt90502_get_frontend,
+	.set_frontend = jdvbt90502_set_frontend,
+	.get_frontend = jdvbt90502_get_frontend,
 
 	.read_status = jdvbt90502_read_status,
 	.read_signal_strength = jdvbt90502_read_signal_strength,
-- 
1.7.8.352.g876a6

