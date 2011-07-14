Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab1GNWGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:06:15 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] [media] em28xx: add em28xx_ prefix to functions
Date: Thu, 14 Jul 2011 18:06:08 -0400
Message-Id: <1310681168-3338-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makes it more straight-forward to follow stack traces if the functions
don't have generic names. Using this as a crutch while trying to better
understand the lockdep warnings I get when loading the em28xx driver.

CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/em28xx/em28xx-dvb.c |   58 +++++++++++++++----------------
 1 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 7904ca4..922b858 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -115,7 +115,7 @@ static inline void print_err_status(struct em28xx *dev,
 	}
 }
 
-static inline int dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
+static inline int em28xx_dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
 {
 	int i;
 
@@ -148,7 +148,7 @@ static inline int dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
 	return 0;
 }
 
-static int start_streaming(struct em28xx_dvb *dvb)
+static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 {
 	int rc;
 	struct em28xx *dev = dvb->adapter.priv;
@@ -163,10 +163,10 @@ static int start_streaming(struct em28xx_dvb *dvb)
 
 	return em28xx_init_isoc(dev, EM28XX_DVB_MAX_PACKETS,
 				EM28XX_DVB_NUM_BUFS, max_dvb_packet_size,
-				dvb_isoc_copy);
+				em28xx_dvb_isoc_copy);
 }
 
-static int stop_streaming(struct em28xx_dvb *dvb)
+static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
 {
 	struct em28xx *dev = dvb->adapter.priv;
 
@@ -177,7 +177,7 @@ static int stop_streaming(struct em28xx_dvb *dvb)
 	return 0;
 }
 
-static int start_feed(struct dvb_demux_feed *feed)
+static int em28xx_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux  = feed->demux;
 	struct em28xx_dvb *dvb = demux->priv;
@@ -191,7 +191,7 @@ static int start_feed(struct dvb_demux_feed *feed)
 	rc = dvb->nfeeds;
 
 	if (dvb->nfeeds == 1) {
-		ret = start_streaming(dvb);
+		ret = em28xx_start_streaming(dvb);
 		if (ret < 0)
 			rc = ret;
 	}
@@ -200,7 +200,7 @@ static int start_feed(struct dvb_demux_feed *feed)
 	return rc;
 }
 
-static int stop_feed(struct dvb_demux_feed *feed)
+static int em28xx_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux  = feed->demux;
 	struct em28xx_dvb *dvb = demux->priv;
@@ -210,7 +210,7 @@ static int stop_feed(struct dvb_demux_feed *feed)
 	dvb->nfeeds--;
 
 	if (0 == dvb->nfeeds)
-		err = stop_streaming(dvb);
+		err = em28xx_stop_streaming(dvb);
 
 	mutex_unlock(&dvb->lock);
 	return err;
@@ -295,7 +295,7 @@ static struct drxd_config em28xx_drxd = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
-static int mt352_terratec_xs_init(struct dvb_frontend *fe)
+static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
 	static u8 clock_config[]   = { CLOCK_CTL,  0x38, 0x2c };
@@ -327,7 +327,7 @@ static struct mt352_config terratec_xs_mt352_cfg = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner = 1,
 	.if2 = 45600,
-	.demod_init = mt352_terratec_xs_init,
+	.demod_init = em28xx_mt352_terratec_xs_init,
 };
 
 static struct tda10023_config em28xx_tda10023_config = {
@@ -357,7 +357,7 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 
 /* ------------------------------------------------------------------ */
 
-static int attach_xc3028(u8 addr, struct em28xx *dev)
+static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 {
 	struct dvb_frontend *fe;
 	struct xc2028_config cfg;
@@ -387,10 +387,8 @@ static int attach_xc3028(u8 addr, struct em28xx *dev)
 
 /* ------------------------------------------------------------------ */
 
-static int register_dvb(struct em28xx_dvb *dvb,
-		 struct module *module,
-		 struct em28xx *dev,
-		 struct device *device)
+static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
+			       struct em28xx *dev, struct device *device)
 {
 	int result;
 
@@ -437,8 +435,8 @@ static int register_dvb(struct em28xx_dvb *dvb,
 	dvb->demux.priv       = dvb;
 	dvb->demux.filternum  = 256;
 	dvb->demux.feednum    = 256;
-	dvb->demux.start_feed = start_feed;
-	dvb->demux.stop_feed  = stop_feed;
+	dvb->demux.start_feed = em28xx_start_feed;
+	dvb->demux.stop_feed  = em28xx_stop_feed;
 
 	result = dvb_dmx_init(&dvb->demux);
 	if (result < 0) {
@@ -506,7 +504,7 @@ fail_adapter:
 	return result;
 }
 
-static void unregister_dvb(struct em28xx_dvb *dvb)
+static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 {
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
@@ -522,7 +520,7 @@ static void unregister_dvb(struct em28xx_dvb *dvb)
 	dvb_unregister_adapter(&dvb->adapter);
 }
 
-static int dvb_init(struct em28xx *dev)
+static int em28xx_dvb_init(struct em28xx *dev)
 {
 	int result = 0;
 	struct em28xx_dvb *dvb;
@@ -563,7 +561,7 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
 					   &em2880_lgdt3303_dev,
 					   &dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -572,7 +570,7 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_with_xc3028,
 					   &dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -583,7 +581,7 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
 					   &dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -604,7 +602,7 @@ static int dvb_init(struct em28xx *dev)
 						   &dev->i2c_adap);
 		}
 
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -614,7 +612,7 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(s5h1409_attach,
 					   &em28xx_s5h1409_with_xc3028,
 					   &dev->i2c_adap);
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -635,7 +633,7 @@ static int dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
 		dvb->fe[0] = dvb_attach(drxd_attach, &em28xx_drxd, NULL,
 					   &dev->i2c_adap, &dev->udev->dev);
-		if (attach_xc3028(0x61, dev) < 0) {
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -703,7 +701,7 @@ static int dvb_init(struct em28xx *dev)
 	dvb->fe[0]->callback = em28xx_tuner_callback;
 
 	/* register everything */
-	result = register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
+	result = em28xx_register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
 
 	if (result < 0)
 		goto out_free;
@@ -720,7 +718,7 @@ out_free:
 	goto ret;
 }
 
-static int dvb_fini(struct em28xx *dev)
+static int em28xx_dvb_fini(struct em28xx *dev)
 {
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
@@ -728,7 +726,7 @@ static int dvb_fini(struct em28xx *dev)
 	}
 
 	if (dev->dvb) {
-		unregister_dvb(dev->dvb);
+		em28xx_unregister_dvb(dev->dvb);
 		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
@@ -739,8 +737,8 @@ static int dvb_fini(struct em28xx *dev)
 static struct em28xx_ops dvb_ops = {
 	.id   = EM28XX_DVB,
 	.name = "Em28xx dvb Extension",
-	.init = dvb_init,
-	.fini = dvb_fini,
+	.init = em28xx_dvb_init,
+	.fini = em28xx_dvb_fini,
 };
 
 static int __init em28xx_dvb_register(void)
-- 
1.7.1

