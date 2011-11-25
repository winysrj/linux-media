Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:33896 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab1KYMzZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 07:55:25 -0500
Message-ID: <4ECF9038.6050208@linuxtv.org>
Date: Fri, 25 Nov 2011 13:55:20 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <4ECE8434.5060106@linuxtv.org> <4ECE85CE.7040807@redhat.com> <4ECE87EA.9000001@linuxtv.org> <4ECE8C06.2070302@redhat.com> <4ECEEAC6.4080208@linuxtv.org> <4ECF010F.5060501@redhat.com>
In-Reply-To: <4ECF010F.5060501@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.11.2011 03:44, Mauro Carvalho Chehab wrote:
> Em 24-11-2011 23:09, Andreas Oberritter escreveu:
>> On 24.11.2011 19:25, Mauro Carvalho Chehab wrote:
>>> Em 24-11-2011 16:07, Andreas Oberritter escreveu:
>>>> On 24.11.2011 18:58, Mauro Carvalho Chehab wrote:
>>>>> Em 24-11-2011 15:51, Andreas Oberritter escreveu:
>>
>> You're encouraging people to do their own stuff instead of using and
>> contributing to a common API?
> 
> Not at all, but this is what happens when drivers are out-of-tree.
> The only way to avoid it to happen is to merge the drivers upstream.

Well, you're right. But only because you artificially made it the only
way to contribute to the API.

>> Anyway, you're talking about the DVB API as a whole, which of course
>> diverges a little bit from upstream in every implementation, because
>> patches to enhance the API are generally rejected if no in-kernel driver
>> uses the new function/flag/whatever at the time of its introduction. I
>> would have submitted many more API enhancements in the past, if you
>> wouldn't force that strict policy. Instead I usually have to wait until
>> another developer does the same job and then merge our work.
> 
> There are no restrictions for you to merge your API enhancements with your drivers.

I guess you're misunderstanding. I don't need to merge *my* enhancements
with *my* drivers. I need to merge upstream API changes with my local
API changes, whenever they are done, i.e. when a device appears which
has a new feature for which I already have created an API extension. See
DVB-T2 as an example: I had the API definition ready and tested about a
year before the first public driver appeared. But I couldn't merge it
upstream without submitting a driver. The result of course is that
everybody else who wanted to develop a DVB-T2 driver during that period
of time needed to create his own API, which IMO is worse than having a
new API (well, two or three #defines or additions to enums) without
in-kernel users.

>> On the other hand, S2API was merged upstream with many unused "DTV_xxx"
>> commands and unused structs in the public header, being incomplete at
>> the same time (e.g. missing DiSEqC support and signal quality
>> measurements functions).
> 
> Yes, this was a big mistake. It should never happen again. On that time,
> I trusted that the developer that proposed S2API would provide us both API 
> documentation and the missing features, as promised, with unfortunately
> didn't happen.
> 
> This is one more reason for me to not accept anymore patches that adds incomplete
> stuff at the Kernel API's: a new API patch series now needs to provide:
>    - API bits;
>    - Documentation;
>    - driver using it.
> 
> This is the only way to be sure that everything is all set, and to warrant that
> other drivers using the API will behave like the first one that added it.

It does not warrant anything, because both drivers and APIs do contain
bugs and oversights, and first implementations are usually worst. You
can't foresee the future, so APIs will eventually evolve, no matter
whether submitted together with a driver or without.

>>> So, keeping the in-kernel unused ioctl's don't bring any real benefit, as vendors
>>> can still do their forks, and applications designed to work with those hardware 
>>> need to support the vendor's stack.
>>
>> Can you please list all unused ioctls? As you know, av7110 uses some of
>> them and Manu is currently developing another open source driver using
>> the audio and video APIs. Please don't pretend that all ioctls are
>> unused to justify a removal of the whole API.
> 
> a make htmldocs will list what API calls aren't documented:
> 
> Error: no ID for constraint linkend: AUDIO_GET_PTS.
> Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
> Error: no ID for constraint linkend: CA_RESET.
> Error: no ID for constraint linkend: CA_GET_CAP.
> Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
> Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
> Error: no ID for constraint linkend: CA_GET_MSG.
> Error: no ID for constraint linkend: CA_SEND_MSG.
> Error: no ID for constraint linkend: CA_SET_DESCR.
> Error: no ID for constraint linkend: CA_SET_PID.
> Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
> Error: no ID for constraint linkend: DMX_GET_CAPS.
> Error: no ID for constraint linkend: DMX_SET_SOURCE.
> Error: no ID for constraint linkend: DMX_ADD_PID.
> Error: no ID for constraint linkend: DMX_REMOVE_PID.
> Error: no ID for constraint linkend: DTV-ENUM-DELSYS.
> Error: no ID for constraint linkend: NET_ADD_IF.
> Error: no ID for constraint linkend: NET_REMOVE_IF.
> Error: no ID for constraint linkend: NET_GET_IF.
> Error: no ID for constraint linkend: VIDEO_GET_SIZE.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
> Error: no ID for constraint linkend: VIDEO_GET_PTS.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
> Error: no ID for constraint linkend: VIDEO_COMMAND.
> Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.
> 
> As far as I remember, the audio/video ioctl's there aren't used. I've made
> a presentation in Prague where I listed what's in usage. I think I've sent
> it to the meeting's public mailing list. I'll put it on a public repository
> when I have some time.

Undocumented doesn't mean unused.

VIDEO_GET_SIZE is used by av7110.

I wouldn't miss VIDEO_COMMAND and VIDEO_TRY_COMMAND. I have no idea why
they were added by Hans in the first place, duplicating many existing
commands. I also wouldn't miss VIDEO_GET_FRAME_COUNT, which was added by
Hans in the same patch. I don't know what this was good for. Ditto for
AUDIO_BILINGUAL_CHANNEL_SELECT.

Of the a/v ioctls listed above I'm using AUDIO_GET_PTS, VIDEO_GET_SIZE,
VIDEO_GET_PTS, VIDEO_GET_FRAME_RATE. I think it would be trivial to
implement them for the av7110. I guess Manu's driver will be using them
anyway.

>>> On the other hand, keeping an outdated API that doesn't fit well for the vendors
>>> that want to upstream their STB drivers is bad, as it creates confusion for
>>> them, and prevents innovation, as they may try to workaround on the limitation of
>>> an API designed for the first generation DVB standards.
>>
>> Can you elaborate which parts of the current generation DVB standards
>> limit the use of the audio and video API, apart from the missing video
>> codec flags, which were sent to the mailing list as a patch in 2006?
> 
> Making an exhaustive list takes some time, but one of the big missing part
> is the pipeline setting. SoC devices may have several ways to configure the
> pipelines, any may have some processing blocks in the middle of the image
> processing. It may also need to share buffers with the video adapter of the
> SoC. All those features are there at the V4L2 core, and are provided via
> the V4L2 subdev and the Media Controller API's. All those discussions are
> under heavy development since 2008. Re-implementing it at the DVB API
> would be to re-invent the wheel.
> 
> Also, SoC devices may have analog TV, Web cams, grabber sources, digital
> TV, etc as input, and, after decoded, using the same pipeline for outputing
> or displaying the video.

See, it has nothing to do with DVB standards. One more of your spurious
arguments just vanished.

>> As already said in another mail today, a comment explaining the
>> existence and benefits of the V4L video decoder API at the top of
>> linux/dvb/{audio,video}.h would stop the confusion you're talking about.
> 
> It would be really nice if you, Manu and Oliver could be there in Prague,
> as those things were discussed there with other Kernelspace and userspace
> developers. This is the kind of discussion that could take a large amount
> of time to discuss and come to a common understanding via email.

You should know that there were good reasons for many people not to
attend the event. It's OK to discuss stuff at a meeting with random
people, but you should listen to other people's opinions afterwards, too.

*But* whatever you decided in Prague, just do it, but without breaking
the API. That's all we want. Nothing more, nothing less.

> I'll seek for some time to write something about that. Maybe the others that
> followed the discussions could write a summary about it.
> 
> Maybe we could try, instead, to set some audio or video conference with the
> interested parties (or even a discussion on irc?).
> 
>> Btw.: How does V4l replace osd.h and audio.h? I know that osd.h has been
>> deprecated for many years, but all reasoning I've heard in this thread
>> until now was that V4L was superior to the DVB video decoder API.
> 
> OSD is currently not supported directly, although I think that the proper
> way for doing it is via the shared buffer API, e. g., doing OSD composition
> inside the video adapter. While V4L2 is well-known for video input, it also
> supports video output, and the shared buffer API is enhancing it by allowing
> to share a video buffer with the GPU.
> 
> The V4L2 API has several ioctl's to control the audio of the stream, like
> selecting the language, SAP, stereo, etc. The DVB implementation for audio
> demod status (pause, play, etc) is the same kind of control that is done at
> the video part. So, the Hans proposal is to use the same ioctl's for both
> audio and video. This approach doesn't allow things like pausing audio while
> keeping video running, but this doesn't seem to make much sense, anyway.

So you're duplicating audio APIs at V4L2 and think it's better than
duplicating them in DVB with respect to ALSA?

Can you control pass-through of digital audio to SPDIF for example? Can
you control which decoder should be the master when synchronizing AV?

>>> That's what Hans patches are addressing.
>>>
>>> If you have a better approach, feel free to suggest it, provided that, at the end,
>>> the API that aren't used by non-legacy drivers are removed (or moved to driver's
>>> specific ioctl's).
>>
>> OK. Can we agree on waiting for Manu's "non-legacy" driver to get
>> merged? After that we can remove unused ioctls - and only those. I
>> assume that "legacy" in your sentence means "unable to decode H.264",
>> which is a little bit odd, considering that large amounts of SDTV STBs
>> are still being sold worldwide and considering that analogue TV is still
>> being used in more than a handful of locations.
> 
> Legacy, in my sentence means legacy hardware.

So what is legacy hardware? PCI? Everything that's older than 3 years?
Everything you can't buy at Amazon?

> The thing is that, while the audio/video DVB API would make some sense at
> av7110 time, with SoC designs, it become obsolete as a hole, as it is not
> enough to replace V4L2/ALSA/MC/subdev API's, and changing it to fulfill
> today's needs would require a very large amount of re-work on something
> that it is already there.

I'm currently actively using the API on three different families of
SoCs. And yes, even on new ones. Please tell me again that my work is
obsolete.

Nobody wants to replace V4L2/ALSA/MC/subdev APIs. I don't know why
you're writing that. Do whatever you want with those APIs but don't
break DVB.

> So, I fail to see how waiting for Manu's driver would change it. In any case,
> I'm not on a hurry. So, should discuss it more, in order to properly
> address the evolution of the media API.

Manu's driver will show you how to the DVB API fulfills today's needs
for DVB.

Again, at this point in time there is no "media API".

Regards,
Andreas
