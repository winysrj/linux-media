Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/22] saa7134-dvb: get rid of wprintk() macro
Date: Thu, 30 Apr 2015 11:08:31 -0300
Message-Id: <03ed56999f40f531f025fe58b6b40f8915cd277e.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

wprintk() macro is now just a wrapper for pr_warn(). Get rid of
it!

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index c7d9896a454e..7e0091343c87 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -85,9 +85,6 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define dprintk(fmt, arg...)	do { if (debug) \
 	printk(KERN_DEBUG "%s/dvb: " fmt, dev->name , ## arg); } while(0)
 
-/* Print a warning */
-#define wprintk(fmt, arg...) \
-	pr_warn("%s/dvb: " fmt, dev->name, ## arg)
 
 /* ------------------------------------------------------------------
  * mt352 based DVB-T cards
@@ -259,7 +256,7 @@ static int kworld_sbtvd_gate_ctrl(struct dvb_frontend* fe, int enable)
 	struct i2c_msg msg = {.addr = 0x4b, .flags = 0, .buf = initmsg, .len = 2};
 
 	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
-		wprintk("could not access the I2C gate\n");
+		pr_warn("could not access the I2C gate\n");
 		return -EIO;
 	}
 	if (enable)
@@ -267,7 +264,7 @@ static int kworld_sbtvd_gate_ctrl(struct dvb_frontend* fe, int enable)
 	else
 		msg.buf = msg_disable;
 	if (i2c_transfer(&dev->i2c_adap, &msg, 1) != 1) {
-		wprintk("could not access the I2C gate\n");
+		pr_warn("could not access the I2C gate\n");
 		return -EIO;
 	}
 	msleep(20);
@@ -370,7 +367,7 @@ static int philips_tda6651_pll_set(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (i2c_transfer(&dev->i2c_adap, &tuner_msg, 1) != 1) {
-		wprintk("could not write to tuner at addr: 0x%02x\n",
+		pr_warn("could not write to tuner at addr: 0x%02x\n",
 			addr << 1);
 		return -EIO;
 	}
@@ -557,8 +554,7 @@ static int tda8290_i2c_gate_ctrl( struct dvb_frontend* fe, int enable)
 		tda8290_msg.buf = tda8290_open;
 	}
 	if (i2c_transfer(state->i2c, &tda8290_msg, 1) != 1) {
-		struct saa7134_dev *dev = fe->dvb->priv;
-		wprintk("could not access tda8290 I2C gate\n");
+		pr_warn("could not access tda8290 I2C gate\n");
 		return -EIO;
 	}
 	msleep(20);
@@ -620,7 +616,7 @@ static int configure_tda827x_fe(struct saa7134_dev *dev,
 			       &dev->i2c_adap, tuner_conf))
 			return 0;
 
-		wprintk("no tda827x tuner found at addr: %02x\n",
+		pr_warn("no tda827x tuner found at addr: %02x\n",
 				cdec_conf->tuner_address);
 	}
 	return -EINVAL;
@@ -1042,8 +1038,7 @@ static int md8800_set_voltage2(struct dvb_frontend *fe, fe_sec_voltage_t voltage
 
 static int md8800_set_high_voltage2(struct dvb_frontend *fe, long arg)
 {
-	struct saa7134_dev *dev = fe->dvb->priv;
-	wprintk("%s: sorry can't set high LNB supply voltage from here\n", __func__);
+	pr_warn("%s: sorry can't set high LNB supply voltage from here\n", __func__);
 	return -EIO;
 }
 
@@ -1402,13 +1397,13 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (fe0->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
-					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
+					pr_warn("%s: Lifeview Trio, No tda826x found!\n", __func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap,
 					       0x08, 0, 0, false) == NULL) {
-					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
+					pr_warn("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
 					goto detach_frontend;
 				}
 			}
@@ -1423,12 +1418,12 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (dvb_attach(tda827x_attach,fe0->dvb.frontend,
 				   ads_tech_duo_config.tuner_address, &dev->i2c_adap,
 								&ads_duo_cfg) == NULL) {
-				wprintk("no tda827x tuner found at addr: %02x\n",
+				pr_warn("no tda827x tuner found at addr: %02x\n",
 					ads_tech_duo_config.tuner_address);
 				goto detach_frontend;
 			}
 		} else
-			wprintk("failed to attach tda10046\n");
+			pr_warn("failed to attach tda10046\n");
 		break;
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
 		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
@@ -1451,7 +1446,7 @@ static int dvb_init(struct saa7134_dev *dev)
 
 				if (dvb_attach(tda826x_attach, fe0->dvb.frontend,
 						0x60, &dev->i2c_adap, 0) == NULL) {
-					wprintk("%s: Medion Quadro, no tda826x "
+					pr_warn("%s: Medion Quadro, no tda826x "
 						"found !\n", __func__);
 					goto detach_frontend;
 				}
@@ -1460,7 +1455,7 @@ static int dvb_init(struct saa7134_dev *dev)
 					fe->ops.i2c_gate_ctrl(fe, 1);
 					if (dvb_attach(isl6405_attach, fe,
 							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-						wprintk("%s: Medion Quadro, no ISL6405 "
+						pr_warn("%s: Medion Quadro, no ISL6405 "
 							"found !\n", __func__);
 						goto detach_frontend;
 					}
@@ -1520,13 +1515,13 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (fe0->dvb.frontend) {
 			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
-				wprintk("%s: No tda826x found!\n", __func__);
+				pr_warn("%s: No tda826x found!\n", __func__);
 				goto detach_frontend;
 			}
 			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
 				       &dev->i2c_adap,
 				       0x08, 0, 0, false) == NULL) {
-				wprintk("%s: No ISL6421 found!\n", __func__);
+				pr_warn("%s: No ISL6421 found!\n", __func__);
 				goto detach_frontend;
 			}
 		}
@@ -1594,12 +1589,12 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (fe0->dvb.frontend) {
 			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 					&dev->i2c_adap, 0) == NULL) {
-				wprintk("%s: No tda826x found!\n", __func__);
+				pr_warn("%s: No tda826x found!\n", __func__);
 				goto detach_frontend;
 			}
 			if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					&dev->i2c_adap, 0, 0) == NULL) {
-				wprintk("%s: No lnbp21 found!\n", __func__);
+				pr_warn("%s: No lnbp21 found!\n", __func__);
 				goto detach_frontend;
 			}
 		}
@@ -1631,7 +1626,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			struct dvb_frontend *fe;
 			if (dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
-				wprintk("%s: MD7134 DVB-S, no SD1878 "
+				pr_warn("%s: MD7134 DVB-S, no SD1878 "
 					"found !\n", __func__);
 				goto detach_frontend;
 			}
@@ -1640,7 +1635,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
 					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
-				wprintk("%s: MD7134 DVB-S, no ISL6405 "
+				pr_warn("%s: MD7134 DVB-S, no ISL6405 "
 					"found !\n", __func__);
 				goto detach_frontend;
 			}
@@ -1672,13 +1667,13 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 						fe0->dvb.frontend, 0x60,
 						&dev->i2c_adap, 0) == NULL) {
-					wprintk("%s: Asus Tiger 3in1, no "
+					pr_warn("%s: Asus Tiger 3in1, no "
 						"tda826x found!\n", __func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 						&dev->i2c_adap, 0, 0) == NULL) {
-					wprintk("%s: Asus Tiger 3in1, no lnbp21"
+					pr_warn("%s: Asus Tiger 3in1, no lnbp21"
 						" found!\n", __func__);
 					goto detach_frontend;
 			       }
@@ -1697,13 +1692,13 @@ static int dvb_init(struct saa7134_dev *dev)
 				if (dvb_attach(tda826x_attach,
 					       fe0->dvb.frontend, 0x60,
 					       &dev->i2c_adap, 0) == NULL) {
-					wprintk("%s: Asus My Cinema PS3-100, no "
+					pr_warn("%s: Asus My Cinema PS3-100, no "
 						"tda826x found!\n", __func__);
 					goto detach_frontend;
 				}
 				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					       &dev->i2c_adap, 0, 0) == NULL) {
-					wprintk("%s: Asus My Cinema PS3-100, no lnbp21"
+					pr_warn("%s: Asus My Cinema PS3-100, no lnbp21"
 						" found!\n", __func__);
 					goto detach_frontend;
 				}
@@ -1751,7 +1746,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (fe0->dvb.frontend) {
 			if (dvb_attach(zl10036_attach, fe0->dvb.frontend,
 					&avertv_a700_tuner, &dev->i2c_adap) == NULL) {
-				wprintk("%s: No zl10036 found!\n",
+				pr_warn("%s: No zl10036 found!\n",
 					__func__);
 			}
 		}
@@ -1762,7 +1757,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (fe0->dvb.frontend)
 			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
 					0x60, &dev->i2c_adap) == NULL)
-				wprintk("%s: No zl10039 found!\n",
+				pr_warn("%s: No zl10039 found!\n",
 					__func__);
 
 		break;
@@ -1775,7 +1770,7 @@ static int dvb_init(struct saa7134_dev *dev)
 					fe0->dvb.frontend,
 					&dev->i2c_adap,
 					&videomate_t750_qt1010_config) == NULL)
-				wprintk("error attaching QT1010\n");
+				pr_warn("error attaching QT1010\n");
 		}
 		break;
 	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
@@ -1851,12 +1846,12 @@ static int dvb_init(struct saa7134_dev *dev)
 			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
 			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
 					0x60, &dev->i2c_adap) == NULL)
-				wprintk("%s: No zl10039 found!\n",
+				pr_warn("%s: No zl10039 found!\n",
 					__func__);
 		}
 		break;
 	default:
-		wprintk("Huh? unknown DVB card?\n");
+		pr_warn("Huh? unknown DVB card?\n");
 		break;
 	}
 
-- 
2.1.0

