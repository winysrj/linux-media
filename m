Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:57922 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753228AbeARCgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 21:36:33 -0500
Subject: Re: [PATCH v2 1/2] si2168: Add spectrum inversion property
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1516224756-1649-2-git-send-email-brad@nextdimension.cc>
 <1516225967-21668-1-git-send-email-brad@nextdimension.cc>
 <dbcea672-b748-0521-b9c1-6aac14b1deac@iki.fi>
 <2e882928-5c1b-b9ad-96dc-bb41346a32b1@b-rad.cc>
 <c044b327-eee7-31e1-df93-11e24f336961@nextdimension.cc>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <43f50e93-3060-c0cd-ea16-0b0a39c952c0@iki.fi>
Date: Thu, 18 Jan 2018 04:36:31 +0200
MIME-Version: 1.0
In-Reply-To: <c044b327-eee7-31e1-df93-11e24f336961@nextdimension.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/18/2018 03:58 AM, Brad Love wrote:
> 
> On 2018-01-17 16:08, Brad Love wrote:
>> On 2018-01-17 16:02, Antti Palosaari wrote:
>>>
>>> On 01/17/2018 11:52 PM, Brad Love wrote:
>>>> Some tuners produce inverted spectrum, but the si2168 is not
>>>> currently set up to accept it. This adds an optional parameter
>>>> to set the frontend up to receive inverted spectrum.
>>>>
>>>> Parameter is optional and only boards who enable inversion
>>>> will utilize this.
>>>>
>>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>>> ---
>>>> Changes since v1:
>>>> - Embarassing build failure due to missing declaration.
>>>>
>>>>    drivers/media/dvb-frontends/si2168.c | 3 +++
>>>>    drivers/media/dvb-frontends/si2168.h | 3 +++
>>>>    2 files changed, 6 insertions(+)
>>>>
>>>> diff --git a/drivers/media/dvb-frontends/si2168.c
>>>> b/drivers/media/dvb-frontends/si2168.c
>>>> index c041e79..048b815 100644
>>>> --- a/drivers/media/dvb-frontends/si2168.c
>>>> +++ b/drivers/media/dvb-frontends/si2168.c
>>>> @@ -213,6 +213,7 @@ static int si2168_set_frontend(struct
>>>> dvb_frontend *fe)
>>>>        struct i2c_client *client = fe->demodulator_priv;
>>>>        struct si2168_dev *dev = i2c_get_clientdata(client);
>>>>        struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>> +    struct si2168_config *config = client->dev.platform_data;
>>> hmmm, are you sure platform data pointer points is const? I usually
>>> tend to store all config information to device state. Then there is no
>>> need to care if pointer is valid or not anymore.
>>>
>>> And inversion happens when those wires are cross-connected
>> It just dawned on me that the platform_data is stack allocated and
>> therefore not safe to access outside of probe. I will fix this momentarily.
>>
>> I was informed by one of our hardware guys that the two models in patch
>> 2/2 are inverted spectrum, so I guess they have wires cross-connected. I
>> can verify this again to be sure.
> 
> 
> Hello Antti,
> 
> I have confirmation. No 'cross-connected' / swapped differential pair
> polarities (if that's what you meant) on the IF pins. The si2157
> inverted spectrum output is configurable though, and Hauppauge
> have the tuner set up to output inverted. Sounds like it was a decision
> based on interoperability with older demods.

yeah, that was what I was thinking for. That board single tuner and two 
demods which other demod does not support if spectrum inversion?

If there is just si2168 and si2157, you can set both to invert or both 
to non-invert - the end result is same.

Antti

-- 
http://palosaari.fi/
