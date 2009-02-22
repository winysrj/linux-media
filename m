Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:56835 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbZBVXob (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 18:44:31 -0500
Message-ID: <49A1E35B.2020803@linuxtv.org>
Date: Mon, 23 Feb 2009 00:44:27 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
Subject: Re: struct dvb_frontend not initialized correctly / random id value
 since MFE merge
References: <200902222031.59364.zzam@gentoo.org>
In-Reply-To: <200902222031.59364.zzam@gentoo.org>
Content-Type: multipart/mixed;
 boundary="------------080009060101010605070504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080009060101010605070504
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Matthias,

Matthias Schwarzott wrote:
> MFE patches added a variable "id" to struct dvb_frontend.
> This variable seems to be uninitialized for some drivers.
> 
> The result is for my skystar2 card (using stv0299 frontend) it sometimes is 0 
> as it should but sometimes it is a random value, so I get this register 
> message:
> DVB: registering adapter 1 frontend -10551321 (ST STV0299 DVB-S)
> 
> The related kernel thread then also has a strange name like:
> kdvb-ad-1-fe--1

I just noticed the same bug (with tda1004x). I think fe->id isn't
useful to dvb_frontend.c and should be removed. It is used where
fepriv->dvbdev->id should be used instead. Bridge drivers could
probably store this id elsewhere, if they need it.

> The same happens for my dvb-ttpci card using ves1x93 frontend.
> 
> Now I wonder if all frontend drivers should be switched to use kzalloc instead 
> of kmalloc for struct dvb_frontend

That's a good thing to do in any case.

How about the attached patch?

Regards,
Andreas

--------------080009060101010605070504
Content-Type: text/x-patch;
 name="fe_id.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fe_id.diff"

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 8434077..332dee3 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -216,9 +216,11 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
-	dprintk ("DVB: initialising adapter %i frontend %i (%s)...\n",
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+
+	dprintk ("DVB%u: initialising frontend%i (%s)...\n",
 		 fe->dvb->num,
-		 fe->id,
+		 fepriv->dvbdev->id,
 		 fe->ops.info.name);
 
 	if (fe->ops.init)
@@ -754,7 +756,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
-		"kdvb-ad-%i-fe-%i", fe->dvb->num,fe->id);
+		"kdvb-ad-%i-fe-%i", fe->dvb->num,fepriv->dvbdev->id);
 	if (IS_ERR(fe_thread)) {
 		ret = PTR_ERR(fe_thread);
 		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
@@ -768,6 +770,8 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 static void dvb_frontend_get_frequeny_limits(struct dvb_frontend *fe,
 					u32 *freq_min, u32 *freq_max)
 {
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+
 	*freq_min = max(fe->ops.info.frequency_min, fe->ops.tuner_ops.info.frequency_min);
 
 	if (fe->ops.info.frequency_max == 0)
@@ -778,13 +782,14 @@ static void dvb_frontend_get_frequeny_limits(struct dvb_frontend *fe,
 		*freq_max = min(fe->ops.info.frequency_max, fe->ops.tuner_ops.info.frequency_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
-		printk(KERN_WARNING "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
-		       fe->dvb->num,fe->id);
+		printk(KERN_WARNING "DVB%u: frontend%u frequency limits undefined - fix the driver\n",
+		       fe->dvb->num,fepriv->dvbdev->id);
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 				struct dvb_frontend_parameters *parms)
 {
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	u32 freq_min;
 	u32 freq_max;
 
@@ -792,8 +797,8 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 	dvb_frontend_get_frequeny_limits(fe, &freq_min, &freq_max);
 	if ((freq_min && parms->frequency < freq_min) ||
 	    (freq_max && parms->frequency > freq_max)) {
-		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
-		       fe->dvb->num, fe->id, parms->frequency, freq_min, freq_max);
+		printk(KERN_WARNING "DVB%u: frontend%u frequency %u out of range (%u..%u)\n",
+		       fe->dvb->num, fepriv->dvbdev->id, parms->frequency, freq_min, freq_max);
 		return -EINVAL;
 	}
 
@@ -803,8 +808,8 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 		     parms->u.qpsk.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qpsk.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qpsk.symbol_rate,
+			printk(KERN_WARNING "DVB%u: frontend%u symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, fepriv->dvbdev->id, parms->u.qpsk.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -814,8 +819,8 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 		     parms->u.qam.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qam.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qam.symbol_rate,
+			printk(KERN_WARNING "DVB%u: frontend%u symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, fepriv->dvbdev->id, parms->u.qam.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -1893,11 +1898,11 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 		.fops = &dvb_frontend_fops,
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
+	int ret;
 
 	dprintk ("%s\n", __func__);
 
-	if (mutex_lock_interruptible(&frontend_mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&frontend_mutex);
 
 	fe->frontend_priv = kzalloc(sizeof(struct dvb_frontend_private), GFP_KERNEL);
 	if (fe->frontend_priv == NULL) {
@@ -1913,13 +1918,18 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
-	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
-		fe->dvb->num,
-		fe->id,
-		fe->ops.info.name);
+	ret = dvb_register_device(fe->dvb, &fepriv->dvbdev, &dvbdev_template,
+				  fe, DVB_DEVICE_FRONTEND);
+	if (ret < 0) {
+		printk(KERN_ERR "DVB%u: failed to register frontend %s\n",
+		       fe->dvb->num, fe->ops.info.name);
+		kfree(fe->frontend_priv);
+		mutex_unlock(&frontend_mutex);
+		return ret;
+	}
 
-	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
-			     fe, DVB_DEVICE_FRONTEND);
+	printk(KERN_INFO "DVB%u: registered frontend%i (%s)\n",
+		fe->dvb->num, fepriv->dvbdev->id, fe->ops.info.name);
 
 	mutex_unlock(&frontend_mutex);
 	return 0;

--------------080009060101010605070504--
