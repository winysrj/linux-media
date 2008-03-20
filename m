Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2K1h8EG013692
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 21:43:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2K1gbvc015824
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 21:42:37 -0400
Date: Wed, 19 Mar 2008 22:42:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Message-ID: <20080319224222.581d7b85@gaivota>
In-Reply-To: <47E1BCAF.80208@t-online.de>
References: <47E060EB.5040207@t-online.de>
	<Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>
	<47E190CF.9050904@t-online.de> <20080319193832.643bf8a0@gaivota>
	<47E1BCAF.80208@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [RFC] TDA8290 / TDA827X with LNA: testers wanted
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 20 Mar 2008 02:23:59 +0100
Hartmut Hackmann <hartmut.hackmann@t-online.de> wrote:

> > On your patch, you're just returning, if dev=NULL, at saa7134 callback function. IMO, the correct would be to
> > print an error message and return. Also, we should discover why dev is being
> > null there (I'll try to identify here - the reason - yet, I can't really test,
> > since the saa7134 boards I have don't need any callback.
> 
> That's not the point. In the call in tda827x.c tda827xa_lna_gain(), the argument
> did not point to the saa7134_dev structure as the function expected. I added
> the check for NULL because only at the very first call, the pointer is still
> not valid. I did not check this carefully but i guess this is a matter of the
> initilization sequence of the data structures. IMHO yes, we should understand this
> sometime but this does not have priority because i am sure that the NULL pointer
> occurs only during initialization.

This is caused by a patch conflict between hybrid redesign and the merge of
xc3028 support. The enclosed experimental patch fixes the tuner_callback
argument, on linux/drivers/media/dvb/frontends/tda827x.c. 
It should also fix the priv argument on saa7134_tuner_callback(). I can't test
the saa7134 part here, due to the lack of a saa7134 hardware that needs a
callback.

The patch also intends to make xc3028 easier to use. That part is still not
fully working. I should finish this patch tomorrow.

> >>> I still need to send a patchset to Linus, after testing compilation
> >>> (unfortunately, I had to postpone, since I need first to free some
> >>> hundreds of Mb on my HD on my /home, to allow kernel compilation).
> >>> Hopefully, I'll have some time tomorrow for doing a "housekeeping".
> >>>
> >> Unfortunately, i deleted you mails describing what went to linux and i don't
> >> have the RC source here :-(
> > 
> > You may take a look on master branch on my git tree. I'm about to forward him a
> > series of patches. Hopefully, 2GB free space will be enough for a full kernel
> > compilation. I'll discover soon...
> > 
> Jep. Meanwhile Michael confirmed that the problem is not in mainstream,
> so there is no reason to hurry.

Yes.

> But we should have a bigger audience for my latest changes, so i will send
> you a pull request in a minute.

Could you please test my patch first? Having the same arguments for all
callback functions avoid future mistakes.

---
[RFC] Fix tuner_callback for tda827x

Signed-off-by Mauro Carvalho Chehab <mchehab@infradead.org>

---

diff -r f24051885fe9 linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c	Wed Mar 19 22:23:54 2008 -0300
@@ -509,7 +509,6 @@ static int cxusb_dvico_xc3028_tuner_atta
 	struct xc2028_config	  cfg = {
 		.i2c_adap  = &adap->dev->i2c_adap,
 		.i2c_addr  = 0x61,
-		.video_dev = adap->dev,
 		.callback  = dvico_bluebird_xc2028_callback,
 	};
 	static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/dvb/frontends/tda827x.c
--- a/linux/drivers/media/dvb/frontends/tda827x.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda827x.c	Wed Mar 19 22:23:54 2008 -0300
@@ -579,7 +579,8 @@ static void tda827xa_lna_gain(struct dvb
 		else
 			arg = 0;
 		if (priv->cfg->tuner_callback)
-			priv->cfg->tuner_callback(priv, 1, arg);
+			priv->cfg->tuner_callback(priv->i2c_adap->algo_data,
+						  1, arg);
 		buf[1] = high ? 0 : 1;
 		if (*priv->cfg->config == 2)
 			buf[1] = high ? 1 : 0;
@@ -587,7 +588,8 @@ static void tda827xa_lna_gain(struct dvb
 		break;
 	case 3: /* switch with GPIO of saa713x */
 		if (priv->cfg->tuner_callback)
-			priv->cfg->tuner_callback(priv, 0, high);
+			priv->cfg->tuner_callback(priv->i2c_adap->algo_data,
+						  0, high);
 		break;
 	}
 }
diff -r f24051885fe9 linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Wed Mar 19 22:23:54 2008 -0300
@@ -298,7 +298,6 @@ static int dvb_register(struct cx23885_t
 			struct xc2028_config cfg = {
 				.i2c_adap  = &i2c_bus->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = port,
 				.callback  = cx23885_hvr1500_xc3028_callback,
 			};
 			static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Wed Mar 19 22:23:54 2008 -0300
@@ -2140,11 +2140,9 @@ static void gdi_eeprom(struct cx88_core 
 
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
-static int cx88_dvico_xc2028_callback(void *priv, int command, int arg)
+static int cx88_dvico_xc2028_callback(struct cx88_core *core,
+				      int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		cx_write(MO_GP0_IO, 0x101000);
@@ -2162,11 +2160,9 @@ static int cx88_dvico_xc2028_callback(vo
 /* ----------------------------------------------------------------------- */
 /* some Geniatech specific stuff                                           */
 
-static int cx88_xc3028_geniatech_tuner_callback(void *priv, int command, int mode)
+static int cx88_xc3028_geniatech_tuner_callback(struct cx88_core *core,
+						int command, int mode)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		switch (INPUT(core->input).type) {
@@ -2193,11 +2189,9 @@ static int cx88_xc3028_geniatech_tuner_c
 
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
-static int cx88_pv_8000gt_callback(void *priv, int command, int arg)
+static int cx88_pv_8000gt_callback(struct cx88_core *core,
+				   int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		cx_write(MO_GP2_IO, 0xcf7);
@@ -2248,21 +2242,19 @@ static void dvico_fusionhdtv_hybrid_init
 	}
 }
 
-static int cx88_xc2028_tuner_callback(void *priv, int command, int arg)
+static int cx88_xc2028_tuner_callback(struct cx88_core *core, int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	/* Board-specific callbacks */
 	switch (core->boardnr) {
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
 	case CX88_BOARD_GENIATECH_X8000_MT:
-		return cx88_xc3028_geniatech_tuner_callback(priv, command, arg);
+		return cx88_xc3028_geniatech_tuner_callback(core,
+							command, arg);
 	case CX88_BOARD_PROLINK_PV_8000GT:
-		return cx88_pv_8000gt_callback(priv, command, arg);
+		return cx88_pv_8000gt_callback(core, command, arg);
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
-		return cx88_dvico_xc2028_callback(priv, command, arg);
+		return cx88_dvico_xc2028_callback(core, command, arg);
 	}
 
 	switch (command) {
@@ -2296,11 +2288,9 @@ static int cx88_xc2028_tuner_callback(vo
  * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both	   *
  * analog tuner attach (tuner-core.c) and dvb tuner attach (cx88-dvb.c)    */
 
-static int cx88_xc5000_tuner_callback(void *priv, int command, int arg)
+static int cx88_xc5000_tuner_callback(struct cx88_core *core,
+				      int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
-
 	switch (core->boardnr) {
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		if (command == 0) { /* This is the reset command from xc5000 */
@@ -2334,15 +2324,27 @@ int cx88_tuner_callback(void *priv, int 
 int cx88_tuner_callback(void *priv, int command, int arg)
 {
 	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct cx88_core *core = i2c_algo->data;
+	struct cx88_core *core;
+
+	if (!i2c_algo) {
+		printk(KERN_ERR "cx88: Error - i2c_algo not defined.\n");
+		return -EINVAL;
+	}
+
+	core = i2c_algo->data;
+
+	if (!core) {
+		printk(KERN_ERR "cx88: Error - i2c_algo->data not defined. priv=%p\n", priv);
+		return -EINVAL;
+	}
 
 	switch (core->board.tuner_type) {
 		case TUNER_XC2028:
 			info_printk(core, "Calling XC2028/3028 callback\n");
-			return cx88_xc2028_tuner_callback(priv, command, arg);
+			return cx88_xc2028_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
 			info_printk(core, "Calling XC5000 callback\n");
-			return cx88_xc5000_tuner_callback(priv, command, arg);
+			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	err_printk(core, "Error: Calling callback for tuner %d\n",
 		   core->board.tuner_type);
diff -r f24051885fe9 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Wed Mar 19 22:23:54 2008 -0300
@@ -465,7 +465,6 @@ static int attach_xc3028(u8 addr, struct
 	struct xc2028_config cfg = {
 		.i2c_adap  = &dev->core->i2c_adap,
 		.i2c_addr  = addr,
-		.video_dev = dev->core->i2c_adap.algo_data,
 	};
 
 	if (!dev->dvb.frontend) {
@@ -787,7 +786,6 @@ static int dvb_register(struct cx8802_de
 			struct xc2028_config cfg = {
 				.i2c_adap  = &dev->core->i2c_adap,
 				.i2c_addr  = 0x61,
-				.video_dev = dev->core,
 				.callback  = cx88_pci_nano_callback,
 			};
 			static struct xc2028_ctrl ctl = {
diff -r f24051885fe9 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Mar 19 22:23:54 2008 -0300
@@ -5353,10 +5353,10 @@ static int saa7134_tda8290_callback(stru
 	return 0;
 }
 
+/* priv retuns algo_data - on saa7134, it is equal to dev */
 int saa7134_tuner_callback(void *priv, int command, int arg)
 {
-	struct i2c_algo_bit_data *i2c_algo = priv;
-	struct saa7134_dev *dev = i2c_algo->data;
+	struct saa7134_dev *dev = priv;
 
 	switch (dev->tuner_type) {
 	case TUNER_PHILIPS_TDA8290:
diff -r f24051885fe9 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Mar 19 22:23:54 2008 -0300
@@ -1173,7 +1173,6 @@ static int dvb_init(struct saa7134_dev *
 		struct xc2028_config cfg = {
 			.i2c_adap  = &dev->i2c_adap,
 			.i2c_addr  = 0x61,
-			.video_dev = dev->i2c_adap.algo_data,
 		};
 		fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
 		if (!fe) {
diff -r f24051885fe9 linux/drivers/media/video/tuner-core.c
--- a/linux/drivers/media/video/tuner-core.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/tuner-core.c	Wed Mar 19 22:23:54 2008 -0300
@@ -448,7 +448,6 @@ static void set_type(struct i2c_client *
 		struct xc2028_config cfg = {
 			.i2c_adap  = t->i2c->adapter,
 			.i2c_addr  = t->i2c->addr,
-			.video_dev = c->adapter->algo_data,
 			.callback  = t->tuner_callback,
 		};
 		if (!xc2028_attach(&t->fe, &cfg)) {
diff -r f24051885fe9 linux/drivers/media/video/tuner-xc2028.c
--- a/linux/drivers/media/video/tuner-xc2028.c	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/video/tuner-xc2028.c	Wed Mar 19 22:23:54 2008 -0300
@@ -1174,7 +1174,7 @@ struct dvb_frontend *xc2028_attach(struc
 	if (debug)
 		printk(KERN_DEBUG "xc2028: Xcv2028/3028 init called!\n");
 
-	if (NULL == cfg || NULL == cfg->video_dev)
+	if (NULL == cfg)
 		return NULL;
 
 	if (!fe) {
@@ -1182,7 +1182,7 @@ struct dvb_frontend *xc2028_attach(struc
 		return NULL;
 	}
 
-	video_dev = cfg->video_dev;
+	video_dev = cfg->i2c_adap->algo_data;
 
 	mutex_lock(&xc2028_list_mutex);
 





Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
