Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KdogL-0007f6-QT
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 18:06:12 +0200
Content-Type: multipart/mixed; boundary="========GMX153991221149136720100"
Date: Thu, 11 Sep 2008 18:05:36 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20080911160536.153990@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH 2/2] S2API: add multifrontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--========GMX153991221149136720100
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Second and last part of the patch.

Regards,
Hans

-- 
GMX Kostenlose Spiele: Einfach online spielen und Spaß haben mit Pastry Passion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/6169196

--========GMX153991221149136720100
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="s2api_multifrontend_2of2.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="s2api_multifrontend_2of2.diff"

diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88-i2c.c
--- a/linux/drivers/media/video/cx88/cx88-i2c.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-i2c.c	Thu Sep 11 15:47:25 2008 +0100
@@ -116,18 +116,23 @@ static int detach_inform(struct i2c_clie
 
 void cx88_call_i2c_clients(struct cx88_core *core, unsigned int cmd, void *arg)
 {
+	struct videobuf_dvb_frontend *fe0 = NULL;
 	if (0 != core->i2c_rc)
 		return;
 
 #if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	if ( (core->dvbdev) && (core->dvbdev->dvb.frontend) ) {
-		if (core->dvbdev->dvb.frontend->ops.i2c_gate_ctrl)
-			core->dvbdev->dvb.frontend->ops.i2c_gate_ctrl(core->dvbdev->dvb.frontend, 1);
+	if (core->dvbdev) {
+		/* Get the first frontend and assume that all I2C is routed through it */
+		/* TODO: Get _THIS_FE_ then find the right i2c_gate_ctrl for it */
+		fe0 = videobuf_dvb_get_frontend(&core->dvbdev->frontends, 1);
+
+		if (fe0 && fe0->dvb.frontend && fe0->dvb.frontend->ops.i2c_gate_ctrl)
+			fe0->dvb.frontend->ops.i2c_gate_ctrl(fe0->dvb.frontend, 1);
 
 		i2c_clients_command(&core->i2c_adap, cmd, arg);
 
-		if (core->dvbdev->dvb.frontend->ops.i2c_gate_ctrl)
-			core->dvbdev->dvb.frontend->ops.i2c_gate_ctrl(core->dvbdev->dvb.frontend, 0);
+		if (fe0 && fe0->dvb.frontend && fe0->dvb.frontend->ops.i2c_gate_ctrl)
+			fe0->dvb.frontend->ops.i2c_gate_ctrl(fe0->dvb.frontend, 0);
 	} else
 #endif
 		i2c_clients_command(&core->i2c_adap, cmd, arg);
@@ -201,7 +206,32 @@ int cx88_i2c_init(struct cx88_core *core
 
 	core->i2c_rc = i2c_bit_add_bus(&core->i2c_adap);
 	if (0 == core->i2c_rc) {
+	        static u8 tuner_data[] =
+			{ 0x0b, 0xdc, 0x86, 0x52 };
+		static struct i2c_msg tuner_msg =
+			{ .flags = 0, .addr = 0xc2 >> 1, .buf = tuner_data, .len = 4 };
+
 		dprintk(1, "i2c register ok\n");
+
+		switch( core->boardnr )
+		{
+		    case CX88_BOARD_HAUPPAUGE_HVR1300:
+		    case CX88_BOARD_HAUPPAUGE_HVR3000: /* ? */
+		    case CX88_BOARD_HAUPPAUGE_HVR4000:
+			/*
+  	 		 * The tda9887 2-0043: tda988[5/6/7] found @ 0x43 (tuner')
+ 	 		 * is disabled after a cold boot on the HVR devices.
+  	 		 *
+  	 		 * We enable it here prior to probing for successful detection.
+  	 		 *
+  	 		 * This has been tested on the HVR1300 and HVR4000. (dmb).
+  	 		 */
+			printk("%s: i2c init: enabling analog demod on HVR1300/3000/4000 tuner\n",
+				core->name);
+			i2c_transfer(core->i2c_client.adapter, &tuner_msg, 1);
+			break;
+		}
+
 		if (i2c_scan)
 			do_i2c_scan(core->name,&core->i2c_client);
 	} else
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Thu Sep 11 15:47:25 2008 +0100
@@ -485,6 +485,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
 		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
 		ir_dprintk("biphase decoded: %x\n", ircode);
+//TODO Darron has other code here
 		if ((ircode & 0xfffff000) != 0x3000)
 			break;
 		ir_input_keydown(ir->input, &ir->ir, ircode & 0x3f, ircode);
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Thu Sep 11 15:47:25 2008 +0100
@@ -808,7 +808,8 @@ static int __devinit cx8802_probe(struct
 {
 	struct cx8802_dev *dev;
 	struct cx88_core  *core;
-	int err;
+	struct videobuf_dvb_frontend *demod;
+	int err,i;
 
 	/* general setup */
 	core = cx88_core_get(pci_dev);
@@ -820,6 +821,11 @@ static int __devinit cx8802_probe(struct
 	err = -ENODEV;
 	if (!core->board.mpeg)
 		goto fail_core;
+
+	if (!core->board.num_frontends) {
+		printk(KERN_ERR "%s() .num_frontends should be non-zero, err = %d\n", __FUNCTION__, err);
+		goto fail_core;
+	}
 
 	err = -ENOMEM;
 	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
@@ -834,6 +840,20 @@ static int __devinit cx8802_probe(struct
 
 	INIT_LIST_HEAD(&dev->drvlist);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
+
+	mutex_init(&dev->frontends.lock);
+	INIT_LIST_HEAD(&dev->frontends.frontend.felist);
+
+	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __FUNCTION__, core->board.num_frontends);
+
+	for (i = 1; i <= core->board.num_frontends; i++) {
+		demod = videobuf_dvb_alloc_frontend(dev, &dev->frontends, i);
+		if(demod == NULL) {
+			printk(KERN_ERR "%s() failed to alloc\n", __FUNCTION__);
+			err = -ENOMEM;
+			goto fail_free;
+		}
+	}
 
 	/* Maintain a reference so cx88-video can query the 8802 device. */
 	core->dvbdev = dev;
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88.h	Thu Sep 11 15:47:25 2008 +0100
@@ -257,6 +257,7 @@ struct cx88_board {
 	struct cx88_input       radio;
 	enum cx88_board_type    mpeg;
 	unsigned int            audio_chip;
+	int			num_frontends;
 };
 
 struct cx88_subid {
@@ -354,6 +355,7 @@ struct cx88_core {
 	struct cx8802_dev          *dvbdev;
 	enum cx88_board_type       active_type_id;
 	int			   active_ref;
+	int			   active_fe_id;
 };
 
 struct cx8800_dev;
@@ -505,7 +507,7 @@ struct cx8802_dev {
 
 #if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
 	/* for dvb only */
-	struct videobuf_dvb        dvb;
+	struct videobuf_dvb_frontends frontends;
 #endif
 
 #if defined(CONFIG_VIDEO_CX88_VP3054) || \
diff -r ffa9a0c644b3 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Sep 11 15:47:25 2008 +0100
@@ -535,11 +535,15 @@ static int configure_tda827x_fe(struct s
 				struct tda1004x_config *cdec_conf,
 				struct tda827x_config *tuner_conf)
 {
-	dev->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
-	if (dev->dvb.frontend) {
+	struct videobuf_dvb_frontend *fe0;
+
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 0);
+
+	fe0->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
+	if (fe0->dvb.frontend) {
 		if (cdec_conf->i2c_gate)
-			dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
-		if (dvb_attach(tda827x_attach, dev->dvb.frontend,
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
+		if (dvb_attach(tda827x_attach, fe0->dvb.frontend,
 			       cdec_conf->tuner_address,
 			       &dev->i2c_adap, tuner_conf))
 			return 0;
@@ -935,12 +939,18 @@ static int dvb_init(struct saa7134_dev *
 {
 	int ret;
 	int attach_xc3028 = 0;
+	struct videobuf_dvb_frontend *fe0;
+
+	/* Get the first frontend */
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 0);
+	if (!fe0)
+		return -EINVAL;
 
 	/* init struct videobuf_dvb */
 	dev->ts.nr_bufs    = 32;
 	dev->ts.nr_packets = 32*4;
-	dev->dvb.name = dev->name;
-	videobuf_queue_sg_init(&dev->dvb.dvbq, &saa7134_ts_qops,
+	fe0->dvb.name = dev->name;
+	videobuf_queue_sg_init(&fe0->dvb.dvbq, &saa7134_ts_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_ALTERNATE,
@@ -950,47 +960,47 @@ static int dvb_init(struct saa7134_dev *
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
 		dprintk("pinnacle 300i dvb setup\n");
-		dev->dvb.frontend = dvb_attach(mt352_attach, &pinnacle_300i,
+		fe0->dvb.frontend = dvb_attach(mt352_attach, &pinnacle_300i,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->dvb.frontend->ops.tuner_ops.set_params = mt352_pinnacle_tuner_set_params;
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.tuner_ops.set_params = mt352_pinnacle_tuner_set_params;
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
 		dprintk("avertv 777 dvb setup\n");
-		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
+		fe0->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
 				   TUNER_PHILIPS_TD1316);
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
 		dprintk("AverMedia A16D dvb setup\n");
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&avermedia_xc3028_mt352_dev,
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
 	case SAA7134_BOARD_MD7134:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &medion_cardbus,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, medion_cardbus.tuner_address,
 				   TUNER_PHILIPS_FMD1216ME_MK3);
 		}
 		break;
 	case SAA7134_BOARD_PHILIPS_TOUGH:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &philips_tu1216_60_config,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
-			dev->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
+			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
 		}
 		break;
 	case SAA7134_BOARD_FLYDVBTDUO:
@@ -1001,24 +1011,24 @@ static int dvb_init(struct saa7134_dev *
 		break;
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &philips_europa_config,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->original_demod_sleep = dev->dvb.frontend->ops.sleep;
-			dev->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
-			dev->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
-			dev->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
-			dev->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
+		if (fe0->dvb.frontend) {
+			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
+			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
+			fe0->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
+			fe0->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
+			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
 		}
 		break;
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &philips_tu1216_61_config,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
-			dev->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
+			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
 		}
 		break;
 	case SAA7134_BOARD_KWORLD_DVBT_210:
@@ -1051,20 +1061,20 @@ static int dvb_init(struct saa7134_dev *
 					 &tda827x_cfg_0) < 0)
 			goto dettach_frontend;
 		break;
-	case SAA7134_BOARD_FLYDVB_TRIO:
+	case SAA7134_BOARD_FLYDVB_TRIO: // XXXXXX multifrontend
 		if (!use_frontend) {	/* terrestrial */
 			if (configure_tda827x_fe(dev, &lifeview_trio_config,
 						 &tda827x_cfg_0) < 0)
 				goto dettach_frontend;
 		} else {  		/* satellite */
-			dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
-			if (dev->dvb.frontend) {
-				if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x63,
+			fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
+			if (fe0->dvb.frontend) {
+				if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
 					goto dettach_frontend;
 				}
-				if (dvb_attach(isl6421_attach, dev->dvb.frontend, &dev->i2c_adap,
+				if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
 										0x08, 0, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
 					goto dettach_frontend;
@@ -1074,11 +1084,11 @@ static int dvb_init(struct saa7134_dev *
 		break;
 	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
 	case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &ads_tech_duo_config,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			if (dvb_attach(tda827x_attach,dev->dvb.frontend,
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda827x_attach,fe0->dvb.frontend,
 				   ads_tech_duo_config.tuner_address, &dev->i2c_adap,
 								&ads_duo_cfg) == NULL) {
 				wprintk("no tda827x tuner found at addr: %02x\n",
@@ -1099,15 +1109,15 @@ static int dvb_init(struct saa7134_dev *
 						 &tda827x_cfg_0) < 0)
 				goto dettach_frontend;
 		} else {        /* satellite */
-			dev->dvb.frontend = dvb_attach(tda10086_attach,
+			fe0->dvb.frontend = dvb_attach(tda10086_attach,
 							&flydvbs, &dev->i2c_adap);
-			if (dev->dvb.frontend) {
-				struct dvb_frontend *fe = dev->dvb.frontend;
+			if (fe0->dvb.frontend) {
+				struct dvb_frontend *fe = fe0->dvb.frontend;
 				u8 dev_id = dev->eedata[2];
 				u8 data = 0xc4;
 				struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
 
-				if (dvb_attach(tda826x_attach, dev->dvb.frontend,
+				if (dvb_attach(tda826x_attach, fe0->dvb.frontend,
 						0x60, &dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Medion Quadro, no tda826x "
 						"found !\n", __func__);
@@ -1141,30 +1151,30 @@ static int dvb_init(struct saa7134_dev *
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180:
-		dev->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
+		fe0->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend)
-			dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x61,
+		if (fe0->dvb.frontend)
+			dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x61,
 				   NULL, DVB_PLL_TDHU2);
 		break;
 	case SAA7134_BOARD_KWORLD_ATSC110:
-		dev->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
+		fe0->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend)
-			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend)
+			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
 				   TUNER_PHILIPS_TUV1236D);
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
-		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
+		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
 				goto dettach_frontend;
 			}
-			if (dvb_attach(isl6421_attach, dev->dvb.frontend,
+			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
 				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: No ISL6421 found!\n", __func__);
 				goto dettach_frontend;
@@ -1172,25 +1182,25 @@ static int dvb_init(struct saa7134_dev *
 		}
 		break;
 	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &medion_cardbus,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->original_demod_sleep = dev->dvb.frontend->ops.sleep;
-			dev->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
+		if (fe0->dvb.frontend) {
+			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
+			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
 
-			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, medion_cardbus.tuner_address,
 				   TUNER_PHILIPS_FMD1216ME_MK3);
 		}
 		break;
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
-		dev->dvb.frontend = dvb_attach(tda10046_attach,
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 				&philips_europa_config,
 				&dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			dev->dvb.frontend->ops.tuner_ops.init = philips_td1316_tuner_init;
-			dev->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.tuner_ops.init = philips_td1316_tuner_init;
+			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
 		}
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
@@ -1229,15 +1239,15 @@ static int dvb_init(struct saa7134_dev *
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_SNAKE:
-		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
+		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
 						&dev->i2c_adap);
-		if (dev->dvb.frontend) {
-			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
 					&dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
 				goto dettach_frontend;
 			}
-			if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
+			if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
 					&dev->i2c_adap, 0, 0) == NULL) {
 				wprintk("%s: No lnbp21 found!\n", __func__);
 				goto dettach_frontend;
@@ -1259,7 +1269,7 @@ static int dvb_init(struct saa7134_dev *
 		saa7134_set_gpio(dev, 25, 0);
 		msleep(10);
 		saa7134_set_gpio(dev, 25, 1);
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&avermedia_xc3028_mt352_dev,
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
@@ -1269,18 +1279,18 @@ static int dvb_init(struct saa7134_dev *
 	case SAA7134_BOARD_VIDEOMATE_T750:
 #endif
 	case SAA7134_BOARD_MD7134_BRIDGE_2:
-		dev->dvb.frontend = dvb_attach(tda10086_attach,
+		fe0->dvb.frontend = dvb_attach(tda10086_attach,
 						&sd1878_4m, &dev->i2c_adap);
-		if (dev->dvb.frontend) {
+		if (fe0->dvb.frontend) {
 			struct dvb_frontend *fe;
-			if (dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x60,
+			if (dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no SD1878 "
 					"found !\n", __func__);
 				goto dettach_frontend;
 			}
 			/* we need to open the i2c gate (we know it exists) */
-			fe = dev->dvb.frontend;
+			fe = fe0->dvb.frontend;
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
 					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
@@ -1299,7 +1309,7 @@ static int dvb_init(struct saa7134_dev *
 		saa7134_set_gpio(dev, 25, 0);
 		msleep(10);
 		saa7134_set_gpio(dev, 25, 1);
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&avermedia_xc3028_mt352_dev,
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
@@ -1316,10 +1326,10 @@ static int dvb_init(struct saa7134_dev *
 			.i2c_addr  = 0x61,
 		};
 
-		if (!dev->dvb.frontend)
+		if (!fe0->dvb.frontend)
 			return -1;
 
-		fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
+		fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
 		if (!fe) {
 			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 			       dev->name);
@@ -1327,38 +1337,44 @@ static int dvb_init(struct saa7134_dev *
 		}
 	}
 
-	if (NULL == dev->dvb.frontend) {
+	if (NULL == fe0->dvb.frontend) {
 		printk(KERN_ERR "%s/dvb: frontend initialization failed\n", dev->name);
 		return -1;
 	}
 
 	/* register everything else */
-	ret = videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev, &dev->pci->dev,
-				    adapter_nr);
+	ret = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev, &dev->pci->dev, adapter_nr);
 
 	/* this sequence is necessary to make the tda1004x load its firmware
 	 * and to enter analog mode of hybrid boards
 	 */
 	if (!ret) {
-		if (dev->dvb.frontend->ops.init)
-			dev->dvb.frontend->ops.init(dev->dvb.frontend);
-		if (dev->dvb.frontend->ops.sleep)
-			dev->dvb.frontend->ops.sleep(dev->dvb.frontend);
-		if (dev->dvb.frontend->ops.tuner_ops.sleep)
-			dev->dvb.frontend->ops.tuner_ops.sleep(dev->dvb.frontend);
+		if (fe0->dvb.frontend->ops.init)
+			fe0->dvb.frontend->ops.init(fe0->dvb.frontend);
+		if (fe0->dvb.frontend->ops.sleep)
+			fe0->dvb.frontend->ops.sleep(fe0->dvb.frontend);
+		if (fe0->dvb.frontend->ops.tuner_ops.sleep)
+			fe0->dvb.frontend->ops.tuner_ops.sleep(fe0->dvb.frontend);
 	}
 	return ret;
 
 dettach_frontend:
-	if (dev->dvb.frontend)
-		dvb_frontend_detach(dev->dvb.frontend);
-	dev->dvb.frontend = NULL;
+	if (fe0->dvb.frontend)
+		dvb_frontend_detach(fe0->dvb.frontend);
+	fe0->dvb.frontend = NULL;
 
 	return -1;
 }
 
 static int dvb_fini(struct saa7134_dev *dev)
 {
+	struct videobuf_dvb_frontend *fe0;
+
+	/* Get the first frontend */
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 0);
+	if (!fe0)
+		return -EINVAL;
+
 	/* FIXME: I suspect that this code is bogus, since the entry for
 	   Pinnacle 300I DVB-T PAL already defines the proper init to allow
 	   the detection of mt2032 (TDA9887_PORT2_INACTIVE)
@@ -1378,7 +1394,7 @@ static int dvb_fini(struct saa7134_dev *
 			u8 data = 0x80;
 			struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};
 			struct dvb_frontend *fe;
-			fe = dev->dvb.frontend;
+			fe = fe0->dvb.frontend;
 			if (fe->ops.i2c_gate_ctrl) {
 				fe->ops.i2c_gate_ctrl(fe, 1);
 				i2c_transfer(&dev->i2c_adap, &msg, 1);
@@ -1386,8 +1402,8 @@ static int dvb_fini(struct saa7134_dev *
 			}
 		}
 	}
-	if (dev->dvb.frontend)
-		videobuf_dvb_unregister(&dev->dvb);
+	if (fe0->dvb.frontend)
+		videobuf_dvb_unregister_bus(&dev->frontends);
 	return 0;
 }
 
diff -r ffa9a0c644b3 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 11 15:47:25 2008 +0100
@@ -580,7 +580,7 @@ struct saa7134_dev {
 
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 	/* SAA7134_MPEG_DVB only */
-	struct videobuf_dvb        dvb;
+	struct videobuf_dvb_frontends frontends;
 	int (*original_demod_sleep)(struct dvb_frontend *fe);
 	int (*original_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
 	int (*original_set_high_voltage)(struct dvb_frontend *fe, long arg);
diff -r ffa9a0c644b3 linux/drivers/media/video/videobuf-dvb.c
--- a/linux/drivers/media/video/videobuf-dvb.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/videobuf-dvb.c	Thu Sep 11 15:47:25 2008 +0100
@@ -140,29 +140,75 @@ static int videobuf_dvb_stop_feed(struct
 }
 
 /* ------------------------------------------------------------------ */
-
-int videobuf_dvb_register(struct videobuf_dvb *dvb,
+/* Register a single adapter and one or more frontends */
+int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
 			  struct module *module,
 			  void *adapter_priv,
 			  struct device *device,
-			  short *adapter_nr)
+			  short *adapter_nr) //NEW
+{
+	struct list_head *list, *q;
+	struct videobuf_dvb_frontend *fe;
+	int res = -EINVAL;
+
+	fe = videobuf_dvb_get_frontend(f, 1);
+	if (!fe) {
+		printk(KERN_WARNING "Unable to register the adapter which has no frontends\n");
+		goto err;
+	}
+
+	/* Bring up the adapter */
+	res = videobuf_dvb_register_adapter(f, module, adapter_priv, device, fe->dvb.name, adapter_nr); //NEW
+	if (res < 0) {
+		printk(KERN_WARNING "videobuf_dvb_register_adapter failed (errno = %d)\n", res);
+		goto err;
+	}
+
+	/* Attach all of the frontends to the adapter */
+	mutex_lock(&f->lock);
+	list_for_each_safe(list, q, &f->frontend.felist) {
+		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
+
+		res = videobuf_dvb_register_frontend(&f->adapter, &fe->dvb);
+		if (res < 0) {
+			printk(KERN_WARNING "%s: videobuf_dvb_register_frontend failed (errno = %d)\n",
+				fe->dvb.name, res);
+		}
+	}
+	mutex_unlock(&f->lock);
+
+err:
+	return res;
+}
+
+int videobuf_dvb_register_adapter(struct videobuf_dvb_frontends *fe,
+			  struct module *module,
+			  void *adapter_priv,
+			  struct device *device,
+			  char *adapter_name,
+			  short *adapter_nr) //NEW
 {
 	int result;
 
-	mutex_init(&dvb->lock);
+	mutex_init(&fe->lock);
 
 	/* register adapter */
-	result = dvb_register_adapter(&dvb->adapter, dvb->name, module, device,
-				      adapter_nr);
+	result = dvb_register_adapter(&fe->adapter, adapter_name, module, device, adapter_nr);
 	if (result < 0) {
 		printk(KERN_WARNING "%s: dvb_register_adapter failed (errno = %d)\n",
-		       dvb->name, result);
-		goto fail_adapter;
+		       adapter_name, result);
 	}
-	dvb->adapter.priv = adapter_priv;
+	fe->adapter.priv = adapter_priv;
+
+	return result;
+}
+
+int videobuf_dvb_register_frontend(struct dvb_adapter *adapter, struct videobuf_dvb *dvb)
+{
+	int result;
 
 	/* register frontend */
-	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
+	result = dvb_register_frontend(adapter, dvb->frontend);
 	if (result < 0) {
 		printk(KERN_WARNING "%s: dvb_register_frontend failed (errno = %d)\n",
 		       dvb->name, result);
@@ -188,7 +234,9 @@ int videobuf_dvb_register(struct videobu
 	dvb->dmxdev.filternum    = 256;
 	dvb->dmxdev.demux        = &dvb->demux.dmx;
 	dvb->dmxdev.capabilities = 0;
-	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
+	//result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
+	result = dvb_dmxdev_init(&dvb->dmxdev, adapter);
+
 	if (result < 0) {
 		printk(KERN_WARNING "%s: dvb_dmxdev_init failed (errno = %d)\n",
 		       dvb->name, result);
@@ -219,7 +267,7 @@ int videobuf_dvb_register(struct videobu
 	}
 
 	/* register network adapter */
-	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
+	dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
 	return 0;
 
 fail_fe_conn:
@@ -235,24 +283,101 @@ fail_frontend:
 fail_frontend:
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
-fail_adapter:
+
 	return result;
 }
 
-void videobuf_dvb_unregister(struct videobuf_dvb *dvb)
+void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f)
 {
-	dvb_net_release(&dvb->net);
-	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
-	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
-	dvb_dmxdev_release(&dvb->dmxdev);
-	dvb_dmx_release(&dvb->demux);
-	dvb_unregister_frontend(dvb->frontend);
-	dvb_frontend_detach(dvb->frontend);
-	dvb_unregister_adapter(&dvb->adapter);
+	struct list_head *list, *q;
+	struct videobuf_dvb_frontend *fe;
+
+	mutex_lock(&f->lock);
+	list_for_each_safe(list, q, &f->frontend.felist) {
+		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
+
+		dvb_net_release(&fe->dvb.net);
+		fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx, &fe->dvb.fe_mem);
+		fe->dvb.demux.dmx.remove_frontend(&fe->dvb.demux.dmx, &fe->dvb.fe_hw);
+		dvb_dmxdev_release(&fe->dvb.dmxdev);
+		dvb_dmx_release(&fe->dvb.demux);
+		dvb_unregister_frontend(fe->dvb.frontend);
+		dvb_frontend_detach(fe->dvb.frontend);
+
+		list_del(list);
+		kfree(fe);
+	}
+	mutex_unlock(&f->lock);
+
+	dvb_unregister_adapter(&f->adapter);
 }
 
-EXPORT_SYMBOL(videobuf_dvb_register);
-EXPORT_SYMBOL(videobuf_dvb_unregister);
+struct videobuf_dvb_frontend * videobuf_dvb_get_frontend(struct videobuf_dvb_frontends *f, int id)
+{
+	struct list_head *list, *q;
+	struct videobuf_dvb_frontend *fe, *ret = NULL;
+
+	mutex_lock(&f->lock);
+
+	list_for_each_safe(list, q, &f->frontend.felist) {
+		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
+		if (fe->id == id) {
+			ret = fe;
+			break;
+		}
+	}
+
+	mutex_unlock(&f->lock);
+
+	return ret;
+}
+
+int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f, struct dvb_frontend *p)
+{
+	struct list_head *list, *q;
+	struct videobuf_dvb_frontend *fe = NULL;
+	int ret = 0;
+
+	mutex_lock(&f->lock);
+
+	list_for_each_safe(list, q, &f->frontend.felist) {
+		fe = list_entry(list, struct videobuf_dvb_frontend, felist);
+		if (fe->dvb.frontend == p) {
+			ret = fe->id;
+			break;
+		}
+	}
+
+	mutex_unlock(&f->lock);
+
+	return ret;
+}
+
+struct videobuf_dvb_frontend * videobuf_dvb_alloc_frontend(void *private, struct videobuf_dvb_frontends *f, int id)
+{
+	struct videobuf_dvb_frontend *fe;
+
+	fe = kzalloc(sizeof(struct videobuf_dvb_frontend),GFP_KERNEL);
+	if (fe == NULL)
+		goto fail_alloc;
+
+	fe->dev = private;
+	fe->id = id;
+	mutex_init(&fe->dvb.lock);
+
+	mutex_lock(&f->lock);
+	list_add_tail(&fe->felist,&f->frontend.felist);
+	mutex_unlock(&f->lock);
+
+fail_alloc:
+	return fe;
+}
+
+EXPORT_SYMBOL(videobuf_dvb_register_bus);
+EXPORT_SYMBOL(videobuf_dvb_unregister_bus);
+EXPORT_SYMBOL(videobuf_dvb_alloc_frontend);
+EXPORT_SYMBOL(videobuf_dvb_get_frontend);
+EXPORT_SYMBOL(videobuf_dvb_find_frontend);
 
 /* ------------------------------------------------------------------ */
 /*
diff -r ffa9a0c644b3 linux/include/media/videobuf-dvb.h
--- a/linux/include/media/videobuf-dvb.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/include/media/videobuf-dvb.h	Thu Sep 11 15:47:25 2008 +0100
@@ -24,12 +24,42 @@ struct videobuf_dvb {
 	struct dvb_net             net;
 };
 
-int videobuf_dvb_register(struct videobuf_dvb *dvb,
+struct videobuf_dvb_frontend {
+	void *dev;
+	struct list_head felist;
+	int id;
+	struct videobuf_dvb dvb;
+};
+
+struct videobuf_dvb_frontends {
+	struct mutex lock;
+	struct dvb_adapter adapter;
+	int active_fe_id; /* Indicates which frontend in the felist is in use */
+	struct videobuf_dvb_frontend frontend;
+};
+
+int videobuf_dvb_register_bus(struct videobuf_dvb_frontends *f,
 			  struct module *module,
 			  void *adapter_priv,
 			  struct device *device,
-			  short *adapter_nr);
-void videobuf_dvb_unregister(struct videobuf_dvb *dvb);
+			  short *adapter_nr);   //NEW
+
+void videobuf_dvb_unregister_bus(struct videobuf_dvb_frontends *f);
+
+int videobuf_dvb_register_adapter(struct videobuf_dvb_frontends *f,
+			  struct module *module,
+			  void *adapter_priv,
+			  struct device *device,
+			  char *adapter_name,
+			  short *adapter_nr);   //NEW
+
+int videobuf_dvb_register_frontend(struct dvb_adapter *adapter, struct videobuf_dvb *dvb);
+
+struct videobuf_dvb_frontend * videobuf_dvb_alloc_frontend(void *private, struct videobuf_dvb_frontends *f, int id);
+
+struct videobuf_dvb_frontend * videobuf_dvb_get_frontend(struct videobuf_dvb_frontends *f, int id);
+int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f, struct dvb_frontend *p);
+
 
 /*
  * Local variables:

--========GMX153991221149136720100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX153991221149136720100--
