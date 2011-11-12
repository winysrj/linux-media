Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:39293 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1KLDg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 22:36:28 -0500
Message-ID: <4EBDE9B7.20802@linuxtv.org>
Date: Sat, 12 Nov 2011 04:36:23 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com> <4EBCF4F1.2030606@redhat.com> <CAHFNz9JWi3f3kB2UdBQXJBP2Q3Y+a0qBVNBAiZPVxtcCVZCN7g@mail.gmail.com> <4EBDA3D2.6060506@redhat.com>
In-Reply-To: <4EBDA3D2.6060506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
> Em 11-11-2011 20:07, Manu Abraham escreveu:
>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>>> The purpose of the patch is to
>>>> query DVB delivery system capabilities alone, rather than DVB frontend
>>>> info/capability.
>>>>
>>>> Attached is a revised version 2 of the patch, which addresses the
>>>> issues that were raised.
>>>
>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
>>> Please, when submitting upstream, don't forget to increment DVB version and
>>> add touch at DocBook, in order to not increase the gap between API specs and the
>>> implementation.
>>
>> Ok, thanks for the feedback, will do that.
>>
>> The naming issue is trivial. I would like to have a shorter name
>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
>> device capability.
> 
> CAPS is not a good name, as there are those two CAPABILITIES calls there
> (well, currently not implemented). So, it can lead in to some confusion.
> 
> DTV_ENUM_DELIVERY could be an alternative for a short name to be used there.

I like "enum", because it suggests that it's a read-only property.

DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
alternative.

Regards,
Andreas
