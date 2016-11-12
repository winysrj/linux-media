Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54744
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750775AbcKLIOv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 03:14:51 -0500
Date: Sat, 12 Nov 2016 06:14:43 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161112061443.4c7cfd3b@vela.lan>
In-Reply-To: <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
        <20161108155520.224229d5@vento.lan>
        <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
        <20161109073331.204b53c4@vento.lan>
        <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
        <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
        <20161109153521.232b0956@vento.lan>
        <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
        <20161110060717.221e8d88@vento.lan>
        <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
        <20161111104903.607428e5@vela.lan>
        <CAA7C2qhAaA0KVj4MNBE4KejhGcfbWuN_7Pj0u=uKdbYc8yvYjQ@mail.gmail.com>
        <20161111195353.3b4ee8e0@vela.lan>
        <20161111201011.2ce05c47@vela.lan>
        <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Nov 2016 20:45:31 -0800
VDR User <user.vdr@gmail.com> escreveu:

> > Sorry, forgot to add one file to the patch.
> >
> > The right fix is this one.  
> 
> This patch seems to fix the unload crash but unfortunately now all I
> get is "frontend 0/0 timed out while tuning".

I don't see any reason why it should cause any regressions.

> Forgot to mention that I didn't see the gp8psk-fe entry in menuconfig
> customize frontends even though the gp8psk module was enabled and set
> to <m>. When I exited and saved .config, DVB_GP8PSK_FE was set though.
> Maybe something at `config DVB_USB_GP8PSK` in
> drivers/media/usb/dvb-usb/Kconfig needs adjusting too?

I used the same approach taken on as102: the frontend driver is auto-selected
when the gsp8psk driver is selected, and its entry is invisible on normal
make config/gconfig/xconfig, as the drivers can only be used together.

You can still see it at the graphical options if you enable it to show
the hidden symbols.

> And I noticed something different in dmesg when loading the module.
> The prior to the patch it logged:
> 
> [   92.041222] dvb-usb: found a 'Genpix SkyWalker-2 DVB-S receiver' in
> warm state.
> [   93.104244] gp8psk: FW Version = 2.14.6 (0x20e06)  Build 2010/10/10
> [   93.104991] gp8psk: FPGA Version = 1
> [   93.105367] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [   93.105549] DVB: registering new adapter (Genpix SkyWalker-2 DVB-S receiver)
> [   93.106614] usb 1-2: DVB: registering adapter 0 frontend 0 (Genpix DVB-S)...
> [   93.107620] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
> initialized and connected.
> [   93.107627] gp8psk: found Genpix USB device pID = 206 (hex)
> [   93.107674] usbcore: registered new interface driver dvb_usb_gp8psk
> 
> After the patch:
> 
> [  542.926237] dvb-usb: found a 'Genpix SkyWalker-2 DVB-S receiver' in
> warm state.
> [  543.989074] gp8psk: FW Version = 208.00.0 (0xd00000)  Build 2193/15/159
> [  543.989945] gp8psk: FPGA Version = 2
> [  543.990071] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [  543.990257] dvbdev: DVB: registering new adapter (Genpix
> SkyWalker-2 DVB-S receiver)
> [  543.994589] usb 1-2: DVB: registering adapter 0 frontend 0 (Genpix DVB-S)...
> [  543.995575] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
> initialized and connected.
> [  543.995581] gp8psk: found Genpix USB device pID = 206 (hex)
> [  543.995628] usbcore: registered new interface driver dvb_usb_gp8psk
> 
> The FW Version and FPGA Version is messed up. Is it possible that
> could cause the tuner timeout?

The version itself is just an information retrieved from the device.
It is not the cause of the trouble. It could be another  symptom, though.
Perhaps some failure happened during device probe, causing the device
to be unstable.

Time to enable the debug messages from the driver and see what changed.

I generated a new version of the patch that should allow enabling all
debug messages from the frontend at once. It also fixes checkpatch
issues.

Please create new file: /etc/modprobe.d/gp8psk.conf with the following 
contents:

	options dvb-usb-gp8psk debug=15
	options gp8psk-fe debug=1

This should allow getting debug messages with and without the patch.
I added a new debug message inside the patch, to indicate if the frontend
driver asks for firmware reload, and another one to indicate that the
firmware driver was properly loaded. Except for that, the other messages
weren't touched.

Could you please apply the patch and pastebin the messages? Please
also pastebin the messages without the patch.

Thanks!
Mauro

[PATCH] [media] gp8psk: Fix DVB frontend attach

The DVB binding schema at the DVB core assumes that the
frontend is a separate driver. Faling to do that causes
OOPS when the module is removed, as it tries to do a
symbol_put_addr on an internal symbol, causing craches like:

 WARNING: CPU: 1 PID: 28102 at kernel/module.c:1108 module_put+0x57/0x70
 Modules linked in: dvb_usb_gp8psk(-) dvb_usb dvb_core nvidia_drm(PO) nvidia_modeset(PO) snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore nvidia(PO) [last unloaded: rc_core]
 CPU: 1 PID: 28102 Comm: rmmod Tainted: P        WC O 4.8.4-build.1 #1
 Hardware name: MSI MS-7309/MS-7309, BIOS V1.12 02/23/2009
 00000000 c12ba080 00000000 00000000 c103ed6a c1616014 00000001 00006dc6
 c1615862 00000454 c109e8a7 c109e8a7 00000009 ffffffff 00000000 f13f6a10
 f5f5a600 c103ee33 00000009 00000000 00000000 c109e8a7 f80ca4d0 c109f617
 Call Trace:
  [<c12ba080>] ? dump_stack+0x44/0x64
  [<c103ed6a>] ? __warn+0xfa/0x120
  [<c109e8a7>] ? module_put+0x57/0x70
  [<c109e8a7>] ? module_put+0x57/0x70
  [<c103ee33>] ? warn_slowpath_null+0x23/0x30
  [<c109e8a7>] ? module_put+0x57/0x70
  [<f80ca4d0>] ? gp8psk_fe_set_frontend+0x460/0x460 [dvb_usb_gp8psk]
  [<c109f617>] ? symbol_put_addr+0x27/0x50
  [<f80bc9ca>] ? dvb_usb_adapter_frontend_exit+0x3a/0x70 [dvb_usb]

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 012225587c25..b71b747ee0ba 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -513,6 +513,11 @@ config DVB_AS102_FE
 	depends on DVB_CORE
 	default DVB_AS102
 
+config DVB_GP8PSK_FE
+	tristate
+	depends on DVB_CORE
+	default DVB_USB_GP8PSK
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index e90165ad361b..93921a4eaa27 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
 obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
+obj-$(CONFIG_DVB_GP8PSK_FE) += gp8psk-fe.o
 obj-$(CONFIG_DVB_TC90522) += tc90522.o
 obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
 obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb-frontends/gp8psk-fe.c
similarity index 72%
rename from drivers/media/usb/dvb-usb/gp8psk-fe.c
rename to drivers/media/dvb-frontends/gp8psk-fe.c
index db6eb79cde07..be19afeed7a9 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb-frontends/gp8psk-fe.c
@@ -14,11 +14,27 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
-#include "gp8psk.h"
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "gp8psk-fe.h"
+#include "dvb_frontend.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
 
 struct gp8psk_fe_state {
 	struct dvb_frontend fe;
-	struct dvb_usb_device *d;
+	void *priv;
+	const struct gp8psk_fe_ops *ops;
+	bool is_rev1;
 	u8 lock;
 	u16 snr;
 	unsigned long next_status_check;
@@ -29,22 +45,24 @@ static int gp8psk_tuned_to_DCII(struct dvb_frontend *fe)
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	u8 status;
-	gp8psk_usb_in_op(st->d, GET_8PSK_CONFIG, 0, 0, &status, 1);
+
+	st->ops->in(st->priv, GET_8PSK_CONFIG, 0, 0, &status, 1);
 	return status & bmDCtuned;
 }
 
 static int gp8psk_set_tuner_mode(struct dvb_frontend *fe, int mode)
 {
-	struct gp8psk_fe_state *state = fe->demodulator_priv;
-	return gp8psk_usb_out_op(state->d, SET_8PSK_CONFIG, mode, 0, NULL, 0);
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+	return st->ops->out(st->priv, SET_8PSK_CONFIG, mode, 0, NULL, 0);
 }
 
 static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
 {
 	u8 buf[6];
 	if (time_after(jiffies,st->next_status_check)) {
-		gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0,0,&st->lock,1);
-		gp8psk_usb_in_op(st->d, GET_SIGNAL_STRENGTH, 0,0,buf,6);
+		st->ops->in(st->priv, GET_SIGNAL_LOCK, 0, 0, &st->lock, 1);
+		st->ops->in(st->priv, GET_SIGNAL_STRENGTH, 0, 0, buf, 6);
 		st->snr = (buf[1]) << 8 | buf[0];
 		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
 	}
@@ -116,13 +134,12 @@ static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 
 static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 {
-	struct gp8psk_fe_state *state = fe->demodulator_priv;
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 cmd[10];
 	u32 freq = c->frequency * 1000;
-	int gp_product_id = le16_to_cpu(state->d->udev->descriptor.idProduct);
 
-	deb_fe("%s()\n", __func__);
+	dprintk("%s()\n", __func__);
 
 	cmd[4] = freq         & 0xff;
 	cmd[5] = (freq >> 8)  & 0xff;
@@ -136,21 +153,21 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 	switch (c->delivery_system) {
 	case SYS_DVBS:
 		if (c->modulation != QPSK) {
-			deb_fe("%s: unsupported modulation selected (%d)\n",
+			dprintk("%s: unsupported modulation selected (%d)\n",
 				__func__, c->modulation);
 			return -EOPNOTSUPP;
 		}
 		c->fec_inner = FEC_AUTO;
 		break;
 	case SYS_DVBS2: /* kept for backwards compatibility */
-		deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
+		dprintk("%s: DVB-S2 delivery system selected\n", __func__);
 		break;
 	case SYS_TURBO:
-		deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
+		dprintk("%s: Turbo-FEC delivery system selected\n", __func__);
 		break;
 
 	default:
-		deb_fe("%s: unsupported delivery system selected (%d)\n",
+		dprintk("%s: unsupported delivery system selected (%d)\n",
 			__func__, c->delivery_system);
 		return -EOPNOTSUPP;
 	}
@@ -161,9 +178,9 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 	cmd[3] = (c->symbol_rate >> 24) & 0xff;
 	switch (c->modulation) {
 	case QPSK:
-		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+		if (st->is_rev1)
 			if (gp8psk_tuned_to_DCII(fe))
-				gp8psk_bcm4500_reload(state->d);
+				st->ops->reload(st->priv);
 		switch (c->fec_inner) {
 		case FEC_1_2:
 			cmd[9] = 0; break;
@@ -207,18 +224,18 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 		cmd[9] = 0;
 		break;
 	default: /* Unknown modulation */
-		deb_fe("%s: unsupported modulation selected (%d)\n",
+		dprintk("%s: unsupported modulation selected (%d)\n",
 			__func__, c->modulation);
 		return -EOPNOTSUPP;
 	}
 
-	if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+	if (st->is_rev1)
 		gp8psk_set_tuner_mode(fe, 0);
-	gp8psk_usb_out_op(state->d, TUNE_8PSK, 0, 0, cmd, 10);
+	st->ops->out(st->priv, TUNE_8PSK, 0, 0, cmd, 10);
 
-	state->lock = 0;
-	state->next_status_check = jiffies;
-	state->status_check_interval = 200;
+	st->lock = 0;
+	st->next_status_check = jiffies;
+	st->status_check_interval = 200;
 
 	return 0;
 }
@@ -228,9 +245,9 @@ static int gp8psk_fe_send_diseqc_msg (struct dvb_frontend* fe,
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 
-	deb_fe("%s\n",__func__);
+	dprintk("%s\n", __func__);
 
-	if (gp8psk_usb_out_op(st->d,SEND_DISEQC_COMMAND, m->msg[0], 0,
+	if (st->ops->out(st->priv, SEND_DISEQC_COMMAND, m->msg[0], 0,
 			m->msg, m->msg_len)) {
 		return -EINVAL;
 	}
@@ -243,12 +260,12 @@ static int gp8psk_fe_send_diseqc_burst(struct dvb_frontend *fe,
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	u8 cmd;
 
-	deb_fe("%s\n",__func__);
+	dprintk("%s\n", __func__);
 
 	/* These commands are certainly wrong */
 	cmd = (burst == SEC_MINI_A) ? 0x00 : 0x01;
 
-	if (gp8psk_usb_out_op(st->d,SEND_DISEQC_COMMAND, cmd, 0,
+	if (st->ops->out(st->priv, SEND_DISEQC_COMMAND, cmd, 0,
 			&cmd, 0)) {
 		return -EINVAL;
 	}
@@ -258,10 +275,10 @@ static int gp8psk_fe_send_diseqc_burst(struct dvb_frontend *fe,
 static int gp8psk_fe_set_tone(struct dvb_frontend *fe,
 			      enum fe_sec_tone_mode tone)
 {
-	struct gp8psk_fe_state* state = fe->demodulator_priv;
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
 
-	if (gp8psk_usb_out_op(state->d,SET_22KHZ_TONE,
-		 (tone == SEC_TONE_ON), 0, NULL, 0)) {
+	if (st->ops->out(st->priv, SET_22KHZ_TONE,
+			 (tone == SEC_TONE_ON), 0, NULL, 0)) {
 		return -EINVAL;
 	}
 	return 0;
@@ -270,9 +287,9 @@ static int gp8psk_fe_set_tone(struct dvb_frontend *fe,
 static int gp8psk_fe_set_voltage(struct dvb_frontend *fe,
 				 enum fe_sec_voltage voltage)
 {
-	struct gp8psk_fe_state* state = fe->demodulator_priv;
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
 
-	if (gp8psk_usb_out_op(state->d,SET_LNB_VOLTAGE,
+	if (st->ops->out(st->priv, SET_LNB_VOLTAGE,
 			 voltage == SEC_VOLTAGE_18, 0, NULL, 0)) {
 		return -EINVAL;
 	}
@@ -281,52 +298,60 @@ static int gp8psk_fe_set_voltage(struct dvb_frontend *fe,
 
 static int gp8psk_fe_enable_high_lnb_voltage(struct dvb_frontend* fe, long onoff)
 {
-	struct gp8psk_fe_state* state = fe->demodulator_priv;
-	return gp8psk_usb_out_op(state->d, USE_EXTRA_VOLT, onoff, 0,NULL,0);
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+	return st->ops->out(st->priv, USE_EXTRA_VOLT, onoff, 0, NULL, 0);
 }
 
 static int gp8psk_fe_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long sw_cmd)
 {
-	struct gp8psk_fe_state* state = fe->demodulator_priv;
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	u8 cmd = sw_cmd & 0x7f;
 
-	if (gp8psk_usb_out_op(state->d,SET_DN_SWITCH, cmd, 0,
-			NULL, 0)) {
+	if (st->ops->out(st->priv, SET_DN_SWITCH, cmd, 0, NULL, 0))
 		return -EINVAL;
-	}
-	if (gp8psk_usb_out_op(state->d,SET_LNB_VOLTAGE, !!(sw_cmd & 0x80),
-			0, NULL, 0)) {
+
+	if (st->ops->out(st->priv, SET_LNB_VOLTAGE, !!(sw_cmd & 0x80),
+			0, NULL, 0))
 		return -EINVAL;
-	}
 
 	return 0;
 }
 
 static void gp8psk_fe_release(struct dvb_frontend* fe)
 {
-	struct gp8psk_fe_state *state = fe->demodulator_priv;
-	kfree(state);
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+	kfree(st);
 }
 
 static struct dvb_frontend_ops gp8psk_fe_ops;
 
-struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d)
+struct dvb_frontend *gp8psk_fe_attach(const struct gp8psk_fe_ops *ops,
+				      void *priv, bool is_rev1)
 {
-	struct gp8psk_fe_state *s = kzalloc(sizeof(struct gp8psk_fe_state), GFP_KERNEL);
-	if (s == NULL)
-		goto error;
-
-	s->d = d;
-	memcpy(&s->fe.ops, &gp8psk_fe_ops, sizeof(struct dvb_frontend_ops));
-	s->fe.demodulator_priv = s;
-
-	goto success;
-error:
-	return NULL;
-success:
-	return &s->fe;
-}
+	struct gp8psk_fe_state *st;
 
+	if (!ops || !ops->in || !ops->out || !ops->reload) {
+		pr_err("Error! gp8psk-fe ops not defined.\n");
+		return NULL;
+	}
+
+	st = kzalloc(sizeof(struct gp8psk_fe_state), GFP_KERNEL);
+	if (!st)
+		return NULL;
+
+	memcpy(&st->fe.ops, &gp8psk_fe_ops, sizeof(struct dvb_frontend_ops));
+	st->fe.demodulator_priv = st;
+	st->ops = ops;
+	st->priv = priv;
+	st->is_rev1 = is_rev1;
+
+	pr_info("Frontend %sattached\n", is_rev1 ? "revision 1 " : "");
+
+	return &st->fe;
+}
+EXPORT_SYMBOL_GPL(gp8psk_fe_attach);
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.delsys = { SYS_DVBS },
diff --git a/drivers/media/dvb-frontends/gp8psk-fe.h b/drivers/media/dvb-frontends/gp8psk-fe.h
new file mode 100644
index 000000000000..6c7944b1ecd6
--- /dev/null
+++ b/drivers/media/dvb-frontends/gp8psk-fe.h
@@ -0,0 +1,82 @@
+/*
+ * gp8psk_fe driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef GP8PSK_FE_H
+#define GP8PSK_FE_H
+
+#include <linux/types.h>
+
+/* gp8psk commands */
+
+#define GET_8PSK_CONFIG                 0x80    /* in */
+#define SET_8PSK_CONFIG                 0x81
+#define I2C_WRITE			0x83
+#define I2C_READ			0x84
+#define ARM_TRANSFER                    0x85
+#define TUNE_8PSK                       0x86
+#define GET_SIGNAL_STRENGTH             0x87    /* in */
+#define LOAD_BCM4500                    0x88
+#define BOOT_8PSK                       0x89    /* in */
+#define START_INTERSIL                  0x8A    /* in */
+#define SET_LNB_VOLTAGE                 0x8B
+#define SET_22KHZ_TONE                  0x8C
+#define SEND_DISEQC_COMMAND             0x8D
+#define SET_DVB_MODE                    0x8E
+#define SET_DN_SWITCH                   0x8F
+#define GET_SIGNAL_LOCK                 0x90    /* in */
+#define GET_FW_VERS			0x92
+#define GET_SERIAL_NUMBER               0x93    /* in */
+#define USE_EXTRA_VOLT                  0x94
+#define GET_FPGA_VERS			0x95
+#define CW3K_INIT			0x9d
+
+/* PSK_configuration bits */
+#define bm8pskStarted                   0x01
+#define bm8pskFW_Loaded                 0x02
+#define bmIntersilOn                    0x04
+#define bmDVBmode                       0x08
+#define bm22kHz                         0x10
+#define bmSEL18V                        0x20
+#define bmDCtuned                       0x40
+#define bmArmed                         0x80
+
+/* Satellite modulation modes */
+#define ADV_MOD_DVB_QPSK 0     /* DVB-S QPSK */
+#define ADV_MOD_TURBO_QPSK 1   /* Turbo QPSK */
+#define ADV_MOD_TURBO_8PSK 2   /* Turbo 8PSK (also used for Trellis 8PSK) */
+#define ADV_MOD_TURBO_16QAM 3  /* Turbo 16QAM (also used for Trellis 8PSK) */
+
+#define ADV_MOD_DCII_C_QPSK 4  /* Digicipher II Combo */
+#define ADV_MOD_DCII_I_QPSK 5  /* Digicipher II I-stream */
+#define ADV_MOD_DCII_Q_QPSK 6  /* Digicipher II Q-stream */
+#define ADV_MOD_DCII_C_OQPSK 7 /* Digicipher II offset QPSK */
+#define ADV_MOD_DSS_QPSK 8     /* DSS (DIRECTV) QPSK */
+#define ADV_MOD_DVB_BPSK 9     /* DVB-S BPSK */
+
+/* firmware revision id's */
+#define GP8PSK_FW_REV1			0x020604
+#define GP8PSK_FW_REV2			0x020704
+#define GP8PSK_FW_VERS(_fw_vers) \
+	((_fw_vers)[2]<<0x10 | (_fw_vers)[1]<<0x08 | (_fw_vers)[0])
+
+struct gp8psk_fe_ops {
+	int (*in)(void *priv, u8 req, u16 value, u16 index, u8 *b, int blen);
+	int (*out)(void *priv, u8 req, u16 value, u16 index, u8 *b, int blen);
+	int (*reload)(void *priv);
+};
+
+struct dvb_frontend *gp8psk_fe_attach(const struct gp8psk_fe_ops *ops,
+				      void *priv, bool is_rev1);
+
+#endif
diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index 2a7b5a963acf..3b3f32b426d1 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_DVB_USB_VP7045) += dvb-usb-vp7045.o
 dvb-usb-vp702x-objs := vp702x.o vp702x-fe.o
 obj-$(CONFIG_DVB_USB_VP702X) += dvb-usb-vp702x.o
 
-dvb-usb-gp8psk-objs := gp8psk.o gp8psk-fe.o
+dvb-usb-gp8psk-objs := gp8psk.o
 obj-$(CONFIG_DVB_USB_GP8PSK) += dvb-usb-gp8psk.o
 
 dvb-usb-dtt200u-objs := dtt200u.o dtt200u-fe.o
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 2829e3082d15..993bb7a72985 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -15,6 +15,7 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include "gp8psk.h"
+#include "gp8psk-fe.h"
 
 /* debug */
 static char bcm4500_firmware[] = "dvb-usb-gp8psk-02.fw";
@@ -28,34 +29,8 @@ struct gp8psk_state {
 	unsigned char data[80];
 };
 
-static int gp8psk_get_fw_version(struct dvb_usb_device *d, u8 *fw_vers)
-{
-	return (gp8psk_usb_in_op(d, GET_FW_VERS, 0, 0, fw_vers, 6));
-}
-
-static int gp8psk_get_fpga_version(struct dvb_usb_device *d, u8 *fpga_vers)
-{
-	return (gp8psk_usb_in_op(d, GET_FPGA_VERS, 0, 0, fpga_vers, 1));
-}
-
-static void gp8psk_info(struct dvb_usb_device *d)
-{
-	u8 fpga_vers, fw_vers[6];
-
-	if (!gp8psk_get_fw_version(d, fw_vers))
-		info("FW Version = %i.%02i.%i (0x%x)  Build %4i/%02i/%02i",
-		fw_vers[2], fw_vers[1], fw_vers[0], GP8PSK_FW_VERS(fw_vers),
-		2000 + fw_vers[5], fw_vers[4], fw_vers[3]);
-	else
-		info("failed to get FW version");
-
-	if (!gp8psk_get_fpga_version(d, &fpga_vers))
-		info("FPGA Version = %i", fpga_vers);
-	else
-		info("failed to get FPGA version");
-}
-
-int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
+static int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
 {
 	struct gp8psk_state *st = d->priv;
 	int ret = 0,try = 0;
@@ -93,7 +68,7 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	return ret;
 }
 
-int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
+static int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen)
 {
 	struct gp8psk_state *st = d->priv;
@@ -124,6 +99,34 @@ int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 	return ret;
 }
 
+
+static int gp8psk_get_fw_version(struct dvb_usb_device *d, u8 *fw_vers)
+{
+	return gp8psk_usb_in_op(d, GET_FW_VERS, 0, 0, fw_vers, 6);
+}
+
+static int gp8psk_get_fpga_version(struct dvb_usb_device *d, u8 *fpga_vers)
+{
+	return gp8psk_usb_in_op(d, GET_FPGA_VERS, 0, 0, fpga_vers, 1);
+}
+
+static void gp8psk_info(struct dvb_usb_device *d)
+{
+	u8 fpga_vers, fw_vers[6];
+
+	if (!gp8psk_get_fw_version(d, fw_vers))
+		info("FW Version = %i.%02i.%i (0x%x)  Build %4i/%02i/%02i",
+		fw_vers[2], fw_vers[1], fw_vers[0], GP8PSK_FW_VERS(fw_vers),
+		2000 + fw_vers[5], fw_vers[4], fw_vers[3]);
+	else
+		info("failed to get FW version");
+
+	if (!gp8psk_get_fpga_version(d, &fpga_vers))
+		info("FPGA Version = %i", fpga_vers);
+	else
+		info("failed to get FPGA version");
+}
+
 static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 {
 	int ret;
@@ -226,10 +229,13 @@ static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 	return 0;
 }
 
-int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
+static int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
 {
 	u8 buf;
 	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
+
+	deb_xfer("reloading firmware\n");
+
 	/* Turn off 8psk power */
 	if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
 		return -EINVAL;
@@ -248,9 +254,47 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return gp8psk_usb_out_op(adap->dev, ARM_TRANSFER, onoff, 0 , NULL, 0);
 }
 
+/* Callbacks for gp8psk-fe.c */
+
+static int gp8psk_fe_in(void *priv, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
+{
+	struct dvb_usb_device *d = priv;
+
+	return gp8psk_usb_in_op(d, req, value, index, b, blen);
+}
+
+static int gp8psk_fe_out(void *priv, u8 req, u16 value,
+			    u16 index, u8 *b, int blen)
+{
+	struct dvb_usb_device *d = priv;
+
+	return gp8psk_usb_out_op(d, req, value, index, b, blen);
+}
+
+static int gp8psk_fe_reload(void *priv)
+{
+	struct dvb_usb_device *d = priv;
+
+	return gp8psk_bcm4500_reload(d);
+}
+
+const struct gp8psk_fe_ops gp8psk_fe_ops = {
+	.in = gp8psk_fe_in,
+	.out = gp8psk_fe_out,
+	.reload = gp8psk_fe_reload,
+};
+
 static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = gp8psk_fe_attach(adap->dev);
+	struct dvb_usb_device *d = adap->dev;
+	int id = le16_to_cpu(d->udev->descriptor.idProduct);
+	int is_rev1;
+
+	is_rev1 = (id == USB_PID_GENPIX_8PSK_REV_1_WARM) ? true : false;
+
+	adap->fe_adap[0].fe = dvb_attach(gp8psk_fe_attach,
+					 &gp8psk_fe_ops, d, is_rev1);
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
index ed32b9da4843..d8975b866dee 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.h
+++ b/drivers/media/usb/dvb-usb/gp8psk.h
@@ -24,58 +24,6 @@ extern int dvb_usb_gp8psk_debug;
 #define deb_info(args...) dprintk(dvb_usb_gp8psk_debug,0x01,args)
 #define deb_xfer(args...) dprintk(dvb_usb_gp8psk_debug,0x02,args)
 #define deb_rc(args...)   dprintk(dvb_usb_gp8psk_debug,0x04,args)
-#define deb_fe(args...)   dprintk(dvb_usb_gp8psk_debug,0x08,args)
-
-/* Twinhan Vendor requests */
-#define TH_COMMAND_IN                     0xC0
-#define TH_COMMAND_OUT                    0xC1
-
-/* gp8psk commands */
-
-#define GET_8PSK_CONFIG                 0x80    /* in */
-#define SET_8PSK_CONFIG                 0x81
-#define I2C_WRITE			0x83
-#define I2C_READ			0x84
-#define ARM_TRANSFER                    0x85
-#define TUNE_8PSK                       0x86
-#define GET_SIGNAL_STRENGTH             0x87    /* in */
-#define LOAD_BCM4500                    0x88
-#define BOOT_8PSK                       0x89    /* in */
-#define START_INTERSIL                  0x8A    /* in */
-#define SET_LNB_VOLTAGE                 0x8B
-#define SET_22KHZ_TONE                  0x8C
-#define SEND_DISEQC_COMMAND             0x8D
-#define SET_DVB_MODE                    0x8E
-#define SET_DN_SWITCH                   0x8F
-#define GET_SIGNAL_LOCK                 0x90    /* in */
-#define GET_FW_VERS			0x92
-#define GET_SERIAL_NUMBER               0x93    /* in */
-#define USE_EXTRA_VOLT                  0x94
-#define GET_FPGA_VERS			0x95
-#define CW3K_INIT			0x9d
-
-/* PSK_configuration bits */
-#define bm8pskStarted                   0x01
-#define bm8pskFW_Loaded                 0x02
-#define bmIntersilOn                    0x04
-#define bmDVBmode                       0x08
-#define bm22kHz                         0x10
-#define bmSEL18V                        0x20
-#define bmDCtuned                       0x40
-#define bmArmed                         0x80
-
-/* Satellite modulation modes */
-#define ADV_MOD_DVB_QPSK 0     /* DVB-S QPSK */
-#define ADV_MOD_TURBO_QPSK 1   /* Turbo QPSK */
-#define ADV_MOD_TURBO_8PSK 2   /* Turbo 8PSK (also used for Trellis 8PSK) */
-#define ADV_MOD_TURBO_16QAM 3  /* Turbo 16QAM (also used for Trellis 8PSK) */
-
-#define ADV_MOD_DCII_C_QPSK 4  /* Digicipher II Combo */
-#define ADV_MOD_DCII_I_QPSK 5  /* Digicipher II I-stream */
-#define ADV_MOD_DCII_Q_QPSK 6  /* Digicipher II Q-stream */
-#define ADV_MOD_DCII_C_OQPSK 7 /* Digicipher II offset QPSK */
-#define ADV_MOD_DSS_QPSK 8     /* DSS (DIRECTV) QPSK */
-#define ADV_MOD_DVB_BPSK 9     /* DVB-S BPSK */
 
 #define GET_USB_SPEED                     0x07
 
@@ -86,15 +34,4 @@ extern int dvb_usb_gp8psk_debug;
 #define PRODUCT_STRING_READ               0x0D
 #define FW_BCD_VERSION_READ               0x14
 
-/* firmware revision id's */
-#define GP8PSK_FW_REV1			0x020604
-#define GP8PSK_FW_REV2			0x020704
-#define GP8PSK_FW_VERS(_fw_vers)	((_fw_vers)[2]<<0x10 | (_fw_vers)[1]<<0x08 | (_fw_vers)[0])
-
-extern struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d);
-extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
-extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
-			     u16 index, u8 *b, int blen);
-extern int gp8psk_bcm4500_reload(struct dvb_usb_device *d);
-
 #endif

