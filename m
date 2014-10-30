Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbaJ3OQF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 10:16:05 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] cx23885-dvb: Fix some issues at the DVB error handling
Date: Thu, 30 Oct 2014 12:15:53 -0200
Message-Id: <1414678553-10191-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by smatch:
	drivers/media/pci/cx23885/cx23885-dvb.c:1066 dvb_register() error: we previously assumed 'fe0->dvb.frontend' could be null (see line 1060)
	drivers/media/pci/cx23885/cx23885-dvb.c:1990 cx23885_dvb_register() error: we previously assumed 'fe0' could be null (see line 1975)

What happens is that the error handling logic when a frontend
register fails sometimes keep doing the work, as if it didn't
fail.

This could potentially cause an OOPS. So, simplify the logic
a little bit and return an error if frontend fails before
trying to setup VB2 queue.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 290 ++++++++++++++++----------------
 1 file changed, 145 insertions(+), 145 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 757854914781..043d9c91fbbd 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1045,11 +1045,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_generic_config,
 						&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(mt2131_attach, fe0->dvb.frontend,
-				   &i2c_bus->i2c_adap,
-				   &hauppauge_generic_tunerconfig, 0);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(mt2131_attach, fe0->dvb.frontend,
+			   &i2c_bus->i2c_adap,
+			   &hauppauge_generic_tunerconfig, 0);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
@@ -1057,11 +1057,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(lgdt3305_attach,
 					       &hauppauge_lgdt3305_config,
 					       &i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(tda18271_attach, fe0->dvb.frontend,
-				   0x60, &dev->i2c_bus[1].i2c_adap,
-				   &hauppauge_hvr127x_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(tda18271_attach, fe0->dvb.frontend,
+			   0x60, &dev->i2c_bus[1].i2c_adap,
+			   &hauppauge_hvr127x_config);
 		if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1275)
 			cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
@@ -1071,11 +1071,12 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 					       &hcw_s5h1411_config,
 					       &i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(tda18271_attach, fe0->dvb.frontend,
-				   0x60, &dev->i2c_bus[1].i2c_adap,
-				   &hauppauge_tda18271_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+
+		dvb_attach(tda18271_attach, fe0->dvb.frontend,
+			   0x60, &dev->i2c_bus[1].i2c_adap,
+			   &hauppauge_tda18271_config);
 
 		tda18271_attach(&dev->ts1.analog_fe,
 			0x60, &dev->i2c_bus[1].i2c_adap,
@@ -1090,14 +1091,15 @@ static int dvb_register(struct cx23885_tsport *port)
 				dvb_attach(s5h1409_attach,
 					   &hauppauge_ezqam_config,
 					   &i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				dvb_attach(tda829x_attach, fe0->dvb.frontend,
-					   &dev->i2c_bus[1].i2c_adap, 0x42,
-					   &tda829x_no_probe);
-				dvb_attach(tda18271_attach, fe0->dvb.frontend,
-					   0x60, &dev->i2c_bus[1].i2c_adap,
-					   &hauppauge_tda18271_config);
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_bus[1].i2c_adap, 0x42,
+				   &tda829x_no_probe);
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
+				   0x60, &dev->i2c_bus[1].i2c_adap,
+				   &hauppauge_tda18271_config);
 			break;
 		case 0:
 		default:
@@ -1105,11 +1107,11 @@ static int dvb_register(struct cx23885_tsport *port)
 				dvb_attach(s5h1409_attach,
 					   &hauppauge_generic_config,
 					   &i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL)
-				dvb_attach(mt2131_attach, fe0->dvb.frontend,
-					   &i2c_bus->i2c_adap,
-					   &hauppauge_generic_tunerconfig, 0);
-			break;
+			if (fe0->dvb.frontend == NULL)
+				break;
+			dvb_attach(mt2131_attach, fe0->dvb.frontend,
+				   &i2c_bus->i2c_adap,
+				   &hauppauge_generic_tunerconfig, 0);
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
@@ -1117,32 +1119,33 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_hvr1800lp_config,
 						&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(mt2131_attach, fe0->dvb.frontend,
-				   &i2c_bus->i2c_adap,
-				   &hauppauge_generic_tunerconfig, 0);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(mt2131_attach, fe0->dvb.frontend,
+			   &i2c_bus->i2c_adap,
+			   &hauppauge_generic_tunerconfig, 0);
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
 		i2c_bus = &dev->i2c_bus[0];
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 						&fusionhdtv_5_express,
 						&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
-				   &i2c_bus->i2c_adap, 0x61,
-				   TUNER_LG_TDVS_H06XF);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
+			   &i2c_bus->i2c_adap, 0x61,
+			   TUNER_LG_TDVS_H06XF);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 		i2c_bus = &dev->i2c_bus[1];
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_hvr1500q_config,
 						&dev->i2c_bus[0].i2c_adap);
-		if (fe0->dvb.frontend != NULL)
-			dvb_attach(xc5000_attach, fe0->dvb.frontend,
-				   &i2c_bus->i2c_adap,
-				   &hauppauge_hvr1500q_tunerconfig);
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(xc5000_attach, fe0->dvb.frontend,
+			   &i2c_bus->i2c_adap,
+			   &hauppauge_hvr1500q_tunerconfig);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 		i2c_bus = &dev->i2c_bus[1];
@@ -1173,14 +1176,14 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 			&hauppauge_hvr1200_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(tda829x_attach, fe0->dvb.frontend,
-				&dev->i2c_bus[1].i2c_adap, 0x42,
-				&tda829x_no_probe);
-			dvb_attach(tda18271_attach, fe0->dvb.frontend,
-				0x60, &dev->i2c_bus[1].i2c_adap,
-				&hauppauge_hvr1200_tuner_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(tda829x_attach, fe0->dvb.frontend,
+			   &dev->i2c_bus[1].i2c_adap, 0x42,
+			   &tda829x_no_probe);
+		dvb_attach(tda18271_attach, fe0->dvb.frontend,
+			   0x60, &dev->i2c_bus[1].i2c_adap,
+			   &hauppauge_hvr1200_tuner_config);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 		i2c_bus = &dev->i2c_bus[0];
@@ -1439,12 +1442,10 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
 			&mygica_x8506_lgs8gl5_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(xc5000_attach,
-				fe0->dvb.frontend,
-				&i2c_bus2->i2c_adap,
-				&mygica_x8506_xc5000_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(xc5000_attach, fe0->dvb.frontend,
+			   &i2c_bus2->i2c_adap, &mygica_x8506_xc5000_config);
 		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
 	case CX23885_BOARD_MYGICA_X8507:
@@ -1453,12 +1454,12 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
 			&mygica_x8507_mb86a20s_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(xc5000_attach,
-			fe0->dvb.frontend,
-			&i2c_bus2->i2c_adap,
-			&mygica_x8507_xc5000_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+
+		dvb_attach(xc5000_attach, fe0->dvb.frontend,
+			   &i2c_bus2->i2c_adap,
+			   &mygica_x8507_xc5000_config);
 		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
@@ -1467,12 +1468,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
 			&magicpro_prohdtve2_lgs8g75_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(xc5000_attach,
-				fe0->dvb.frontend,
-				&i2c_bus2->i2c_adap,
-				&magicpro_prohdtve2_xc5000_config);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(xc5000_attach, fe0->dvb.frontend,
+			   &i2c_bus2->i2c_adap,
+			   &magicpro_prohdtve2_xc5000_config);
 		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
@@ -1480,10 +1480,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 			&hcw_s5h1411_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
-			dvb_attach(tda18271_attach, fe0->dvb.frontend,
-				0x60, &dev->i2c_bus[0].i2c_adap,
-				&hauppauge_tda18271_config);
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(tda18271_attach, fe0->dvb.frontend,
+			   0x60, &dev->i2c_bus[0].i2c_adap,
+			   &hauppauge_tda18271_config);
 
 		tda18271_attach(&dev->ts1.analog_fe,
 			0x60, &dev->i2c_bus[1].i2c_adap,
@@ -1495,10 +1496,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 			&hcw_s5h1411_config,
 			&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
-			dvb_attach(tda18271_attach, fe0->dvb.frontend,
-				0x60, &dev->i2c_bus[0].i2c_adap,
-				&hauppauge_tda18271_config);
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(tda18271_attach, fe0->dvb.frontend,
+			   0x60, &dev->i2c_bus[0].i2c_adap,
+			   &hauppauge_tda18271_config);
 		break;
 	case CX23885_BOARD_MYGICA_X8558PRO:
 		switch (port->nr) {
@@ -1508,12 +1510,11 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe0->dvb.frontend = dvb_attach(atbm8830_attach,
 				&mygica_x8558pro_atbm8830_cfg1,
 				&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				dvb_attach(max2165_attach,
-					fe0->dvb.frontend,
-					&i2c_bus->i2c_adap,
-					&mygic_x8558pro_max2165_cfg1);
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+			dvb_attach(max2165_attach, fe0->dvb.frontend,
+				   &i2c_bus->i2c_adap,
+				   &mygic_x8558pro_max2165_cfg1);
 			break;
 		/* port C */
 		case 2:
@@ -1521,13 +1522,11 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe0->dvb.frontend = dvb_attach(atbm8830_attach,
 				&mygica_x8558pro_atbm8830_cfg2,
 				&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				dvb_attach(max2165_attach,
-					fe0->dvb.frontend,
-					&i2c_bus->i2c_adap,
-					&mygic_x8558pro_max2165_cfg2);
-			}
-			break;
+			if (fe0->dvb.frontend == NULL)
+				break;
+			dvb_attach(max2165_attach, fe0->dvb.frontend,
+				   &i2c_bus->i2c_adap,
+				   &mygic_x8558pro_max2165_cfg2);
 		}
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
@@ -1539,15 +1538,15 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(stv0367ter_attach,
 					&netup_stv0367_config[port->nr - 1],
 					&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			if (NULL == dvb_attach(xc5000_attach,
-					fe0->dvb.frontend,
+		if (fe0->dvb.frontend == NULL)
+			break;
+		if (NULL == dvb_attach(xc5000_attach, fe0->dvb.frontend,
 					&i2c_bus->i2c_adap,
 					&netup_xc5000_config[port->nr - 1]))
-				goto frontend_detach;
-			/* load xc5000 firmware */
-			fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);
-		}
+			goto frontend_detach;
+		/* load xc5000 firmware */
+		fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);
+
 		/* MFE frontend 2 */
 		fe1 = vb2_dvb_get_frontend(&port->frontends, 2);
 		if (fe1 == NULL)
@@ -1556,14 +1555,15 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe1->dvb.frontend = dvb_attach(stv0367cab_attach,
 					&netup_stv0367_config[port->nr - 1],
 					&i2c_bus->i2c_adap);
-		if (fe1->dvb.frontend != NULL) {
-			fe1->dvb.frontend->id = 1;
-			if (NULL == dvb_attach(xc5000_attach,
-					fe1->dvb.frontend,
-					&i2c_bus->i2c_adap,
-					&netup_xc5000_config[port->nr - 1]))
-				goto frontend_detach;
-		}
+		if (fe1->dvb.frontend == NULL)
+			break;
+
+		fe1->dvb.frontend->id = 1;
+		if (NULL == dvb_attach(xc5000_attach,
+				       fe1->dvb.frontend,
+				       &i2c_bus->i2c_adap,
+				       &netup_xc5000_config[port->nr - 1]))
+			goto frontend_detach;
 		break;
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		i2c_bus = &dev->i2c_bus[0];
@@ -1575,26 +1575,26 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe0->dvb.frontend = dvb_attach(drxk_attach,
 					&terratec_drxk_config[0],
 					&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				if (!dvb_attach(mt2063_attach,
-						fe0->dvb.frontend,
-						&terratec_mt2063_config[0],
-						&i2c_bus2->i2c_adap))
-					goto frontend_detach;
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+			if (!dvb_attach(mt2063_attach,
+					fe0->dvb.frontend,
+					&terratec_mt2063_config[0],
+					&i2c_bus2->i2c_adap))
+				goto frontend_detach;
 			break;
 		/* port c */
 		case 2:
 			fe0->dvb.frontend = dvb_attach(drxk_attach,
 					&terratec_drxk_config[1],
 					&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				if (!dvb_attach(mt2063_attach,
-						fe0->dvb.frontend,
-						&terratec_mt2063_config[1],
-						&i2c_bus2->i2c_adap))
-					goto frontend_detach;
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+			if (!dvb_attach(mt2063_attach,
+					fe0->dvb.frontend,
+					&terratec_mt2063_config[1],
+					&i2c_bus2->i2c_adap))
+				goto frontend_detach;
 			break;
 		}
 		break;
@@ -1604,10 +1604,10 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
 					&tevii_ds3000_config,
 					&i2c_bus->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
-			dvb_attach(ts2020_attach, fe0->dvb.frontend,
-				&tevii_ts2020_config, &i2c_bus->i2c_adap);
-		}
+		if (fe0->dvb.frontend == NULL)
+			break;
+		dvb_attach(ts2020_attach, fe0->dvb.frontend,
+			   &tevii_ts2020_config, &i2c_bus->i2c_adap);
 		break;
 	case CX23885_BOARD_PROF_8000:
 		i2c_bus = &dev->i2c_bus[0];
@@ -1616,15 +1616,15 @@ static int dvb_register(struct cx23885_tsport *port)
 						&prof_8000_stv090x_config,
 						&i2c_bus->i2c_adap,
 						STV090x_DEMODULATOR_0);
-		if (fe0->dvb.frontend != NULL) {
-			if (!dvb_attach(stb6100_attach,
-					fe0->dvb.frontend,
-					&prof_8000_stb6100_config,
-					&i2c_bus->i2c_adap))
-				goto frontend_detach;
+		if (fe0->dvb.frontend == NULL)
+			break;
+		if (!dvb_attach(stb6100_attach,
+				fe0->dvb.frontend,
+				&prof_8000_stb6100_config,
+				&i2c_bus->i2c_adap))
+			goto frontend_detach;
 
-			fe0->dvb.frontend->ops.set_voltage = p8000_set_voltage;
-		}
+		fe0->dvb.frontend->ops.set_voltage = p8000_set_voltage;
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR4400:
 		i2c_bus = &dev->i2c_bus[0];
@@ -1635,26 +1635,26 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe0->dvb.frontend = dvb_attach(tda10071_attach,
 						&hauppauge_tda10071_config,
 						&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
-						&i2c_bus->i2c_adap,
-						&hauppauge_a8293_config))
-					goto frontend_detach;
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+			if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&hauppauge_a8293_config))
+				goto frontend_detach;
 			break;
 		/* port c */
 		case 2:
 			fe0->dvb.frontend = dvb_attach(si2165_attach,
 					&hauppauge_hvr4400_si2165_config,
 					&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
-				if (!dvb_attach(tda18271_attach,
-						fe0->dvb.frontend,
-						0x60, &i2c_bus2->i2c_adap,
-					  &hauppauge_hvr4400_tuner_config))
-					goto frontend_detach;
-			}
+			if (fe0->dvb.frontend == NULL)
+				break;
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+			if (!dvb_attach(tda18271_attach,
+					fe0->dvb.frontend,
+					0x60, &i2c_bus2->i2c_adap,
+				  &hauppauge_hvr4400_tuner_config))
+				goto frontend_detach;
 			break;
 		}
 		break;
@@ -1973,7 +1973,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 
 		fe0 = vb2_dvb_get_frontend(&port->frontends, i);
 		if (!fe0)
-			err = -EINVAL;
+			return -EINVAL;
 
 		dprintk(1, "%s\n", __func__);
 		dprintk(1, " ->probed by Card=%d Name=%s, PCI %02x:%02x\n",
-- 
1.9.3

