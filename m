Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Kdoe9-0007aU-5S
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 18:03:55 +0200
Content-Type: multipart/mixed; boundary="========GMX15400122114900040000"
Date: Thu, 11 Sep 2008 18:03:20 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20080911160320.154000@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH 1/2] S2API: add multifrontend
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

--========GMX15400122114900040000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Steve,

here is a patch which adds multifrontend to S2API (rev ffa9a0c644b3). It's based on 
the earlier patches by you and the mfe patches at Darron's website. Those patches
are quite old so I had to do a lot by hand without automatic patching -- so please check
it carefully.

Notes: somewhere along the line in the past
(a) videobuf-dvb.h:  struct dvb_adapter  *adapter; in videobuf_dvb changed to struct dvb_adapter adapter;
(b) videobuf-dvb.h:  videobuf_dvb_register gained an extra parameter short *adapter_nr.

I tested it with the HVR4000. Seems OK so far.

/dev/dvb/adapter0/frontend0: DVB-S/S2 (tested OK with new API, S,S2QPSK,S28PSK)
/dev/dvb/adapter0/frontend1: DVB-T (tested OK with old API)

The DVB-T part of the HVR4000 (cx22702) still needs additions so that it picks up
and uses the new API property cache (not hard as you know).

I see you are progressing rapidly (great!) so I thought I had better send this before
it's out of date.

You know this subject better than I, so I'll leave it up to you how to prioritise this, but
the recent messages in the ML indicate there is quite a lot of interest in multifrontend.

Regards,
Hans

-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

--========GMX15400122114900040000
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="s2api_multifrontend_1of2.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="s2api_multifrontend_1of2.diff"

diff -r ffa9a0c644b3 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Thu Sep 11 15:47:25 2008 +0100
@@ -216,8 +216,9 @@ static int dvb_frontend_get_event(struct
 
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
-	dprintk ("DVB: initialising frontend %i (%s)...\n",
+	dprintk ("DVB: initialising adapter %i frontend %i (%s)...\n",
 		 fe->dvb->num,
+		 fe->id,
 		 fe->ops.info.name);
 
 	if (fe->ops.init)
@@ -696,7 +697,7 @@ static int dvb_frontend_start(struct dvb
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
-		"kdvb-fe-%i", fe->dvb->num);
+		"kdvb-ad-%i-fe-%i", fe->dvb->num,fe->id);
 	if (IS_ERR(fe_thread)) {
 		ret = PTR_ERR(fe_thread);
 		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
@@ -720,8 +721,8 @@ static void dvb_frontend_get_frequeny_li
 		*freq_max = min(fe->ops.info.frequency_max, fe->ops.tuner_ops.info.frequency_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
-		printk(KERN_WARNING "DVB: frontend %u frequency limits undefined - fix the driver\n",
-		       fe->dvb->num);
+		printk(KERN_WARNING "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
+		       fe->dvb->num,fe->id);
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
@@ -734,8 +735,8 @@ static int dvb_frontend_check_parameters
 	dvb_frontend_get_frequeny_limits(fe, &freq_min, &freq_max);
 	if ((freq_min && parms->frequency < freq_min) ||
 	    (freq_max && parms->frequency > freq_max)) {
-		printk(KERN_WARNING "DVB: frontend %u frequency %u out of range (%u..%u)\n",
-		       fe->dvb->num, parms->frequency, freq_min, freq_max);
+		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
+		       fe->dvb->num, fe->id, parms->frequency, freq_min, freq_max);
 		return -EINVAL;
 	}
 
@@ -745,8 +746,8 @@ static int dvb_frontend_check_parameters
 		     parms->u.qpsk.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qpsk.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: frontend %u symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, parms->u.qpsk.symbol_rate,
+			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, fe->id, parms->u.qpsk.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -756,8 +757,8 @@ static int dvb_frontend_check_parameters
 		     parms->u.qam.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qam.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: frontend %u symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, parms->u.qam.symbol_rate,
+			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, fe->id, parms->u.qam.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -1775,8 +1776,9 @@ int dvb_register_frontend(struct dvb_ada
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
-	printk ("DVB: registering frontend %i (%s)...\n",
+	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
 		fe->dvb->num,
+		fe->id,
 		fe->ops.info.name);
 
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
diff -r ffa9a0c644b3 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Thu Sep 11 15:47:25 2008 +0100
@@ -234,6 +234,7 @@ struct dvb_frontend {
 	void *sec_priv;
 	void *analog_demod_priv;
 	struct tv_frontend_properties tv_property_cache;
+	int id;
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,
diff -r ffa9a0c644b3 linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Thu Sep 11 15:47:25 2008 +0100
@@ -315,48 +315,53 @@ static int dvb_register(struct cx23885_t
 {
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_i2c *i2c_bus = NULL;
+	struct videobuf_dvb_frontend *fe0;
+
+	fe0 = videobuf_dvb_get_frontend(&port->frontends, 0);
+	if (!fe0)
+		return -EINVAL;
 
 	/* init struct videobuf_dvb */
-	port->dvb.name = dev->name;
+	fe0->dvb.name = dev->name;
 
 	/* init frontend */
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		i2c_bus = &dev->i2c_bus[0];
-		port->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_generic_config,
 						&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
-			dvb_attach(mt2131_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(mt2131_attach, fe0->dvb.frontend,
 				   &i2c_bus->i2c_adap,
 				   &hauppauge_generic_tunerconfig, 0);
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 		i2c_bus = &dev->i2c_bus[0];
-		switch (alt_tuner) {
+		switch (alt_tuner) { // XXXXXX multifrontend?
 		case 1:
-			port->dvb.frontend =
+			fe0->dvb.frontend =
 				dvb_attach(s5h1409_attach,
 					   &hauppauge_ezqam_config,
 					   &i2c_bus->i2c_adap);
-			if (port->dvb.frontend != NULL) {
-				dvb_attach(tda829x_attach, port->dvb.frontend,
+			if (fe0->dvb.frontend != NULL) {
+				dvb_attach(tda829x_attach, fe0->dvb.frontend,
 					   &dev->i2c_bus[1].i2c_adap, 0x42,
 					   &tda829x_no_probe);
-				dvb_attach(tda18271_attach, port->dvb.frontend,
+				dvb_attach(tda18271_attach, fe0->dvb.frontend,
 					   0x60, &dev->i2c_bus[1].i2c_adap,
 					   &hauppauge_tda18271_config);
 			}
 			break;
 		case 0:
 		default:
-			port->dvb.frontend =
+			fe0->dvb.frontend =
 				dvb_attach(s5h1409_attach,
 					   &hauppauge_generic_config,
 					   &i2c_bus->i2c_adap);
-			if (port->dvb.frontend != NULL)
-				dvb_attach(mt2131_attach, port->dvb.frontend,
+			if (fe0->dvb.frontend != NULL)
+				dvb_attach(mt2131_attach, fe0->dvb.frontend,
 					   &i2c_bus->i2c_adap,
 					   &hauppauge_generic_tunerconfig, 0);
 			break;
@@ -364,47 +369,47 @@ static int dvb_register(struct cx23885_t
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 		i2c_bus = &dev->i2c_bus[0];
-		port->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_hvr1800lp_config,
 						&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
-			dvb_attach(mt2131_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(mt2131_attach, fe0->dvb.frontend,
 				   &i2c_bus->i2c_adap,
 				   &hauppauge_generic_tunerconfig, 0);
 		}
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
 		i2c_bus = &dev->i2c_bus[0];
-		port->dvb.frontend = dvb_attach(lgdt330x_attach,
+		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 						&fusionhdtv_5_express,
 						&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
-			dvb_attach(simple_tuner_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &i2c_bus->i2c_adap, 0x61,
 				   TUNER_LG_TDVS_H06XF);
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 		i2c_bus = &dev->i2c_bus[1];
-		port->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_hvr1500q_config,
 						&dev->i2c_bus[0].i2c_adap);
-		if (port->dvb.frontend != NULL)
-			dvb_attach(xc5000_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL)
+			dvb_attach(xc5000_attach, fe0->dvb.frontend,
 				&i2c_bus->i2c_adap,
 				&hauppauge_hvr1500q_tunerconfig, port);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 		i2c_bus = &dev->i2c_bus[1];
-		port->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&hauppauge_hvr1500_config,
 						&dev->i2c_bus[0].i2c_adap);
-		if (port->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend *fe;
 			struct xc2028_config cfg = {
 				.i2c_adap  = &i2c_bus->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = port,
+				.video_dev = fe0,
 				.callback  = cx23885_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
@@ -414,7 +419,7 @@ static int dvb_register(struct cx23885_t
 			};
 
 			fe = dvb_attach(xc2028_attach,
-					port->dvb.frontend, &cfg);
+					fe0->dvb.frontend, &cfg);
 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
@@ -422,29 +427,29 @@ static int dvb_register(struct cx23885_t
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 		i2c_bus = &dev->i2c_bus[0];
-		port->dvb.frontend = dvb_attach(tda10048_attach,
+		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 			&hauppauge_hvr1200_config,
 			&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
-			dvb_attach(tda829x_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
 				&dev->i2c_bus[1].i2c_adap, 0x42,
 				&tda829x_no_probe);
-			dvb_attach(tda18271_attach, port->dvb.frontend,
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
 				0x60, &dev->i2c_bus[1].i2c_adap,
 				&hauppauge_hvr1200_tuner_config);
 		}
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 		i2c_bus = &dev->i2c_bus[0];
-		port->dvb.frontend = dvb_attach(dib7000p_attach,
+		fe0->dvb.frontend = dvb_attach(dib7000p_attach,
 			&i2c_bus->i2c_adap,
 			0x12, &hauppauge_hvr1400_dib7000_config);
-		if (port->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend *fe;
 			struct xc2028_config cfg = {
 				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
 				.i2c_addr  = 0x64,
-				.video_dev = port,
+				.video_dev = fe0,
 				.callback  = cx23885_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
@@ -455,7 +460,7 @@ static int dvb_register(struct cx23885_t
 			};
 
 			fe = dvb_attach(xc2028_attach,
-					port->dvb.frontend, &cfg);
+					fe0->dvb.frontend, &cfg);
 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
@@ -463,30 +468,30 @@ static int dvb_register(struct cx23885_t
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 		i2c_bus = &dev->i2c_bus[port->nr - 1];
 
-		port->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&dvico_s5h1409_config,
 						&i2c_bus->i2c_adap);
-		if (port->dvb.frontend == NULL)
-			port->dvb.frontend = dvb_attach(s5h1411_attach,
+		if (fe0->dvb.frontend == NULL)
+			fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 							&dvico_s5h1411_config,
 							&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL)
-			dvb_attach(xc5000_attach, port->dvb.frontend,
+		if (fe0->dvb.frontend != NULL)
+			dvb_attach(xc5000_attach, fe0->dvb.frontend,
 				&i2c_bus->i2c_adap,
-				&dvico_xc5000_tunerconfig, port);
+				&dvico_xc5000_tunerconfig, fe0);
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
 		i2c_bus = &dev->i2c_bus[port->nr - 1];
 
-		port->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_xc3028,
 					       &i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend      *fe;
 			struct xc2028_config	  cfg = {
 				.i2c_adap  = &i2c_bus->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = port,
+				.video_dev = fe0,
 				.callback  = cx23885_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
@@ -495,7 +500,7 @@ static int dvb_register(struct cx23885_t
 				.demod       = XC3028_FE_ZARLINK456,
 			};
 
-			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
+			fe = dvb_attach(xc2028_attach, fe0->dvb.frontend,
 					&cfg);
 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
@@ -505,15 +510,15 @@ static int dvb_register(struct cx23885_t
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		i2c_bus = &dev->i2c_bus[0];
 
-		port->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 			&dvico_fusionhdtv_xc3028,
 			&i2c_bus->i2c_adap);
-		if (port->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend      *fe;
 			struct xc2028_config	  cfg = {
 				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = port,
+				.video_dev = fe0,
 				.callback  = cx23885_tuner_callback,
 			};
 			static struct xc2028_ctrl ctl = {
@@ -522,7 +527,7 @@ static int dvb_register(struct cx23885_t
 				.demod       = XC3028_FE_ZARLINK456,
 			};
 
-			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
+			fe = dvb_attach(xc2028_attach, fe0->dvb.frontend,
 				&cfg);
 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
@@ -533,7 +538,7 @@ static int dvb_register(struct cx23885_t
 		       dev->name);
 		break;
 	}
-	if (NULL == port->dvb.frontend) {
+	if (NULL == fe0->dvb.frontend) {
 		printk("%s: frontend initialization failed\n", dev->name);
 		return -1;
 	}
@@ -541,18 +546,25 @@ static int dvb_register(struct cx23885_t
 	/* Put the analog decoder in standby to keep it quiet */
 	cx23885_call_i2c_clients(i2c_bus, TUNER_SET_STANDBY, NULL);
 
-	if (port->dvb.frontend->ops.analog_ops.standby)
-		port->dvb.frontend->ops.analog_ops.standby(port->dvb.frontend);
+	if (fe0->dvb.frontend->ops.analog_ops.standby)
+		fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);
 
 	/* register everything */
-	return videobuf_dvb_register(&port->dvb, THIS_MODULE, port,
+	return videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
 				     &dev->pci->dev, adapter_nr);
+
 }
 
 int cx23885_dvb_register(struct cx23885_tsport *port)
 {
+
+	struct videobuf_dvb_frontend *fe0;
 	struct cx23885_dev *dev = port->dev;
 	int err;
+
+	fe0 = videobuf_dvb_get_frontend(&port->frontends, 0);
+	if (!fe0)
+		err = -EINVAL;
 
 	dprintk(1, "%s\n", __func__);
 	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
@@ -565,7 +577,7 @@ int cx23885_dvb_register(struct cx23885_
 
 	/* dvb stuff */
 	printk("%s: cx23885 based dvb card\n", dev->name);
-	videobuf_queue_sg_init(&port->dvb.dvbq, &dvb_qops, &dev->pci->dev, &port->slock,
+	videobuf_queue_sg_init(&fe0->dvb.dvbq, &dvb_qops, &dev->pci->dev, &port->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_TOP,
 			    sizeof(struct cx23885_buffer), port);
 	err = dvb_register(port);
@@ -577,9 +589,12 @@ int cx23885_dvb_register(struct cx23885_
 
 int cx23885_dvb_unregister(struct cx23885_tsport *port)
 {
+	struct videobuf_dvb_frontend *fe0;
+
+	fe0 = videobuf_dvb_get_frontend(&port->frontends, 0);
 	/* dvb */
-	if(port->dvb.frontend)
-		videobuf_dvb_unregister(&port->dvb);
+	if(fe0->dvb.frontend)
+		videobuf_dvb_unregister_bus(&port->frontends);
 
 	return 0;
 }
diff -r ffa9a0c644b3 linux/drivers/media/video/cx23885/cx23885.h
--- a/linux/drivers/media/video/cx23885/cx23885.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx23885/cx23885.h	Thu Sep 11 15:47:25 2008 +0100
@@ -226,7 +226,7 @@ struct cx23885_tsport {
 	int                        nr;
 	int                        sram_chno;
 
-	struct videobuf_dvb        dvb;
+	struct videobuf_dvb_frontends frontends;
 
 	/* dma queues */
 	struct cx23885_dmaqueue    mpegq;
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/Kconfig
--- a/linux/drivers/media/video/cx88/Kconfig	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/Kconfig	Thu Sep 11 15:47:25 2008 +0100
@@ -58,6 +58,7 @@ config VIDEO_CX88_DVB
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
+	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB/ATSC cards based on the
 	  Conexant 2388x chip.
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Sep 11 15:47:25 2008 +0100
@@ -1324,6 +1324,7 @@ static const struct cx88_board cx88_boar
 			.gpio0  = 0x84bf,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
+		.num_frontends	= 2,
 	},
 	[CX88_BOARD_NORWOOD_MICRO] = {
 		.name           = "Norwood Micro TV Tuner",
@@ -1717,6 +1718,26 @@ static const struct cx88_board cx88_boar
 		 * S-Video      0xc4bf  0xc4bb
 		 * Composite1   0xc4ff  0xc4fb
 		 * S-Video1     0xc4ff  0xc4fb
+		 *
+		 * BIT  VALUE	FUNCTION GP{x}_IO
+		 * 0	1	I:?
+		 * 1	1	I:?
+		 * 2	1	O:DVB-T DEMOD ENABLE LOW/ANALOG DEMOD ENABLE HIGH
+		 * 3	1	I:?
+		 * 4	1	I:?
+		 * 5	1	I:?
+		 * 6	0	O:INPUT SELECTOR 0=INTERNAL 1=EXPANSION
+		 * 7	1	O:DVB-T DEMOD RESET LOW
+		 *
+		 * BIT  VALUE	FUNCTION GP{x}_OE
+		 * 8	0	I
+		 * 9	0	I
+		 * a	1	O
+		 * b	0	I
+		 * c	0	I
+		 * d	0	I
+		 * e	1	O
+		 * f	1	O
 		 */
 		.input          = {{
 			.type   = CX88_VMUX_TELEVISION,
@@ -1733,6 +1754,7 @@ static const struct cx88_board cx88_boar
 		} },
 		/* fixme: Add radio support */
 		.mpeg           = CX88_MPEG_DVB,
+		.num_frontends	= 2,
 	},
 	[CX88_BOARD_HAUPPAUGE_HVR4000LITE] = {
 		.name           = "Hauppauge WinTV-HVR4000(Lite) DVB-S/S2",
@@ -2543,8 +2565,13 @@ static void cx88_card_setup_pre_i2c(stru
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
 		/* Init GPIO to allow tuner to attach */
-		cx_write(MO_GP0_IO, 0x0000c4bf);
-		udelay(1000);
+		//cx_write(MO_GP0_IO, 0x0000c4bf);
+		//udelay(1000);
+
+		//from MFE
+		/* Init GPIO for DVB-S/S2/Analog */
+		cx_write(MO_GP0_IO, core->board.input[0].gpio0);
+		break;
 	}
 }
 
@@ -2871,12 +2898,17 @@ struct cx88_core *cx88_core_create(struc
 		cx88_card_list(core, pci);
 	}
 
+	memset(&core->board, 0, sizeof(core->board));
 	memcpy(&core->board, &cx88_boards[core->boardnr], sizeof(core->board));
 
-	info_printk(core, "subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
+	if (!core->board.num_frontends)
+		core->board.num_frontends=1;
+
+	info_printk(core, "subsystem: %04x:%04x, board: %s [card=%d,%s], frontend(s): %d\n",
 		pci->subsystem_vendor, pci->subsystem_device, core->board.name,
 		core->boardnr, card[core->nr] == core->boardnr ?
-		"insmod option" : "autodetected");
+		"insmod option" : "autodetected",
+		core->board.num_frontends);
 
 	if (tuner[core->nr] != UNSET)
 		core->board.tuner_type = tuner[core->nr];
diff -r ffa9a0c644b3 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Sep 11 15:47:25 2008 +0100
@@ -113,13 +113,24 @@ static int cx88_dvb_bus_ctrl(struct dvb_
 	struct cx8802_dev *dev= fe->dvb->priv;
 	struct cx8802_driver *drv = NULL;
 	int ret = 0;
+	int fe_id;
+
+	fe_id = videobuf_dvb_find_frontend(&dev->frontends, fe);
+	if (!fe_id) {
+		printk(KERN_ERR "%s() No frontend found\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
 
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
 	if (drv) {
-		if (acquire)
+		if (acquire){
+			dev->frontends.active_fe_id = fe_id;
 			ret = drv->request_acquire(drv);
-		else
+		} else {
 			ret = drv->request_release(drv);
+			dev->frontends.active_fe_id = 0;
+		}
 	}
 
 	return ret;
@@ -516,6 +527,7 @@ static int attach_xc3028(u8 addr, struct
 static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 {
 	struct dvb_frontend *fe;
+	struct videobuf_dvb_frontend *fe0 = NULL;
 	struct xc2028_ctrl ctl;
 	struct xc2028_config cfg = {
 		.i2c_adap  = &dev->core->i2c_adap,
@@ -524,7 +536,12 @@ static int attach_xc3028(u8 addr, struct
 		.callback  = cx88_tuner_callback,
 	};
 
-	if (!dev->dvb.frontend) {
+/* Get the first frontend */
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	if (!fe0)
+		return -EINVAL;
+
+	if (!fe0->dvb.frontend) {
 		printk(KERN_ERR "%s/2: dvb frontend not attached. "
 				"Can't attach xc3028\n",
 		       dev->core->name);
@@ -538,10 +555,13 @@ static int attach_xc3028(u8 addr, struct
 	 */
 	cx88_setup_xc3028(dev->core, &ctl);
 
-	fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
+	fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
 	if (!fe) {
 		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 		       dev->core->name);
+		dvb_frontend_detach(fe0->dvb.frontend);
+		dvb_unregister_frontend(fe0->dvb.frontend);
+		fe0->dvb.frontend = NULL;
 		return -EINVAL;
 	}
 
@@ -566,8 +586,10 @@ static int cx24116_reset_device(struct d
 	struct cx88_core *core = dev->core;
 
 	/* Reset the part */
+	/* Put the cx24116 into reset */
 	cx_write(MO_SRST_IO, 0);
 	msleep(10);
+	/* Take the cx24116 out of reset */
 	cx_write(MO_SRST_IO, 1);
 	msleep(10);
 
@@ -588,20 +610,28 @@ static struct cx24116_config tevii_s460_
 
 static int dvb_register(struct cx8802_dev *dev)
 {
+	//struct cx88_core *core = dev->core;
+
+	///* init struct videobuf_dvb */
+	//dev->dvb.name = core->name;
+	//dev->ts_gen_cntrl = 0x0c;
+
 	struct cx88_core *core = dev->core;
+	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
 
-	/* init struct videobuf_dvb */
-	dev->dvb.name = core->name;
-	dev->ts_gen_cntrl = 0x0c;
+	/* Get the first frontend */
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	if (!fe0)
+		return -EINVAL;
 
 	/* init frontend */
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_DVB_T1:
-		dev->dvb.frontend = dvb_attach(cx22702_attach,
+		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &connexant_refboard_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, &core->i2c_adap,
 					DVB_PLL_THOMSON_DTT759X))
 				goto frontend_detach;
@@ -611,11 +641,11 @@ static int dvb_register(struct cx8802_de
 	case CX88_BOARD_CONEXANT_DVB_T1:
 	case CX88_BOARD_KWORLD_DVB_T_CX22702:
 	case CX88_BOARD_WINFAST_DTV1000:
-		dev->dvb.frontend = dvb_attach(cx22702_attach,
+		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &connexant_refboard_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, &core->i2c_adap,
 					DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
@@ -625,33 +655,84 @@ static int dvb_register(struct cx8802_de
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
-	case CX88_BOARD_HAUPPAUGE_HVR3000:
-		dev->dvb.frontend = dvb_attach(cx22702_attach,
+		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &hauppauge_hvr_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &core->i2c_adap, 0x61,
 				   TUNER_PHILIPS_FMD1216ME_MK3))
 				goto frontend_detach;
 		}
 		break;
+	case CX88_BOARD_HAUPPAUGE_HVR3000:
+		/* DVB-S init */
+
+		fe0->dvb.frontend = dvb_attach(cx24123_attach,
+			       &hauppauge_novas_config,
+			       &dev->core->i2c_adap);
+
+		if (fe0->dvb.frontend) {
+			/*
+  			 * ISL6421_DCL turns off dynamic current protection
+  			 * and enforces static protection.
+  			 *
+  			 * This is a requirement for 4x1 DiSEqC switches
+  	 		 * and/or Rotors. 
+  			 *
+  			 * This is also how the Windows driver configures
+  			 * the LNB voltage controller. (dmb).
+  			 */
+			if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
+			&dev->core->i2c_adap, 0x08, ISL6421_DCL, 0x00)) {
+				dprintk( 1, "%s(): HVR3000 - DVB-S LNB Init: failed\n", __FUNCTION__);
+			}
+		} else {
+			dprintk( 1, "%s(): HVR3000 - DVB-S Init: failed\n", __FUNCTION__);
+		}
+
+		/* DVB-T init */
+
+		fe1 = videobuf_dvb_get_frontend(&dev->frontends, 2);
+
+		if (fe1) {
+			fe1->dvb.frontend = dvb_attach(cx22702_attach,
+				&hauppauge_hvr_config,
+				&dev->core->i2c_adap);
+
+			if (fe1->dvb.frontend) {
+				fe1->dvb.frontend->id = 1;
+				if(!dvb_attach(simple_tuner_attach, fe1->dvb.frontend,
+						&dev->core->i2c_adap, 0x61,
+						TUNER_PHILIPS_FMD1216ME_MK3)) {
+					dprintk( 1, "%s(): HVR3000 - DVB-T misc Init: failed\n", __FUNCTION__);
+				}
+			} else {
+				dprintk( 1, "%s(): HVR3000 - DVB-T Init: failed\n", __FUNCTION__);
+			}
+		} else {
+			dprintk( 1, "%s(): HVR3000 - DVB-T Init: can't find frontend 2.\n", __FUNCTION__);
+		}
+
+		break;
+
+
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS:
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
 			break;
 		}
 		/* ZL10353 replaces MT352 on later cards */
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_plus_v1_1,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
 		}
@@ -659,31 +740,31 @@ static int dvb_register(struct cx8802_de
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL:
 		/* The tin box says DEE1601, but it seems to be DTT7579
 		 * compatible, with a slightly different MT352 AGC gain. */
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv_dual,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
 			break;
 		}
 		/* ZL10353 replaces MT352 on later cards */
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_plus_v1_1,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
 		}
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T1:
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_LG_Z201))
 				goto frontend_detach;
 		}
@@ -691,11 +772,11 @@ static int dvb_register(struct cx8802_de
 	case CX88_BOARD_KWORLD_DVB_T:
 	case CX88_BOARD_DNTV_LIVE_DVB_T:
 	case CX88_BOARD_ADSTECH_DVB_T_PCI:
-		dev->dvb.frontend = dvb_attach(mt352_attach,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dntv_live_dvbt_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_UNKNOWN_1))
 				goto frontend_detach;
 		}
@@ -703,10 +784,10 @@ static int dvb_register(struct cx8802_de
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
 #if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 		/* MT352 is on a secondary I2C bus made from some GPIO lines */
-		dev->dvb.frontend = dvb_attach(mt352_attach, &dntv_live_dvbt_pro_config,
+		fe0->dvb.frontend = dvb_attach(mt352_attach, &dntv_live_dvbt_pro_config,
 					       &dev->vp3054->adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_PHILIPS_FMD1216ME_MK3))
 				goto frontend_detach;
@@ -717,22 +798,22 @@ static int dvb_register(struct cx8802_de
 #endif
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_HYBRID:
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_hybrid,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &core->i2c_adap, 0x61,
 				   TUNER_THOMSON_FE6600))
 				goto frontend_detach;
 		}
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_xc3028,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend == NULL)
-			dev->dvb.frontend = dvb_attach(mt352_attach,
+		if (fe0->dvb.frontend == NULL)
+			fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&dvico_fusionhdtv_mt352_xc3028,
 						&core->i2c_adap);
 		/*
@@ -740,16 +821,16 @@ static int dvb_register(struct cx8802_de
 		 * We must not permit gate_ctrl to be performed, or
 		 * the xc3028 cannot communicate on the bus.
 		 */
-		if (dev->dvb.frontend)
-			dev->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+		if (fe0->dvb.frontend)
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
 		if (attach_xc3028(0x61, dev) < 0)
 			return -EINVAL;
 		break;
 	case CX88_BOARD_PCHDTV_HD3000:
-		dev->dvb.frontend = dvb_attach(or51132_attach, &pchdtv_hd3000,
+		fe0->dvb.frontend = dvb_attach(or51132_attach, &pchdtv_hd3000,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_THOMSON_DTT761X))
 				goto frontend_detach;
@@ -766,11 +847,11 @@ static int dvb_register(struct cx8802_de
 
 		/* Select RF connector callback */
 		fusionhdtv_3_gold.pll_rf_set = lgdt330x_pll_rf_set;
-		dev->dvb.frontend = dvb_attach(lgdt330x_attach,
+		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_MICROTUNE_4042FI5))
 				goto frontend_detach;
@@ -784,11 +865,11 @@ static int dvb_register(struct cx8802_de
 		mdelay(100);
 		cx_set(MO_GP0_IO, 9);
 		mdelay(200);
-		dev->dvb.frontend = dvb_attach(lgdt330x_attach,
+		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_THOMSON_DTT761X))
 				goto frontend_detach;
@@ -802,15 +883,15 @@ static int dvb_register(struct cx8802_de
 		mdelay(100);
 		cx_set(MO_GP0_IO, 1);
 		mdelay(200);
-		dev->dvb.frontend = dvb_attach(lgdt330x_attach,
+		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_5_gold,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_LG_TDVS_H06XF))
 				goto frontend_detach;
-			if (!dvb_attach(tda9887_attach, dev->dvb.frontend,
+			if (!dvb_attach(tda9887_attach, fe0->dvb.frontend,
 				   &core->i2c_adap, 0x43))
 				goto frontend_detach;
 		}
@@ -823,25 +904,25 @@ static int dvb_register(struct cx8802_de
 		mdelay(100);
 		cx_set(MO_GP0_IO, 1);
 		mdelay(200);
-		dev->dvb.frontend = dvb_attach(lgdt330x_attach,
+		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &pchdtv_hd5500,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_LG_TDVS_H06XF))
 				goto frontend_detach;
-			if (!dvb_attach(tda9887_attach, dev->dvb.frontend,
+			if (!dvb_attach(tda9887_attach, fe0->dvb.frontend,
 				   &core->i2c_adap, 0x43))
 				goto frontend_detach;
 		}
 		break;
 	case CX88_BOARD_ATI_HDTVWONDER:
-		dev->dvb.frontend = dvb_attach(nxt200x_attach,
+		fe0->dvb.frontend = dvb_attach(nxt200x_attach,
 					       &ati_hdtvwonder,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			if (!dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_PHILIPS_TUV1236D))
 				goto frontend_detach;
@@ -849,42 +930,43 @@ static int dvb_register(struct cx8802_de
 		break;
 	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
 	case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
-		dev->dvb.frontend = dvb_attach(cx24123_attach,
+		fe0->dvb.frontend = dvb_attach(cx24123_attach,
 					       &hauppauge_novas_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend) {
-			if (!dvb_attach(isl6421_attach, dev->dvb.frontend,
+		if (fe0->dvb.frontend) {
+//TODO Darron has different code here
+			if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x08, 0x00, 0x00))
 				goto frontend_detach;
 		}
 		break;
 	case CX88_BOARD_KWORLD_DVBS_100:
-		dev->dvb.frontend = dvb_attach(cx24123_attach,
+		fe0->dvb.frontend = dvb_attach(cx24123_attach,
 					       &kworld_dvbs_100_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend) {
-			core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
-			dev->dvb.frontend->ops.set_voltage = kworld_dvbs_100_set_voltage;
+		if (fe0->dvb.frontend) {
+			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage = kworld_dvbs_100_set_voltage;
 		}
 		break;
 	case CX88_BOARD_GENIATECH_DVBS:
-		dev->dvb.frontend = dvb_attach(cx24123_attach,
+		fe0->dvb.frontend = dvb_attach(cx24123_attach,
 					       &geniatech_dvbs_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend) {
-			core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
-			dev->dvb.frontend->ops.set_voltage = geniatech_dvbs_set_voltage;
+		if (fe0->dvb.frontend) {
+			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage = geniatech_dvbs_set_voltage;
 		}
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-		dev->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 					       &pinnacle_pctv_hd_800i_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			/* tuner_config.video_dev must point to
 			 * i2c_adap.algo_data
 			 */
-			if (!dvb_attach(xc5000_attach, dev->dvb.frontend,
+			if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
 					&core->i2c_adap,
 					&pinnacle_pctv_hd_800i_tuner_config,
 					core->i2c_adap.algo_data))
@@ -892,10 +974,10 @@ static int dvb_register(struct cx8802_de
 		}
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
-		dev->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 						&dvico_hdtv5_pci_nano_config,
 						&core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend *fe;
 			struct xc2028_config cfg = {
 				.i2c_adap  = &core->i2c_adap,
@@ -909,13 +991,13 @@ static int dvb_register(struct cx8802_de
 			};
 
 			fe = dvb_attach(xc2028_attach,
-					dev->dvb.frontend, &cfg);
+					fe0->dvb.frontend, &cfg);
 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
 		break;
 	 case CX88_BOARD_PINNACLE_HYBRID_PCTV:
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &cx88_geniatech_x8000_mt,
 					       &core->i2c_adap);
 		if (attach_xc3028(0x61, dev) < 0)
@@ -924,28 +1006,28 @@ static int dvb_register(struct cx8802_de
 	 case CX88_BOARD_GENIATECH_X8000_MT:
 		dev->ts_gen_cntrl = 0x00;
 
-		dev->dvb.frontend = dvb_attach(zl10353_attach,
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &cx88_geniatech_x8000_mt,
 					       &core->i2c_adap);
 		if (attach_xc3028(0x61, dev) < 0)
 			goto frontend_detach;
 		break;
 	 case CX88_BOARD_KWORLD_ATSC_120:
-		dev->dvb.frontend = dvb_attach(s5h1409_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 					       &kworld_atsc_120_config,
 					       &core->i2c_adap);
 		if (attach_xc3028(0x61, dev) < 0)
 			goto frontend_detach;
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD:
-		dev->dvb.frontend = dvb_attach(s5h1411_attach,
+		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 					       &dvico_fusionhdtv7_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend != NULL) {
 			/* tuner_config.video_dev must point to
 			 * i2c_adap.algo_data
 			 */
-			if (!dvb_attach(xc5000_attach, dev->dvb.frontend,
+			if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
 					&core->i2c_adap,
 					&dvico_fusionhdtv7_tuner_config,
 					core->i2c_adap.algo_data))
@@ -953,24 +1035,76 @@ static int dvb_register(struct cx8802_de
 		}
 		break;
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
+		/* DVB-S/S2 Enabled */
+		fe0->dvb.frontend = dvb_attach(cx24116_attach,
+					&hauppauge_hvr4000_config,
+					&dev->core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			/*
+  			 * ISL6421_DCL turns off dynamic current protection
+  			 * and enforces static protection.
+  			 *
+  			 * This is a requirement for 4x1 DiSEqC switches
+  			 * and/or Rotors. 
+  			 *
+  			 * This is also how the Windows driver configures
+ 			 * the LNB voltage controller. (dmb).
+  			 */
+			if(!dvb_attach(isl6421_attach, fe0->dvb.frontend,
+			&dev->core->i2c_adap, 0x08, ISL6421_DCL, 0x00)) {
+				dprintk( 1, "%s(): HVR4000 - DVB-S LNB Init: failed\n", __FUNCTION__);
+			}
+		} else {
+			dprintk( 1, "%s(): HVR4000 - DVB-S Init: failed\n", __FUNCTION__);
+		}
+
+		fe1 = videobuf_dvb_get_frontend(&dev->frontends, 2);
+
+		/* DVB-T Enabled */
+		if (fe1) {
+			fe1->dvb.frontend = dvb_attach(cx22702_attach,
+					       &hauppauge_hvr_config,
+					       &dev->core->i2c_adap);
+			if (fe1->dvb.frontend) {
+				fe1->dvb.frontend->id = 1;
+				if(!dvb_attach(simple_tuner_attach, fe1->dvb.frontend,
+						&dev->core->i2c_adap, 0x61,
+						TUNER_PHILIPS_FMD1216ME_MK3)) {
+					dprintk( 1, "%s(): HVR4000 - DVB-T misc Init: failed\n", __FUNCTION__);
+				}
+			} else {
+				dprintk( 1, "%s(): HVR4000 - DVB-T Init: failed\n", __FUNCTION__);
+			}
+		} else {
+			dprintk( 1, "%s(): HVR4000 - DVB-T Init: can't find frontend 2.\n", __FUNCTION__);
+		}
+		break;
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
-		/* Support for DVB-S only, not DVB-T support */
-		dev->dvb.frontend = dvb_attach(cx24116_attach,
-			&hauppauge_hvr4000_config,
-			&dev->core->i2c_adap);
-		if (dev->dvb.frontend) {
-			dvb_attach(isl6421_attach, dev->dvb.frontend,
-				&dev->core->i2c_adap,
-				0x08, 0x00, 0x00);
+		fe0->dvb.frontend = dvb_attach(cx24116_attach,
+						&hauppauge_hvr4000_config,
+						&dev->core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			/*
+  			 * ISL6421_DCL turns off dynamic current protection
+  			 * and enforces static protection.
+  			 *
+  			 * This is a requirement for 4x1 DiSEqC switches
+  			 * and/or Rotors. 
+  			 *
+  			 * This is also how the Windows driver configures
+  			 * the LNB voltage controller. (dmb).
+  			 */
+			dvb_attach(isl6421_attach, fe0->dvb.frontend,
+			&dev->core->i2c_adap, 0x08, ISL6421_DCL, 0x00);
 		}
 		break;
 	case CX88_BOARD_TEVII_S460:
-	        dev->dvb.frontend = dvb_attach(cx24116_attach,
+	        fe0->dvb.frontend = dvb_attach(cx24116_attach,
 					       &tevii_s460_config,
 					       &core->i2c_adap);
-		if (dev->dvb.frontend != NULL) {
-			core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
-			dev->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+		if (fe0->dvb.frontend != NULL) {
+			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
 		}
 		break;
 	default:
@@ -978,7 +1112,8 @@ static int dvb_register(struct cx8802_de
 		       core->name);
 		break;
 	}
-	if (NULL == dev->dvb.frontend) {
+
+        if ( (NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend) ) {
 		printk(KERN_ERR
 		       "%s/2: frontend initialization failed\n",
 		       core->name);
@@ -986,19 +1121,25 @@ static int dvb_register(struct cx8802_de
 	}
 
 	/* Ensure all frontends negotiate bus access */
-	dev->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;
+	fe0->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;
+	if (fe1)
+		fe1->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;
+
 
 	/* Put the analog decoder in standby to keep it quiet */
 	cx88_call_i2c_clients(core, TUNER_SET_STANDBY, NULL);
 
 	/* register everything */
-	return videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev,
-				     &dev->pci->dev, adapter_nr);
+	//return videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev,
+	//			     &dev->pci->dev, adapter_nr);
+//TODO there's a new param (adapter_nr) on line above, why? Looks like should be on line below too
+	return videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev, &dev->pci->dev, adapter_nr);
+
 
 frontend_detach:
-	if (dev->dvb.frontend) {
-		dvb_frontend_detach(dev->dvb.frontend);
-		dev->dvb.frontend = NULL;
+	if (fe0->dvb.frontend) {
+		dvb_frontend_detach(fe0->dvb.frontend);
+		fe0->dvb.frontend = NULL;
 	}
 	return -EINVAL;
 }
@@ -1022,6 +1163,66 @@ static int cx8802_dvb_advise_acquire(str
 		cx_clear(MO_GP0_IO, 0x00000004);
 		udelay(1000);
 		break;
+
+	case CX88_BOARD_HAUPPAUGE_HVR3000: /* ? */
+		if(core->dvbdev->frontends.active_fe_id == 1) {
+			/* DVB-S/S2 Enabled */
+
+			/* Toggle reset on cx22702 leaving i2c active */
+			cx_write(MO_GP0_IO, core->board.input[0].gpio0);
+			udelay(1000);
+			cx_clear(MO_GP0_IO, 0x00000080);
+			udelay(50);
+			cx_set(MO_GP0_IO, 0x00000080); /* cx22702 out of reset */
+			cx_set(MO_GP0_IO, 0x00000004); /* tri-state the cx22702 pins */
+			udelay(1000);
+
+			cx_write(MO_SRST_IO, 1); /* Take the cx24116/cx24123 out of reset */
+			core->dvbdev->ts_gen_cntrl = 0x02; /* Parallel IO */
+		} else
+		if (core->dvbdev->frontends.active_fe_id == 2) {
+			/* DVB-T Enabled */
+
+			/* Put the cx24116/cx24123 into reset */
+			cx_write(MO_SRST_IO, 0);
+
+			/* cx22702 out of reset and enable it */
+			cx_set(MO_GP0_IO,   0x00000080);
+			cx_clear(MO_GP0_IO, 0x00000004);
+			core->dvbdev->ts_gen_cntrl = 0x0c; /* Serial IO */
+			udelay(1000);
+		}
+		break;
+	case CX88_BOARD_HAUPPAUGE_HVR4000:
+		if(core->dvbdev->frontends.active_fe_id == 1) {
+			/* DVB-S/S2 Enabled */
+
+			/* Toggle reset on cx22702 leaving i2c active */
+			cx_write(MO_GP0_IO, (core->board.input[0].gpio0 & 0x0000ff00) | 0x00000080);
+			udelay(1000);
+			cx_clear(MO_GP0_IO, 0x00000080);
+			udelay(50);
+			cx_set(MO_GP0_IO, 0x00000080); /* cx22702 out of reset */
+			cx_set(MO_GP0_IO, 0x00000004); /* tri-state the cx22702 pins */
+			udelay(1000);
+
+			cx_write(MO_SRST_IO, 1); /* Take the cx24116/cx24123 out of reset */
+			core->dvbdev->ts_gen_cntrl = 0x02; /* Parallel IO */
+		} else
+		if (core->dvbdev->frontends.active_fe_id == 2) {
+			/* DVB-T Enabled */
+
+			/* Put the cx24116/cx24123 into reset */
+			cx_write(MO_SRST_IO, 0);
+
+			/* cx22702 out of reset and enable it */
+			cx_set(MO_GP0_IO,   0x00000080);
+			cx_clear(MO_GP0_IO, 0x00000004);
+			core->dvbdev->ts_gen_cntrl = 0x0c; /* Serial IO */
+			udelay(1000);
+		}
+		break;
+
 	default:
 		err = -ENODEV;
 	}
@@ -1042,6 +1243,9 @@ static int cx8802_dvb_advise_release(str
 		 cx_set(MO_GP0_IO, 0x00000004);
 #endif
 		break;
+	case CX88_BOARD_HAUPPAUGE_HVR3000:
+	case CX88_BOARD_HAUPPAUGE_HVR4000:
+		break;
 	default:
 		err = -ENODEV;
 	}
@@ -1052,7 +1256,8 @@ static int cx8802_dvb_probe(struct cx880
 {
 	struct cx88_core *core = drv->core;
 	struct cx8802_dev *dev = drv->core->dvbdev;
-	int err;
+	int err,i;
+	struct videobuf_dvb_frontend *fe;
 
 	dprintk( 1, "%s\n", __func__);
 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
@@ -1072,12 +1277,23 @@ static int cx8802_dvb_probe(struct cx880
 
 	/* dvb stuff */
 	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
-	videobuf_queue_sg_init(&dev->dvb.dvbq, &dvb_qops,
+	dev->ts_gen_cntrl = 0x0c;
+
+	for (i = 1; i <= core->board.num_frontends; i++) {
+		fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
+		if (!fe) {
+			printk(KERN_ERR "%s() failed to get frontend(%d)\n", __FUNCTION__, i);
+			continue;
+		}
+		videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_TOP,
 			    sizeof(struct cx88_buffer),
 			    dev);
+		/* init struct videobuf_dvb */
+		fe->dvb.name = dev->core->name;
+	}
 	err = dvb_register(dev);
 	if (err != 0)
 		printk(KERN_ERR "%s/2: dvb_register failed (err = %d)\n",
@@ -1092,8 +1308,10 @@ static int cx8802_dvb_remove(struct cx88
 	struct cx8802_dev *dev = drv->core->dvbdev;
 
 	/* dvb */
-	if (dev->dvb.frontend)
-		videobuf_dvb_unregister(&dev->dvb);
+//TODO is the if necessary, and does it work?
+	//if (dev->dvb.frontend)
+	videobuf_dvb_unregister_bus(&dev->frontends);
+
 
 	vp3054_i2c_remove(dev);
 

--========GMX15400122114900040000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX15400122114900040000--
