Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51243 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933574AbeARQXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 11:23:34 -0500
Subject: Re: [PATCH v2 1/2] si2168: Add spectrum inversion property
To: Brad Love <brad@nextdimension.cc>, Antti Palosaari <crope@iki.fi>,
        linux-media@vger.kernel.org
References: <1516224756-1649-2-git-send-email-brad@nextdimension.cc>
 <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
 <dbcea672-b748-0521-b9c1-6aac14b1deac@iki.fi>
 <2e882928-5c1b-b9ad-96dc-bb41346a32b1@b-rad.cc>
 <c044b327-eee7-31e1-df93-11e24f336961@nextdimension.cc>
 <43f50e93-3060-c0cd-ea16-0b0a39c952c0@iki.fi>
 <d780be11-46af-7293-d80b-40a360d23323@nextdimension.cc>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <7a8d6e57-5d60-f2f3-24e1-2f028df0fd5b@nextdimension.cc>
Date: Thu, 18 Jan 2018 10:23:32 -0600
MIME-Version: 1.0
In-Reply-To: <d780be11-46af-7293-d80b-40a360d23323@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-17 21:10, Brad Love wrote:
> On 2018-01-17 20:36, Antti Palosaari wrote:
>> On 01/18/2018 03:58 AM, Brad Love wrote:
>>> On 2018-01-17 16:08, Brad Love wrote:
>>>> On 2018-01-17 16:02, Antti Palosaari wrote:
>>>>> On 01/17/2018 11:52 PM, Brad Love wrote:
>>>>>> Some tuners produce inverted spectrum, but the si2168 is not
>>>>>> currently set up to accept it. This adds an optional parameter
>>>>>> to set the frontend up to receive inverted spectrum.
>>>>>>
>>>>>> Parameter is optional and only boards who enable inversion
>>>>>> will utilize this.
>>>>>>
>>>>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>>>>> ---
>>>>>> Changes since v1:
>>>>>> - Embarassing build failure due to missing declaration.
>>>>>>
>>>>>> =C2=A0=C2=A0 drivers/media/dvb-frontends/si2168.c | 3 +++
>>>>>> =C2=A0=C2=A0 drivers/media/dvb-frontends/si2168.h | 3 +++
>>>>>> =C2=A0=C2=A0 2 files changed, 6 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/media/dvb-frontends/si2168.c
>>>>>> b/drivers/media/dvb-frontends/si2168.c
>>>>>> index c041e79..048b815 100644
>>>>>> --- a/drivers/media/dvb-frontends/si2168.c
>>>>>> +++ b/drivers/media/dvb-frontends/si2168.c
>>>>>> @@ -213,6 +213,7 @@ static int si2168_set_frontend(struct
>>>>>> dvb_frontend *fe)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct i2c_client *client =3D=
 fe->demodulator_priv;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2168_dev *dev =3D i2=
c_get_clientdata(client);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dtv_frontend_propertie=
s *c =3D &fe->dtv_property_cache;
>>>>>> +=C2=A0=C2=A0=C2=A0 struct si2168_config *config =3D client->dev.p=
latform_data;
>>>>> hmmm, are you sure platform data pointer points is const? I usually
>>>>> tend to store all config information to device state. Then there is=
 no
>>>>> need to care if pointer is valid or not anymore.
>>>>>
>>>>> And inversion happens when those wires are cross-connected
>>>> It just dawned on me that the platform_data is stack allocated and
>>>> therefore not safe to access outside of probe. I will fix this
>>>> momentarily.
>>>>
>>>> I was informed by one of our hardware guys that the two models in pa=
tch
>>>> 2/2 are inverted spectrum, so I guess they have wires
>>>> cross-connected. I
>>>> can verify this again to be sure.
>>>
>>> Hello Antti,
>>>
>>> I have confirmation. No 'cross-connected' / swapped differential pair
>>> polarities (if that's what you meant) on the IF pins. The si2157
>>> inverted spectrum output is configurable though, and Hauppauge
>>> have the tuner set up to output inverted. Sounds like it was a decisi=
on
>>> based on interoperability with older demods.
>> yeah, that was what I was thinking for. That board single tuner and
>> two demods which other demod does not support if spectrum inversion?
>>
>> If there is just si2168 and si2157, you can set both to invert or both
>> to non-invert - the end result is same.
>>
>> Antti
>
> I will check on the HVR975 tomorrow, if it's affected as well I'll
> submit a patch. The lgdt3306a frontend is already set up for auto
> spectrum inversion, so it is able handle the si2157 in either config.
>

The HVR975 should be good as currently submitted.

Cheers,

Brad
