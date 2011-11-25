Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:36593 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1KYQDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 11:03:45 -0500
Message-ID: <4ECFBC5E.6080308@linuxtv.org>
Date: Fri, 25 Nov 2011 17:03:42 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com> <4ECE8839.8040606@redhat.com> <CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com> <4ECE913A.9090001@redhat.com> <4ECF8359.5080705@linuxtv.org> <4ECF9C92.2040607@redhat.com> <4ECFA927.10108@linuxtv.org> <4ECFB686.2090204@redhat.com>
In-Reply-To: <4ECFB686.2090204@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.11.2011 16:38, Mauro Carvalho Chehab wrote:
> Em 25-11-2011 12:41, Andreas Oberritter escreveu:
>> On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
>>> If your complain is about the removal of audio.h, video.h
>>
>> We're back on topic, thank you!
>>
>>> and osd.h, then my proposal is
>>> to keep it there, writing a text that they are part of a deprecated API,
>>
>> That's exactly what I proposed. Well, you shouldn't write "deprecated",
>> because it's not. Just explain - inside this text - when V4L2 should be
>> preferred over DVB.
> 
> It is deprecated, as the API is not growing to fulfill today's needs, and
> no patches adding new stuff to it to it will be accepted anymore.

Haha, nice one. "It doesn't grow because I don't allow it to." Great!

>>> but keeping
>>> the rest of the patches
>>
>> Which ones?
> 
> V4L2, ivtv and DocBook patches.

Fine.

>>> and not accepting anymore any submission using them
>>
>> Why? First you complain about missing users and then don't want to allow
>> any new ones.
> 
> I didn't complain about missing users. What I've said is that, between a
> one-user API and broad used APIs like ALSA and V4L2, the choice is to freeze
> the one-user API and mark it as deprecated.

Your assumtion about only one user still isn't true.

> Also, today's needs are properly already covered by V4L/ALSA/MC/subdev. 
> It is easier to add what's missing there for DVB than to work the other
> way around, and deprecate V4L2/ALSA/MC/subdev.

Yes. Please! Add it! But leave the DVB API alone!

>>> , removing
>>> the ioctl's that aren't used by av7110 from them.
>>
>> That's just stupid. I can easily provide a list of used and valuable
>> ioctls, which need to remain present in order to not break userspace
>> applications.
> 
> Those ioctl's aren't used by any Kernel driver, and not even documented.
> So, why to keep/maintain them?

If you already deprecated it, why bother deleting random stuff from it
that people are using?

There's a difference in keeping and maintaining something. You don't
need to maintain ioctls that haven't changed in years. Deleting
something is more work than letting it there to be used by those who
want to.

>> Btw.: It's not easy to submit a driver for a SoC. Even if you are
>> legally allowed to do it, you have to first merge and maintain the board
>> support code before even thinking about multimedia.
> 
> Yes, I know that there's a long road for SoC drivers addition. Fortunately,
> several vendors are now working to put their stuff upstream.
> 
> I heard that there are some upcoming changes intended to simplify it a little bit,
> trying to make the architecture a little more generic, and put board-specific
> configuration on userspace. I dunno the details.

Thanks for your help.

Regards,
Andreas
