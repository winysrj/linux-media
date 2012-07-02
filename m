Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:43841 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab2GBV1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 17:27:44 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kraxel@bytesex.org,
	Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] [media] saa7134: fix spelling of detach in label
Date: Mon,  2 Jul 2012 23:27:41 +0200
Message-Id: <1341264461-1313-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/media/video/saa7134/saa7134-dvb.c |   82 ++++++++++++++---------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 5dfd826..cc7f3d6 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -1282,7 +1282,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_FLYDVBT_DUO_CARDBUS:
 		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
@@ -1322,7 +1322,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_KWORLD_DVBT_210:
 		if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config,
 					 &tda827x_cfg_2) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
@@ -1340,17 +1340,17 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_PHILIPS_TIGER:
 		if (configure_tda827x_fe(dev, &philips_tiger_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
 					 &tda827x_cfg_1) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
 					 &tda827x_cfg_1) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 		fe0->dvb.frontend = dvb_attach(lgdt3305_attach,
@@ -1368,30 +1368,30 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 		if (configure_tda827x_fe(dev, &asus_p7131_dual_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVBT_LR301:
 		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVB_TRIO:
 		if (!use_frontend) {	/* terrestrial */
 			if (configure_tda827x_fe(dev, &lifeview_trio_config,
 						 &tda827x_cfg_0) < 0)
-				goto dettach_frontend;
+				goto detach_frontend;
 		} else {  		/* satellite */
 			fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
 			if (fe0->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 				if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
 										0x08, 0, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 			}
 		}
@@ -1407,7 +1407,7 @@ static int dvb_init(struct saa7134_dev *dev)
 								&ads_duo_cfg) == NULL) {
 				wprintk("no tda827x tuner found at addr: %02x\n",
 					ads_tech_duo_config.tuner_address);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 		} else
 			wprintk("failed to attach tda10046\n");
@@ -1415,13 +1415,13 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
 		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
 		if (!use_frontend) {     /* terrestrial */
 			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
 						 &tda827x_cfg_0) < 0)
-				goto dettach_frontend;
+				goto detach_frontend;
 		} else {        /* satellite */
 			fe0->dvb.frontend = dvb_attach(tda10086_attach,
 							&flydvbs, &dev->i2c_adap);
@@ -1435,7 +1435,7 @@ static int dvb_init(struct saa7134_dev *dev)
 						0x60, &dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Medion Quadro, no tda826x "
 						"found !\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 				if (dev_id != 0x08) {
 					/* we need to open the i2c gate (we know it exists) */
@@ -1444,7 +1444,7 @@ static int dvb_init(struct saa7134_dev *dev)
 							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 						wprintk("%s: Medion Quadro, no ISL6405 "
 							"found !\n", __func__);
-						goto dettach_frontend;
+						goto detach_frontend;
 					}
 					if (dev_id == 0x07) {
 						/* fire up the 2nd section of the LNB supply since
@@ -1503,12 +1503,12 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
 				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: No ISL6421 found!\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 		}
 		break;
@@ -1537,37 +1537,37 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
 		if (configure_tda827x_fe(dev, &cinergy_ht_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCI:
 		if (configure_tda827x_fe(dev, &cinergy_ht_pci_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER_S:
 		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
 					 &tda827x_cfg_2) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_ASUS_P7131_4871:
 		if (configure_tda827x_fe(dev, &asus_p7131_4871_config,
 					 &tda827x_cfg_2) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 		if (configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config,
 					 &tda827x_cfg_2) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 		if (configure_tda827x_fe(dev, &avermedia_super_007_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 		if (configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config,
 					 &tda827x_cfg_2_sw42) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_SNAKE:
 		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
@@ -1576,24 +1576,24 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 					&dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 			if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					&dev->i2c_adap, 0, 0) == NULL) {
 				wprintk("%s: No lnbp21 found!\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 		}
 		break;
 	case SAA7134_BOARD_CREATIX_CTX953:
 		if (configure_tda827x_fe(dev, &md8800_dvbt_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
 		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
 					 &tda827x_cfg_2) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		dprintk("AverMedia E506R dvb setup\n");
@@ -1614,7 +1614,7 @@ static int dvb_init(struct saa7134_dev *dev)
 				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no SD1878 "
 					"found !\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 			/* we need to open the i2c gate (we know it exists) */
 			fe = fe0->dvb.frontend;
@@ -1623,7 +1623,7 @@ static int dvb_init(struct saa7134_dev *dev)
 					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no ISL6405 "
 					"found !\n", __func__);
-				goto dettach_frontend;
+				goto detach_frontend;
 			}
 			fe->ops.i2c_gate_ctrl(fe, 0);
 			dev->original_set_voltage = fe->ops.set_voltage;
@@ -1645,7 +1645,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (!use_frontend) {     /* terrestrial */
 			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
 							&tda827x_cfg_2) < 0)
-				goto dettach_frontend;
+				goto detach_frontend;
 		} else {  		/* satellite */
 			fe0->dvb.frontend = dvb_attach(tda10086_attach,
 						&flydvbs, &dev->i2c_adap);
@@ -1655,13 +1655,13 @@ static int dvb_init(struct saa7134_dev *dev)
 						&dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Asus Tiger 3in1, no "
 						"tda826x found!\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 						&dev->i2c_adap, 0, 0) == NULL) {
 					wprintk("%s: Asus Tiger 3in1, no lnbp21"
 						" found!\n", __func__);
-				       goto dettach_frontend;
+				       goto detach_frontend;
 			       }
 		       }
 	       }
@@ -1670,7 +1670,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (!use_frontend) {     /* terrestrial */
 			if (configure_tda827x_fe(dev, &asus_ps3_100_config,
 						 &tda827x_cfg_2) < 0)
-				goto dettach_frontend;
+				goto detach_frontend;
 	       } else {                /* satellite */
 			fe0->dvb.frontend = dvb_attach(tda10086_attach,
 						       &flydvbs, &dev->i2c_adap);
@@ -1680,13 +1680,13 @@ static int dvb_init(struct saa7134_dev *dev)
 					       &dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Asus My Cinema PS3-100, no "
 						"tda826x found!\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap, 0, 0) == NULL) {
 					wprintk("%s: Asus My Cinema PS3-100, no lnbp21"
 						" found!\n", __func__);
-					goto dettach_frontend;
+					goto detach_frontend;
 				}
 			}
 		}
@@ -1694,7 +1694,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_TIGER:
 		if (configure_tda827x_fe(dev, &philips_tiger_config,
 					 &tda827x_cfg_0) < 0)
-			goto dettach_frontend;
+			goto detach_frontend;
 		break;
 	case SAA7134_BOARD_BEHOLD_H6:
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
@@ -1830,19 +1830,19 @@ static int dvb_init(struct saa7134_dev *dev)
 		};
 
 		if (!fe0->dvb.frontend)
-			goto dettach_frontend;
+			goto detach_frontend;
 
 		fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
 		if (!fe) {
 			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 			       dev->name);
-			goto dettach_frontend;
+			goto detach_frontend;
 		}
 	}
 
 	if (NULL == fe0->dvb.frontend) {
 		printk(KERN_ERR "%s/dvb: frontend initialization failed\n", dev->name);
-		goto dettach_frontend;
+		goto detach_frontend;
 	}
 	/* define general-purpose callback pointer */
 	fe0->dvb.frontend->callback = saa7134_tuner_callback;
@@ -1864,7 +1864,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	}
 	return ret;
 
-dettach_frontend:
+detach_frontend:
 	videobuf_dvb_dealloc_frontends(&dev->frontends);
 	return -EINVAL;
 }
-- 
1.7.9.5

