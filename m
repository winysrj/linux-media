Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaKBMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 10/14] [media] cx231xx: use dev_foo instead of printk
Date: Sun,  2 Nov 2014 10:32:33 -0200
Message-Id: <caa43aeac28acdb1fdab7f105b2107bd8a0c6063.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several places at cx231xx that uses printk without
any special reason. Change all of them to use dev_foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 9088a32db2d1..b299242a63dd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1208,7 +1208,8 @@ int cx231xx_set_audio_decoder_input(struct cx231xx *dev,
 			/* This is just a casual suggestion to people adding
 			   new boards in case they use a tuner type we don't
 			   currently know about */
-			printk(KERN_INFO "Unknown tuner type configuring SIF");
+			dev_info(&dev->udev->dev,
+				 "Unknown tuner type configuring SIF");
 			break;
 		}
 		break;
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 2e8741314bce..7156344e7022 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1216,11 +1216,11 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	cx231xx_add_into_devlist(dev);
 
 	if (dev->board.has_417) {
-		printk(KERN_INFO "attach 417 %d\n", dev->model);
+		dev_info(&udev->dev, "attach 417 %d\n", dev->model);
 		if (cx231xx_417_register(dev) < 0) {
-			printk(KERN_ERR
+			dev_err(&udev->dev,
 				"%s() Failed to register 417 on VID_B\n",
-			       __func__);
+				__func__);
 		}
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 044ad353d09b..a0d40bda718d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -45,11 +45,6 @@ MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk(level, fmt, arg...) do {			\
-if (debug >= level) 						\
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
-} while (0)
-
 #define CX231XX_DVB_NUM_BUFS 5
 #define CX231XX_DVB_MAX_PACKETSIZE 564
 #define CX231XX_DVB_MAX_PACKETS 64
@@ -196,9 +191,11 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		dprintk(1, "URB status %d [%s].\n", status, errmsg);
+		dev_dbg(&dev->udev->dev,
+			"URB status %d [%s].\n", status, errmsg);
 	} else {
-		dprintk(1, "URB packet %d, status %d [%s].\n",
+		dev_dbg(&dev->udev->dev,
+			"URB packet %d, status %d [%s].\n",
 			packet, status, errmsg);
 	}
 }
@@ -377,20 +374,21 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
+		dev_err(&dev->udev->dev, "%s/2: dvb frontend not attached. "
 		       "Can't attach xc5000\n", dev->name);
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc5000_attach, dev->dvb->frontend, &cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc5000 attach failed\n", dev->name);
+		dev_err(&dev->udev->dev,
+			"%s/2: xc5000 attach failed\n", dev->name);
 		dvb_frontend_detach(dev->dvb->frontend);
 		dev->dvb->frontend = NULL;
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "%s/2: xc5000 attached\n", dev->name);
+	dev_info(&dev->udev->dev, "%s/2: xc5000 attached\n", dev->name);
 
 	return 0;
 }
@@ -462,7 +460,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	result = dvb_register_adapter(&dvb->adapter, dev->name, module, device,
 				      adapter_nr);
 	if (result < 0) {
-		printk(KERN_WARNING
+		dev_warn(&dev->udev->dev,
 		       "%s: dvb_register_adapter failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_adapter;
@@ -476,7 +474,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
 	if (result < 0) {
-		printk(KERN_WARNING
+		dev_warn(&dev->udev->dev,
 		       "%s: dvb_register_frontend failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_frontend;
@@ -494,7 +492,8 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmx_init failed (errno = %d)\n",
+		dev_warn(&dev->udev->dev,
+			 "%s: dvb_dmx_init failed (errno = %d)\n",
 		       dev->name, result);
 		goto fail_dmx;
 	}
@@ -504,15 +503,16 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	dvb->dmxdev.capabilities = 0;
 	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (result < 0) {
-		printk(KERN_WARNING "%s: dvb_dmxdev_init failed (errno = %d)\n",
-		       dev->name, result);
+		dev_warn(&dev->udev->dev,
+			 "%s: dvb_dmxdev_init failed (errno = %d)\n",
+			 dev->name, result);
 		goto fail_dmxdev;
 	}
 
 	dvb->fe_hw.source = DMX_FRONTEND_0;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_WARNING
+		dev_warn(&dev->udev->dev,
 		       "%s: add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
 		       dev->name, result);
 		goto fail_fe_hw;
@@ -521,17 +521,17 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 	dvb->fe_mem.source = DMX_MEMORY_FE;
 	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	if (result < 0) {
-		printk(KERN_WARNING
-		       "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
-		       dev->name, result);
+		dev_warn(&dev->udev->dev,
+			 "%s: add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
+			 dev->name, result);
 		goto fail_fe_mem;
 	}
 
 	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	if (result < 0) {
-		printk(KERN_WARNING
-		       "%s: connect_frontend failed (errno = %d)\n", dev->name,
-		       result);
+		dev_warn(&dev->udev->dev,
+			 "%s: connect_frontend failed (errno = %d)\n",
+			 dev->name, result);
 		goto fail_fe_conn;
 	}
 
@@ -590,7 +590,8 @@ static int dvb_init(struct cx231xx *dev)
 	dvb = kzalloc(sizeof(struct cx231xx_dvb), GFP_KERNEL);
 
 	if (dvb == NULL) {
-		printk(KERN_INFO "cx231xx_dvb: memory allocation failed\n");
+		dev_info(&dev->udev->dev,
+			 "cx231xx_dvb: memory allocation failed\n");
 		return -ENOMEM;
 	}
 	dev->dvb = dvb;
@@ -612,8 +613,8 @@ static int dvb_init(struct cx231xx *dev)
 					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach s5h1432 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -637,8 +638,8 @@ static int dvb_init(struct cx231xx *dev)
 					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach s5h1411 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -660,8 +661,8 @@ static int dvb_init(struct cx231xx *dev)
 					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach s5h1432 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -684,8 +685,8 @@ static int dvb_init(struct cx231xx *dev)
 					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach s5h1411 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -702,7 +703,8 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
-		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
+		dev_info(&dev->udev->dev,
+			 "%s: looking for tuner / demod on i2c bus: %d\n",
 		       __func__, i2c_adapter_id(tuner_i2c));
 
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
@@ -710,8 +712,8 @@ static int dvb_init(struct cx231xx *dev)
 						tuner_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach LG3305 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach LG3305 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -732,8 +734,8 @@ static int dvb_init(struct cx231xx *dev)
 			);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach SI2165 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -765,8 +767,8 @@ static int dvb_init(struct cx231xx *dev)
 			);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach SI2165 front end\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -810,16 +812,17 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
-		printk(KERN_INFO "%s: looking for demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(tuner_i2c));
+		dev_info(&dev->udev->dev,
+			 "%s: looking for demod on i2c bus: %d\n",
+			 __func__, i2c_adapter_id(tuner_i2c));
 
 		dev->dvb->frontend = dvb_attach(mb86a20s_attach,
 						&pv_mb86a20s_config,
 						demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
-			printk(DRIVER_NAME
-			       ": Failed to attach mb86a20s demod\n");
+			dev_err(&dev->udev->dev,
+				"Failed to attach mb86a20s demod\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -833,12 +836,13 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 
 	default:
-		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
-		       " isn't supported yet\n", dev->name);
+		dev_err(&dev->udev->dev,
+			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
+			dev->name);
 		break;
 	}
 	if (NULL == dvb->frontend) {
-		printk(KERN_ERR
+		dev_err(&dev->udev->dev,
 		       "%s/2: frontend initialization failed\n", dev->name);
 		result = -EINVAL;
 		goto out_free;
@@ -851,7 +855,7 @@ static int dvb_init(struct cx231xx *dev)
 		goto out_free;
 
 
-	printk(KERN_INFO "Successfully loaded cx231xx-dvb\n");
+	dev_info(&dev->udev->dev, "Successfully loaded cx231xx-dvb\n");
 
 ret:
 	cx231xx_set_mode(dev, CX231XX_SUSPEND);
-- 
1.9.3

