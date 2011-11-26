Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1KZL7V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 06:59:21 -0500
Message-ID: <4ED0D48F.40007@redhat.com>
Date: Sat, 26 Nov 2011 09:59:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <CAHFNz9LS1OxumLvWBXaLFri8_dW3jAOvJJ4NpeZFCDbCiJd+YA@mail.gmail.com> <4ED0116A.6050108@linuxtv.org> <201111260655.54570@orion.escape-edv.de> <4ED0CE6A.3030703@redhat.com>
In-Reply-To: <4ED0CE6A.3030703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-11-2011 09:32, Mauro Carvalho Chehab escreveu:
> Em 26-11-2011 03:55, Oliver Endriss escreveu:
>> On Friday 25 November 2011 23:06:34 Andreas Oberritter wrote:
>>> On 25.11.2011 17:51, Manu Abraham wrote:
>>>> On Fri, Nov 25, 2011 at 9:56 PM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> Em 25-11-2011 14:03, Andreas Oberritter escreveu:
>>>>>> On 25.11.2011 16:38, Mauro Carvalho Chehab wrote:
>>>>>>> Em 25-11-2011 12:41, Andreas Oberritter escreveu:
>>>>>>>> On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
>>>>>>>>> If your complain is about the removal of audio.h, video.h
>>>>>>>>
>>>>>>>> We're back on topic, thank you!
>>>>>>>>
>>>>>>>>> and osd.h, then my proposal is
>>>>>>>>> to keep it there, writing a text that they are part of a deprecated API,
>>>>>>>>
>>>>>>>> That's exactly what I proposed. Well, you shouldn't write "deprecated",
>>>>>>>> because it's not. Just explain - inside this text - when V4L2 should be
>>>>>>>> preferred over DVB.
>>>>>>>
>>>>>>> It is deprecated, as the API is not growing to fulfill today's needs, and
>>>>>>> no patches adding new stuff to it to it will be accepted anymore.
>>>>>>
>>>>>> Haha, nice one. "It doesn't grow because I don't allow it to." Great!
>>>>>
>>>>> No. It didn't grow because nobody cared with it for years:
>>>>>
>>>>> Since 2.6.12-rc2 (start of git history), no changes ever happened at osd.h.
>>>>>
>>>>> Excluding Hans changes for using it on a pure V4L device, and other trivial
>>>>> patches not related to API changes, the last API change on audio.h and video.h
>>>>> was this patch:
>>>>>        commit f05cce863fa399dd79c5aa3896d608b8b86d8030
>>>>>        Author: Andreas Oberritter <obi@linuxtv.org>
>>>>>        Date:   Mon Feb 27 00:09:00 2006 -0300
>>>>>
>>>>>            V4L/DVB (3375): Add AUDIO_GET_PTS and VIDEO_GET_PTS ioctls
>>>>>
>>>>>        (yet not used on any upstream driver)
>>>>>
>>>>> An then:
>>>>>        commit 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
>>>>>        Author: Linus Torvalds <torvalds@ppc970.osdl.org>
>>>>>        Date:   Sat Apr 16 15:20:36 2005 -0700
>>>>>
>>>>>            Linux-2.6.12-rc2
>>>>>
>>>>> No changes adding support for any in-kernel driver were ever added there.
>>>>>
>>>>> So, it didn't grow over the last 5 or 6 years because nobody submitted
>>>>> driver patches requiring new things or _even_ using it.
>>>>>
>>>>>>
>>>>>>>>> but keeping
>>>>>>>>> the rest of the patches
>>>>>>>>
>>>>>>>> Which ones?
>>>>>>>
>>>>>>> V4L2, ivtv and DocBook patches.
>>>>>>
>>>>>> Fine.
>>>>>>
>>>>>>>>> and not accepting anymore any submission using them
>>>>>>>>
>>>>>>>> Why? First you complain about missing users and then don't want to allow
>>>>>>>> any new ones.
>>>>>>>
>>>>>>> I didn't complain about missing users. What I've said is that, between a
>>>>>>> one-user API and broad used APIs like ALSA and V4L2, the choice is to freeze
>>>>>>> the one-user API and mark it as deprecated.
>>>>>>
>>>>>> Your assumtion about only one user still isn't true.
>>>>>>
>>>>>>> Also, today's needs are properly already covered by V4L/ALSA/MC/subdev.
>>>>>>> It is easier to add what's missing there for DVB than to work the other
>>>>>>> way around, and deprecate V4L2/ALSA/MC/subdev.
>>>>>>
>>>>>> Yes. Please! Add it! But leave the DVB API alone!
>>>>>>
>>>>>>>>> , removing
>>>>>>>>> the ioctl's that aren't used by av7110 from them.
>>>>>>>>
>>>>>>>> That's just stupid. I can easily provide a list of used and valuable
>>>>>>>> ioctls, which need to remain present in order to not break userspace
>>>>>>>> applications.
>>>>>>>
>>>>>>> Those ioctl's aren't used by any Kernel driver, and not even documented.
>>>>>>> So, why to keep/maintain them?
>>>>>>
>>>>>> If you already deprecated it, why bother deleting random stuff from it
>>>>>> that people are using?
>>>>>>
>>>>>> There's a difference in keeping and maintaining something. You don't
>>>>>> need to maintain ioctls that haven't changed in years. Deleting
>>>>>> something is more work than letting it there to be used by those who
>>>>>> want to.
>>>>>
>>>>> Ok. Let's just keep the headers as is, just adding a comment that it is now
>>>>> considered superseded.
>>>
>>> Thank you! This is a step into the right direction.
>>>
>>>> http://dictionary.reference.com/browse/superseded
>>>>
>>>> to set aside or cause to be set aside as void, useless, or obsolete, usually
>>>> in favor of something mentioned; make obsolete: They superseded the
>>>> old statute with a new one.
>>>>
>>>> No, that's not acceptable. New DVB devices as they come will make use
>>>> of the API and API changes might be applied.
>>>
>>> Honestly, I think we all should accept this proposal and just hope that
>>> the comment is going to be written objectively.
>>
>> 'Hoping' is not enough for me anymore. I am deeply disappointed.
>> Mauro and Hans have severely damaged my trust, that v4ldvb APIs are
>> stable in Linux, and how things are handled in this project.
>>
>> So I request a public statement from the subsystem maintainer that
>> 1. The DVB Decoder API will not be removed.
>> 2. It can be updated if required (e.g. adding a missing function).
>> 3. New drivers are allowed to use this architecture.
>> 4. These driver will be accepted, if they follow the kernel standards.
>>
>> The reason is simple: I need to know, whether this project is still
>> worth investing some time, or it is better to do something else.
>>
> 
> What it is agreed so far is to keep it there untouched, doing the evolution
> for the decoder API via V4L2, in order to merge efforts on decoding
> features, and use the proper existing systems to output decoded audio and
> video streams (ALSA and V4L2). 
> 
> In other words, (item 1) the headers will stay there, with a note pointing 
> that the evolution will be via V4L2. As the evolution will follow another
> direction, I don't agree it your items 2, 3 and 4.

A small addendum: drivers can still be merged at staging. I can help the efforts
of porting them to use ALSA/V4L2.

Regards,
Mauro
