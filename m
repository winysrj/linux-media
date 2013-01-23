Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:43814 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388Ab3AWWeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:34:37 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: LMML <linux-media@vger.kernel.org>
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Add lock to af9035 driver for dual mode
Date: Wed, 23 Jan 2013 23:34:30 +0100
Message-ID: <45300900.lplt0zG7i2@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lock to af9035 driver for dual mode.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>


diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c 
linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07 05:45:57.000000000 
+0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-23 
23:18:18.544788327 +0100
@@ -824,6 +824,104 @@ static int af9035_get_adapter_count(stru
 	return state->dual_mode + 1;
 }
 
+static int af9035_lock_set_frontend(struct dvb_frontend* fe)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].set_frontend(fe);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_get_frontend(struct dvb_frontend* fe)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].get_frontend(fe);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_read_status(struct dvb_frontend* fe, fe_status_t* 
status)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].read_status(fe, status);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_read_ber(struct dvb_frontend* fe, u32* ber)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].read_ber(fe, ber);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_read_signal_strength(struct dvb_frontend* fe, u16* 
strength)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].read_signal_strength(fe, strength);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_read_snr(struct dvb_frontend* fe, u16* snr)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].read_snr(fe, snr);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
+static int af9035_lock_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
+{
+       int result;
+       struct dvb_usb_adapter *adap = fe_to_adap(fe);
+       struct state *state = adap_to_priv(adap);
+
+       if (mutex_lock_interruptible(&state->fe_mutex))
+               return -EAGAIN;
+
+       result = state->fe_ops[adap->id].read_ucblocks(fe, ucblocks);
+       mutex_unlock(&state->fe_mutex);
+       return result;
+}
+
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -862,6 +960,22 @@ static int af9035_frontend_attach(struct
 	adap->fe[0]->ops.i2c_gate_ctrl = NULL;
 	adap->fe[0]->callback = af9035_frontend_callback;
 
+       memcpy(&state->fe_ops[adap->id], &adap->fe[0]->ops, sizeof(struct 
dvb_frontend_ops));
+       if (adap->fe[0]->ops.set_frontend)
+               adap->fe[0]->ops.set_frontend = af9035_lock_set_frontend;
+       if (adap->fe[0]->ops.get_frontend)
+               adap->fe[0]->ops.get_frontend = af9035_lock_get_frontend;
+       if (adap->fe[0]->ops.read_status)
+               adap->fe[0]->ops.read_status = af9035_lock_read_status;
+       if (adap->fe[0]->ops.read_ber)
+               adap->fe[0]->ops.read_ber = af9035_lock_read_ber;
+       if (adap->fe[0]->ops.read_signal_strength)
+               adap->fe[0]->ops.read_signal_strength = 
af9035_lock_read_signal_strength;
+       if (adap->fe[0]->ops.read_snr)
+               adap->fe[0]->ops.read_snr = af9035_lock_read_snr;
+       if (adap->fe[0]->ops.read_ucblocks)
+               adap->fe[0]->ops.read_ucblocks = af9035_lock_read_ucblocks;
+
 	return 0;
 
 err:
@@ -1130,6 +1244,8 @@ static int af9035_init(struct dvb_usb_de
 			"packet_size=%02x\n", __func__,
 			d->udev->speed, frame_size, packet_size);
 
+	mutex_init(&state->fe_mutex);
+
 	/* init endpoints */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
 		ret = af9035_wr_reg_mask(d, tab[i].reg, tab[i].val,
diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h 
linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
--- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07 05:45:57.000000000 
+0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-23 
23:12:59.389532516 +0100
@@ -55,6 +55,10 @@ struct state {
 	u8 seq; /* packet sequence number */
 	bool dual_mode;
 	struct af9033_config af9033_config[2];
+
+	struct dvb_frontend_ops fe_ops[2];
+
+	struct mutex fe_mutex;
 };
 
 u32 clock_lut[] = {

