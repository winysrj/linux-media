Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63684 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1KXSeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:34:05 -0500
Received: by eaak14 with SMTP id k14so349875eaa.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 10:34:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECE8C06.2070302@redhat.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com>
	<4ECE79F5.9000402@linuxtv.org>
	<201111241844.23292.hverkuil@xs4all.nl>
	<4ECE8434.5060106@linuxtv.org>
	<4ECE85CE.7040807@redhat.com>
	<4ECE87EA.9000001@linuxtv.org>
	<4ECE8C06.2070302@redhat.com>
Date: Fri, 25 Nov 2011 00:04:04 +0530
Message-ID: <CAHFNz9JbETiNWzJ_zrFEmb8HOOy-Jmsc-NzGo=AJ_sS1ND=3SA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2011 at 11:55 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 24-11-2011 16:07, Andreas Oberritter escreveu:
>> On 24.11.2011 18:58, Mauro Carvalho Chehab wrote:
>>> Em 24-11-2011 15:51, Andreas Oberritter escreveu:
>>>> On 24.11.2011 18:44, Hans Verkuil wrote:
>>>>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>>>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>>>>> new API, but - pretty please - don't just blindly remove audio.h and
>>>>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>>>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>>>>> those out-of-tree drivers merged, but it isn't possible for many
>>>>>> reasons. And even if they were merged, you'd say "Port them and your
>>>>>> apps to V4L". No! That's not an option.
>>>>>
>>>>> I'm not breaking anything. All apps will still work.
>>>>>
>>>>> One option (and it depends on whether people like it or not) is to have
>>>>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>>>>> that these headers need to be replaced by the new av7110.h.
>>>>>
>>>>> And really remove them at some point in the future.
>>>>>
>>>>> But the important thing to realize is that the ABI hasn't changed (unless
>>>>> I made a mistake somewhere).
>>>>
>>>> So why don't you just leave the headers where they are and add a notice
>>>> about the new V4L API as a comment?
>>>>
>>>> What you proposed breaks compilation. If you add a warning, it breaks
>>>> compilation for programs compiled with -Werror. Both are regressions.
>>>
>>> I don't mind doing it for 3.3 kernel, and add a note at
>>> Documentation/feature-removal-schedule.txt that the
>>> headers will go away on 3.4. This should give distributions
>>> and app developers enough time to prevent build failures, and
>>> prepare for the upcoming changes.
>>
>> Are you serious?
>>
>> Breaking things that worked well for many years - for an artificially
>> invented reason - is so annoying, I can't even find the words to express
>> how much this sucks.
>
> Andreas,
>
> All the in-kernel API's are there to support in-kernel drivers.
>
> Out of tree drivers can do whatever they want. As you likely know, several STB
> vendors have their own API's.
>
> Some use some variants of DVBv3 or DVBv5, and some use their own proprietary
> API's, that are even incompatible with DVB (and some even provide both).
>
> Even the ones that use DVBv3 (or v5) have their own implementation that diverges
> from the upstream one.
>
> Provided that such vendors don't violate the Kernel GPLv2 license where it applies,
> they're free do do whatever they want, forking the DVB API, or creating their own
> stacks.
>
> So, keeping the in-kernel unused ioctl's don't bring any real benefit, as vendors
> can still do their forks, and applications designed to work with those hardware
> need to support the vendor's stack.


In another thread, where I requested you to revert the audio/video
ioctl removal
patch, I did chime in that those headers are in use. If you consider a
driver that's
to be merged as an out-of tree driver, then you are asking people to go away.
