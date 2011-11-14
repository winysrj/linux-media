Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1KNWiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 17:38:19 -0500
Received: by wwe5 with SMTP id 5so5132370wwe.1
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 14:38:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC19622.80304@redhat.com>
References: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
	<4EC17E31.5010407@redhat.com>
	<CAHFNz9+44KMXYDpXKswkp5a3eah8UFLX4oe5GnKpnP4fHTqCLw@mail.gmail.com>
	<4EC19622.80304@redhat.com>
Date: Tue, 15 Nov 2011 04:08:18 +0530
Message-ID: <CAHFNz9JqPtaAoaFn6aR-VJRv7wWNOqQnvWbW+Agi8pXWzCKXEg@mail.gmail.com>
Subject: Re: PATCH v3: Query DVB frontend delivery capabilities (was: Re:
 PATCH: Query DVB frontend capabilities)
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2011 at 3:58 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 14-11-2011 20:08, Manu Abraham escreveu:
>> On Tue, Nov 15, 2011 at 2:16 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 14-11-2011 17:39, Manu Abraham escreveu:
>>>> On 11/12/11, Andreas Oberritter <obi@linuxtv.org> wrote:
>>>>> On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
>>>>>> Em 11-11-2011 20:07, Manu Abraham escreveu:
>>>>>>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
>>>>>>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>>>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>>>>>>>> The purpose of the patch is to
>>>>>>>>> query DVB delivery system capabilities alone, rather than DVB frontend
>>>>>>>>> info/capability.
>>>>>>>>>
>>>>>>>>> Attached is a revised version 2 of the patch, which addresses the
>>>>>>>>> issues that were raised.
>>>>>>>>
>>>>>>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
>>>>>>>> Please, when submitting upstream, don't forget to increment DVB version
>>>>>>>> and
>>>>>>>> add touch at DocBook, in order to not increase the gap between API specs
>>>>>>>> and the
>>>>>>>> implementation.
>>>>>>>
>>>>>>> Ok, thanks for the feedback, will do that.
>>>>>>>
>>>>>>> The naming issue is trivial. I would like to have a shorter name
>>>>>>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
>>>>>>> device capability.
>>>>>>
>>>>>> CAPS is not a good name, as there are those two CAPABILITIES calls there
>>>>>> (well, currently not implemented). So, it can lead in to some confusion.
>>>>>>
>>>>>> DTV_ENUM_DELIVERY could be an alternative for a short name to be used
>>>>>> there.
>>>>>
>>>>> I like "enum", because it suggests that it's a read-only property.
>>>>>
>>>>> DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
>>>>> alternative.
>>>>
>>>> This is a bit more sensible and meaningful than the others. I like
>>>> this one better than the others.
>>>>
>>>> Attached is a version 3 patch which addresses all the issues that were raised
>>>
>>> Ok from my side. A minor issue is that we've renamed the cmd, but the
>>> internal function name was the same:
>>>
>>> dtv_set_default_delivery_caps()
>>>
>>> Anyway, ACK from my side.
>>>
>>
>> Ok, thanks.
>>
>>
>>> I'll merge it upstream when you submit the DocBook patches (or send me a git
>>> pull request with both things - whatever work better for you).
>>
>> Those xml docs seem to have some issue ?
>> I get this following error on opening the docs:
>>
>> XML error while loading the document:
>> The markup in the document following the root element must be well
>> formed. at line3
>
> Never saw this error before. I doubt that there are any issues, as otherwise,
> kernel people would have complained already. Also, linuxtv rebuilds it every
> day.
>
> Are you just doing:
>        make htmldocs
> ?

Just opened frontend.xml in an XML editor Jaxe, XML Copy Editor

both gave similar errors.

Regards,
Manu
