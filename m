Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:35838 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753031Ab1HTLhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:37:31 -0400
Message-ID: <4E4F9C77.6010008@yahoo.com>
Date: Sat, 20 Aug 2011 12:37:27 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/6] EM28xx - don't sleep on disconnect
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010004040001090104030006"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010004040001090104030006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The DVB framework will try to power-down an adapter that no-one is using any 
more, but this assumes that the adapter is still connected to the machine. 
That's not always true for a USB adapter, so disable the sleep operations when 
the adapter has been physically unplugged.

This prevents I2C write failures with error -19 from appearing occasionally in 
the dmesg log.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------010004040001090104030006
Content-Type: text/x-patch;
 name="EM28xx-disconnect-dont-sleep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-disconnect-dont-sleep.diff"

--- linux-3.0/drivers/media/common/tuners/tda18271-fe.c.orig	2011-08-18 16:55:53.000000000 +0100
+++ linux-3.0/drivers/media/common/tuners/tda18271-fe.c	2011-08-18 23:12:55.000000000 +0100
@@ -1230,7 +1230,7 @@
 	return 0;
 }
 
-static struct dvb_tuner_ops tda18271_tuner_ops = {
+static const struct dvb_tuner_ops tda18271_tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271HD",
 		.frequency_min  =  45000000,
--- linux-3.0/drivers/media/dvb/frontends/cxd2820r_core.c.orig	2011-08-18 16:56:02.000000000 +0100
+++ linux-3.0/drivers/media/dvb/frontends/cxd2820r_core.c	2011-08-18 23:14:06.000000000 +0100
@@ -778,7 +778,7 @@
 }
 EXPORT_SYMBOL(cxd2820r_get_tuner_i2c_adapter);
 
-static struct dvb_frontend_ops cxd2820r_ops[2];
+static const struct dvb_frontend_ops cxd2820r_ops[2];
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 	struct i2c_adapter *i2c, struct dvb_frontend *fe)
@@ -844,7 +844,7 @@
 }
 EXPORT_SYMBOL(cxd2820r_attach);
 
-static struct dvb_frontend_ops cxd2820r_ops[2] = {
+static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 	{
 		/* DVB-T/T2 */
 		.info = {
--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-17 08:52:30.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-18 23:17:42.000000000 +0100
@@ -720,6 +720,12 @@
 	goto ret;
 }
 
+static inline void prevent_sleep(struct dvb_frontend_ops *ops) {
+	ops->set_voltage = NULL;
+	ops->sleep = NULL;
+	ops->tuner_ops.sleep = NULL;
+}
+
 static int dvb_fini(struct em28xx *dev)
 {
 	if (!dev->board.has_dvb) {
@@ -728,8 +734,17 @@
 	}
 
 	if (dev->dvb) {
-		unregister_dvb(dev->dvb);
-		kfree(dev->dvb);
+		struct em28xx_dvb *dvb = dev->dvb;
+
+		if (dev->state & DEV_DISCONNECTED) {
+			/* We cannot tell the device to sleep
+			 * once it has been unplugged. */
+			prevent_sleep(&dvb->fe[0]->ops);
+			prevent_sleep(&dvb->fe[1]->ops);
+		}
+
+		unregister_dvb(dvb);
+		kfree(dvb);
 		dev->dvb = NULL;
 	}
 

--------------010004040001090104030006--
