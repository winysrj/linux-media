Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34407 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdIOI2K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:28:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170914175059.722ac4f3@vento.lan>
References: <CGME20170914095941epcas5p3520a04d543890249b4952fea48747276@epcas5p3.samsung.com>
 <1505383167-2836-1-git-send-email-satendra.t@samsung.com> <20170914175059.722ac4f3@vento.lan>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 15 Sep 2017 10:28:08 +0200
Message-ID: <CAJbz7-03SU=oTyqhtTiA4fKNSQ=dVG7vPgiLdZrAwzcCcoX=LA@mail.gmail.com>
Subject: Re: [RFC] [DVB][FRONTEND] Added a new ioctl for optimizing frontend
 property set operation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Satendra Singh Thakur <satendra.t@samsung.com>, mchehab@kernel.org,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, hans.verkuil@cisco.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, taeyoung0432.lee@samsung.com,
        jackee.lee@samsung.com, hemanshu.s@samsung.com,
        p.awasthi@samsung.com, siddharth.s@samsung.com,
        madhur.verma@samsung.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-14 22:50 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Hi Satendra,
>
> Em Thu, 14 Sep 2017 05:59:27 -0400
> Satendra Singh Thakur <satendra.t@samsung.com> escreveu:
>
>> -For setting one frontend property , one FE_SET_PROPERTY ioctl is called
>> -Since, size of struct dtv_property is 72 bytes, this ioctl requires
>> ---allocating 72 bytes of memory in user space
>> ---allocating 72 bytes of memory in kernel space
>> ---copying 72 bytes of data from user space to kernel space
>> -However, for all the properties, only 8 out of 72 bytes are used
>>  for setting the property
>
> That's true. Yet, for get, the size can be bigger, as ISDB-T can
> return statistics per layer, plus a global one.
>
>> -Four bytes are needed for specifying property type and another 4 for
>>  property value
>> -Moreover, there are 2 properties DTV_CLEAR and DTV_TUNE which use
>>  only 4 bytes for property name
>> ---They don't use property value
>> -Therefore, we have defined new short variant/forms/version of currently
>>  used structures for such 8 byte properties.
>> -This results in 89% (8*100/72) of memory saving in user and kernel space
>>  each.
>> -This also results in faster copy (8 bytes as compared to 72 bytes) from
>>  user to kernel space
>> -We have added new ioctl FE_SET_PROPERTY_SHORT which utilizes above
>>  mentioned new property structures
>> -This ioctl can co-exist with present ioctl FE_SET_PROPERTY
>> -If the apps wish to use shorter forms they can use
>>  proposed FE_SET_PROPERTY_SHORT, rest of them can continue to use
>>  current versions FE_SET_PROPERTY
>
>> -We are currently not validating incoming properties in
>>  function dtv_property_short_process_set because most of
>>  the frontend drivers in linux source are not using the
>>  method ops.set_property. Just two drivers are using it
>>  drivers/media/dvb-frontends/stv0288.c
>>  driver/media/usb/dvb-usb/friio-fe.c
>>  -Moreover, stv0288 driver implemments blank function
>>  for set_property.
>> -If needed in future, we can define a new
>>  ops.set_property_short method to support
>>  struct dtv_property_short.
>
> Nah. Better to just get rid of get_property()/set_froperty() for good.
>
> Just sent a RFC patch series doing that.
>
> The only thing is that stv6110 seems to have a dirty hack that may
> depend on that. Someone need to double-check if the patch series
> I just sent doesn't break anything. If it breaks, then we'll need
> to add an extra parameter to stv6110 attach for it to know what
> behavior is needed there.

Do you mean in stv6110_set_frequency()?

I must say I was shocked by the beginning of it.
Can somebody explain me the reason for such strange
srate computation?

See the head of function:

static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
{
        struct stv6110_priv *priv = fe->tuner_priv;
        struct dtv_frontend_properties *c = &fe->dtv_property_cache;
        u8 ret = 0x04;
        u32 divider, ref, p, presc, i, result_freq, vco_freq;
        s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
        s32 srate;

        dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
                                                frequency, priv->mclk);

        /* K = (Reference / 1000000) - 16 */
        priv->regs[RSTV6110_CTRL1] &= ~(0x1f << 3);
        priv->regs[RSTV6110_CTRL1] |=
                                ((((priv->mclk / 1000000) - 16) & 0x1f) << 3);

        /* BB_GAIN = db/2 */
        if (fe->ops.set_property && fe->ops.get_property) {
                srate = c->symbol_rate;
                dprintk("%s: Get Frontend parameters: srate=%d\n",
                                                        __func__, srate);
        } else
                srate = 15000000;

^^^^ here I would like to note, there there is NO MORE
anything dependant on srate. It looks like some dead code for me.

And the condition sentence looks even more funny - is it
for real to check of retrieval of srate only in case
if some other function pointers are not null?

/Honza

PS: Don't forget that we have duplicated drivers for STV6110,
stv6110 by Igor and stv6110x by Manu.
