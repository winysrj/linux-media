Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1GOD4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 23:56:39 -0400
Message-ID: <4E1FBA6F.10509@redhat.com>
Date: Fri, 15 Jul 2011 00:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <201107040124.04924@orion.escape-edv.de> <4E1106B0.7030102@redhat.com> <201107150145.29547@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com>
In-Reply-To: <4E1F8E1F.3000008@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 21:47, Mauro Carvalho Chehab escreveu:
> Em 14-07-2011 20:45, Oliver Endriss escreveu:
>> - DVB-T tuning does not work anymore.
> I think that the better is to revert my patch and apply a solution similar
> to cxd2820r_attach. It should work fine if called just once (like ngene/ddbridge)
> or twice (like em28xx).

I ended by fixing it at the easiest way: Just add a hack at em28xx to work the same
way as ngene/ddbridge.

The code is not beautiful, but in order to fix, I would also need to touch at
tda18271c2dd. Let's do it on another time.

-

[media] Remove the double symbol increment hack from drxk_hard
    
Both ngene and ddbrige calls dvb_attach once for drxk_attach.
The logic used there, and by tda18271c2dd driver is different
from similar logic on other frontends.

The right fix is to change them to use the same logic, but,
while we don't do that, we need to patch em28xx-dvb in order
to do cope with ngene/ddbridge magic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index d503558..a0e2ff5 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6313,12 +6313,10 @@ static int drxk_c_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend
 
 static void drxk_t_release(struct dvb_frontend *fe)
 {
-#if 0
-	struct drxk_state *state = fe->demodulator_priv;
-
-	dprintk(1, "\n");
-	kfree(state);
-#endif
+	/*
+	 * There's nothing to release here, as the state struct
+	 * is already freed by drxk_c_release.
+	 */
 }
 
 static int drxk_t_init(struct dvb_frontend *fe)
@@ -6451,17 +6449,6 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 		goto error;
 	*fe_t = &state->t_frontend;
 
-#ifdef CONFIG_MEDIA_ATTACH
-	/*
-	 * HACK: As this function initializes both DVB-T and DVB-C fe symbols,
-	 * and calling it twice would create the state twice, leading into
-	 * memory leaks, the right way is to call it only once. However, dvb
-	 * release functions will call symbol_put twice. So, the solution is to
-	 * artificially increment the usage count, in order to allow the
-	 * driver to be released.
-	 */
-	symbol_get(drxk_attach);
-#endif
 	return &state->c_frontend;
 
 error:
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index f8617d2..ab8a740 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -76,9 +76,10 @@ struct em28xx_dvb {
 	struct dmx_frontend        fe_mem;
 	struct dvb_net             net;
 
-	/* Due to DRX-D - probably need changes */
+	/* Due to DRX-K - probably need changes */
 	int (*gate_ctrl)(struct dvb_frontend *, int);
 	struct semaphore      pll_mutex;
+	bool			dont_attach_fe1;
 };
 
 
@@ -595,7 +596,7 @@ static void unregister_dvb(struct em28xx_dvb *dvb)
 	if (dvb->fe[1])
 		dvb_unregister_frontend(dvb->fe[1]);
 	dvb_unregister_frontend(dvb->fe[0]);
-	if (dvb->fe[1])
+	if (dvb->fe[1] && !dvb->dont_attach_fe1)
 		dvb_frontend_detach(dvb->fe[1]);
 	dvb_frontend_detach(dvb->fe[0]);
 	dvb_unregister_adapter(&dvb->adapter);
@@ -771,21 +772,22 @@ static int dvb_init(struct em28xx *dev)
 	case EM2884_BOARD_TERRATEC_H5:
 		terratec_h5_init(dev);
 
-		/* dvb->fe[1] will be DVB-C, and dvb->fe[0] will be DVB-T */
+		dvb->dont_attach_fe1 = 1;
+
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap, &dvb->fe[1]);
-		if (!dvb->fe[0] || !dvb->fe[1]) {
+		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
 		}
+
 		/* FIXME: do we need a pll semaphore? */
 		dvb->fe[0]->sec_priv = dvb;
 		sema_init(&dvb->pll_mutex, 1);
 		dvb->gate_ctrl = dvb->fe[0]->ops.i2c_gate_ctrl;
 		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-		dvb->fe[1]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 		dvb->fe[1]->id = 1;
 
-		/* Attach tda18271 */
+		/* Attach tda18271 to DVB-C frontend */
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
 		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0], &dev->i2c_adap, 0x60)) {
@@ -794,8 +796,12 @@ static int dvb_init(struct em28xx *dev)
 		}
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
-		if (dvb->fe[1]->ops.i2c_gate_ctrl)
-			dvb->fe[1]->ops.i2c_gate_ctrl(dvb->fe[1], 1);
+
+		/* Hack - needed by drxk/tda18271c2dd */
+		dvb->fe[1]->tuner_priv = dvb->fe[0]->tuner_priv;
+		memcpy(&dvb->fe[1]->ops.tuner_ops,
+		       &dvb->fe[0]->ops.tuner_ops,
+		       sizeof(dvb->fe[0]->ops.tuner_ops));
 
 		break;
 	default:
