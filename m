Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.93]:24759
	"HELO nm4-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754435Ab1HRW2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 18:28:48 -0400
Message-ID: <4E4D921A.4080605@yahoo.com>
Date: Thu, 18 Aug 2011 23:28:42 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
In-Reply-To: <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040001030805030306030300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040001030805030306030300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Next patch: By default, the DVB framework tries to put a frontend to sleep after 
it has been shut down. This obviously doesn't work for a USB device that has 
been disconnected, and can result in occasional errors in dmesg about I2C writes 
failing with error code -19.

The patch works by nulling out the function pointers that the DVB framework 
would otherwise try to call. I have therefore declared the structs in the 
tda18271 and cxd2820r modules to be "const", so that we know that they are 
supposed only to be templates.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------040001030805030306030300
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
 

--------------040001030805030306030300--
