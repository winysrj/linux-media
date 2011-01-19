Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1ASMCt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 07:02:49 -0500
Message-ID: <4D36D2D9.8030305@redhat.com>
Date: Wed, 19 Jan 2011 10:02:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: video_device -> v4l2_devnode rename
References: <201101190839.15175.hverkuil@xs4all.nl>    <4D36C40C.3080607@redhat.com> <8544fb4aeb5aad63c78a4f9f9d2edcaf.squirrel@webmail.xs4all.nl>
In-Reply-To: <8544fb4aeb5aad63c78a4f9f9d2edcaf.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-01-2011 09:53, Hans Verkuil escreveu:
>> Em 19-01-2011 05:39, Hans Verkuil escreveu:
>>> Hi Mauro,
>>>
>>> I saw that 2.6.38-rc1 was released. I also noticed that not all the
>>> patches
>>> that are in the for_2.6.38-rc1 branch are in 2.6.38-rc1.
>>
>> Yes. Unfortunately, when I was sending the pull request yesterday, I
>> noticed
>> an issue on my linux next tree, and I had to abort its send. After that,
>> Linus
>> released -rc1, before I have time to fix it.
>>
>> People should really send me patches for the next window before the start
>> of the
>> merge window, as doing it during the merge window makes my work harder and
>> may
>> cause troubles like that.
>>
>> The net result is that most patches were submitted in time and were
>> applied upstream.
>> Of course, there are usual fix patches sent during the merge window, that
>> will be sent
>> upstream anyway during the rc period.
> 
> Speaking of that, my prio patches and the dsbr100 patches (with the new
> v4l2_device release callback) can be moved to 2.6.39. If they can be
> merged fairly early on, then I can build on those.
> 
>> There are two patch series with new stuff submitted in time and merged on
>> my
>> tree that didn't reach upstream:
>> 	- vb2/s5p-fimc - they required me more time to review - I also spent 3
>> days testing it;
>> 	- ngene - there were a pending API discussion - I waited for a while to
>> see if
>> 	  there were some solution, before deciding to merge and move the
>> problematic
>> 	  code to staging.
>>
>> So, I'll need to dig into the pending patches, in order to send the ones
>> that
>> are acceptable after the end of the merge window, and letting the other
>> patches
>> for .39. I'll likely try to send the two above and the dib0700 patches on
>> a separate
>> pull request, but this pull request might be rejected.
>>
>>> We want to rename video_device to v4l2_devnode. So let me know when I
>>> can
>>> finalize my patches and, most importantly, against which branch.
>>
>> It is too late for that. As I said you, the better time for doing that is
>> during
>> the merge window. Linus said me that he don't want to make life easier for
>> function
>> rename. So, he won't be accepting such patch after the merge window.
> 
> You were going to tell me when you had finished merging so that I wouldn't
> aim at a moving target. This is very annoying.

The vb2 merge took a longer time than I expected. Sorry for that.

Cheers,
Mauro
