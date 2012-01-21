Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4iKd017789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 20/35] [media] az6007: Use the new MFE support at dvb-usb
Date: Sat, 21 Jan 2012 14:04:22 -0200
Message-Id: <1327161877-16784-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-20-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly dvb-usb MFE support added by
changeset 9bd9e3bd2c57530dfe3057dd0aa9bdb37824925d.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   74 ++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index c9b6f80..b667854 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -59,7 +59,7 @@ struct az6007_device_state {
 	/* Due to DRX-K - probably need changes */
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
 	struct			semaphore pll_mutex;
-	bool			dont_attach_fe1;
+	bool			tuner_attached;
 };
 
 static struct drxk_config terratec_h7_drxk = {
@@ -290,56 +290,56 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct az6007_device_state *st = adap->priv;
 
-	int result;
+	/* FIXME: dvb-usb will call this function twice! */
+	if (adap->fe[0])
+		return 0;
 
 	BUG_ON(!st);
 
 	az6007_frontend_poweron(adap);
 
-	info("az6007: attaching demod drxk");
-	adap->fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
-			      &adap->dev->i2c_adap, &adap->fe2);
-	if (!adap->fe) {
-		result = -EINVAL;
-		goto out_free;
-	}
-
-	deb_info("Setting hacks\n");
+	info("attaching demod drxk");
+	adap->fe[0] = dvb_attach(drxk_attach, &terratec_h7_drxk,
+			         &adap->dev->i2c_adap, &adap->fe[1]);
+	if (!adap->fe[0])
+		return -EINVAL;
 
+	adap->fe[0]->sec_priv = adap;
 	/* FIXME: do we need a pll semaphore? */
-	adap->fe->sec_priv = adap;
 	sema_init(&st->pll_mutex, 1);
-	st->gate_ctrl = adap->fe->ops.i2c_gate_ctrl;
-	adap->fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-	adap->fe2->id = 1;
+	st->gate_ctrl = adap->fe[0]->ops.i2c_gate_ctrl;
+	adap->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	adap->dont_attach_fe[1] = true;
+
+	return 0;
+}
+
+static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct az6007_device_state *st = adap->priv;
+
+	if (st->tuner_attached)
+		return 0;
+
+	st->tuner_attached = true;
 
-	info("az6007: attaching tuner mt2063");
+	info("attaching tuner mt2063");
 	/* Attach mt2063 to DVB-C frontend */
-	if (adap->fe->ops.i2c_gate_ctrl)
-		adap->fe->ops.i2c_gate_ctrl(adap->fe, 1);
-	if (!dvb_attach(mt2063_attach, adap->fe, &az6007_mt2063_config,
-			&adap->dev->i2c_adap)) {
-		result = -EINVAL;
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 1);
+	if (!dvb_attach(mt2063_attach, adap->fe[0], &az6007_mt2063_config,
+			&adap->dev->i2c_adap))
+		return -EINVAL;
 
-		goto out_free;
-	}
-	if (adap->fe->ops.i2c_gate_ctrl)
-		adap->fe->ops.i2c_gate_ctrl(adap->fe, 0);
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 0);
 
 	/* Hack - needed due to drxk */
-	adap->fe2->tuner_priv = adap->fe->tuner_priv;
-	memcpy(&adap->fe2->ops.tuner_ops,
-	       &adap->fe->ops.tuner_ops, sizeof(adap->fe->ops.tuner_ops));
+	adap->fe[1]->tuner_priv = adap->fe[0]->tuner_priv;
+	memcpy(&adap->fe[1]->ops.tuner_ops,
+	       &adap->fe[0]->ops.tuner_ops, sizeof(adap->fe[0]->ops.tuner_ops));
 
 	return 0;
-
-out_free:
-	if (adap->fe)
-		dvb_frontend_detach(adap->fe);
-	adap->fe = NULL;
-	adap->fe2 = NULL;
-
-	return result;
 }
 
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
@@ -530,7 +530,9 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.num_adapters = 1,
 	.adapter = {
 		{
+			.num_frontends    = 2,
 			.streaming_ctrl   = az6007_streaming_ctrl,
+			.tuner_attach     = az6007_tuner_attach,
 			.frontend_attach  = az6007_frontend_attach,
 
 			/* parameter for the MPEG2-data transfer */
-- 
1.7.8

