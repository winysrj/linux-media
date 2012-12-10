Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61686 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2LJTRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:17:15 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1253436bkw.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 11:17:13 -0800 (PST)
Message-ID: <50C63543.8020500@googlemail.com>
Date: Mon, 10 Dec 2012 20:17:23 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
References: <201212101407.09338.hverkuil@xs4all.nl> <50C60620.2010603@googlemail.com> <201212101727.29074.hverkuil@xs4all.nl> <20121210153816.0d4d9b64@redhat.com>
In-Reply-To: <20121210153816.0d4d9b64@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.12.2012 18:38, schrieb Mauro Carvalho Chehab:
> Em Mon, 10 Dec 2012 17:27:29 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> On Mon December 10 2012 16:56:16 Frank Schäfer wrote:
>>> Am 10.12.2012 14:07, schrieb Hans Verkuil:
>>>
>>> <snip>
>>>> 3) This document describes the situation we will have when the submaintainers
>>>> take their place early next year. So please check if I got that part right.
>>> ...
>>>
>>>> Reviewed-by/Acked-by
>>>> ====================
>>>>
>>>> Within the media subsystem there are three levels of maintainership: Mauro
>>>> Carvalho Chehab is the maintainer of the whole subsystem and the
>>>> DVB/V4L/IR/Media Controller core code in particular, then there are a number of
>>>> submaintainers for specific areas of the subsystem:
>>>>
>>>> - Kamil Debski: codec (aka memory-to-memory) drivers
>>>> - Hans de Goede: non-UVC USB webcam drivers
>>>> - Mike Krufky: frontends/tuners/demodulators In addition he'll be the reviewer
>>>>   for DVB core patches.
>>>> - Guennadi Liakhovetski: soc-camera drivers
>>>> - Laurent Pinchart: sensor subdev drivers.  In addition he'll be the reviewer
>>>>   for Media Controller core patches.
>>>> - Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
>>>>   receivers and transmitters). In addition he'll be the reviewer for V4L2 core
>>>>   patches.
>>>>
>>>> Finally there are maintainers for specific drivers. This is documented in the
>>>> MAINTAINERS file.
>>>>
>>>> When modifying existing code you need to get the Reviewed-by/Acked-by of the
>>>> maintainer of that code. So CC that maintainer when posting patches. If said
>>>> maintainer is unavailable then the submaintainer or even Mauro can accept it as
>>>> well, but that should be the exception, not the rule.
>>>>
>>>> Once patches are accepted they will flow through the git tree of the
>>>> submaintainer to the git tree of the maintainer (Mauro) who will do a final
>>>> review.
>>>>
>>>> There are a few exceptions: code for certain platforms goes through git trees
>>>> specific to that platform. The submaintainer will still review it and add a
>>>> acked-by or reviewed-by line, but it will not go through the submaintainer's
>>>> git tree.
>>>>
>>>> The platform maintainers are:
>>>>
>>>> TDB
>>>>
>>>> In case patches touch on areas that are the responsibility of multiple
>>>> submaintainers, then they will decide among one another who will merge the
>>>> patches.
>>> I've read this "when the submaintainers take their place early next
>>> year, everything will be fine" several times now.
>> I doubt everything will be fine, but I sure hope it will be better at least.
>> In other words, don't expect miracles :-)
>>
>>> But can anyone please explain me what's going to change ?
>>> AFAICS, the above exactly describes the _current_ situation.
>>> We already have sub-maintainers, sub-trees etc, right !? And the people
>>> listed above are already doing the same job at the moment.
>>>
>>> Looking at patchwork, it seems we are behind at least 1 complete kernel
>>> release cycle.
> No, this is not true; git pull requests are typically handled faster, as
> the material there is submitted either by a driver maintainer or by a
> sub-maintainer. The delay there for -git is currently 2 weeks, as we closed our
> merge window at the beginning of -rc7 (expecting that there won't be a -rc8).

But it's not "git pull request" vs. "patches sent to the list directly",
it's "reviewed" vs. "not reviewed", right ?

> The very large of individual patches have a longer delays, due to the lack of
> driver maintainers reviews.

That's what I said, the problem is that we lack maintainers/reviewers.
And people beeing subsystem maintainers AND driver maintainers have to
find a balance between processing pull requests and reviewing patches.
I'm not sure if I have understood yet how this balance should look
like... Can you elaborate a bit on this ?
At the moment it's ~12 weeks / ~2 weeks. What's the target value ? ;)

>
>>> And the reason seems to be, that (at least some) maintainers don't have
>>> the resources to review them in time (no reproaches !).
>>>
>>> But to me this seems to be no structural problem.
>>> If a maintainer (permanently) doesn't have the time to review patches,
>>> he should leave maintainership to someone else.
> Agreed.
>
>>> So the actual problem seems to be, that we don't have enough
>>> maintainers/reviewers, right ?
>> The main problem is that all the work is done by Mauro. Sure, people help
>> out with reviews but a lot of the final administrative and merge effort is
>> done by one person only. In particular the patch flow is something he can't
>> keep up with anymore. So by assigning official submaintainers who get access
>> to patchwork and can process patches quickly we hope that his job will become
>> a lot easier.
>>
>> So the core two changes are 1) giving clear responsibilities to submaintainers
>> and 2) giving submaintainers access to patchwork to keep track of the patches.
>>
>> So patch submitters no longer have to wait until Mauro gets around to cleaning
>> out patchwork. Instead the submaintainers can do that themselves and collect
>> accepted patches in their git tree and post regular pull requests for Mauro.
>>
>> It should simplify things substantially for Mauro, we hope.
>>
>> I think we have enough people doing reviews etc. (although more are always
>> welcome), it's the patchflow itself that is the problem.
> Yeah, the issue is that both reviewed, non-reviewed and rejected/commented
> patches go into the very same queue, forcing me to revisit each patch again, 
> even the rejected/commented ones, and the previous versions of newer patches.
>
> By giving rights and responsibilities to the sub-maintainers to manage their
> stuff directly at patchwork, those patches that tend to stay at patchwork for
> a long time will likely disappear, and the queue will be cleaner.

So who can get an account / is supposed to access patchwork ?
- subsystem maintainers ?
- driver maintainers ?
- patch creators ?

Regards,
Frank

> Regards,
> Mauro

