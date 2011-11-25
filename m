Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1KYCoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 21:44:37 -0500
Message-ID: <4ECF010F.5060501@redhat.com>
Date: Fri, 25 Nov 2011 00:44:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <4ECE8434.5060106@linuxtv.org> <4ECE85CE.7040807@redhat.com> <4ECE87EA.9000001@linuxtv.org> <4ECE8C06.2070302@redhat.com> <4ECEEAC6.4080208@linuxtv.org>
In-Reply-To: <4ECEEAC6.4080208@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 23:09, Andreas Oberritter escreveu:
> On 24.11.2011 19:25, Mauro Carvalho Chehab wrote:
>> Em 24-11-2011 16:07, Andreas Oberritter escreveu:
>>> On 24.11.2011 18:58, Mauro Carvalho Chehab wrote:
>>>> Em 24-11-2011 15:51, Andreas Oberritter escreveu:
>>>>> On 24.11.2011 18:44, Hans Verkuil wrote:
>>>>>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>>>>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>>>>>> new API, but - pretty please - don't just blindly remove audio.h and
>>>>>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>>>>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>>>>>> those out-of-tree drivers merged, but it isn't possible for many
>>>>>>> reasons. And even if they were merged, you'd say "Port them and your
>>>>>>> apps to V4L". No! That's not an option.
>>>>>>
>>>>>> I'm not breaking anything. All apps will still work.
>>>>>>
>>>>>> One option (and it depends on whether people like it or not) is to have
>>>>>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>>>>>> that these headers need to be replaced by the new av7110.h.
>>>>>>
>>>>>> And really remove them at some point in the future.
>>>>>>
>>>>>> But the important thing to realize is that the ABI hasn't changed (unless
>>>>>> I made a mistake somewhere).
>>>>>
>>>>> So why don't you just leave the headers where they are and add a notice
>>>>> about the new V4L API as a comment?
>>>>>
>>>>> What you proposed breaks compilation. If you add a warning, it breaks
>>>>> compilation for programs compiled with -Werror. Both are regressions.
>>>>
>>>> I don't mind doing it for 3.3 kernel, and add a note at
>>>> Documentation/feature-removal-schedule.txt that the
>>>> headers will go away on 3.4. This should give distributions
>>>> and app developers enough time to prevent build failures, and
>>>> prepare for the upcoming changes.
>>>
>>> Are you serious?
>>>
>>> Breaking things that worked well for many years - for an artificially
>>> invented reason - is so annoying, I can't even find the words to express
>>> how much this sucks.
>>
>> Andreas,
>>
>> All the in-kernel API's are there to support in-kernel drivers.
>>
>> Out of tree drivers can do whatever they want. As you likely know, several STB 
>> vendors have their own API's. 
>>
>> Some use some variants of DVBv3 or DVBv5, and some use their own proprietary
>> API's, that are even incompatible with DVB (and some even provide both).
>>
>> Even the ones that use DVBv3 (or v5) have their own implementation that diverges
>> from the upstream one.
>>
>> Provided that such vendors don't violate the Kernel GPLv2 license where it applies, 
>> they're free do do whatever they want, forking the DVB API, or creating their own
>> stacks.
> 
> You're encouraging people to do their own stuff instead of using and
> contributing to a common API?

Not at all, but this is what happens when drivers are out-of-tree.
The only way to avoid it to happen is to merge the drivers upstream.

> Anyway, you're talking about the DVB API as a whole, which of course
> diverges a little bit from upstream in every implementation, because
> patches to enhance the API are generally rejected if no in-kernel driver
> uses the new function/flag/whatever at the time of its introduction. I
> would have submitted many more API enhancements in the past, if you
> wouldn't force that strict policy. Instead I usually have to wait until
> another developer does the same job and then merge our work.

There are no restrictions for you to merge your API enhancements with your drivers.

> On the other hand, S2API was merged upstream with many unused "DTV_xxx"
> commands and unused structs in the public header, being incomplete at
> the same time (e.g. missing DiSEqC support and signal quality
> measurements functions).

Yes, this was a big mistake. It should never happen again. On that time,
I trusted that the developer that proposed S2API would provide us both API 
documentation and the missing features, as promised, with unfortunately
didn't happen.

This is one more reason for me to not accept anymore patches that adds incomplete
stuff at the Kernel API's: a new API patch series now needs to provide:
   - API bits;
   - Documentation;
   - driver using it.

This is the only way to be sure that everything is all set, and to warrant that
other drivers using the API will behave like the first one that added it.

>> So, keeping the in-kernel unused ioctl's don't bring any real benefit, as vendors
>> can still do their forks, and applications designed to work with those hardware 
>> need to support the vendor's stack.
> 
> Can you please list all unused ioctls? As you know, av7110 uses some of
> them and Manu is currently developing another open source driver using
> the audio and video APIs. Please don't pretend that all ioctls are
> unused to justify a removal of the whole API.

a make htmldocs will list what API calls aren't documented:

Error: no ID for constraint linkend: AUDIO_GET_PTS.
Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
Error: no ID for constraint linkend: CA_RESET.
Error: no ID for constraint linkend: CA_GET_CAP.
Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
Error: no ID for constraint linkend: CA_GET_MSG.
Error: no ID for constraint linkend: CA_SEND_MSG.
Error: no ID for constraint linkend: CA_SET_DESCR.
Error: no ID for constraint linkend: CA_SET_PID.
Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
Error: no ID for constraint linkend: DMX_GET_CAPS.
Error: no ID for constraint linkend: DMX_SET_SOURCE.
Error: no ID for constraint linkend: DMX_ADD_PID.
Error: no ID for constraint linkend: DMX_REMOVE_PID.
Error: no ID for constraint linkend: DTV-ENUM-DELSYS.
Error: no ID for constraint linkend: NET_ADD_IF.
Error: no ID for constraint linkend: NET_REMOVE_IF.
Error: no ID for constraint linkend: NET_GET_IF.
Error: no ID for constraint linkend: VIDEO_GET_SIZE.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
Error: no ID for constraint linkend: VIDEO_GET_PTS.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
Error: no ID for constraint linkend: VIDEO_COMMAND.
Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.

As far as I remember, the audio/video ioctl's there aren't used. I've made
a presentation in Prague where I listed what's in usage. I think I've sent
it to the meeting's public mailing list. I'll put it on a public repository
when I have some time.
 
>> On the other hand, keeping an outdated API that doesn't fit well for the vendors
>> that want to upstream their STB drivers is bad, as it creates confusion for
>> them, and prevents innovation, as they may try to workaround on the limitation of
>> an API designed for the first generation DVB standards.
> 
> Can you elaborate which parts of the current generation DVB standards
> limit the use of the audio and video API, apart from the missing video
> codec flags, which were sent to the mailing list as a patch in 2006?

Making an exhaustive list takes some time, but one of the big missing part
is the pipeline setting. SoC devices may have several ways to configure the
pipelines, any may have some processing blocks in the middle of the image
processing. It may also need to share buffers with the video adapter of the
SoC. All those features are there at the V4L2 core, and are provided via
the V4L2 subdev and the Media Controller API's. All those discussions are
under heavy development since 2008. Re-implementing it at the DVB API
would be to re-invent the wheel.

Also, SoC devices may have analog TV, Web cams, grabber sources, digital
TV, etc as input, and, after decoded, using the same pipeline for outputing
or displaying the video.

> As already said in another mail today, a comment explaining the
> existence and benefits of the V4L video decoder API at the top of
> linux/dvb/{audio,video}.h would stop the confusion you're talking about.

It would be really nice if you, Manu and Oliver could be there in Prague,
as those things were discussed there with other Kernelspace and userspace
developers. This is the kind of discussion that could take a large amount
of time to discuss and come to a common understanding via email.

I'll seek for some time to write something about that. Maybe the others that
followed the discussions could write a summary about it.

Maybe we could try, instead, to set some audio or video conference with the
interested parties (or even a discussion on irc?).

> Btw.: How does V4l replace osd.h and audio.h? I know that osd.h has been
> deprecated for many years, but all reasoning I've heard in this thread
> until now was that V4L was superior to the DVB video decoder API.

OSD is currently not supported directly, although I think that the proper
way for doing it is via the shared buffer API, e. g., doing OSD composition
inside the video adapter. While V4L2 is well-known for video input, it also
supports video output, and the shared buffer API is enhancing it by allowing
to share a video buffer with the GPU.

The V4L2 API has several ioctl's to control the audio of the stream, like
selecting the language, SAP, stereo, etc. The DVB implementation for audio
demod status (pause, play, etc) is the same kind of control that is done at
the video part. So, the Hans proposal is to use the same ioctl's for both
audio and video. This approach doesn't allow things like pausing audio while
keeping video running, but this doesn't seem to make much sense, anyway.

>> That's what Hans patches are addressing.
>>
>> If you have a better approach, feel free to suggest it, provided that, at the end,
>> the API that aren't used by non-legacy drivers are removed (or moved to driver's
>> specific ioctl's).
> 
> OK. Can we agree on waiting for Manu's "non-legacy" driver to get
> merged? After that we can remove unused ioctls - and only those. I
> assume that "legacy" in your sentence means "unable to decode H.264",
> which is a little bit odd, considering that large amounts of SDTV STBs
> are still being sold worldwide and considering that analogue TV is still
> being used in more than a handful of locations.

Legacy, in my sentence means legacy hardware.

The thing is that, while the audio/video DVB API would make some sense at
av7110 time, with SoC designs, it become obsolete as a hole, as it is not
enough to replace V4L2/ALSA/MC/subdev API's, and changing it to fulfill
today's needs would require a very large amount of re-work on something
that it is already there.

So, I fail to see how waiting for Manu's driver would change it. In any case,
I'm not on a hurry. So, should discuss it more, in order to properly
address the evolution of the media API.

Regards,
Mauro
