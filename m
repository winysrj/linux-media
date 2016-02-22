Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbcBVTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/9] [media] ttpci: cleanup a bogus smatch warning
Date: Mon, 22 Feb 2016 16:09:22 -0300
Message-Id: <29691c3d0b3692a54e3dfc8bd07c09b524156093.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup this bogus smatch warning:
	drivers/media/pci/ttpci/budget.c:635 frontend_init() warn: missing break? reassigning 'budget->dvb_frontend'

And document the fall through logic at the switch().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/ttpci/budget.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
index 9f48100227f1..fb8ede5a1531 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -615,33 +615,47 @@ static void frontend_init(struct budget *budget)
 		break;
 
 	case 0x1016: // Hauppauge/TT Nova-S SE (samsung s5h1420/????(tda8260))
-		budget->dvb_frontend = dvb_attach(s5h1420_attach, &s5h1420_config, &budget->i2c_adap);
-		if (budget->dvb_frontend) {
-			budget->dvb_frontend->ops.tuner_ops.set_params = s5h1420_tuner_set_params;
-			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
+	{
+		struct dvb_frontend *fe;
+
+		fe = dvb_attach(s5h1420_attach, &s5h1420_config, &budget->i2c_adap);
+		if (fe) {
+			fe->ops.tuner_ops.set_params = s5h1420_tuner_set_params;
+			budget->dvb_frontend = fe;
+			if (dvb_attach(lnbp21_attach, fe, &budget->i2c_adap,
+				       0, 0) == NULL) {
 				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
 		}
-
+	}
+	/* fall through */
 	case 0x1018: // TT Budget-S-1401 (philips tda10086/philips tda8262)
+	{
+		struct dvb_frontend *fe;
+
 		// gpio2 is connected to CLB - reset it + leave it high
 		saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
 		msleep(1);
 		saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
 		msleep(1);
 
-		budget->dvb_frontend = dvb_attach(tda10086_attach, &tda10086_config, &budget->i2c_adap);
-		if (budget->dvb_frontend) {
-			if (dvb_attach(tda826x_attach, budget->dvb_frontend, 0x60, &budget->i2c_adap, 0) == NULL)
+		fe = dvb_attach(tda10086_attach, &tda10086_config, &budget->i2c_adap);
+		if (fe) {
+			budget->dvb_frontend = fe;
+			if (dvb_attach(tda826x_attach, fe, 0x60,
+				       &budget->i2c_adap, 0) == NULL)
 				printk("%s: No tda826x found!\n", __func__);
-			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
+			if (dvb_attach(lnbp21_attach, fe,
+				       &budget->i2c_adap, 0, 0) == NULL) {
 				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
 		}
+	}
+	/* fall through */
 
 	case 0x101c: { /* TT S2-1600 */
 			const struct stv6110x_devctl *ctl;
-- 
2.5.0

