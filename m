Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KX7pD-0007T5-Ab
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 07:07:43 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 24 Aug 2008 06:56:43 +0200
References: <48B00D6C.8080302@gmx.de>
	<alpine.LRH.1.10.0808231750550.26788@pub5.ifh.de>
	<200808231842.36465@orion.escape-edv.de>
In-Reply-To: <200808231842.36465@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NoOsI/P0WDbNKYj"
Message-Id: <200808240656.45936@orion.escape-edv.de>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_NoOsI/P0WDbNKYj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Oliver Endriss wrote:
> Patrick Boettcher wrote:
> > On Sat, 23 Aug 2008, Oliver Endriss wrote:
> > >> In addition (see my other mail in that thread), sending two independent
> > >> i2c_transfers which actually belong together is not really safe.
> > >
> > > The current code in the else path will *never* work, because the tuner
> > > does not support repeated start conditions. The problem is not the I2C
> > > master (saa7146/flexcop) but the I2C slave (s5h1420).
> > 
> > Wouldn't it be more correct to have a flag signaling to the 
> > i2c_tranfer-function that a repeated start is not wanted even though it is 
> > two i2c-messages glued (which are interpreted today as a read with
> > repeated start).
> 
> I remember that we had the same discussion for the stv0297 driver a long
> time ago.

See
  http://linuxtv.org/pipermail/linux-dvb/2007-May/018122.html
for this interesting discussion.

Obviously the i2c maintainers were not willing to add the I2C_M_STOP
flag...

> For the stv0297 I have an experimental patch which intercepts the
> master_xfer routine, but this is not very nice either.

See attachment. It will probably not apply to the current tree, but you
should get the idea. Anyway, I don't want to add this crap to a frontend
driver. It does not fix the userspace issues anyway.

For now I suggest to use the good old double i2c_transfer() approach for
the budget driver.

Btw, I still do not understand how your repeated_start_workaround works.
  struct i2c_msg msg[] = {
    { .addr = state->config->demod_address, .flags = 0, .buf = b, .len = 2 },
    { .addr = state->config->demod_address, .flags = 0, .buf = &reg, .len = 1 },
    { .addr = state->config->demod_address, .flags = I2C_M_RD, .buf = b, .len = 1 },
  };
What does the flexcop master_xfer send over the i2c bus when it receives
these messages?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_NoOsI/P0WDbNKYj
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stv0297_restart_workaround.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stv0297_restart_workaround.diff"

diff -r 8f9147c3bacd linux/drivers/media/dvb/frontends/stv0297.c
--- a/linux/drivers/media/dvb/frontends/stv0297.c	Wed Aug 01 12:14:44 2007 -0300
+++ b/linux/drivers/media/dvb/frontends/stv0297.c	Wed Aug 01 23:02:17 2007 +0200
@@ -35,6 +35,10 @@ struct stv0297_state {
 	const struct stv0297_config *config;
 	struct dvb_frontend frontend;
 
+	/* workaround, chip does not support repeated start condition */
+	struct i2c_algorithm i2c_algo_virt;
+	struct i2c_adapter i2c_adap_virt;
+
 	unsigned long last_ber;
 	unsigned long base_freq;
 };
@@ -47,6 +51,29 @@ struct stv0297_state {
 
 #define STV0297_CLOCK_KHZ   28900
 
+
+static int stv0297_master_xfer_virt (struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct stv0297_state *state = i2c_get_adapdata(adap);
+	struct i2c_adapter *i2c_phys = adap->algo_data;
+	int i, rc;
+
+	if (num == 2 &&
+	    msgs[0].addr == state->config->demod_address &&
+	    msgs[1].addr == state->config->demod_address &&
+	    msgs[0].flags == 0 && msgs[1].flags == I2C_M_RD) {
+		/* device needs a STOP between the register and data */
+		for (i = 0; i < num; i++) {
+			rc = i2c_transfer(i2c_phys, msgs+i, 1);
+			if (rc != 1)
+				return rc;
+		}
+		rc = num;
+	} else
+		rc = i2c_transfer(i2c_phys, msgs, num);
+
+	return rc;
+}
 
 static int stv0297_writereg(struct stv0297_state *state, u8 reg, u8 data)
 {
@@ -72,21 +99,9 @@ static int stv0297_readreg(struct stv029
 				 {.addr = state->config->demod_address,.flags = I2C_M_RD,.buf = b1,.len = 1}
 			       };
 
-	// this device needs a STOP between the register and data
-	if (state->config->stop_during_read) {
-		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
-			return -1;
-		}
-		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
-			return -1;
-		}
-	} else {
-		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
-			return -1;
-		}
+	if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
+		dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+		return -1;
 	}
 
 	return b1[0];
@@ -107,26 +122,13 @@ static int stv0297_readregs(struct stv02
 static int stv0297_readregs(struct stv0297_state *state, u8 reg1, u8 * b, u8 len)
 {
 	int ret;
-	struct i2c_msg msg[] = { {.addr = state->config->demod_address,.flags = 0,.buf =
-				  &reg1,.len = 1},
-	{.addr = state->config->demod_address,.flags = I2C_M_RD,.buf = b,.len = len}
-	};
-
-	// this device needs a STOP between the register and data
-	if (state->config->stop_during_read) {
-		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
-			return -1;
-		}
-		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
-			return -1;
-		}
-	} else {
-		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
-			return -1;
-		}
+	struct i2c_msg msg[] = { {.addr = state->config->demod_address,.flags = 0,.buf = &reg1,.len = 1},
+				 {.addr = state->config->demod_address,.flags = I2C_M_RD,.buf = b,.len = len}
+			       };
+
+	if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
+		dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+		return -1;
 	}
 
 	return 0;
@@ -651,15 +653,30 @@ struct dvb_frontend *stv0297_attach(cons
 	struct stv0297_state *state = NULL;
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct stv0297_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct stv0297_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
 
 	/* setup the state */
 	state->config = config;
-	state->i2c = i2c;
-	state->last_ber = 0;
-	state->base_freq = 0;
+	if (state->config->stop_during_read) {
+		state->i2c_algo_virt.master_xfer = stv0297_master_xfer_virt;
+		state->i2c_algo_virt.functionality = i2c->algo->functionality;
+
+		state->i2c_adap_virt.id = i2c->id;
+		state->i2c_adap_virt.class = i2c->class;
+		state->i2c_adap_virt.algo = &state->i2c_algo_virt;
+		state->i2c_adap_virt.algo_data = i2c;
+		state->i2c_adap_virt.timeout = i2c->timeout;
+		state->i2c_adap_virt.retries = i2c->retries;
+		state->i2c_adap_virt.dev.parent = i2c->dev.parent;
+		i2c_set_adapdata(&state->i2c_adap_virt, state);
+
+		if (i2c_add_adapter(&state->i2c_adap_virt) < 0)
+			goto error;
+		state->i2c = &state->i2c_adap_virt;
+	} else
+		state->i2c = i2c;
 
 	/* check if the demod is there */
 	if ((stv0297_readreg(state, 0x80) & 0x70) != 0x20)
@@ -671,6 +688,8 @@ struct dvb_frontend *stv0297_attach(cons
 	return &state->frontend;
 
 error:
+	if (state && state->config->stop_during_read && state->i2c)
+		i2c_del_adapter(state->i2c);
 	kfree(state);
 	return NULL;
 }

--Boundary-00=_NoOsI/P0WDbNKYj
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_NoOsI/P0WDbNKYj--
