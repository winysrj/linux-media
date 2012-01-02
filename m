Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:32903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2ABLsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 06:48:20 -0500
Received: by werm1 with SMTP id m1so7383434wer.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 03:48:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F018D1D.8050707@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
	<CAHFNz9LzQX+UrkhPnuwpoX9eQix=du4HwyXS38DDw0XrWpOM+Q@mail.gmail.com>
	<4F018D1D.8050707@redhat.com>
Date: Mon, 2 Jan 2012 17:18:19 +0530
Message-ID: <CAHFNz9Jfb6Caebp7CaabHNrd96UvzWqByvMfSY5GHaW3_ofjow@mail.gmail.com>
Subject: Re: [PATCH 0/9] dvb_frontend: Don't rely on drivers filling ops->info.type
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 2, 2012 at 4:25 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 02-01-2012 05:31, Manu Abraham wrote:
>> On Mon, Jan 2, 2012 at 1:41 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> This is likely the last patch series from my series of DVB cleanups.
>>> I still intend to work on DRX-K frontend merge patch, but this will
>>> need to wait until my return to my home town. Of course, if you're
>>> hurry with this, patches are welcome.
>>>
>>> This series changes dvb_frontend to use ops->delsys instead of ops->info.type,
>>> as the source for the frontend support. With this series:
>>>
>>> 1) the first delivery system is reported as info.type for DVBv3 apps;
>>> 2) all subsequent checks are made against the current delivery system
>>>   (c->delivery_system);
>>> 3) An attempt to use an un-suported delivery system will either return
>>>   an error, or enter into the emulation mode, if the frontend is
>>>   using a newer delivery system.
>>> 4) Lots of cleanup at the cache sync logic. Now, a pure DVBv5 call
>>>   shouldn't fill the DVBv3 structs. Still, as events are generated,
>>>   the event will dynamically generate a DVBv3 compat struct.
>>>
>>> The emulation logic is not perfect (but it were not perfect before this
>>> patch series). The emulation will work worse for devices that have
>>> support for different "ops->info.type", as there's no way for a DVBv3
>>> application to work properly with those devices.
>>>
>>> TODO:
>>>
>>> There are a few things left to do, with regards to DVB frontend cleanup.
>>> They're more related to the DVBv5 API, so they were out of the scope
>>> of this series. Maybe some work for this upcoming year!
>>>
>>> They are:
>>>
>>>        1) Fix the capabilities flags. There are several capabilities
>>> not reported, like several modulations, etc. There are not enough flags
>>> for them. It was suggested that the delivery system (DTV_ENUM_DELSYS)
>>> would be enough, but it doesn't seem so. For example, there are several
>>> SYS_ATSC devices that only support VSB_8. So, we'll end by needing to
>>> either extend the current way (but we lack bits) or to implement a DVBv5
>>> way for that;
>>>
>>
>> If an ATSC device supports fewer modulations, things should be
>> even simpler. Just return INVALID Frontend setup if it is trying to
>> setup something invalid, that which is not supported. Advertising
>> the available modulations doesn't help in any sense.
>> A53 spec talks about devices supporting 2 modes, Terrestrial
>> mode and High data rate mode. It is unlikely and yet maybe
>> some devices don't adhere to specifications supporting only
>> 8VSB, but even in those cases, just returning -EINVAL would be
>> sufficient for 16VSB.
>>
>> What you suggest, just adds confusion alone to applications as
>> to what to do with all the exported fields/flags.
>
> Returning -EINVAL works from kernel POV, but at least one userpsace
> application developer sent me an email those days complaining that
> applications need to know what are the supported capabilities, in order
> to provide a proper userspace gui.


FWIW, userapps shouldn't really bother about all the
hardware details. If user application were to really
bother about all the tiny intricacies (I can point out
a large amount of tiny intricacies that which might
sound pretty, as you are stating) then there wouldn't
be the need for a driver API -- the application itself
can contain the driver code. In short, providing too
much information to application is also not nice.

The user application should simply set the parameters
and try to demodulate, return error if it cannot.
Having unnecessary fields just causes confusion alone.
I don't see how providing all the modulations under a
delivery system can improve a GUI application
especially when it is according to the specifications.


>>>        2) The DVBv3 events call (FE_GET_EVENT) is not ok for
>>> newer delivery system. We'll likely need to replace it by a DVBv5 way;
>>>
>>
>>
>> It should be noted that there is no "DVBv5 way", If you are implying
>> to replace ioctl calls with a get/set interface, it doesn't make sense
>> at all.
>
> By DVBv5 way, I'm meaning to say that it should be replaced by some way
> that allow reporting events not only for the 4 delivery systems supported
> by DVBv3 API.
>
> This could be as easy as adding a DTV_GET_EVENT command for FE_GET_PROPERTY.
>
> Alternatively, events could be reported via a poll() ops at the frontend
> node.


I am unable to see the advantage in adding a
new DTV_GET_EVENT call instead of FE_GET_PROPERTY
improve anything at all.


>
>>>        3) The stats API needs to be extended. Delivery systems like
>>> ISDB can report a per-layer set of statistics. This is currently not
>>> supported. Also, it is desirable to get the stats together with a
>>> set of other properties.
>>
>> The per layer statistics is a myth and can be ignored. Each of the
>> layers are much higher above and simply RF/demodulation
>> parameters don't exist/layer; Even if you argue that they do exist,
>> it would be exactly sufficient to read stats after setting up the
>> relevant layer for filtering (since you cannot read demodulation
>> statistics, without setting up proper demodulation parameters).
>
> Take a look at:
>        http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#isdb-hierq-layers
>
> Each layer has a group of OFDM carriers, each group have its own modulation,
> viterbi and red-salomon decoders. And all of them can be decoded
> simultaneously. So, the statistics for each layer will be different.
>


Hierarchial modulation is not new as with ISDB,
DVB has been using hieararchial modulation with
DVB-T, T2, and S2 with no issues.

After a tune, an application can simply retrieve the
stats for that particular layer. The application knowing
which layer the frontend was setup/tuned for.

http://www.dvb.org/technology/fact_sheets/WP01_DVB-T%20Hierarchical.pdf
