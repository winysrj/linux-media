Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alannisota@gmail.com>) id 1LCeGe-0004af-T0
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 19:03:38 +0100
Received: by bwz11 with SMTP id 11so7045599bwz.17
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 10:03:03 -0800 (PST)
Message-ID: <4947EC68.6080403@gmail.com>
Date: Tue, 16 Dec 2008 09:59:04 -0800
From: Alan Nisota <alannisota@gmail.com>
MIME-Version: 1.0
To: Janne Grunau <janne-dvb@grunau.be>
References: <200812161740.46186.janne-dvb@grunau.be>
In-Reply-To: <200812161740.46186.janne-dvb@grunau.be>
Content-Type: multipart/mixed; boundary="------------060706010601060206030508"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] (Try 2) Convert GP8PSK module to use S2API
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

This is a multi-part message in MIME format.
--------------060706010601060206030508
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Janne, Thanks for your' response.  Hopefuly this patch addresses all of 
your concerns.

I am not including the API changes at the moment.  I'll try again on 
that after this gets committed (the number of folks working with DCII is 
very small, as far as I'm aware, so the other modulation types can be 
handled later)

There were a fewquestions which I'll try to answer here as well:

> Do the values for the FEC in cmd[9] depend on the
> modulation?
Yes, each modulation can have completely different meanings for cmd[9]

> I would prefer a S2API command DTV_TURBO_MODES over duplicating
> modulations. Especially since the the implemtation in the driver differs
> only for QPSK and QPSK_TURBO.
>   
The downside to this is that it requires more changes inside of the 
user-space software to do something special with these modulations.  
They really are completely different than non-turbo modes.  But as the 
only interesting case is Turbo-QPSK, and I'm not sure which satellites 
even broadcast it, that may be ok.

>> +	QPSK_DCII_C,
>> +	QPSK_DCII_I,
>> +	QPSK_DCII_Q,
>>     
>
> Are all three needed? What does the last character mean?
>   
I'm not an expert in DCII, and don't know much about it.  This set of 
code came directly from the vendor.  Here is the best description of 
DCII that I've seen though:
http://www.coolstf.com/mpeg/#dcii

----------------------
This patch converts the gp8psk module to use the S2API.
It pretends to be  DVB-S2 capable in order to allow the various 
supported modulations (8PSK, QPSK-Turbo, etc), and keep software 
compatibility with the S2API patches for Mythtv and VDR.

Signed-off by: Alan Nisota <alannisota@gmail.com>



--------------060706010601060206030508
Content-Type: text/x-diff;
 name="gp8psk_dvbs2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gp8psk_dvbs2.patch"

diff -r 086c580cf0e7 linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	Tue Dec 16 10:46:32 2008 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	Tue Dec 16 09:36:32 2008 -0800
@@ -24,6 +24,20 @@ struct gp8psk_fe_state {
 	unsigned long next_status_check;
 	unsigned long status_check_interval;
 };
+
+static int gp8psk_tuned_to_DCII(struct dvb_frontend* fe)
+{
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+	u8 status;
+	gp8psk_usb_in_op(st->d, GET_8PSK_CONFIG, 0,0,&status,1);
+	return (status & bmDCtuned);
+}
+
+static int gp8psk_set_tuner_mode(struct dvb_frontend* fe, int mode)
+{
+	struct gp8psk_fe_state *state = fe->demodulator_priv;
+	return gp8psk_usb_out_op(state->d, SET_8PSK_CONFIG, mode,0,NULL,0);
+}
 
 static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
 {
@@ -99,38 +113,100 @@ static int gp8psk_fe_get_tune_settings(s
 	return 0;
 }
 
+static int gp8psk_fe_set_property(struct dvb_frontend *fe,
+	struct dtv_property *tvp)
+{
+	deb_fe("%s(..)\n", __func__);
+	return 0;
+}
+
+static int gp8psk_fe_get_property(struct dvb_frontend *fe,
+	struct dtv_property *tvp)
+{
+	deb_fe("%s(..)\n", __func__);
+	return 0;
+}
+
+
 static int gp8psk_fe_set_frontend(struct dvb_frontend* fe,
 				  struct dvb_frontend_parameters *fep)
 {
 	struct gp8psk_fe_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 cmd[10];
 	u32 freq = fep->frequency * 1000;
+	int gp_product_id = le16_to_cpu(state->d->udev->descriptor.idProduct);
+
+	deb_fe("%s()\n", __func__);
 
 	cmd[4] = freq         & 0xff;
 	cmd[5] = (freq >> 8)  & 0xff;
 	cmd[6] = (freq >> 16) & 0xff;
 	cmd[7] = (freq >> 24) & 0xff;
 
-	switch(fe->ops.info.type) {
-	case FE_QPSK:
-		cmd[0] =  fep->u.qpsk.symbol_rate        & 0xff;
-		cmd[1] = (fep->u.qpsk.symbol_rate >>  8) & 0xff;
-		cmd[2] = (fep->u.qpsk.symbol_rate >> 16) & 0xff;
-		cmd[3] = (fep->u.qpsk.symbol_rate >> 24) & 0xff;
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		/* Only QPSK is supported for DVB-S */
+		if (c->modulation != QPSK) {
+			deb_fe("%s: unsupported modulation selected (%d)\n",
+				__func__, c->modulation);
+			return -EOPNOTSUPP;
+		}
+		c->fec_inner = FEC_AUTO;
+		break;
+	case SYS_DVBS2:
+		deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
+		break;
+
+	default:
+		deb_fe("%s: unsupported delivery system selected (%d)\n",
+			__func__, c->delivery_system);
+		return -EOPNOTSUPP;
+	}
+
+	cmd[0] =  c->symbol_rate        & 0xff;
+	cmd[1] = (c->symbol_rate >>  8) & 0xff;
+	cmd[2] = (c->symbol_rate >> 16) & 0xff;
+	cmd[3] = (c->symbol_rate >> 24) & 0xff;
+	switch (c->modulation) {
+	case QPSK:
+		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+			if (gp8psk_tuned_to_DCII(fe))
+				gp8psk_bcm4500_reload(state->d);
+		switch (c->fec_inner) {
+		case FEC_1_2:  cmd[9] = 0; break;
+		case FEC_2_3:  cmd[9] = 1; break;
+		case FEC_3_4:  cmd[9] = 2; break;
+		case FEC_5_6:  cmd[9] = 3; break;
+		case FEC_7_8:  cmd[9] = 4; break;
+		case FEC_AUTO: cmd[9] = 5; break;
+		default:       cmd[9] = 5; break;
+		}
 		cmd[8] = ADV_MOD_DVB_QPSK;
-		cmd[9] = 0x03; /*ADV_MOD_FEC_XXX*/
 		break;
-	default:
-		// other modes are unsuported right now
-		cmd[0] = 0;
-		cmd[1] = 0;
-		cmd[2] = 0;
-		cmd[3] = 0;
-		cmd[8] = 0;
+	case PSK_8: /* PSK_8 is for compatibility with DN */
+		cmd[8] = ADV_MOD_TURBO_8PSK;
+		switch (c->fec_inner) {
+		case FEC_2_3:  cmd[9] = 0; break;
+		case FEC_3_4:  cmd[9] = 1; break;
+		case FEC_3_5:  cmd[9] = 2; break;
+		case FEC_5_6:  cmd[9] = 3; break;
+		case FEC_8_9:  cmd[9] = 4; break;
+		default:       cmd[9] = 0; break;
+		}
+		break;
+	case QAM_16: /* QAM_16 is for compatibility with DN */
+		cmd[8] = ADV_MOD_TURBO_16QAM;
 		cmd[9] = 0;
 		break;
+	default: /* Unknown modulation */
+		deb_fe("%s: unsupported modulation selected (%d)\n",
+			__func__, c->modulation);
+		return -EOPNOTSUPP;
 	}
 
+	if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+		gp8psk_set_tuner_mode(fe,0);
 	gp8psk_usb_out_op(state->d,TUNE_8PSK,0,0,cmd,10);
 
 	state->lock = 0;
@@ -139,13 +215,6 @@ static int gp8psk_fe_set_frontend(struct
 
 	return 0;
 }
-
-static int gp8psk_fe_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
-{
-	return 0;
-}
-
 
 static int gp8psk_fe_send_diseqc_msg (struct dvb_frontend* fe,
 				    struct dvb_diseqc_master_cmd *m)
@@ -261,9 +330,11 @@ static struct dvb_frontend_ops gp8psk_fe
 		.symbol_rate_max        = 45000000,
 		.symbol_rate_tolerance  = 500,  /* ppm */
 		.caps = FE_CAN_INVERSION_AUTO |
-				FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
-				FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
-				FE_CAN_QPSK
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			// FE_CAN_QAM_16 is for compatibility 
+			// (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
+			FE_CAN_QPSK | FE_CAN_QAM_16
 	},
 
 	.release = gp8psk_fe_release,
@@ -271,8 +342,10 @@ static struct dvb_frontend_ops gp8psk_fe
 	.init = NULL,
 	.sleep = NULL,
 
+	.set_property = gp8psk_fe_set_property,
+	.get_property = gp8psk_fe_get_property,
 	.set_frontend = gp8psk_fe_set_frontend,
-	.get_frontend = gp8psk_fe_get_frontend,
+
 	.get_tune_settings = gp8psk_fe_get_tune_settings,
 
 	.read_status = gp8psk_fe_read_status,
diff -r 086c580cf0e7 linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Tue Dec 16 10:46:32 2008 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Tue Dec 16 09:36:32 2008 -0800
@@ -174,7 +174,6 @@ static int gp8psk_power_ctrl(struct dvb_
 	return 0;
 }
 
-#if 0
 int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
 {
 	u8 buf;
@@ -191,7 +190,6 @@ int gp8psk_bcm4500_reload(struct dvb_usb
 			return EINVAL;
 	return 0;
 }
-#endif  /*  0  */
 
 static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
diff -r 086c580cf0e7 linux/drivers/media/dvb/dvb-usb/gp8psk.h
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.h	Tue Dec 16 10:46:32 2008 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.h	Tue Dec 16 09:36:32 2008 -0800
@@ -92,5 +92,6 @@ extern int gp8psk_usb_in_op(struct dvb_u
 extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
 extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen);
+extern int gp8psk_bcm4500_reload(struct dvb_usb_device *d);
 
 #endif

--------------060706010601060206030508
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060706010601060206030508--
