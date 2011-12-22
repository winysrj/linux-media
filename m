Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1LVUM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 15:12:29 -0500
Message-ID: <4EF38F19.3050709@redhat.com>
Date: Thu, 22 Dec 2011 18:12:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: which is correct name DTMB or CTTB?
References: <4EF1ACA3.8080808@iki.fi> <4EF35EB5.5010700@iki.fi> <4EF38B5B.8020408@redhat.com>
In-Reply-To: <4EF38B5B.8020408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22-12-2011 17:56, Mauro Carvalho Chehab wrote:
> On 22-12-2011 14:45, Antti Palosaari wrote:
>> On 12/21/2011 11:53 AM, Antti Palosaari wrote:
>>> I am adding DTMB/CTTB support for the Linux Kernel DVB API. Do anyone
>>> have clear idea which correct name?
>>>
>>> Background of that discussion can be found from the following patch:
>>> http://patchwork.linuxtv.org/patch/8827/
>>
>> There is already defined delivery system SYS_DMBTH. It have been from the time S2API was introduced coming from the patch: 6b73eeafbc856c0cef7166242f0e55403407f355
>>
>> include/linux/dvb/frontend.h
>>
>> Should I change that name? Or introduce new names using define? Or just leave it as it is. No single driver is using that because all existing DTMB/CTTB/DMB-TH drivers are abusing DVB-T...
> 
>>
>> I still think it is rather safe to change better one, there is likely no user space apps using that yet...
> 
> Feel free to change it, as nobody is using it yet.
> 
> In a matter of fact, I wrote today one patch using it, but I'll rebase my patch to
> the name you define.

FYI, I'm enclosing the patch I wrote for a CTTB driver. The Idea is that,
while such drivers are lying to DVBv3 calls, they'll tell the true delivery
system, and properly honor get_frontend/set_frontend for
FE_GET_PROPERTY/FE_SETPROPERTY ioctl calls.

I'll be submitting it together with a series of patches converting the demods
to use struct dtv_frontend_properties instead of struct dvb_frontend_parameters.

This patch depends on some patches on my experimental tree:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/DVB_v5_v2

Please, don't base any of your patches on that tree yet. There are about
70 drivers pending conversion. Only after converting everything I'll send
a RFC, and test with a few devices I have with me. 

I'll likely need to rebase it a few times, in order to be sure that all
tuner drivers are converted before the demods, as I'm doing, this change,
at demod drivers I'm converting:
-		fe->ops.tuner_ops.set_params(fe, params);
+		fe->ops.tuner_ops.set_params(fe, NULL);

The final step will be to remove the now legacy "params" argument, but
there are still a few tuners not converted (the ones that aren't at
drivers/media/common/tuners).

Regards,
Mauro

-

[PATCH] [media] atbm8830: convert set_fontend to new way and fix delivery system

This is one of the cases where the frontend changes is required:
while this device lies to applications that it is a DVB-T, it is,
in fact, a frontend for CTTB delivery system. So, the information
provided for a DVBv3 application should be different than the one
provided to a DVBv5 application.

So, fill delsys with the CTTB delivery system, and use the new
way. there aren't many changes here, as everything on this driver
is on auto mode, probably because of the lack of a proper API
for this delivery system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index e6114b4..ee69509 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -267,8 +267,7 @@ static void atbm8830_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static int atbm8830_set_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+static int atbm8830_set_fe(struct dvb_frontend *fe)
 {
 	struct atbm_state *priv = fe->demodulator_priv;
 	int i;
@@ -279,7 +278,7 @@ static int atbm8830_set_fe(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, fe_params);
+		fe->ops.tuner_ops.set_params(fe, NULL);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
@@ -298,31 +297,32 @@ static int atbm8830_set_fe(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int atbm8830_get_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+static int atbm8830_get_fe(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
 	dprintk("%s\n", __func__);
 
 	/* TODO: get real readings from device */
 	/* inversion status */
-	fe_params->inversion = INVERSION_OFF;
+	c->inversion = INVERSION_OFF;
 
 	/* bandwidth */
-	fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+	c->bandwidth_hz = 8000000;
 
-	fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
-	fe_params->u.ofdm.code_rate_LP = FEC_AUTO;
+	c->code_rate_HP = FEC_AUTO;
+	c->code_rate_LP = FEC_AUTO;
 
-	fe_params->u.ofdm.constellation = QAM_AUTO;
+	c->modulation = QAM_AUTO;
 
 	/* transmission mode */
-	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 
 	/* guard interval */
-	fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
+	c->guard_interval = GUARD_INTERVAL_AUTO;
 
 	/* hierarchy */
-	fe_params->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	c->hierarchy = HIERARCHY_NONE;
 
 	return 0;
 }
@@ -429,6 +429,7 @@ static int atbm8830_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 static struct dvb_frontend_ops atbm8830_ops = {
+	.delsys = { SYS_DMBTH },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
 		.type = FE_OFDM,
@@ -449,8 +450,8 @@ static struct dvb_frontend_ops atbm8830_ops = {
 	.write = NULL,
 	.i2c_gate_ctrl = atbm8830_i2c_gate_ctrl,
 
-	.set_frontend_legacy = atbm8830_set_fe,
-	.get_frontend_legacy = atbm8830_get_fe,
+	.set_frontend = atbm8830_set_fe,
+	.get_frontend = atbm8830_get_fe,
 	.get_tune_settings = atbm8830_get_tune_settings,
 
 	.read_status = atbm8830_read_status,
