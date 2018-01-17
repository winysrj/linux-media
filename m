Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:50932 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753059AbeAQWIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 17:08:10 -0500
Received: from homiemail-a123.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id C28E4908C2
        for <linux-media@vger.kernel.org>; Wed, 17 Jan 2018 14:08:09 -0800 (PST)
Subject: Re: [PATCH v2 1/2] si2168: Add spectrum inversion property
To: Antti Palosaari <crope@iki.fi>, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org
References: <1516224756-1649-2-git-send-email-brad@nextdimension.cc>
 <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
 <dbcea672-b748-0521-b9c1-6aac14b1deac@iki.fi>
From: Brad Love <brad@b-rad.cc>
Message-ID: <2e882928-5c1b-b9ad-96dc-bb41346a32b1@b-rad.cc>
Date: Wed, 17 Jan 2018 16:08:08 -0600
MIME-Version: 1.0
In-Reply-To: <dbcea672-b748-0521-b9c1-6aac14b1deac@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-17 16:02, Antti Palosaari wrote:
>
>
> On 01/17/2018 11:52 PM, Brad Love wrote:
>> Some tuners produce inverted spectrum, but the si2168 is not
>> currently set up to accept it. This adds an optional parameter
>> to set the frontend up to receive inverted spectrum.
>>
>> Parameter is optional and only boards who enable inversion
>> will utilize this.
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>> Changes since v1:
>> - Embarassing build failure due to missing declaration.
>>
>> =C2=A0 drivers/media/dvb-frontends/si2168.c | 3 +++
>> =C2=A0 drivers/media/dvb-frontends/si2168.h | 3 +++
>> =C2=A0 2 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/dvb-frontends/si2168.c
>> b/drivers/media/dvb-frontends/si2168.c
>> index c041e79..048b815 100644
>> --- a/drivers/media/dvb-frontends/si2168.c
>> +++ b/drivers/media/dvb-frontends/si2168.c
>> @@ -213,6 +213,7 @@ static int si2168_set_frontend(struct
>> dvb_frontend *fe)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct i2c_client *client =3D fe->demod=
ulator_priv;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2168_dev *dev =3D i2c_get_clie=
ntdata(client);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dtv_frontend_properties *c =3D &=
fe->dtv_property_cache;
>> +=C2=A0=C2=A0=C2=A0 struct si2168_config *config =3D client->dev.platf=
orm_data;
>
> hmmm, are you sure platform data pointer points is const? I usually
> tend to store all config information to device state. Then there is no
> need to care if pointer is valid or not anymore.
>
> And inversion happens when those wires are cross-connected

It just dawned on me that the platform_data is stack allocated and
therefore not safe to access outside of probe. I will fix this momentaril=
y.

I was informed by one of our hardware guys that the two models in patch
2/2 are inverted spectrum, so I guess they have wires cross-connected. I
can verify this again to be sure.



>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2168_cmd cmd;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 bandwidth, delivery_system;
>> @@ -339,6 +340,8 @@ static int si2168_set_frontend(struct
>> dvb_frontend *fe)
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(cmd.args, "\x14\x00\x0a\x=
10\x00\x00", 6);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd.args[4] =3D delivery_system | bandw=
idth;
>> +=C2=A0=C2=A0=C2=A0 if (config->spectral_inversion)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd.args[5] |=3D 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd.wlen =3D 6;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd.rlen =3D 4;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D si2168_cmd_execute(client, &cmd=
);
>> diff --git a/drivers/media/dvb-frontends/si2168.h
>> b/drivers/media/dvb-frontends/si2168.h
>> index f48f0fb..d519edd 100644
>> --- a/drivers/media/dvb-frontends/si2168.h
>> +++ b/drivers/media/dvb-frontends/si2168.h
>> @@ -46,6 +46,9 @@ struct si2168_config {
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* TS clock gapped */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ts_clock_gapped;
>> +
>> +=C2=A0=C2=A0=C2=A0 /* Inverted spectrum */
>> +=C2=A0=C2=A0=C2=A0 bool spectral_inversion;
>> =C2=A0 };
>> =C2=A0 =C2=A0 #endif
>>
>
