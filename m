Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab0CLPhN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 10:37:13 -0500
Message-ID: <4B9A5FE7.9030504@redhat.com>
Date: Fri, 12 Mar 2010 16:38:15 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: v4l-utils: i2c-id.h and alevt
References: <201003090848.29301.hverkuil@xs4all.nl> <4B98FABB.1040605@gmail.com> <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com> <201003120827.44814.hverkuil@xs4all.nl>
In-Reply-To: <201003120827.44814.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/12/2010 08:27 AM, Hans Verkuil wrote:
> On Thursday 11 March 2010 15:31:32 Devin Heitmueller wrote:
>> On Thu, Mar 11, 2010 at 9:14 AM, Douglas Schilling Landgraf
>> <dougsland@gmail.com>  wrote:
>>> On 03/10/2010 02:04 AM, hermann pitton wrote:
>>>> Hi Hans, both,
>>>>
>>>> Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
>>>>> It's nice to see this new tree, that should be make it easier to develop
>>>>> utilities!
>>>>>
>>>>> After a quick check I noticed that the i2c-id.h header was copied from the
>>>>> kernel. This is not necessary. The only utility that includes this is v4l2-dbg
>>>>> and that one no longer needs it. Hans, can you remove this?
>>>>>
>>>>> The second question is whether anyone would object if alevt is moved from
>>>>> dvb-apps to v4l-utils? It is much more appropriate to have that tool in
>>>>> v4l-utils.
>>>>
>>>> i wonder that this stays such calm, hopefully a good sign.
>>>>
>>>> In fact alevt analog should come with almost every distribution, but the
>>>> former alevt-dvb, named now only alevt, well, might be ok in some
>>>> future, is enhanced for doing also dvb-t-s and hence there ATM.
>>>>
>>>>> Does anyone know of other unmaintained but useful tools that we might merge
>>>>> into v4l-utils? E.g. xawtv perhaps?
>>>>
>>>> If for xawtv could be some more care, ships also since close to ever
>>>> with alevtd, that would be fine, but I'm not sure we are talking about
>>>> tools anymore in such case, since xawtv4x, tvtime and mpeg4ip ;) for
>>>> example are also there and unmaintained.
>>>>
>>>
>>> I think would be nice to hear a word from Devin, which have been working in tvtime. Devin?
>>
>> Sorry, I've been sick for the last couple of days and not actively on email.
>>
>> I don't think it's a good idea to consolidate applications like xawtv
>> and tvtime into the v4l2-utils codebase.  The existing v4l2-utils is
>> nice because it's small and what the packages provides what it says it
>> does - v4l2 *utilities*.  I wouldn't consider full blown tv viewing
>> applications to be "utilities".
>>
>> The apps in question are currently packaged by multiple distros today
>> as standalone packages.  Today distros can decide whether they want
>> the "bloat" associated with large GUI applications just to get the
>> benefits of a couple of command line utilities.  Bundling them
>> together makes that much harder (and would also result in a package
>> with lots of external dependencies on third party libraries).
>>
>> Adding them into v4l2-utils doesn't really solve the real problem -
>> that there are very few people willing to put in the effort to
>> extend/improve these applications (something which, as Douglas pointed
>> out, I'm trying to improve in the case of tvtime).
>
> For unmaintained applications the problem is that even those people that
> have patches for them have no easy way to get them applied, precisely because
> they are unmaintained.
>
> We as v4l-dvb developers don't have the time to make TV apps, but perhaps if
> we 'adopted' one unmaintained application and just update that whenever we
> make new features, then that would be very helpful I think. Or perhaps just
> provide a place for such applications where there is someone who can take
> community supplied patches and review and apply them.
>
> Such an application does not have to be in v4l2-utils, it can have its own
> tree.
>
> Anyway, regarding alevt: I believe that the consensus is that it should be
> moved to v4l2-utils? Or am I wrong?
>

I'm not in favor of moving alevt into v4l-utils, if there are
people who want to pick up its maintenance and host a separate tree for
it at linuxtv.org including doing regular tarbal releases for upstream to consume
that would seem a good idea to me.

Regards,

Hans
