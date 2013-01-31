Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:64577 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3AaPCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 10:02:54 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so2925935obc.20
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 07:02:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510A821F.1060101@iki.fi>
References: <CABXgeUHzMhk7rCtpoVuEz1zUYuGwUMEmxrFMKripnO8qvNX+Sg@mail.gmail.com>
 <510A821F.1060101@iki.fi>
From: Michael Stilmant-Rovi <stilmant.michael.rovi@gmail.com>
Date: Thu, 31 Jan 2013 16:02:34 +0100
Message-ID: <CABXgeUF9dRS9zeWTCOGExRYOU3ZOxJ1bPZxM0GqogQOaUF580Q@mail.gmail.com>
Subject: Re: DVB_T2 Multistream support (PLP)
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Looking for a tuner supporting multiple PLP, is it conceivable to add
to the driver the possibility to pass to the hardware that value? (I
don't know if that need other math though) ( I will look the sources
anyway but I don't have good knowledge)

If I want to look for another USB stick how could I know if the driver
will support that feature?
For example is TBS5880 DVB-T2 USB TV Tuner ?

I understand here that the difficulties is that few people are in a
MultiPLP DVB_T2 range. even myself.. .

Regards,

On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>
>> Hello,
>>
>> I would like to know the support status of Multiple PLPs in DVB-T2.
>> Is someone know if tests were performed in a broadcast with an
>> effective Multistream? (PLP Id: 0 and 1 for example)
>>
>> I'm out of range of such multiplex but I'm trying some tunes on London
>> DVB-T2 (CrystalPalace tower)
>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>    ( yes tune always succeed :-D )
>>
>> I'm using DVB API 5.6.
>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>> 0, 1 or 15. the tune succeed.
>>
>> I'm not sure of the expected behavior, I was expecting if I tune with
>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>
>> So in short I don't understand what is the requirements to be able to
>> use the DVB_T2 Multistream support proposed in APIs:
>>   o I see that the DVB API 5.8(?) had some patch at that level and so
>> it is maybe requested?
>>   o How can I know if my driver support that feature on DVB API 5.6?
>> (PCTV nanoStick T2 290e)?
>>
>> Thank you for all indications.
>>
>> -Michael
>
>
> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
> driver and I has only Live signal with single TS. What I think Windows
> driver either supports that feature. It just tunes to first PLP regardless
> of whole property and that's it.
>
> regards
> Antti
>
> --
> http://palosaari.fi/

On Thu, Jan 31, 2013 at 3:39 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/31/2013 04:27 PM, Michael Stilmant-Rovi wrote:
>>
>> Hello,
>>
>> I would like to know the support status of Multiple PLPs in DVB-T2.
>> Is someone know if tests were performed in a broadcast with an
>> effective Multistream? (PLP Id: 0 and 1 for example)
>>
>> I'm out of range of such multiplex but I'm trying some tunes on London
>> DVB-T2 (CrystalPalace tower)
>> "unfortunately" that mux seems Single PLP and everything work well :-(
>>    ( yes tune always succeed :-D )
>>
>> I'm using DVB API 5.6.
>> If I tune with FE_SET_PROPERTY without or with DTV_DVBT2_PLP_ID set to
>> 0, 1 or 15. the tune succeed.
>>
>> I'm not sure of the expected behavior, I was expecting if I tune with
>> plp_id 1 that the tuner would fail somewhere finding that stream.
>>
>> So in short I don't understand what is the requirements to be able to
>> use the DVB_T2 Multistream support proposed in APIs:
>>   o I see that the DVB API 5.8(?) had some patch at that level and so
>> it is maybe requested?
>>   o How can I know if my driver support that feature on DVB API 5.6?
>> (PCTV nanoStick T2 290e)?
>>
>> Thank you for all indications.
>>
>> -Michael
>
>
> nanoStick T2 290e Linux driver does not support multiple PLPs. I did that
> driver and I has only Live signal with single TS. What I think Windows
> driver either supports that feature. It just tunes to first PLP regardless
> of whole property and that's it.
>
> regards
> Antti
>
> --
> http://palosaari.fi/
