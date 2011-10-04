Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415Ab1JDUof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 16:44:35 -0400
Received: by iakk32 with SMTP id k32so999750iak.19
        for <linux-media@vger.kernel.org>; Tue, 04 Oct 2011 13:44:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
Date: Wed, 5 Oct 2011 07:44:34 +1100
Message-ID: <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Jason Hecker <jwhecker@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: tvboxspy <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have had some luck with this patch.  I am still getting fouled
recordings with tuner A but it's not consistent.  I have yet to
ascertain if the problem occurs depending on the order of tuning to
have both tuners recording different frquencies at the same time, ie
Tuner B then Tuner A or vice versa.

Malcolm, did you say there was a MythTV tubing bug?  Do you have an
URL for the bug if it has been reported?

I fear I might have a multi-layered problem - not only the Afatech
tuners but perhaps some PCI issue too.  It doesn't help if MythTV
isn't doing the right thing either.

On 5 October 2011 06:28, Josu Lazkano <josu.lazkano@gmail.com> wrote:
> 2011/9/28 tvboxspy <tvboxspy@gmail.com>:
>> Frontend bus lock for af9015 devices.
>>
>> Last week, I aqcuired a dual KWorld PlusTV Dual DVB-T Stick (DVB-T 399U).
>>
>> The lock is intended for dual frontends that share the same tuner I2C address
>> to stop either frontend sending data while any gate is open. The patch
>> should have no effect on single devices or multiple single devices, well
>> not on the ones I have!
>>
>> It also delays read_status call backs being sent while either gate is open, a
>> mostly like cause of corruption.
>>
>> The lock also covers the attachment process of the tuner in case there is any
>> race condition, although unlikely.
>>
>> Points about troubles with Myth TV;
>> Streaming corruptions are more likely to appear from the I2C noise generated
>> from setting either frontend. Afatech love their bits as bytes:-)
>>
>> Latest version of Myth TV appears to have a bug where you can't select the second
>> frontend independently and when it does it tunes to the same frequency as
>> the first frontend!
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>> ---
>>  drivers/media/dvb/dvb-usb/af9015.c   |    7 ++++++-
>>  drivers/media/dvb/frontends/af9013.c |   13 ++++++++++++-
>>  drivers/media/dvb/frontends/af9013.h |    5 +++--
>>  3 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
>> index c6c275b..0089858 100644
>> --- a/drivers/media/dvb/dvb-usb/af9015.c
>> +++ b/drivers/media/dvb/dvb-usb/af9015.c
>> @@ -43,6 +43,7 @@ MODULE_PARM_DESC(remote, "select remote");
>>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>>
>>  static DEFINE_MUTEX(af9015_usb_mutex);
>> +static DEFINE_MUTEX(af9015_fe_mutex);
>>
>>  static struct af9015_config af9015_config;
>>  static struct dvb_usb_device_properties af9015_properties[3];
>> @@ -1114,7 +1115,7 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
>>
>>        /* attach demodulator */
>>        adap->fe_adap[0].fe = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
>> -               &adap->dev->i2c_adap);
>> +               &adap->dev->i2c_adap, &af9015_fe_mutex);
>>
>>        return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
>>  }
>> @@ -1187,6 +1188,9 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
>>        int ret;
>>        deb_info("%s:\n", __func__);
>>
>> +       if (mutex_lock_interruptible(&af9015_fe_mutex) < 0)
>> +               return -EAGAIN;
>> +
>>        switch (af9015_af9013_config[adap->id].tuner) {
>>        case AF9013_TUNER_MT2060:
>>        case AF9013_TUNER_MT2060_2:
>> @@ -1242,6 +1246,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
>>                err("Unknown tuner id:%d",
>>                        af9015_af9013_config[adap->id].tuner);
>>        }
>> +       mutex_unlock(&af9015_fe_mutex);
>>        return ret;
>>  }
>>
>> diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
>> index 345311c..b220a87 100644
>> --- a/drivers/media/dvb/frontends/af9013.c
>> +++ b/drivers/media/dvb/frontends/af9013.c
>> @@ -50,6 +50,7 @@ struct af9013_state {
>>        u16 snr;
>>        u32 frequency;
>>        unsigned long next_statistics_check;
>> +       struct mutex *fe_mutex;
>>  };
>>
>>  static u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
>> @@ -630,9 +631,14 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
>>        state->frequency = params->frequency;
>>
>>        /* program tuner */
>> +       if (mutex_lock_interruptible(state->fe_mutex) < 0)
>> +               return -EAGAIN;
>> +
>>        if (fe->ops.tuner_ops.set_params)
>>                fe->ops.tuner_ops.set_params(fe, params);
>>
>> +       mutex_unlock(state->fe_mutex);
>> +
>>        /* program CFOE coefficients */
>>        ret = af9013_set_coeff(state, params->u.ofdm.bandwidth);
>>        if (ret)
>> @@ -1038,6 +1044,9 @@ static int af9013_read_status(struct dvb_frontend *fe, fe_status_t *status)
>>        u8 tmp;
>>        *status = 0;
>>
>> +       if (mutex_lock_interruptible(state->fe_mutex) < 0)
>> +               return -EAGAIN;
>> +
>>        /* MPEG2 lock */
>>        ret = af9013_read_reg_bits(state, 0xd507, 6, 1, &tmp);
>>        if (ret)
>> @@ -1086,6 +1095,7 @@ static int af9013_read_status(struct dvb_frontend *fe, fe_status_t *status)
>>        ret = af9013_update_statistics(fe);
>>
>>  error:
>> +       mutex_unlock(state->fe_mutex);
>>        return ret;
>>  }
>>
>> @@ -1446,7 +1456,7 @@ static void af9013_release(struct dvb_frontend *fe)
>>  static struct dvb_frontend_ops af9013_ops;
>>
>>  struct dvb_frontend *af9013_attach(const struct af9013_config *config,
>> -       struct i2c_adapter *i2c)
>> +       struct i2c_adapter *i2c, struct mutex *fe_mutex)
>>  {
>>        int ret;
>>        struct af9013_state *state = NULL;
>> @@ -1459,6 +1469,7 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
>>
>>        /* setup the state */
>>        state->i2c = i2c;
>> +       state->fe_mutex = fe_mutex;
>>        memcpy(&state->config, config, sizeof(struct af9013_config));
>>
>>        /* download firmware */
>> diff --git a/drivers/media/dvb/frontends/af9013.h b/drivers/media/dvb/frontends/af9013.h
>> index e53d873..95c966a 100644
>> --- a/drivers/media/dvb/frontends/af9013.h
>> +++ b/drivers/media/dvb/frontends/af9013.h
>> @@ -96,10 +96,11 @@ struct af9013_config {
>>  #if defined(CONFIG_DVB_AF9013) || \
>>        (defined(CONFIG_DVB_AF9013_MODULE) && defined(MODULE))
>>  extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
>> -       struct i2c_adapter *i2c);
>> +       struct i2c_adapter *i2c, struct mutex *fe_mutex);
>>  #else
>>  static inline struct dvb_frontend *af9013_attach(
>> -const struct af9013_config *config, struct i2c_adapter *i2c)
>> +       const struct af9013_config *config, struct i2c_adapter *i2,
>> +               struct mutex *fe_mutex)
>>  {
>>        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>>        return NULL;
>> --
>> 1.7.5.4
>>
>>
>
> Thanks!!! I have same device, I apply the patch to the s2-liplianin
> branch and it works well.
>
> Two days on MythTV and there is no pixeled playback and not I2C
> messges on dmesg.
>
> Thank you very much, I was waiting long for this fix.
>
> Kind regards.
>
> --
> Josu Lazkano
>
