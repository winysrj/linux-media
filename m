Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49546 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ABQsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 11:48:11 -0500
Received: by wibhm6 with SMTP id hm6so8508160wib.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 08:48:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F01C02A.8030908@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
	<CAHFNz9LzQX+UrkhPnuwpoX9eQix=du4HwyXS38DDw0XrWpOM+Q@mail.gmail.com>
	<4F018D1D.8050707@redhat.com>
	<CAHFNz9Jfb6Caebp7CaabHNrd96UvzWqByvMfSY5GHaW3_ofjow@mail.gmail.com>
	<4F01C02A.8030908@redhat.com>
Date: Mon, 2 Jan 2012 22:18:10 +0530
Message-ID: <CAHFNz9JdJVkH2Nm7bN9=bwbEFPQDwHsDQwDKDrmPngO2UoPq_A@mail.gmail.com>
Subject: Re: [PATCH 0/9] dvb_frontend: Don't rely on drivers filling ops->info.type
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 2, 2012 at 8:03 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 02-01-2012 09:48, Manu Abraham wrote:
>> On Mon, Jan 2, 2012 at 4:25 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> On 02-01-2012 05:31, Manu Abraham wrote:
>>>> On Mon, Jan 2, 2012 at 1:41 AM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> This is likely the last patch series from my series of DVB cleanups.
>>>>> I still intend to work on DRX-K frontend merge patch, but this will
>>>>> need to wait until my return to my home town. Of course, if you're
>>>>> hurry with this, patches are welcome.
>>>>>
>>>>> This series changes dvb_frontend to use ops->delsys instead of ops->info.type,
>>>>> as the source for the frontend support. With this series:
>>>>>
>>>>> 1) the first delivery system is reported as info.type for DVBv3 apps;
>>>>> 2) all subsequent checks are made against the current delivery system
>>>>>   (c->delivery_system);
>>>>> 3) An attempt to use an un-suported delivery system will either return
>>>>>   an error, or enter into the emulation mode, if the frontend is
>>>>>   using a newer delivery system.
>>>>> 4) Lots of cleanup at the cache sync logic. Now, a pure DVBv5 call
>>>>>   shouldn't fill the DVBv3 structs. Still, as events are generated,
>>>>>   the event will dynamically generate a DVBv3 compat struct.
>>>>>
>>>>> The emulation logic is not perfect (but it were not perfect before this
>>>>> patch series). The emulation will work worse for devices that have
>>>>> support for different "ops->info.type", as there's no way for a DVBv3
>>>>> application to work properly with those devices.
>>>>>
>>>>> TODO:
>>>>>
>>>>> There are a few things left to do, with regards to DVB frontend cleanup.
>>>>> They're more related to the DVBv5 API, so they were out of the scope
>>>>> of this series. Maybe some work for this upcoming year!
>>>>>
>>>>> They are:
>>>>>
>>>>>        1) Fix the capabilities flags. There are several capabilities
>>>>> not reported, like several modulations, etc. There are not enough flags
>>>>> for them. It was suggested that the delivery system (DTV_ENUM_DELSYS)
>>>>> would be enough, but it doesn't seem so. For example, there are several
>>>>> SYS_ATSC devices that only support VSB_8. So, we'll end by needing to
>>>>> either extend the current way (but we lack bits) or to implement a DVBv5
>>>>> way for that;
>>>>>
>>>>
>>>> If an ATSC device supports fewer modulations, things should be
>>>> even simpler. Just return INVALID Frontend setup if it is trying to
>>>> setup something invalid, that which is not supported. Advertising
>>>> the available modulations doesn't help in any sense.
>>>> A53 spec talks about devices supporting 2 modes, Terrestrial
>>>> mode and High data rate mode. It is unlikely and yet maybe
>>>> some devices don't adhere to specifications supporting only
>>>> 8VSB, but even in those cases, just returning -EINVAL would be
>>>> sufficient for 16VSB.
>>>>
>>>> What you suggest, just adds confusion alone to applications as
>>>> to what to do with all the exported fields/flags.
>>>
>>> Returning -EINVAL works from kernel POV, but at least one userpsace
>>> application developer sent me an email those days complaining that
>>> applications need to know what are the supported capabilities, in order
>>> to provide a proper userspace gui.
>>
>>
>> FWIW, userapps shouldn't really bother about all the
>> hardware details. If user application were to really
>> bother about all the tiny intricacies (I can point out
>> a large amount of tiny intricacies that which might
>> sound pretty, as you are stating) then there wouldn't
>> be the need for a driver API -- the application itself
>> can contain the driver code. In short, providing too
>> much information to application is also not nice.
>>
>> The user application should simply set the parameters
>> and try to demodulate, return error if it cannot.
>
> -EINVAL could mean an error on any parameter, not just on
> modulation.

This suggestion of FE_CAN_MODULATION_X/Y/Z just follows
an earlier discussion about the FE_CAN_ bits where almost
everyone came to the conclusion and eventually agreed
that those are superfluous and such fine grained-ness is
not useful.
