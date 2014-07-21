Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:52900 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUR4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 13:56:06 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N920046DPTGWMA0@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 13:56:04 -0400 (EDT)
Date: Mon, 21 Jul 2014 14:56:00 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] mb86a20s: fix ISDB-T mode handling
Message-id: <20140721145600.62bc22d0.m.chehab@samsung.com>
In-reply-to: <53C183FE.8080008@iki.fi>
References: <1405183191-10432-1-git-send-email-m.chehab@samsung.com>
 <53C183FE.8080008@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Jul 2014 21:52:46 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Mauro, you have forgot some debug hacks to that patch.

Thanks for noticing. Actually, it got merged by mistake with
a hack I'm using to debug another driver.

Just sent a version 2 of this patch.

Regards,
Mauro

> 
> Antti
> 
> On 07/12/2014 07:39 PM, Mauro Carvalho Chehab wrote:
> > The driver was reporting an incorrect mode, when mode 2
> > is selected.
> >
> > While testing it, noticed that neither mode 1 or guard
> > interval 1/32 is supported by this device. Document it,
> > and ensure that it will report _AUTO when it doesn't lock,
> > in order to not report a wrong detection to userspace.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >   drivers/media/dvb-frontends/dib0090.c       | 6 +++++-
> >   drivers/media/dvb-frontends/mb86a20s.c      | 9 +++++----
> >   drivers/media/usb/dvb-usb/dib0700_devices.c | 3 +++
> >   3 files changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
> > index 68e2af2650d3..27d5c5cd439c 100644
> > --- a/drivers/media/dvb-frontends/dib0090.c
> > +++ b/drivers/media/dvb-frontends/dib0090.c
> > @@ -24,6 +24,8 @@
> >    *
> >    */
> >
> > +#define DEBUG_AGC
> > +
> >   #include <linux/kernel.h>
> >   #include <linux/slab.h>
> >   #include <linux/i2c.h>
> > @@ -1199,11 +1201,13 @@ int dib0090_gain_control(struct dvb_frontend *fe)
> >   		state->rf_gain_limit = state->rf_ramp[0] << WBD_ALPHA;
> >   		state->current_gain = ((state->rf_ramp[0] + state->bb_ramp[0]) / 2) << GAIN_ALPHA;
> >
> > +dprintk("Current gain: %d\n", state->current_gain);
> > +
> >   		*tune_state = CT_AGC_STEP_0;
> >   	} else if (!state->agc_freeze) {
> >   		s16 wbd = 0, i, cnt;
> >
> > -		int adc;
> > +		int adc = 0;
> >   		wbd_val = dib0090_get_slow_adc_val(state);
> >
> >   		if (*tune_state == CT_AGC_STEP_0)
> > diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> > index 227a420f7069..b931179c70a4 100644
> > --- a/drivers/media/dvb-frontends/mb86a20s.c
> > +++ b/drivers/media/dvb-frontends/mb86a20s.c
> > @@ -711,11 +711,10 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
> >   	rc = mb86a20s_readreg(state, 0x07);
> >   	if (rc < 0)
> >   		return rc;
> > +	c->transmission_mode = TRANSMISSION_MODE_AUTO;
> >   	if ((rc & 0x60) == 0x20) {
> > -		switch (rc & 0x0c >> 2) {
> > -		case 0:
> > -			c->transmission_mode = TRANSMISSION_MODE_2K;
> > -			break;
> > +		/* Only modes 2 and 3 are supported */
> > +		switch ((rc >> 2) & 0x03) {
> >   		case 1:
> >   			c->transmission_mode = TRANSMISSION_MODE_4K;
> >   			break;
> > @@ -724,7 +723,9 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
> >   			break;
> >   		}
> >   	}
> > +	c->guard_interval = GUARD_INTERVAL_AUTO;
> >   	if (!(rc & 0x10)) {
> > +		/* Guard interval 1/32 is not supported */
> >   		switch (rc & 0x3) {
> >   		case 0:
> >   			c->guard_interval = GUARD_INTERVAL_1_4;
> > diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> > index 501947eaacfe..cad359fcd690 100644
> > --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> > +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> > @@ -1645,6 +1645,8 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
> >   	int ret = 0;
> >   	enum frontend_tune_state tune_state = CT_SHUTDOWN;
> >
> > +printk("%s called.\n", __func__);
> > +
> >   	switch (band) {
> >   	default:
> >   			deb_info("Warning : Rf frequency  (%iHz) is not in the supported range, using VHF switch ", fe->dtv_property_cache.frequency);
> > @@ -1714,6 +1716,7 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
> >   	} else {
> >   		/* for everything else than CBAND we are using standard AGC */
> >   		deb_info("not tuning in CBAND - standard AGC startup\n");
> > +printk("%s: calling dib0090_pwm_gain_reset\n", __func__);
> >   		dib0090_pwm_gain_reset(fe);
> >   	}
> >
> >
> 
