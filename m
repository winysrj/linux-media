Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2ABKzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jan 2012 05:55:31 -0500
Message-ID: <4F018D1D.8050707@redhat.com>
Date: Mon, 02 Jan 2012 08:55:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/9] dvb_frontend: Don't rely on drivers filling ops->info.type
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com> <CAHFNz9LzQX+UrkhPnuwpoX9eQix=du4HwyXS38DDw0XrWpOM+Q@mail.gmail.com>
In-Reply-To: <CAHFNz9LzQX+UrkhPnuwpoX9eQix=du4HwyXS38DDw0XrWpOM+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02-01-2012 05:31, Manu Abraham wrote:
> On Mon, Jan 2, 2012 at 1:41 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> This is likely the last patch series from my series of DVB cleanups.
>> I still intend to work on DRX-K frontend merge patch, but this will
>> need to wait until my return to my home town. Of course, if you're
>> hurry with this, patches are welcome.
>>
>> This series changes dvb_frontend to use ops->delsys instead of ops->info.type,
>> as the source for the frontend support. With this series:
>>
>> 1) the first delivery system is reported as info.type for DVBv3 apps;
>> 2) all subsequent checks are made against the current delivery system
>>   (c->delivery_system);
>> 3) An attempt to use an un-suported delivery system will either return
>>   an error, or enter into the emulation mode, if the frontend is
>>   using a newer delivery system.
>> 4) Lots of cleanup at the cache sync logic. Now, a pure DVBv5 call
>>   shouldn't fill the DVBv3 structs. Still, as events are generated,
>>   the event will dynamically generate a DVBv3 compat struct.
>>
>> The emulation logic is not perfect (but it were not perfect before this
>> patch series). The emulation will work worse for devices that have
>> support for different "ops->info.type", as there's no way for a DVBv3
>> application to work properly with those devices.
>>
>> TODO:
>>
>> There are a few things left to do, with regards to DVB frontend cleanup.
>> They're more related to the DVBv5 API, so they were out of the scope
>> of this series. Maybe some work for this upcoming year!
>>
>> They are:
>>
>>        1) Fix the capabilities flags. There are several capabilities
>> not reported, like several modulations, etc. There are not enough flags
>> for them. It was suggested that the delivery system (DTV_ENUM_DELSYS)
>> would be enough, but it doesn't seem so. For example, there are several
>> SYS_ATSC devices that only support VSB_8. So, we'll end by needing to
>> either extend the current way (but we lack bits) or to implement a DVBv5
>> way for that;
>>
> 
> If an ATSC device supports fewer modulations, things should be
> even simpler. Just return INVALID Frontend setup if it is trying to
> setup something invalid, that which is not supported. Advertising
> the available modulations doesn't help in any sense.
> A53 spec talks about devices supporting 2 modes, Terrestrial
> mode and High data rate mode. It is unlikely and yet maybe
> some devices don't adhere to specifications supporting only
> 8VSB, but even in those cases, just returning -EINVAL would be
> sufficient for 16VSB.
> 
> What you suggest, just adds confusion alone to applications as
> to what to do with all the exported fields/flags.

Returning -EINVAL works from kernel POV, but at least one userpsace
application developer sent me an email those days complaining that
applications need to know what are the supported capabilities, in order
to provide a proper userspace gui.

>>        2) The DVBv3 events call (FE_GET_EVENT) is not ok for
>> newer delivery system. We'll likely need to replace it by a DVBv5 way;
>>
> 
> 
> It should be noted that there is no "DVBv5 way", If you are implying
> to replace ioctl calls with a get/set interface, it doesn't make sense
> at all.

By DVBv5 way, I'm meaning to say that it should be replaced by some way
that allow reporting events not only for the 4 delivery systems supported
by DVBv3 API.

This could be as easy as adding a DTV_GET_EVENT command for FE_GET_PROPERTY.

Alternatively, events could be reported via a poll() ops at the frontend
node.

>>        3) The stats API needs to be extended. Delivery systems like
>> ISDB can report a per-layer set of statistics. This is currently not
>> supported. Also, it is desirable to get the stats together with a
>> set of other properties.
> 
> The per layer statistics is a myth and can be ignored. Each of the
> layers are much higher above and simply RF/demodulation
> parameters don't exist/layer; Even if you argue that they do exist,
> it would be exactly sufficient to read stats after setting up the
> relevant layer for filtering (since you cannot read demodulation
> statistics, without setting up proper demodulation parameters).

Take a look at:
	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#isdb-hierq-layers

Each layer has a group of OFDM carriers, each group have its own modulation,
viterbi and red-salomon decoders. And all of them can be decoded 
simultaneously. So, the statistics for each layer will be different.

That's said, I haven't seen any broadcaster using more than one layer yet,
so, there's no pressure for adding such feature yet.

Regards,
Mauro
