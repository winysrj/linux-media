Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:45857 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1L0UoU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 15:44:20 -0500
Message-ID: <4EFA2E20.6030600@linuxtv.org>
Date: Tue, 27 Dec 2011 21:44:16 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 03/91] [media] dvb-core: add support for a DVBv5 get_frontend()
 callback
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-2-git-send-email-mchehab@redhat.com> <1324948159-23709-3-git-send-email-mchehab@redhat.com> <1324948159-23709-4-git-send-email-mchehab@redhat.com> <4EF9B860.4000103@linuxtv.org> <4EF9CD07.6080608@infradead.org> <4EF9DA66.1070409@linuxtv.org> <4EF9FFC2.30705@infradead.org>
In-Reply-To: <4EF9FFC2.30705@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.12.2011 18:26, Mauro Carvalho Chehab wrote:
> On 27-12-2011 12:47, Andreas Oberritter wrote:
>> On 27.12.2011 14:49, Mauro Carvalho Chehab wrote:
>>> On 27-12-2011 10:21, Andreas Oberritter wrote:
>>>> On 27.12.2011 02:07, Mauro Carvalho Chehab wrote:
>>>>> The old method is renamed to get_frontend_legacy(), while not all
>>>>> frontends are converted.
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> ---
>>>>>  drivers/media/dvb/bt8xx/dst.c               |    8 +-
>>>>>  drivers/media/dvb/dvb-core/dvb_frontend.c   |  102 ++++++++++++++++++++------
>>>>>  drivers/media/dvb/dvb-core/dvb_frontend.h   |    5 +-
>>>>>  drivers/media/dvb/dvb-usb/af9005-fe.c       |    4 +-
>>>>>  drivers/media/dvb/dvb-usb/cinergyT2-fe.c    |    2 +-
>>>>>  drivers/media/dvb/dvb-usb/dtt200u-fe.c      |    2 +-
>>>>>  drivers/media/dvb/dvb-usb/friio-fe.c        |    2 +-
>>>>>  drivers/media/dvb/dvb-usb/mxl111sf-demod.c  |    2 +-
>>>>>  drivers/media/dvb/dvb-usb/vp702x-fe.c       |    2 +-
>>>>>  drivers/media/dvb/dvb-usb/vp7045-fe.c       |    2 +-
>>>>>  drivers/media/dvb/firewire/firedtv-fe.c     |    2 +-
>>>>>  drivers/media/dvb/frontends/af9013.c        |    2 +-
>>>>>  drivers/media/dvb/frontends/atbm8830.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/au8522_dig.c    |    2 +-
>>>>>  drivers/media/dvb/frontends/cx22700.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/cx22702.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/cx24110.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/cx24123.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/cxd2820r_core.c |    4 +-
>>>>>  drivers/media/dvb/frontends/dib3000mb.c     |    2 +-
>>>>>  drivers/media/dvb/frontends/dib3000mc.c     |    2 +-
>>>>>  drivers/media/dvb/frontends/dib7000m.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/dib7000p.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/dib8000.c       |    4 +-
>>>>>  drivers/media/dvb/frontends/dib9000.c       |    4 +-
>>>>>  drivers/media/dvb/frontends/drxd_hard.c     |    2 +-
>>>>>  drivers/media/dvb/frontends/drxk_hard.c     |    4 +-
>>>>>  drivers/media/dvb/frontends/dvb_dummy_fe.c  |    6 +-
>>>>>  drivers/media/dvb/frontends/it913x-fe.c     |    2 +-
>>>>>  drivers/media/dvb/frontends/l64781.c        |    2 +-
>>>>>  drivers/media/dvb/frontends/lgdt3305.c      |    4 +-
>>>>>  drivers/media/dvb/frontends/lgdt330x.c      |    4 +-
>>>>>  drivers/media/dvb/frontends/lgs8gl5.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/lgs8gxx.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/mb86a20s.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/mt312.c         |    2 +-
>>>>>  drivers/media/dvb/frontends/mt352.c         |    2 +-
>>>>>  drivers/media/dvb/frontends/or51132.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/s5h1409.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/s5h1411.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/s5h1420.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/s5h1432.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/s921.c          |    2 +-
>>>>>  drivers/media/dvb/frontends/stb0899_drv.c   |    2 +-
>>>>>  drivers/media/dvb/frontends/stb6100.c       |    4 +-
>>>>>  drivers/media/dvb/frontends/stv0297.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/stv0299.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/stv0367.c       |    4 +-
>>>>>  drivers/media/dvb/frontends/stv0900_core.c  |    2 +-
>>>>>  drivers/media/dvb/frontends/tda10021.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/tda10023.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/tda10048.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/tda1004x.c      |    4 +-
>>>>>  drivers/media/dvb/frontends/tda10071.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/tda10086.c      |    2 +-
>>>>>  drivers/media/dvb/frontends/tda8083.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/ves1820.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/ves1x93.c       |    2 +-
>>>>>  drivers/media/dvb/frontends/zl10353.c       |    2 +-
>>>>>  drivers/media/dvb/siano/smsdvb.c            |    2 +-
>>>>>  drivers/media/video/tlg2300/pd-dvb.c        |    2 +-
>>>>>  drivers/staging/media/as102/as102_fe.c      |    2 +-
>>>>>  62 files changed, 157 insertions(+), 100 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
>>>>> index 4658bd6..6afc083 100644
>>>>> --- a/drivers/media/dvb/bt8xx/dst.c
>>>>> +++ b/drivers/media/dvb/bt8xx/dst.c
>>>>> @@ -1778,7 +1778,7 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
>>>>>  	.init = dst_init,
>>>>>  	.tune = dst_tune_frontend,
>>>>>  	.set_frontend_legacy = dst_set_frontend,
>>>>> -	.get_frontend = dst_get_frontend,
>>>>> +	.get_frontend_legacy = dst_get_frontend,
>>>>>  	.get_frontend_algo = dst_get_tuning_algo,
>>>>>  	.read_status = dst_read_status,
>>>>>  	.read_signal_strength = dst_read_signal_strength,
>>>>> @@ -1804,7 +1804,7 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
>>>>>  	.init = dst_init,
>>>>>  	.tune = dst_tune_frontend,
>>>>>  	.set_frontend_legacy = dst_set_frontend,
>>>>> -	.get_frontend = dst_get_frontend,
>>>>> +	.get_frontend_legacy = dst_get_frontend,
>>>>>  	.get_frontend_algo = dst_get_tuning_algo,
>>>>>  	.read_status = dst_read_status,
>>>>>  	.read_signal_strength = dst_read_signal_strength,
>>>>> @@ -1838,7 +1838,7 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
>>>>>  	.init = dst_init,
>>>>>  	.tune = dst_tune_frontend,
>>>>>  	.set_frontend_legacy = dst_set_frontend,
>>>>> -	.get_frontend = dst_get_frontend,
>>>>> +	.get_frontend_legacy = dst_get_frontend,
>>>>>  	.get_frontend_algo = dst_get_tuning_algo,
>>>>>  	.read_status = dst_read_status,
>>>>>  	.read_signal_strength = dst_read_signal_strength,
>>>>> @@ -1861,7 +1861,7 @@ static struct dvb_frontend_ops dst_atsc_ops = {
>>>>>  	.init = dst_init,
>>>>>  	.tune = dst_tune_frontend,
>>>>>  	.set_frontend_legacy = dst_set_frontend,
>>>>> -	.get_frontend = dst_get_frontend,
>>>>> +	.get_frontend_legacy = dst_get_frontend,
>>>>>  	.get_frontend_algo = dst_get_tuning_algo,
>>>>>  	.read_status = dst_read_status,
>>>>>  	.read_signal_strength = dst_read_signal_strength,
>>>>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> index eca6170..1eefb91 100644
>>>>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>>>>> @@ -139,6 +139,14 @@ struct dvb_frontend_private {
>>>>>  };
>>>>>  
>>>>>  static void dvb_frontend_wakeup(struct dvb_frontend *fe);
>>>>> +static int dtv_get_frontend(struct dvb_frontend *fe,
>>>>> +			    struct dtv_frontend_properties *c,
>>>>> +			    struct dvb_frontend_parameters *p_out);
>>>>> +
>>>>> +static bool has_get_frontend(struct dvb_frontend *fe)
>>>>> +{
>>>>> +	return fe->ops.get_frontend || fe->ops.get_frontend_legacy;
>>>>> +}
>>>>>  
>>>>>  static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
>>>>>  {
>>>>> @@ -149,8 +157,8 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
>>>>>  
>>>>>  	dprintk ("%s\n", __func__);
>>>>>  
>>>>> -	if ((status & FE_HAS_LOCK) && fe->ops.get_frontend)
>>>>> -		fe->ops.get_frontend(fe, &fepriv->parameters_out);
>>>>> +	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
>>>>> +		dtv_get_frontend(fe, NULL, &fepriv->parameters_out);
>>>>>  
>>>>>  	mutex_lock(&events->mtx);
>>>>>  
>>>>> @@ -1097,11 +1105,10 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
>>>>>  /* Ensure the cached values are set correctly in the frontend
>>>>>   * legacy tuning structures, for the advanced tuning API.
>>>>>   */
>>>>> -static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>>>>> +static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
>>>>> +					    struct dvb_frontend_parameters *p)
>>>>>  {
>>>>>  	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>>> -	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>>>>> -	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
>>>>>  
>>>>>  	p->frequency = c->frequency;
>>>>>  	p->inversion = c->inversion;
>>>>> @@ -1223,6 +1230,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
>>>>>  static void dtv_property_cache_submit(struct dvb_frontend *fe)
>>>>>  {
>>>>>  	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>>> +	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>>>>>  
>>>>>  	/* For legacy delivery systems we don't need the delivery_system to
>>>>>  	 * be specified, but we populate the older structures from the cache
>>>>> @@ -1231,7 +1239,7 @@ static void dtv_property_cache_submit(struct dvb_frontend *fe)
>>>>>  	if(is_legacy_delivery_system(c->delivery_system)) {
>>>>>  
>>>>>  		dprintk("%s() legacy, modulation = %d\n", __func__, c->modulation);
>>>>> -		dtv_property_legacy_params_sync(fe);
>>>>> +		dtv_property_legacy_params_sync(fe, &fepriv->parameters_in);
>>>>>  
>>>>>  	} else {
>>>>>  		dprintk("%s() adv, modulation = %d\n", __func__, c->modulation);
>>>>> @@ -1246,6 +1254,58 @@ static void dtv_property_cache_submit(struct dvb_frontend *fe)
>>>>>  	}
>>>>>  }
>>>>>  
>>>>> +/**
>>>>> + * dtv_get_frontend - calls a callback for retrieving DTV parameters
>>>>> + * @fe:		struct dvb_frontend pointer
>>>>> + * @c:		struct dtv_frontend_properties pointer (DVBv5 cache)
>>>>> + * @p_out	struct dvb_frontend_parameters pointer (DVBv3 FE struct)
>>>>> + *
>>>>> + * This routine calls either the DVBv3 or DVBv5 get_frontend call.
>>>>> + * If c is not null, it will update the DVBv5 cache struct pointed by it.
>>>>> + * If p_out is not null, it will update the DVBv3 params pointed by it.
>>>>> + */
>>>>> +static int dtv_get_frontend(struct dvb_frontend *fe,
>>>>> +			    struct dtv_frontend_properties *c,
>>>>> +			    struct dvb_frontend_parameters *p_out)
>>>>> +{
>>>>> +	const struct dtv_frontend_properties *cache = &fe->dtv_property_cache;
>>>>> +	struct dtv_frontend_properties tmp_cache;
>>>>> +	struct dvb_frontend_parameters tmp_out;
>>>>> +	bool fill_cache = (c != NULL);
>>>>> +	bool fill_params = (p_out != NULL);
>>>>> +	int r;
>>>>> +
>>>>> +	if (!p_out)
>>>>> +		p_out = & tmp_out;
>>>>> +
>>>>> +	if (!c)
>>>>> +		c = &tmp_cache;
>>>>> +	else
>>>>> +		memcpy(c, cache, sizeof(*c));
>>>>> +
>>>>> +	/* Then try the DVBv5 one */
>>>>> +	if (fe->ops.get_frontend) {
>>>>> +		r = fe->ops.get_frontend(fe, c);
>>>>> +		if (unlikely(r < 0))
>>>>> +			return r;
>>>>> +		if (fill_params)
>>>>> +			dtv_property_legacy_params_sync(fe, p_out);
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>> +	/* As no DVBv5 call exists, use the DVBv3 one */
>>>>> +	if (fe->ops.get_frontend_legacy) {
>>>>> +		r = fe->ops.get_frontend_legacy(fe, p_out);
>>>>> +		if (unlikely(r < 0))
>>>>> +			return r;
>>>>> +		if (fill_cache)
>>>>> +			dtv_property_cache_sync(fe, c, p_out);
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>> +	return -EOPNOTSUPP;
>>>>> +}
>>>>> +
>>>>>  static int dvb_frontend_ioctl_legacy(struct file *file,
>>>>>  			unsigned int cmd, void *parg);
>>>>>  static int dvb_frontend_ioctl_properties(struct file *file,
>>>>> @@ -1296,24 +1356,12 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
>>>>>  }
>>>>>  
>>>>>  static int dtv_property_process_get(struct dvb_frontend *fe,
>>>>> +				    const struct dtv_frontend_properties *c,
>>>>>  				    struct dtv_property *tvp,
>>>>>  				    struct file *file)
>>>>>  {
>>>>> -	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>>> -	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>>>>> -	struct dtv_frontend_properties cdetected;
>>>>>  	int r;
>>>>>  
>>>>> -	/*
>>>>> -	 * If the driver implements a get_frontend function, then convert
>>>>> -	 * detected parameters to S2API properties.
>>>>> -	 */
>>>>> -	if (fe->ops.get_frontend) {
>>>>> -		cdetected = *c;
>>>>> -		dtv_property_cache_sync(fe, &cdetected, &fepriv->parameters_out);
>>>>> -		c = &cdetected;
>>>>> -	}
>>>>> -
>>>>>  	switch(tvp->cmd) {
>>>>>  	case DTV_ENUM_DELSYS:
>>>>>  		dtv_set_default_delivery_caps(fe, tvp);
>>>>> @@ -1685,6 +1733,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>>>>>  
>>>>>  	} else
>>>>>  	if(cmd == FE_GET_PROPERTY) {
>>>>> +		struct dtv_frontend_properties cache_out;
>>>>>  
>>>>>  		tvps = (struct dtv_properties __user *)parg;
>>>>>  
>>>>> @@ -1707,8 +1756,13 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>>>>>  			goto out;
>>>>>  		}
>>>>>  
>>>>> +		/*
>>>>> +		 * Fills the cache out struct with the cache contents, plus
>>>>> +		 * the data retrieved from get_frontend/get_frontend_legacy.
>>>>> +		 */
>>>>> +		dtv_get_frontend(fe, &cache_out, NULL);
>>>>
>>>> Unlike before, this code actually calls the get_frontend driver
>>>> callback, causing unwanted I2C traffic for every property. Please drop
>>>> this behavioural change.
>>>
>>> Look again: get_frontend() is called only once, when the user requests
>>> FE_GET_PROPERTY.
>>
>> So let me rephrase: Unlike before, this code actually calls the
>> get_frontend driver callback,
> 
> True.
> 
>> causing unwanted I2C traffic for every FE_GET_PROPERTY ioctl.
> 
> Why unwanted? If the userspace is calling it, it likely wants some fresh 
> information about the frontend.

If I want to query the current frequency property, then the driver
shouldn't have to read the symbol rate, FEC etc. Doing that made sense
when FE_GET_FRONTEND had to fill a struct, but now that we're using
distinct properties it doesn't make sense anymore.

> One usage of such call would be to retrieve the autodetected properties,
> after having a frontend lock.
> 
>>> This will only generate i2c traffic if the frontend implements get_frontend,
>>> and if it needs to retrieve something from the hardware.
>>
>> What do you mean by "if it needs to retrieve something"? There's no
>> logic in dtv_get_frontend() to handle that. Usually there's no logic in
>> the get_frontend callback either, because it's job is to retrieve
>> something from the hardware _unconditionally_.
> 
> For example, at FE_SET, it asked for modulation detection. a GET_PROP may
> return what was the detected modulation.

Yes. The detected value should be set by the driver in its get_property
callback.

>> Btw, I just noticed that get_frontend gets a parameter 'props' while
>> set_frontend doesn't.
> 
> My first coding were to not add a props parameter there. Then I realized
> that it could make some sense to not touch at the frontend cache parameters
> on a get_frontend, in order to prevent it to replace *_AUTO parameters by
> a detected parameter, as subsequent FE_SET_PROPERTY calls might try to just
> change the frequency, instead of filling all the properties again.
> 
> So, I decided to explicitly pass a parameter there.
> 
>> IMO this should be changed, e.g. by adding const
>> struct dtv_frontend_properties* to set_frontend, if you insist on
>> introducing this callback.
>>
>> A far better solution would be to just use the get_property callback for
>> all properties instead of replacing the legacy get_frontend callback
>> with a new "catch-all" function.
> 
> Sorry, but I didn't understand what you're meaning. This is exactly what
> get_frontend callback is doing: it retrieves all properties.

See above.
