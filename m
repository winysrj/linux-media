Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:27038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0ATWnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 17:43:32 -0500
Received: by fg-out-1718.google.com with SMTP id 22so390455fge.1
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 14:43:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B574BEB.9040509@redhat.com>
References: <846899810912150749q38d8a1ffy96b135cf355fe8eb@mail.gmail.com>
	 <4B27CF77.1050008@redhat.com>
	 <846899810912151620m35a96025hf9ffb924d77eafa8@mail.gmail.com>
	 <846899811001200558g78693d1cy2f399840c6572af0@mail.gmail.com>
	 <4B574BEB.9040509@redhat.com>
Date: Wed, 20 Jan 2010 23:43:29 +0100
Message-ID: <846899811001201443g60bd03edg9bd6fb5a4d3888a8@mail.gmail.com>
Subject: Re: [PATCH v3] isl6421.c - added tone control and temporary diseqc
	overcurrent
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: ajurik@quick.cz, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2010/1/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
> HoP wrote:
>> Hi Mauro,
>>
>> Not to hassle you, I'm sure you're very busy.
>>
>> But I'm not yet received a response from you on mail with corrected patch.
>>
>> Your attention would be appreciated
>
> Hi Honza,
>
> The patch looks correct to me, but, as I previously mentioned, our policy is
> to add new features at the kernel driver only together with a driver that
> actually requires it. This helps to avoid increasing the kernel without need.
>
> So, please re-submit it when you have your driver requiring the isl6421
> changes ready for submission, on the same patch series.
>

Are you sure about such policy?

I did small google research and found out the following:

My feeling is different otherwise I don't understand why did you
accept WITHOUT any word Oliver Endriss' PULL request
from December 12th:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg13302.html

I'm pointing on Oliver's pull request only because he did very similar
thing for lnbp21 like I did for isl6421.

You very quickly added his patch to 2.6.33 on December 16th:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg13429.html

So again. If I'm not blind you have accepted same work from him
but not from me. Please show me what I have overlooked
and this is not true.

Another possible explanation is that I'm totally unknow.

I hope you have some other explanation otherwise it feels to
me like elitism.

Regards

/Honza

> Cheers,
> Mauro.
>>
>> Regards
>>
>> /Honza
>>
>> 2009/12/16 HoP <jpetrous@gmail.com>:
>>> Hi Mauro,
>>>
>>> 2009/12/15 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>> [snip]
>>>
>>>> I'm still missing a driver or a board entry that requires those
>>>> changes. Could you please send it together with this patch series?
>>>>
>>> We are using it in our project. Currently we are in very early
>>> stage of it. We still have some serious issue, what not allows
>>> us sending such code for mainlining.
>>>
>>> Anyway, I don't think it can block accepting current patchset.
>>> Isl6421 driver is already in tree, we only want to add some
>>> features, which can be or can not be interesting for others.
>>>
>>> I believe extending of usability of current drivers is correct
>>> way.
>>>
>>>> Also, you forgot to send your Signed-off-By. This is required for
>>>> patch submission.
>>>>
>>>>> Regards
>>>>>
>>>>> /Honza
>>>>>
>>>>> ---
>>>>>
>>>>> isl6421.c - added tone control and temporary diseqc overcurrent
>>>> Please, always send patches in-lined. makes easier for commenting.
>>>>
>>> OK.
>>>
>>>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
>>>>> --- a/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c Mon Dec 14 17:43:13 2009 -0200
>>>>> +++ b/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c Tue Dec 15 16:36:14 2009 +0100
>>>>> @@ -302,6 +302,12 @@ static struct itd1000_config skystar2_re
>>>>>       .i2c_address = 0x61,
>>>>>  };
>>>>>
>>>>> +static struct isl6421_config skystar2_rev2_7_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = 0x01,
>>>>> +     .override_clear = 0x01,
>>>>> +};
>>>>> +
>>>>>  static int skystar2_rev27_attach(struct flexcop_device *fc,
>>>>>       struct i2c_adapter *i2c)
>>>>>  {
>>>>> @@ -325,7 +331,7 @@ static int skystar2_rev27_attach(struct
>>>>>       /* enable no_base_addr - no repeated start when reading */
>>>>>       fc->fc_i2c_adap[2].no_base_addr = 1;
>>>>>       if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
>>>>> -                     0x08, 1, 1)) {
>>>>> +                     &skystar2_rev2_7_isl6421_config)) {
>>>>>               err("ISL6421 could NOT be attached");
>>>>>               goto fail_isl;
>>>>>       }
>>>>> @@ -368,6 +374,12 @@ static const struct cx24113_config skyst
>>>>>       .xtal_khz = 10111,
>>>>>  };
>>>>>
>>>>> +static struct isl6421_config skystar2_rev2_8_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = 0x00,
>>>>> +     .override_clear = 0x00,
>>>> Please, do not set any static value to zero. Kernel module support already
>>>> does that, and this will just add uneeded stuff into BSS.
>>>>
>>> Done.
>>>
>>>>> +};
>>>>> +
>>>>>  static int skystar2_rev28_attach(struct flexcop_device *fc,
>>>>>       struct i2c_adapter *i2c)
>>>>>  {
>>>>> @@ -391,7 +403,7 @@ static int skystar2_rev28_attach(struct
>>>>>
>>>>>       fc->fc_i2c_adap[2].no_base_addr = 1;
>>>>>       if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
>>>>> -                     0x08, 0, 0)) {
>>>>> +                     &skystar2_rev2_8_isl6421_config)) {
>>>>>               err("ISL6421 could NOT be attached");
>>>>>               fc->fc_i2c_adap[2].no_base_addr = 0;
>>>>>               return 0;
>>>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/frontends/isl6421.c
>>>>> --- a/linux/drivers/media/dvb/frontends/isl6421.c     Mon Dec 14 17:43:13 2009 -0200
>>>>> +++ b/linux/drivers/media/dvb/frontends/isl6421.c     Tue Dec 15 16:36:14 2009 +0100
>>>>> @@ -3,6 +3,9 @@
>>>>>   *
>>>>>   * Copyright (C) 2006 Andrew de Quincey
>>>>>   * Copyright (C) 2006 Oliver Endriss
>>>>> + * Copyright (C) 2009 Ales Jurik and Jan Petrous (added optional 22k tone
>>>>> + *                    support and temporary diseqc overcurrent enable until
>>>>> + *                    next command - set voltage or tone)
>>>>>   *
>>>>>   * This program is free software; you can redistribute it and/or
>>>>>   * modify it under the terms of the GNU General Public License
>>>>> @@ -36,37 +39,88 @@
>>>>>  #include "isl6421.h"
>>>>>
>>>>>  struct isl6421 {
>>>>> -     u8                      config;
>>>>> -     u8                      override_or;
>>>>> -     u8                      override_and;
>>>>> -     struct i2c_adapter      *i2c;
>>>>> -     u8                      i2c_addr;
>>>>> +     const struct isl6421_config     *config;
>>>>> +     u8                              reg1;
>>>> reg1 seems a very bad name. Based on the datasheet, maybe
>>>> you could call it as sys_config or sys_reg_config.
>>>>
>>> Renamed to sys_reg.
>>>
>>>>> +
>>>>> +     struct i2c_adapter *i2c;
>>>>> +
>>>>> +     int (*diseqc_send_master_cmd_orig)(struct dvb_frontend *fe,
>>>>> +                     struct dvb_diseqc_master_cmd *cmd);
>>>>>  };
>>>>>
>>>>>  static int isl6421_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
>>>>>  {
>>>>>       struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>>>> -     struct i2c_msg msg = {  .addr = isl6421->i2c_addr, .flags = 0,
>>>>> -                             .buf = &isl6421->config,
>>>>> -                             .len = sizeof(isl6421->config) };
>>>>> +     struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>>>> +                             .buf = &isl6421->reg1,
>>>>> +                             .len = sizeof(isl6421->reg1) };
>>>>>
>>>>> -     isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
>>>>> +     isl6421->reg1 &= ~(ISL6421_VSEL1 | ISL6421_EN1);
>>>>>
>>>>>       switch(voltage) {
>>>>>       case SEC_VOLTAGE_OFF:
>>>>>               break;
>>>>>       case SEC_VOLTAGE_13:
>>>>> -             isl6421->config |= ISL6421_EN1;
>>>>> +             isl6421->reg1 |= ISL6421_EN1;
>>>>>               break;
>>>>>       case SEC_VOLTAGE_18:
>>>>> -             isl6421->config |= (ISL6421_EN1 | ISL6421_VSEL1);
>>>>> +             isl6421->reg1 |= (ISL6421_EN1 | ISL6421_VSEL1);
>>>>>               break;
>>>>>       default:
>>>>>               return -EINVAL;
>>>>>       };
>>>>>
>>>>> -     isl6421->config |= isl6421->override_or;
>>>>> -     isl6421->config &= isl6421->override_and;
>>>>> +     isl6421->reg1 |= isl6421->config->override_set;
>>>>> +     isl6421->reg1 &= ~isl6421->config->override_clear;
>>>>> +
>>>>> +     return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>>>> +}
>>>>> +
>>>>> +static int isl6421_send_diseqc(struct dvb_frontend *fe,
>>>>> +                             struct dvb_diseqc_master_cmd *cmd)
>>>> Please add a comment explaining that this function is only called
>>>> when diseqc_send_master_cmd_orig() is defined. On a first look, it seemed
>>> OK, similar note added.
>>>
>>>> to me that you would cause a crash by not checking if diseqc_send_master_cmd_orig()
>>>> is not null.
>>>>
>>> Your are right! Thanks. Fixed.
>>>
>>>>> +{
>>>>> +     struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>>>> +     struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>>>> +                             .buf = &isl6421->reg1,
>>>>> +                             .len = sizeof(isl6421->reg1) };
>>>>> +
>>>>> +     isl6421->reg1 |= ISL6421_DCL;
>>>>> +
>>>>> +     isl6421->reg1 |= isl6421->config->override_set;
>>>>> +     isl6421->reg1 &= ~isl6421->config->override_clear;
>>>>> +
>>>>> +     if (i2c_transfer(isl6421->i2c, &msg, 1) != 1)
>>>>> +             return -EIO;
>>>>> +
>>>>> +     isl6421->reg1 &= ~ISL6421_DCL;
>>>>> +
>>>>> +     return isl6421->diseqc_send_master_cmd_orig(fe, cmd);
>>>>> +}
>>>>> +
>>>>> +static int isl6421_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
>>>>> +{
>>>>> +     struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>>>> +     struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>>>> +                             .buf = &isl6421->reg1,
>>>>> +                             .len = sizeof(isl6421->reg1) };
>>>>> +
>>>>> +     isl6421->reg1 &= ~(ISL6421_ENT1);
>>>>> +
>>>>> +     printk(KERN_INFO "%s: %s\n", __func__, ((tone == SEC_TONE_OFF) ?
>>>>> +                             "Off" : "On"));
>>>>> +
>>>>> +     switch (tone) {
>>>>> +     case SEC_TONE_ON:
>>>>> +             isl6421->reg1 |= ISL6421_ENT1;
>>>>> +             break;
>>>>> +     case SEC_TONE_OFF:
>>>>> +             break;
>>>>> +     default:
>>>>> +             return -EINVAL;
>>>>> +     };
>>>>> +
>>>>> +     isl6421->reg1 |= isl6421->config->override_set;
>>>>> +     isl6421->reg1 &= ~isl6421->config->override_clear;
>>>>>
>>>>>       return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>>>>  }
>>>>> @@ -74,49 +128,52 @@ static int isl6421_enable_high_lnb_volta
>>>>>  static int isl6421_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
>>>>>  {
>>>>>       struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>>>> -     struct i2c_msg msg = {  .addr = isl6421->i2c_addr, .flags = 0,
>>>>> -                             .buf = &isl6421->config,
>>>>> -                             .len = sizeof(isl6421->config) };
>>>>> +     struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>>>> +                             .buf = &isl6421->reg1,
>>>>> +                             .len = sizeof(isl6421->reg1) };
>>>>>
>>>>>       if (arg)
>>>>> -             isl6421->config |= ISL6421_LLC1;
>>>>> +             isl6421->reg1 |= ISL6421_LLC1;
>>>>>       else
>>>>> -             isl6421->config &= ~ISL6421_LLC1;
>>>>> +             isl6421->reg1 &= ~ISL6421_LLC1;
>>>>>
>>>>> -     isl6421->config |= isl6421->override_or;
>>>>> -     isl6421->config &= isl6421->override_and;
>>>>> +     isl6421->reg1 |= isl6421->config->override_set;
>>>>> +     isl6421->reg1 &= ~isl6421->config->override_clear;
>>>>>
>>>>>       return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>>>>  }
>>>>>
>>>>>  static void isl6421_release(struct dvb_frontend *fe)
>>>>>  {
>>>>> +     struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>>>> +
>>>>>       /* power off */
>>>>>       isl6421_set_voltage(fe, SEC_VOLTAGE_OFF);
>>>>> +
>>>>> +     if (isl6421->config->disable_overcurrent_protection)
>>>>> +             fe->ops.diseqc_send_master_cmd =
>>>>> +                     isl6421->diseqc_send_master_cmd_orig;
>>>> You need to test if this function pointer were defined or not at the config struct.
>>>>
>>> Why? If original value was NULL, then there should be no problem
>>> to reassign back to NULL.
>>>
>>>>>       /* free */
>>>>>       kfree(fe->sec_priv);
>>>>>       fe->sec_priv = NULL;
>>>>>  }
>>>>>
>>>>> -struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
>>>>> -                u8 override_set, u8 override_clear)
>>>>> +struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>>>> +                                        struct i2c_adapter *i2c,
>>>>> +                                        const struct isl6421_config *config)
>>>>>  {
>>>>>       struct isl6421 *isl6421 = kmalloc(sizeof(struct isl6421), GFP_KERNEL);
>>>>> +
>>>>>       if (!isl6421)
>>>>>               return NULL;
>>>>>
>>>>> -     /* default configuration */
>>>>> -     isl6421->config = ISL6421_ISEL1;
>>>>> +     isl6421->config = config;
>>>>>       isl6421->i2c = i2c;
>>>>> -     isl6421->i2c_addr = i2c_addr;
>>>>>       fe->sec_priv = isl6421;
>>>>>
>>>>> -     /* bits which should be forced to '1' */
>>>>> -     isl6421->override_or = override_set;
>>>>> -
>>>>> -     /* bits which should be forced to '0' */
>>>>> -     isl6421->override_and = ~override_clear;
>>>>> +     /* default configuration */
>>>>> +     isl6421->reg1 = ISL6421_ISEL1;
>>>>>
>>>>>       /* detect if it is present or not */
>>>>>       if (isl6421_set_voltage(fe, SEC_VOLTAGE_OFF)) {
>>>>> @@ -131,11 +188,38 @@ struct dvb_frontend *isl6421_attach(stru
>>>>>       /* override frontend ops */
>>>>>       fe->ops.set_voltage = isl6421_set_voltage;
>>>>>       fe->ops.enable_high_lnb_voltage = isl6421_enable_high_lnb_voltage;
>>>>> +     if (config->tone_control)
>>>>> +             fe->ops.set_tone = isl6421_set_tone;
>>>>> +
>>>>> +     printk(KERN_INFO "ISL6421 attached on addr=%x\n", config->i2c_addr);
>>>>> +
>>>>> +     if (config->disable_overcurrent_protection) {
>>>>> +             if ((config->override_set & ISL6421_DCL) ||
>>>>> +                             (config->override_clear & ISL6421_DCL)) {
>>>>> +                     /* there is no sense to use overcurrent_enable
>>>>> +                      * with DCL bit set in any override byte */
>>>>> +                     if (config->override_set & ISL6421_DCL)
>>>>> +                             printk(KERN_WARNING "ISL6421 overcurrent_enable"
>>>>> +                                             " with DCL bit in override_set,"
>>>>> +                                             " overcurrent_enable ignored\n");
>>>>> +                     if (config->override_clear & ISL6421_DCL)
>>>>> +                             printk(KERN_WARNING "ISL6421 overcurrent_enable"
>>>>> +                                             " with DCL bit in override_clear,"
>>>>> +                                             " overcurrent_enable ignored\n");
>>>>> +             } else {
>>>>> +                     printk(KERN_WARNING "ISL6421 overcurrent_enable "
>>>>> +                                     " activated. WARNING: it can be "
>>>>> +                                     " dangerous for your hardware!");
>>>>> +                     isl6421->diseqc_send_master_cmd_orig =
>>>>> +                             fe->ops.diseqc_send_master_cmd;
>>>>> +                     fe->ops.diseqc_send_master_cmd = isl6421_send_diseqc;
>>>>> +             }
>>>>> +     }
>>>>>
>>>>>       return fe;
>>>>>  }
>>>>>  EXPORT_SYMBOL(isl6421_attach);
>>>>>
>>>>>  MODULE_DESCRIPTION("Driver for lnb supply and control ic isl6421");
>>>>> -MODULE_AUTHOR("Andrew de Quincey & Oliver Endriss");
>>>>> +MODULE_AUTHOR("Andrew de Quincey,Oliver Endriss,Ales Jurik,Jan Petrous");
>>>>>  MODULE_LICENSE("GPL");
>>>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/frontends/isl6421.h
>>>>> --- a/linux/drivers/media/dvb/frontends/isl6421.h     Mon Dec 14 17:43:13 2009 -0200
>>>>> +++ b/linux/drivers/media/dvb/frontends/isl6421.h     Tue Dec 15 16:36:14 2009 +0100
>>>>> @@ -39,14 +39,40 @@
>>>>>  #define ISL6421_ISEL1        0x20
>>>>>  #define ISL6421_DCL  0x40
>>>>>
>>>>> +struct isl6421_config {
>>>>> +     /* I2C address */
>>>>> +     u8 i2c_addr;
>>>>> +
>>>>> +     /* Enable DISEqC tone control mode */
>>>>> +     bool tone_control;
>>>>> +
>>>>> +     /*
>>>>> +      * Disable isl6421 overcurrent protection.
>>>>> +      *
>>>>> +      * WARNING: Don't disable the protection unless you are 100% sure about
>>>>> +      *          what you're doing, otherwise you may damage your board.
>>>>> +      *          Only a few designs require to disable the protection, since
>>>>> +      *          the hardware designer opted to use a hardware protection instead
>>>>> +      */
>>>>> +     bool disable_overcurrent_protection;
>>>>> +
>>>>> +     /* bits which should be forced to '1' */
>>>>> +     u8 override_set;
>>>>> +
>>>>> +     /* bits which should be forced to '0' */
>>>>> +     u8 override_clear;
>>>>> +};
>>>>> +
>>>>> +
>>>>>  #if defined(CONFIG_DVB_ISL6421) || (defined(CONFIG_DVB_ISL6421_MODULE) && defined(MODULE))
>>>>>  /* override_set and override_clear control which system register bits (above) to always set & clear */
>>>>> -extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
>>>>> -                       u8 override_set, u8 override_clear);
>>>>> +extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>>>> +                                        struct i2c_adapter *i2c,
>>>>> +                                        const struct isl6421_config *config);
>>>>>  #else
>>>>> -static inline struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
>>>>> -                                               u8 override_set, u8 override_clear)
>>>>> -{
>>>>> +static struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>>>> +                                        struct i2c_adapter *i2c,
>>>>> +                                        const struct isl6421_config *config);
>>>>>       printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>>>>>       return NULL;
>>>>>  }
>>>>> diff -r 79fc32bba0a0 linux/drivers/media/video/cx88/cx88-dvb.c
>>>>> --- a/linux/drivers/media/video/cx88/cx88-dvb.c       Mon Dec 14 17:43:13 2009 -0200
>>>>> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c       Tue Dec 15 16:36:14 2009 +0100
>>>>> @@ -456,6 +456,12 @@ static struct cx24123_config hauppauge_n
>>>>>       .set_ts_params = cx24123_set_ts_param,
>>>>>  };
>>>>>
>>>>> +static struct isl6421_config hauppauge_novas_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = ISL6421_DCL,
>>>>> +     .override_clear = 0x00,
>>>> Don't initialize a value with zero.
>>>>
>>> Done.
>>>
>>>>> +};
>>>>> +
>>>>>  static struct cx24123_config kworld_dvbs_100_config = {
>>>>>       .demod_address = 0x15,
>>>>>       .set_ts_params = cx24123_set_ts_param,
>>>>> @@ -614,6 +620,12 @@ static struct cx24116_config hauppauge_h
>>>>>       .reset_device           = cx24116_reset_device,
>>>>>  };
>>>>>
>>>>> +static struct isl6421_config hauppauge_hvr4000_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = ISL6421_DCL,
>>>>> +     .override_clear = 0x00,
>>>> Don't initialize a value with zero.
>>>>
>>> Done.
>>>
>>>>> +};
>>>>> +
>>>>>  static struct cx24116_config tevii_s460_config = {
>>>>>       .demod_address = 0x55,
>>>>>       .set_ts_params = cx24116_set_ts_param,
>>>>> @@ -757,7 +769,7 @@ static int dvb_register(struct cx8802_de
>>>>>                       if (!dvb_attach(isl6421_attach,
>>>>>                                       fe0->dvb.frontend,
>>>>>                                       &dev->core->i2c_adap,
>>>>> -                                     0x08, ISL6421_DCL, 0x00))
>>>>> +                                     &hauppauge_novas_isl6421_config))
>>>>>                               goto frontend_detach;
>>>>>               }
>>>>>               /* MFE frontend 2 */
>>>>> @@ -995,7 +1007,8 @@ static int dvb_register(struct cx8802_de
>>>>>                                              &core->i2c_adap);
>>>>>               if (fe0->dvb.frontend) {
>>>>>                       if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
>>>>> -                                     &core->i2c_adap, 0x08, ISL6421_DCL, 0x00))
>>>>> +                                     &core->i2c_adap,
>>>>> +                                     &hauppauge_novas_isl6421_config))
>>>>>                               goto frontend_detach;
>>>>>               }
>>>>>               break;
>>>>> @@ -1100,7 +1113,7 @@ static int dvb_register(struct cx8802_de
>>>>>                       if (!dvb_attach(isl6421_attach,
>>>>>                                       fe0->dvb.frontend,
>>>>>                                       &dev->core->i2c_adap,
>>>>> -                                     0x08, ISL6421_DCL, 0x00))
>>>>> +                                     &hauppauge_hvr4000_isl6421_config))
>>>>>                               goto frontend_detach;
>>>>>               }
>>>>>               /* MFE frontend 2 */
>>>>> @@ -1128,7 +1141,7 @@ static int dvb_register(struct cx8802_de
>>>>>                       if (!dvb_attach(isl6421_attach,
>>>>>                                       fe0->dvb.frontend,
>>>>>                                       &dev->core->i2c_adap,
>>>>> -                                     0x08, ISL6421_DCL, 0x00))
>>>>> +                                     &hauppauge_hvr4000_isl6421_config))
>>>>>                               goto frontend_detach;
>>>>>               }
>>>>>               break;
>>>>> diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-dvb.c
>>>>> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c Mon Dec 14 17:43:13 2009 -0200
>>>>> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c Tue Dec 15 16:36:14 2009 +0100
>>>>> @@ -716,6 +716,12 @@ static struct tda1004x_config lifeview_t
>>>>>       .request_firmware = philips_tda1004x_request_firmware
>>>>>  };
>>>>>
>>>>> +static struct isl6421_config lifeview_trio_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = 0x00,
>>>>> +     .override_clear = 0x00,
>>>> Don't initialize a value with zero.
>>>>
>>> Done.
>>>
>>>>> +};
>>>>> +
>>>>>  static struct tda1004x_config tevion_dvbt220rf_config = {
>>>>>       .demod_address = 0x08,
>>>>>       .invert        = 1,
>>>>> @@ -895,6 +901,12 @@ static struct tda10086_config flydvbs =
>>>>>       .invert = 0,
>>>>>       .diseqc_tone = 0,
>>>>>       .xtal_freq = TDA10086_XTAL_16M,
>>>>> +};
>>>>> +
>>>>> +static struct isl6421_config flydvbs_isl6421_config = {
>>>>> +     .i2c_address = 0x08,
>>>>> +     .override_set = 0x00,
>>>>> +     .override_clear = 0x00,
>>>> Don't initialize a value with zero.
>>>>
>>> Done.
>>>
>>>>>  };
>>>>>
>>>>>  static struct tda10086_config sd1878_4m = {
>>>>> @@ -1248,7 +1260,7 @@ static int dvb_init(struct saa7134_dev *
>>>>>                                       goto dettach_frontend;
>>>>>                               }
>>>>>                               if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
>>>>> -                                                                             0x08, 0, 0) == NULL) {
>>>>> +                                                                     &lifeview_trio_isl6421_config) == NULL) {
>>>>>                                       wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
>>>>>                                       goto dettach_frontend;
>>>>>                               }
>>>>> @@ -1349,7 +1361,8 @@ static int dvb_init(struct saa7134_dev *
>>>>>                               goto dettach_frontend;
>>>>>                       }
>>>>>                       if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
>>>>> -                                    &dev->i2c_adap, 0x08, 0, 0) == NULL) {
>>>>> +                                    &dev->i2c_adap,
>>>>> +                                    &flydvbs_isl6421_config) == NULL) {
>>>>>                               wprintk("%s: No ISL6421 found!\n", __func__);
>>>>>                               goto dettach_frontend;
>>>>>                       }
>>>>
>>>>
>>> I hope mailer not squash patch somehow
>>>
>>> Regards
>>>
>>> /Honza
>>>
>>> ---
>>>
>>> isl6421.c - added tone control and temporary diseqc overcurrent
>>>
>>> Signed-off-by: Jan Petrous <jpetrous@gmail.com>
>>> Signed-off-by: Ales Jurik <ajurik@quick.cz>
>>>
>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
>>> --- a/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c   Mon Dec 14
>>> 17:43:13 2009 -0200
>>> +++ b/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c   Wed Dec 16
>>> 01:08:05 2009 +0100
>>> @@ -302,6 +302,12 @@ static struct itd1000_config skystar2_re
>>>        .i2c_address = 0x61,
>>>  };
>>>
>>> +static struct isl6421_config skystar2_rev2_7_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>> +       .override_set = 0x01,
>>> +       .override_clear = 0x01,
>>> +};
>>> +
>>>  static int skystar2_rev27_attach(struct flexcop_device *fc,
>>>        struct i2c_adapter *i2c)
>>>  {
>>> @@ -325,7 +331,7 @@ static int skystar2_rev27_attach(struct
>>>        /* enable no_base_addr - no repeated start when reading */
>>>        fc->fc_i2c_adap[2].no_base_addr = 1;
>>>        if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
>>> -                       0x08, 1, 1)) {
>>> +                       &skystar2_rev2_7_isl6421_config)) {
>>>                err("ISL6421 could NOT be attached");
>>>                goto fail_isl;
>>>        }
>>> @@ -368,6 +374,10 @@ static const struct cx24113_config skyst
>>>        .xtal_khz = 10111,
>>>  };
>>>
>>> +static struct isl6421_config skystar2_rev2_8_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>> +};
>>> +
>>>  static int skystar2_rev28_attach(struct flexcop_device *fc,
>>>        struct i2c_adapter *i2c)
>>>  {
>>> @@ -391,7 +401,7 @@ static int skystar2_rev28_attach(struct
>>>
>>>        fc->fc_i2c_adap[2].no_base_addr = 1;
>>>        if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
>>> -                       0x08, 0, 0)) {
>>> +                       &skystar2_rev2_8_isl6421_config)) {
>>>                err("ISL6421 could NOT be attached");
>>>                fc->fc_i2c_adap[2].no_base_addr = 0;
>>>                return 0;
>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/frontends/isl6421.c
>>> --- a/linux/drivers/media/dvb/frontends/isl6421.c       Mon Dec 14 17:43:13 2009 -0200
>>> +++ b/linux/drivers/media/dvb/frontends/isl6421.c       Wed Dec 16 01:08:05 2009 +0100
>>> @@ -3,6 +3,9 @@
>>>  *
>>>  * Copyright (C) 2006 Andrew de Quincey
>>>  * Copyright (C) 2006 Oliver Endriss
>>> + * Copyright (C) 2009 Ales Jurik and Jan Petrous (added optional 22k tone
>>> + *                    support and temporary diseqc overcurrent enable until
>>> + *                    next command - set voltage or tone)
>>>  *
>>>  * This program is free software; you can redistribute it and/or
>>>  * modify it under the terms of the GNU General Public License
>>> @@ -36,37 +39,91 @@
>>>  #include "isl6421.h"
>>>
>>>  struct isl6421 {
>>> -       u8                      config;
>>> -       u8                      override_or;
>>> -       u8                      override_and;
>>> -       struct i2c_adapter      *i2c;
>>> -       u8                      i2c_addr;
>>> +       const struct isl6421_config     *config;
>>> +       u8                              sys_reg;
>>> +
>>> +       struct i2c_adapter *i2c;
>>> +
>>> +       int (*diseqc_send_master_cmd_orig)(struct dvb_frontend *fe,
>>> +                       struct dvb_diseqc_master_cmd *cmd);
>>>  };
>>>
>>>  static int isl6421_set_voltage(struct dvb_frontend *fe,
>>> fe_sec_voltage_t voltage)
>>>  {
>>>        struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>> -       struct i2c_msg msg = {  .addr = isl6421->i2c_addr, .flags = 0,
>>> -                               .buf = &isl6421->config,
>>> -                               .len = sizeof(isl6421->config) };
>>> +       struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>> +                               .buf = &isl6421->sys_reg,
>>> +                               .len = sizeof(isl6421->sys_reg) };
>>>
>>> -       isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
>>> +       isl6421->sys_reg &= ~(ISL6421_VSEL1 | ISL6421_EN1);
>>>
>>>        switch(voltage) {
>>>        case SEC_VOLTAGE_OFF:
>>>                break;
>>>        case SEC_VOLTAGE_13:
>>> -               isl6421->config |= ISL6421_EN1;
>>> +               isl6421->sys_reg |= ISL6421_EN1;
>>>                break;
>>>        case SEC_VOLTAGE_18:
>>> -               isl6421->config |= (ISL6421_EN1 | ISL6421_VSEL1);
>>> +               isl6421->sys_reg |= (ISL6421_EN1 | ISL6421_VSEL1);
>>>                break;
>>>        default:
>>>                return -EINVAL;
>>>        };
>>>
>>> -       isl6421->config |= isl6421->override_or;
>>> -       isl6421->config &= isl6421->override_and;
>>> +       isl6421->sys_reg |= isl6421->config->override_set;
>>> +       isl6421->sys_reg &= ~isl6421->config->override_clear;
>>> +
>>> +       return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>> +}
>>> +
>>> +/* Hooked to fe->ops.diseqc_send_master_cmd() only
>>> +   when disable_overcurrent_protection=1 */
>>> +static int isl6421_send_diseqc(struct dvb_frontend *fe,
>>> +                               struct dvb_diseqc_master_cmd *cmd)
>>> +{
>>> +       struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>> +       struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>> +                               .buf = &isl6421->sys_reg,
>>> +                               .len = sizeof(isl6421->sys_reg) };
>>> +
>>> +       isl6421->sys_reg |= ISL6421_DCL;
>>> +
>>> +       isl6421->sys_reg |= isl6421->config->override_set;
>>> +       isl6421->sys_reg &= ~isl6421->config->override_clear;
>>> +
>>> +       if (i2c_transfer(isl6421->i2c, &msg, 1) != 1)
>>> +               return -EIO;
>>> +
>>> +       isl6421->sys_reg &= ~ISL6421_DCL;
>>> +
>>> +       return isl6421->diseqc_send_master_cmd_orig ?
>>> +               isl6421->diseqc_send_master_cmd_orig(fe, cmd) : -EIO;
>>> +}
>>> +
>>> +static int isl6421_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
>>> +{
>>> +       struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>> +       struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>> +                               .buf = &isl6421->sys_reg,
>>> +                               .len = sizeof(isl6421->sys_reg) };
>>> +
>>> +       isl6421->sys_reg &= ~(ISL6421_ENT1);
>>> +
>>> +       printk(KERN_INFO "%s: %s\n", __func__, ((tone == SEC_TONE_OFF) ?
>>> +                               "Off" : "On"));
>>> +
>>> +       switch (tone) {
>>> +       case SEC_TONE_ON:
>>> +               isl6421->sys_reg |= ISL6421_ENT1;
>>> +               break;
>>> +       case SEC_TONE_OFF:
>>> +               break;
>>> +       default:
>>> +               return -EINVAL;
>>> +       };
>>> +
>>> +       isl6421->sys_reg |= isl6421->config->override_set;
>>> +       isl6421->sys_reg &= ~isl6421->config->override_clear;
>>>
>>>        return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>>  }
>>> @@ -74,49 +131,52 @@ static int isl6421_enable_high_lnb_volta
>>>  static int isl6421_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
>>>  {
>>>        struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>> -       struct i2c_msg msg = {  .addr = isl6421->i2c_addr, .flags = 0,
>>> -                               .buf = &isl6421->config,
>>> -                               .len = sizeof(isl6421->config) };
>>> +       struct i2c_msg msg = {  .addr = isl6421->config->i2c_addr, .flags = 0,
>>> +                               .buf = &isl6421->sys_reg,
>>> +                               .len = sizeof(isl6421->sys_reg) };
>>>
>>>        if (arg)
>>> -               isl6421->config |= ISL6421_LLC1;
>>> +               isl6421->sys_reg |= ISL6421_LLC1;
>>>        else
>>> -               isl6421->config &= ~ISL6421_LLC1;
>>> +               isl6421->sys_reg &= ~ISL6421_LLC1;
>>>
>>> -       isl6421->config |= isl6421->override_or;
>>> -       isl6421->config &= isl6421->override_and;
>>> +       isl6421->sys_reg |= isl6421->config->override_set;
>>> +       isl6421->sys_reg &= ~isl6421->config->override_clear;
>>>
>>>        return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
>>>  }
>>>
>>>  static void isl6421_release(struct dvb_frontend *fe)
>>>  {
>>> +       struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
>>> +
>>>        /* power off */
>>>        isl6421_set_voltage(fe, SEC_VOLTAGE_OFF);
>>> +
>>> +       if (isl6421->config->disable_overcurrent_protection)
>>> +               fe->ops.diseqc_send_master_cmd =
>>> +                       isl6421->diseqc_send_master_cmd_orig;
>>>
>>>        /* free */
>>>        kfree(fe->sec_priv);
>>>        fe->sec_priv = NULL;
>>>  }
>>>
>>> -struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct
>>> i2c_adapter *i2c, u8 i2c_addr,
>>> -                  u8 override_set, u8 override_clear)
>>> +struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>> +                                          struct i2c_adapter *i2c,
>>> +                                          const struct isl6421_config *config)
>>>  {
>>>        struct isl6421 *isl6421 = kmalloc(sizeof(struct isl6421), GFP_KERNEL);
>>> +
>>>        if (!isl6421)
>>>                return NULL;
>>>
>>> -       /* default configuration */
>>> -       isl6421->config = ISL6421_ISEL1;
>>> +       isl6421->config = config;
>>>        isl6421->i2c = i2c;
>>> -       isl6421->i2c_addr = i2c_addr;
>>>        fe->sec_priv = isl6421;
>>>
>>> -       /* bits which should be forced to '1' */
>>> -       isl6421->override_or = override_set;
>>> -
>>> -       /* bits which should be forced to '0' */
>>> -       isl6421->override_and = ~override_clear;
>>> +       /* default configuration */
>>> +       isl6421->sys_reg = ISL6421_ISEL1;
>>>
>>>        /* detect if it is present or not */
>>>        if (isl6421_set_voltage(fe, SEC_VOLTAGE_OFF)) {
>>> @@ -131,11 +191,38 @@ struct dvb_frontend *isl6421_attach(stru
>>>        /* override frontend ops */
>>>        fe->ops.set_voltage = isl6421_set_voltage;
>>>        fe->ops.enable_high_lnb_voltage = isl6421_enable_high_lnb_voltage;
>>> +       if (config->tone_control)
>>> +               fe->ops.set_tone = isl6421_set_tone;
>>> +
>>> +       printk(KERN_INFO "ISL6421 attached on addr=%x\n", config->i2c_addr);
>>> +
>>> +       if (config->disable_overcurrent_protection) {
>>> +               if ((config->override_set & ISL6421_DCL) ||
>>> +                               (config->override_clear & ISL6421_DCL)) {
>>> +                       /* there is no sense to use overcurrent_enable
>>> +                        * with DCL bit set in any override byte */
>>> +                       if (config->override_set & ISL6421_DCL)
>>> +                               printk(KERN_WARNING "ISL6421 overcurrent_enable"
>>> +                                               " with DCL bit in override_set,"
>>> +                                               " overcurrent_enable ignored\n");
>>> +                       if (config->override_clear & ISL6421_DCL)
>>> +                               printk(KERN_WARNING "ISL6421 overcurrent_enable"
>>> +                                               " with DCL bit in override_clear,"
>>> +                                               " overcurrent_enable ignored\n");
>>> +               } else {
>>> +                       printk(KERN_WARNING "ISL6421 overcurrent_enable "
>>> +                                       " activated. WARNING: it can be "
>>> +                                       " dangerous for your hardware!");
>>> +                       isl6421->diseqc_send_master_cmd_orig =
>>> +                               fe->ops.diseqc_send_master_cmd;
>>> +                       fe->ops.diseqc_send_master_cmd = isl6421_send_diseqc;
>>> +               }
>>> +       }
>>>
>>>        return fe;
>>>  }
>>>  EXPORT_SYMBOL(isl6421_attach);
>>>
>>>  MODULE_DESCRIPTION("Driver for lnb supply and control ic isl6421");
>>> -MODULE_AUTHOR("Andrew de Quincey & Oliver Endriss");
>>> +MODULE_AUTHOR("Andrew de Quincey,Oliver Endriss,Ales Jurik,Jan Petrous");
>>>  MODULE_LICENSE("GPL");
>>> diff -r 79fc32bba0a0 linux/drivers/media/dvb/frontends/isl6421.h
>>> --- a/linux/drivers/media/dvb/frontends/isl6421.h       Mon Dec 14 17:43:13 2009 -0200
>>> +++ b/linux/drivers/media/dvb/frontends/isl6421.h       Wed Dec 16 01:08:05 2009 +0100
>>> @@ -39,14 +39,40 @@
>>>  #define ISL6421_ISEL1  0x20
>>>  #define ISL6421_DCL    0x40
>>>
>>> +struct isl6421_config {
>>> +       /* I2C address */
>>> +       u8 i2c_addr;
>>> +
>>> +       /* Enable DISEqC tone control mode */
>>> +       bool tone_control;
>>> +
>>> +       /*
>>> +        * Disable isl6421 overcurrent protection.
>>> +        *
>>> +        * WARNING: Don't disable the protection unless you are 100% sure about
>>> +        *          what you're doing, otherwise you may damage your board.
>>> +        *          Only a few designs require to disable the protection, since
>>> +        *          the hardware designer opted to use a hardware protection instead
>>> +        */
>>> +       bool disable_overcurrent_protection;
>>> +
>>> +       /* bits which should be forced to '1' */
>>> +       u8 override_set;
>>> +
>>> +       /* bits which should be forced to '0' */
>>> +       u8 override_clear;
>>> +};
>>> +
>>> +
>>>  #if defined(CONFIG_DVB_ISL6421) ||
>>> (defined(CONFIG_DVB_ISL6421_MODULE) && defined(MODULE))
>>>  /* override_set and override_clear control which system register bits
>>> (above) to always set & clear */
>>> -extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>> struct i2c_adapter *i2c, u8 i2c_addr,
>>> -                         u8 override_set, u8 override_clear);
>>> +extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>> +                                          struct i2c_adapter *i2c,
>>> +                                          const struct isl6421_config *config);
>>>  #else
>>> -static inline struct dvb_frontend *isl6421_attach(struct dvb_frontend
>>> *fe, struct i2c_adapter *i2c, u8 i2c_addr,
>>> -                                                 u8 override_set, u8 override_clear)
>>> -{
>>> +static struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe,
>>> +                                          struct i2c_adapter *i2c,
>>> +                                          const struct isl6421_config *config);
>>>        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>>>        return NULL;
>>>  }
>>> diff -r 79fc32bba0a0 linux/drivers/media/video/cx88/cx88-dvb.c
>>> --- a/linux/drivers/media/video/cx88/cx88-dvb.c Mon Dec 14 17:43:13 2009 -0200
>>> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Wed Dec 16 01:08:05 2009 +0100
>>> @@ -456,6 +456,11 @@ static struct cx24123_config hauppauge_n
>>>        .set_ts_params = cx24123_set_ts_param,
>>>  };
>>>
>>> +static struct isl6421_config hauppauge_novas_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>> +       .override_set = ISL6421_DCL,
>>> +};
>>> +
>>>  static struct cx24123_config kworld_dvbs_100_config = {
>>>        .demod_address = 0x15,
>>>        .set_ts_params = cx24123_set_ts_param,
>>> @@ -614,6 +619,11 @@ static struct cx24116_config hauppauge_h
>>>        .reset_device           = cx24116_reset_device,
>>>  };
>>>
>>> +static struct isl6421_config hauppauge_hvr4000_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>> +       .override_set = ISL6421_DCL,
>>> +};
>>> +
>>>  static struct cx24116_config tevii_s460_config = {
>>>        .demod_address = 0x55,
>>>        .set_ts_params = cx24116_set_ts_param,
>>> @@ -757,7 +767,7 @@ static int dvb_register(struct cx8802_de
>>>                        if (!dvb_attach(isl6421_attach,
>>>                                        fe0->dvb.frontend,
>>>                                        &dev->core->i2c_adap,
>>> -                                       0x08, ISL6421_DCL, 0x00))
>>> +                                       &hauppauge_novas_isl6421_config))
>>>                                goto frontend_detach;
>>>                }
>>>                /* MFE frontend 2 */
>>> @@ -995,7 +1005,8 @@ static int dvb_register(struct cx8802_de
>>>                                               &core->i2c_adap);
>>>                if (fe0->dvb.frontend) {
>>>                        if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
>>> -                                       &core->i2c_adap, 0x08, ISL6421_DCL, 0x00))
>>> +                                       &core->i2c_adap,
>>> +                                       &hauppauge_novas_isl6421_config))
>>>                                goto frontend_detach;
>>>                }
>>>                break;
>>> @@ -1100,7 +1111,7 @@ static int dvb_register(struct cx8802_de
>>>                        if (!dvb_attach(isl6421_attach,
>>>                                        fe0->dvb.frontend,
>>>                                        &dev->core->i2c_adap,
>>> -                                       0x08, ISL6421_DCL, 0x00))
>>> +                                       &hauppauge_hvr4000_isl6421_config))
>>>                                goto frontend_detach;
>>>                }
>>>                /* MFE frontend 2 */
>>> @@ -1128,7 +1139,7 @@ static int dvb_register(struct cx8802_de
>>>                        if (!dvb_attach(isl6421_attach,
>>>                                        fe0->dvb.frontend,
>>>                                        &dev->core->i2c_adap,
>>> -                                       0x08, ISL6421_DCL, 0x00))
>>> +                                       &hauppauge_hvr4000_isl6421_config))
>>>                                goto frontend_detach;
>>>                }
>>>                break;
>>> diff -r 79fc32bba0a0 linux/drivers/media/video/saa7134/saa7134-dvb.c
>>> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c   Mon Dec 14
>>> 17:43:13 2009 -0200
>>> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c   Wed Dec 16
>>> 01:08:05 2009 +0100
>>> @@ -716,6 +716,10 @@ static struct tda1004x_config lifeview_t
>>>        .request_firmware = philips_tda1004x_request_firmware
>>>  };
>>>
>>> +static struct isl6421_config lifeview_trio_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>> +};
>>> +
>>>  static struct tda1004x_config tevion_dvbt220rf_config = {
>>>        .demod_address = 0x08,
>>>        .invert        = 1,
>>> @@ -895,6 +899,10 @@ static struct tda10086_config flydvbs =
>>>        .invert = 0,
>>>        .diseqc_tone = 0,
>>>        .xtal_freq = TDA10086_XTAL_16M,
>>> +};
>>> +
>>> +static struct isl6421_config flydvbs_isl6421_config = {
>>> +       .i2c_address = 0x08,
>>>  };
>>>
>>>  static struct tda10086_config sd1878_4m = {
>>> @@ -1248,7 +1256,7 @@ static int dvb_init(struct saa7134_dev *
>>>                                        goto dettach_frontend;
>>>                                }
>>>                                if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
>>> -                                                                               0x08, 0, 0) == NULL) {
>>> +                                                                       &lifeview_trio_isl6421_config) == NULL) {
>>>                                        wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
>>>                                        goto dettach_frontend;
>>>                                }
>>> @@ -1349,7 +1357,8 @@ static int dvb_init(struct saa7134_dev *
>>>                                goto dettach_frontend;
>>>                        }
>>>                        if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
>>> -                                      &dev->i2c_adap, 0x08, 0, 0) == NULL) {
>>> +                                      &dev->i2c_adap,
>>> +                                      &flydvbs_isl6421_config) == NULL) {
>>>                                wprintk("%s: No ISL6421 found!\n", __func__);
>>>                                goto dettach_frontend;
>>>                        }
>>>
>
>
