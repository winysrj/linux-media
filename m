Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4i6Y023685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 21/35] [media] az6007: Change it to use the MFE solution adopted at dvb-usb
Date: Sat, 21 Jan 2012 14:04:23 -0200
Message-Id: <1327161877-16784-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-21-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver were written to use a previous solution for MFE at dvb-usb.
Due to the internal API changes, change the binding to work with the
new way.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   42 ++++++++++++++---------------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index b667854..92ded30 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -66,7 +66,7 @@ static struct drxk_config terratec_h7_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 0,
-	.max_size = 64,
+	.chunk_size = 64,
 	.microcode_name = "dvb-usb-terratec-h7-drxk.fw",
 	.parallel_ts = 1,
 };
@@ -290,26 +290,21 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct az6007_device_state *st = adap->priv;
 
-	/* FIXME: dvb-usb will call this function twice! */
-	if (adap->fe[0])
-		return 0;
-
 	BUG_ON(!st);
 
 	az6007_frontend_poweron(adap);
 
 	info("attaching demod drxk");
-	adap->fe[0] = dvb_attach(drxk_attach, &terratec_h7_drxk,
-			         &adap->dev->i2c_adap, &adap->fe[1]);
-	if (!adap->fe[0])
+	adap->fe_adap[0].fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
+					 &adap->dev->i2c_adap);
+	if (!adap->fe_adap[0].fe)
 		return -EINVAL;
 
-	adap->fe[0]->sec_priv = adap;
+	adap->fe_adap[0].fe->sec_priv = adap;
 	/* FIXME: do we need a pll semaphore? */
 	sema_init(&st->pll_mutex, 1);
-	st->gate_ctrl = adap->fe[0]->ops.i2c_gate_ctrl;
-	adap->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-	adap->dont_attach_fe[1] = true;
+	st->gate_ctrl = adap->fe_adap[0].fe->ops.i2c_gate_ctrl;
+	adap->fe_adap[0].fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 
 	return 0;
 }
@@ -325,19 +320,15 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 
 	info("attaching tuner mt2063");
 	/* Attach mt2063 to DVB-C frontend */
-	if (adap->fe[0]->ops.i2c_gate_ctrl)
-		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 1);
-	if (!dvb_attach(mt2063_attach, adap->fe[0], &az6007_mt2063_config,
+	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
+		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 1);
+	if (!dvb_attach(mt2063_attach, adap->fe_adap[0].fe, 
+			&az6007_mt2063_config,
 			&adap->dev->i2c_adap))
 		return -EINVAL;
 
-	if (adap->fe[0]->ops.i2c_gate_ctrl)
-		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 0);
-
-	/* Hack - needed due to drxk */
-	adap->fe[1]->tuner_priv = adap->fe[0]->tuner_priv;
-	memcpy(&adap->fe[1]->ops.tuner_ops,
-	       &adap->fe[0]->ops.tuner_ops, sizeof(adap->fe[0]->ops.tuner_ops));
+	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
+		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 0);
 
 	return 0;
 }
@@ -530,7 +521,8 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.num_adapters = 1,
 	.adapter = {
 		{
-			.num_frontends    = 2,
+		.num_frontends = 1,
+		.fe = {{
 			.streaming_ctrl   = az6007_streaming_ctrl,
 			.tuner_attach     = az6007_tuner_attach,
 			.frontend_attach  = az6007_frontend_attach,
@@ -547,8 +539,8 @@ static struct dvb_usb_device_properties az6007_properties = {
 				}
 			},
 			.size_of_priv     = sizeof(struct az6007_device_state),
-		}
-	},
+		}}
+	} },
 	.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
 
-- 
1.7.8

