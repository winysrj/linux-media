Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:53387 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1FGQMn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 12:12:43 -0400
Received: from [94.248.227.150] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTytL-0006CU-RL
	for linux-media@vger.kernel.org; Tue, 07 Jun 2011 18:12:41 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] cx88: added XC4000 tuner callback and DVB attach functions
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 18:12:29 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071812.29766.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Added functions for XC4000 tuner reset and attaching DVB frontend.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-cards.c xc4000/drivers/media/video/cx88/cx88-cards.c
--- xc4000_orig/drivers/media/video/cx88/cx88-cards.c	2011-06-07 14:33:39.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-cards.c	2011-06-07 15:28:03.000000000 +0200
@@ -28,6 +28,7 @@
 
 #include "cx88.h"
 #include "tea5767.h"
+#include "xc4000.h"
 
 static unsigned int tuner[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 static unsigned int radio[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
@@ -2948,6 +2949,15 @@
 	return -EINVAL;
 }
 
+static int cx88_xc4000_tuner_callback(struct cx88_core *core,
+				      int command, int arg)
+{
+	/* Board-specific callbacks */
+	switch (core->boardnr) {
+	}
+	return -EINVAL;
+}
+
 /* ----------------------------------------------------------------------- */
 /* Tuner callback function. Currently only needed for the Pinnacle 	   *
  * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both	   *
@@ -3022,6 +3032,9 @@
 		case TUNER_XC2028:
 			info_printk(core, "Calling XC2028/3028 callback\n");
 			return cx88_xc2028_tuner_callback(core, command, arg);
+		case TUNER_XC4000:
+			info_printk(core, "Calling XC4000 callback\n");
+			return cx88_xc4000_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
 			info_printk(core, "Calling XC5000 callback\n");
 			return cx88_xc5000_tuner_callback(core, command, arg);
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-dvb.c xc4000/drivers/media/video/cx88/cx88-dvb.c
--- xc4000_orig/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 14:33:39.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-dvb.c	2011-06-07 15:33:09.000000000 +0200
@@ -41,6 +41,7 @@
 #include "or51132.h"
 #include "lgdt330x.h"
 #include "s5h1409.h"
+#include "xc4000.h"
 #include "xc5000.h"
 #include "nxt200x.h"
 #include "cx24123.h"
@@ -604,6 +605,39 @@
 
 	return 0;
 }
+
+static int attach_xc4000(struct cx8802_dev *dev, struct xc4000_config *cfg)
+{
+	struct dvb_frontend *fe;
+	struct videobuf_dvb_frontend *fe0 = NULL;
+
+	/* Get the first frontend */
+	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
+	if (!fe0)
+		return -EINVAL;
+
+	if (!fe0->dvb.frontend) {
+		printk(KERN_ERR "%s/2: dvb frontend not attached. "
+				"Can't attach xc4000\n",
+		       dev->core->name);
+		return -EINVAL;
+	}
+
+	fe = dvb_attach(xc4000_attach, fe0->dvb.frontend, &dev->core->i2c_adap,
+			cfg);
+	if (!fe) {
+		printk(KERN_ERR "%s/2: xc4000 attach failed\n",
+		       dev->core->name);
+		dvb_frontend_detach(fe0->dvb.frontend);
+		dvb_unregister_frontend(fe0->dvb.frontend);
+		fe0->dvb.frontend = NULL;
+		return -EINVAL;
+	}
+
+	printk(KERN_INFO "%s/2: xc4000 attached\n", dev->core->name);
+
+	return 0;
+}
 
 static int cx24116_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
