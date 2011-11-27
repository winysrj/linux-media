Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1K0S3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 13:29:03 -0500
Message-ID: <4ED28165.9000600@redhat.com>
Date: Sun, 27 Nov 2011 16:28:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <4ED0116A.6050108@linuxtv.org> <201111260655.54570@orion.escape-edv.de> <201111261249.09740.hverkuil@xs4all.nl> <4ED14BB5.1050907@linuxtv.org>
In-Reply-To: <4ED14BB5.1050907@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-11-2011 18:27, Andreas Oberritter escreveu:
> On 26.11.2011 12:49, Hans Verkuil wrote:
>> On Saturday, November 26, 2011 06:55:52 Oliver Endriss wrote:
>>> On Friday 25 November 2011 23:06:34 Andreas Oberritter wrote:
>>>> On 25.11.2011 17:51, Manu Abraham wrote:
>>>>> On Fri, Nov 25, 2011 at 9:56 PM, Mauro Carvalho Chehab
>>>>> <mchehab@redhat.com> wrote:
>>>>>> Em 25-11-2011 14:03, Andreas Oberritter escreveu:
>>>>>>> On 25.11.2011 16:38, Mauro Carvalho Chehab wrote:
>>>>>>>> Em 25-11-2011 12:41, Andreas Oberritter escreveu:
>>>>>>>>> On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
>>>>>>>>>> If your complain is about the removal of audio.h, video.h
>>>>>>>>>
>>>>>>>>> We're back on topic, thank you!
>>>>>>>>>
>>>>>>>>>> and osd.h, then my proposal is
>>>>>>>>>> to keep it there, writing a text that they are part of a deprecated API,
>>>>>>>>>
>>>>>>>>> That's exactly what I proposed. Well, you shouldn't write "deprecated",
>>>>>>>>> because it's not. Just explain - inside this text - when V4L2 should be
>>>>>>>>> preferred over DVB.
>>>>>>>>
>>>>>>>> It is deprecated, as the API is not growing to fulfill today's needs, and
>>>>>>>> no patches adding new stuff to it to it will be accepted anymore.
>>>>>>>
>>>>>>> Haha, nice one. "It doesn't grow because I don't allow it to." Great!
>>>>>>
>>>>>> No. It didn't grow because nobody cared with it for years:
>>>>>>
>>>>>> Since 2.6.12-rc2 (start of git history), no changes ever happened at osd.h.
>>>>>>
>>>>>> Excluding Hans changes for using it on a pure V4L device, and other trivial
>>>>>> patches not related to API changes, the last API change on audio.h and video.h
>>>>>> was this patch:
>>>>>>        commit f05cce863fa399dd79c5aa3896d608b8b86d8030
>>>>>>        Author: Andreas Oberritter <obi@linuxtv.org>
>>>>>>        Date:   Mon Feb 27 00:09:00 2006 -0300
>>>>>>
>>>>>>            V4L/DVB (3375): Add AUDIO_GET_PTS and VIDEO_GET_PTS ioctls
>>>>>>
>>>>>>        (yet not used on any upstream driver)
>>>>>>
>>>>>> An then:
>>>>>>        commit 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
>>>>>>        Author: Linus Torvalds <torvalds@ppc970.osdl.org>
>>>>>>        Date:   Sat Apr 16 15:20:36 2005 -0700
>>>>>>
>>>>>>            Linux-2.6.12-rc2
>>>>>>
>>>>>> No changes adding support for any in-kernel driver were ever added there.
>>>>>>
>>>>>> So, it didn't grow over the last 5 or 6 years because nobody submitted
>>>>>> driver patches requiring new things or _even_ using it.
>>>>>>
>>>>>>>
>>>>>>>>>> but keeping
>>>>>>>>>> the rest of the patches
>>>>>>>>>
>>>>>>>>> Which ones?
>>>>>>>>
>>>>>>>> V4L2, ivtv and DocBook patches.
>>>>>>>
>>>>>>> Fine.
>>>>>>>
>>>>>>>>>> and not accepting anymore any submission using them
>>>>>>>>>
>>>>>>>>> Why? First you complain about missing users and then don't want to allow
>>>>>>>>> any new ones.
>>>>>>>>
>>>>>>>> I didn't complain about missing users. What I've said is that, between a
>>>>>>>> one-user API and broad used APIs like ALSA and V4L2, the choice is to freeze
>>>>>>>> the one-user API and mark it as deprecated.
>>>>>>>
>>>>>>> Your assumtion about only one user still isn't true.
>>>>>>>
>>>>>>>> Also, today's needs are properly already covered by V4L/ALSA/MC/subdev.
>>>>>>>> It is easier to add what's missing there for DVB than to work the other
>>>>>>>> way around, and deprecate V4L2/ALSA/MC/subdev.
>>>>>>>
>>>>>>> Yes. Please! Add it! But leave the DVB API alone!
>>>>>>>
>>>>>>>>>> , removing
>>>>>>>>>> the ioctl's that aren't used by av7110 from them.
>>>>>>>>>
>>>>>>>>> That's just stupid. I can easily provide a list of used and valuable
>>>>>>>>> ioctls, which need to remain present in order to not break userspace
>>>>>>>>> applications.
>>>>>>>>
>>>>>>>> Those ioctl's aren't used by any Kernel driver, and not even documented.
>>>>>>>> So, why to keep/maintain them?
>>>>>>>
>>>>>>> If you already deprecated it, why bother deleting random stuff from it
>>>>>>> that people are using?
>>>>>>>
>>>>>>> There's a difference in keeping and maintaining something. You don't
>>>>>>> need to maintain ioctls that haven't changed in years. Deleting
>>>>>>> something is more work than letting it there to be used by those who
>>>>>>> want to.
>>>>>>
>>>>>> Ok. Let's just keep the headers as is, just adding a comment that it is now
>>>>>> considered superseded.
>>>>
>>>> Thank you! This is a step into the right direction.
>>>>
>>>>> http://dictionary.reference.com/browse/superseded
>>>>>
>>>>> to set aside or cause to be set aside as void, useless, or obsolete, usually
>>>>> in favor of something mentioned; make obsolete: They superseded the
>>>>> old statute with a new one.
>>>>>
>>>>> No, that's not acceptable. New DVB devices as they come will make use
>>>>> of the API and API changes might be applied.
>>>>
>>>> Honestly, I think we all should accept this proposal and just hope that
>>>> the comment is going to be written objectively.
>>>
>>> 'Hoping' is not enough for me anymore. I am deeply disappointed.
>>> Mauro and Hans have severely damaged my trust, that v4ldvb APIs are
>>> stable in Linux, and how things are handled in this project.
>>>
>>> So I request a public statement from the subsystem maintainer that
>>> 1. The DVB Decoder API will not be removed.
>>> 2. It can be updated if required (e.g. adding a missing function).
>>> 3. New drivers are allowed to use this architecture.
>>> 4. These driver will be accepted, if they follow the kernel standards.
>>>
>>> The reason is simple: I need to know, whether this project is still
>>> worth investing some time, or it is better to do something else.
>>
>> 1) There are two APIs that do the same thing: the DVB decoder API and the
>>    V4L2 API.
>> 2) That's bad because it confuses driver developers and application developers
>>    who have to support *two* APIs to do the same thing.
> 
> I've heard that more than once now from you and Mauro, but can you name
> anyone who's actually so confused that it justifies creating confusion
> for other people by breaking stuff?
> 
> Nobody has to support two APIs. You can choose which API to implement,
> depending on what applications you want to be compatible to. Removing
> one API doesn't make all applications compatible to the other one.
> 
>> 3) The DVB decoder API is used in only one DVB driver (av7110), and in one
>>    V4L2 driver (ivtv). The latter is easily converted to V4L2 which leaves only
>>    one driver, av7110.
> 
> OK. av7110 is the only driver implementing the DVB decoder API in-tree
> and has always been. You're implying that it's not easy to convert it to
> V4L2. Are you going to change V4L2 in a way that make it easy to convert
> existing drivers *and* applications?

It shouldn't be hard to support av7110 at V4L2, but it requires someone with the
hardware for doing that.

> 
>> 4) A decoder API has nothing to do with DVB as a standard, it simply takes
>>    the output of the DVB part of the hardware and decodes it to the output.
>>    That's basic V4L2 functionality.
> 
> A TS demux has nothing to do with DVB as a standard either, because it's
> MPEG, not DVB. Still it's implemented in dvb-core. Should we remove it,
> too, to break some more applications for fun?

There's no duplication with TS demux, as only the DVB API does that.

>> 5) Video output is present in quite a few V4L2 drivers (10 at a quick count)
>>    and that already includes support for decoders (just not decoder operations
>>    like PLAY/STOP/PAUSE/RESUME etc., that's where the V4L2 additions come in).
>>    Note that most of the video output drivers these days are from SoCs. That's
>>    where all the activity is these days. Ensuring that SoC vendors know what to
>>    do and that they have the right APIs and frameworks is an important part of
>>    our work these days.
> 
> That's very nice. If this API is attractive enough, I'm sure everybody
> will switch to it eventually by choice.
> 
>> 6) So with 10 V4L2 video output drivers and 1 DVB output driver it is not
>>    hard to see that the easiest solution is to make the DVB decoder API an
>>    av7110-specific API and prohibit its use for new drivers.
> 
> So should we remove the few existing DVB-T2 drivers, too, because there
> are way more DVB-T drivers and both basically just receive terrestrial
> digital signals?

Please don't use silly arguments. The efforts are to solve API conflicts,
not to remove drivers. There's just one API that supports DVB T/T2. It should
be kept there, growing to support newer standards as needed.

Yet, if someone comes with a patch proposing adding a new API outside the DVB API 
for a supported or a new delivery system, such patch will be rejected, and the
developer will be pointed to use the right API's.

>> What should be done with the existing audio.h, video.h and osd.h headers is
>> a separate issue. I believe that keeping them indefinitely is a bad move in
>> the long term if we decide to remove the DVB decoder API but that's just
>> my experience with similar situations (the removal of V4L1 springs to mind).
>> But I'll just follow what Mauro decides.
> 
> The name V4L2 implies that it's a successor of V4L1 and thus that its
> goal was to replace V4L1. That somehow differs from DVB, unless you're
> going to provide demux, frontend and CA APIs in V4L2, too. I'd really
> like this to happen, if the result is going to be superior to the status
> quo. However, please, without annoying all the people that much.

The V4L API (both versions 1 and 2) were designed to control video streams.

I don't think we should extend the V4L API to cover DVB inside it. The
frontend, demux and CI API's are well designed, and they don't conflict with
any other Linux Kernel API's. The net API integrates nicely with the Linux
network stack, so, there's nothing more to touch on them.

> Second, by moving all contents of audio.h, video.h and osd.h to a *new*
> header (av7110.h) that's going to stay, you're just breaking something
> without even removing anything. Application developers won't magically
> start to implement V4L2, but instead they will be forced by you to use
> autoconf et al to detect the presence of av7110.h and use it instead.
> What would be solved then?

We've already agreed to keep the headers there.

>> Yes, there are out-of-tree drivers that use the DVB decoder API. You know
>> the rules: if you are out-of-tree you do not count. That's true for everyone
>> maintaining an out-of-tree driver. I've maintained the out-of-tree ivtv
>> driver at the time and I know the pain. And that's also why SoC vendors are
>> now trying to get their video hardware supported in the kernel, because once
>> it is in much of that pain disappears.
> 
> Until now, there was no pain involved for users of DVB decoder APIs.
> You're causing it.

I can't see any pain on deciding that future developments should be to use
the decoder API that exists in V4L2/ALSA.

> 
>> Finally I want to mention again that the DVB subsystem isn't an ivory tower.
>> It doesn't exist in isolation. Particularly with the ever increasing
>> integration of video capabilities (include DVB) on SoCs cooperation between
>> subsystems is ever more important and will only increase in the future.
> 
> Just provide an acceptable, attractive solution and everybody is going
> to be your friend and follow your proposals.
> 
> Breaking user interfaces instead to force your interpretation of
> "evolution" on other people is a no-go.

Nobody is breaking user interfaces. Even on Hans proposal, nothing breaks,
except for the header rename. With the agreed proposal of preserving the
headers, even this won't break.

> Currently, there is no guide on how to port applications using the DVB
> decoder API to V4L2, right?
> 
> You're just creating a V4L2 API extension and pretend that it's well
> established. Is there any proof that your API is complete enough to be
> used as a drop-in replacement for DVB developers?

This is a nice example where a driver implementing the new API is
required. The ivtv driver brings usage of some requred features. As
av7110 uses a few more ioctls, a patch converting it to use V4L2 
(or adding a new driver with similar features) might need to add some
new V4L2 controls.

If you're not familiar with V4L2 (it is defined at include/linux/videodev2.h), 
the controls interface is close to the DVBv5 frontend API. Controls are used 
to adjust things like bright, contrast, white balance, encoder/decoder 
parameters, etc, and ioctl's are provided to query the supported controls,
to create user-friendy menus for them, and to get/set one or several controls.

Each control is defined as:

struct v4l2_queryctrl {
	__u32		     id;
	enum v4l2_ctrl_type  type;
	__u8		     name[32];	/* Whatever */
	__s32		     minimum;	/* Note signedness */
	__s32		     maximum;
	__s32		     step;
	__s32		     default_value;
	__u32                flags;
	__u32		     reserved[2];
};

So, they have a string name, maximum/minimum/step/default values, and can belong
to several different types, and are sub-divided into classes of control.

For example, the MPEG-1/2 stream class is currently defined as:

#define V4L2_CID_MPEG_STREAM_TYPE 		(V4L2_CID_MPEG_BASE+0)
enum v4l2_mpeg_stream_type {
	V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
	V4L2_MPEG_STREAM_TYPE_MPEG2_TS   = 1, /* MPEG-2 transport stream */
	V4L2_MPEG_STREAM_TYPE_MPEG1_SS   = 2, /* MPEG-1 system stream */
	V4L2_MPEG_STREAM_TYPE_MPEG2_DVD  = 3, /* MPEG-2 DVD-compatible stream */
	V4L2_MPEG_STREAM_TYPE_MPEG1_VCD  = 4, /* MPEG-1 VCD-compatible stream */
	V4L2_MPEG_STREAM_TYPE_MPEG2_SVCD = 5, /* MPEG-2 SVCD-compatible stream */
};
#define V4L2_CID_MPEG_STREAM_PID_PMT 		(V4L2_CID_MPEG_BASE+1)
#define V4L2_CID_MPEG_STREAM_PID_AUDIO 		(V4L2_CID_MPEG_BASE+2)
#define V4L2_CID_MPEG_STREAM_PID_VIDEO 		(V4L2_CID_MPEG_BASE+3)
#define V4L2_CID_MPEG_STREAM_PID_PCR 		(V4L2_CID_MPEG_BASE+4)
#define V4L2_CID_MPEG_STREAM_PES_ID_AUDIO 	(V4L2_CID_MPEG_BASE+5)
#define V4L2_CID_MPEG_STREAM_PES_ID_VIDEO 	(V4L2_CID_MPEG_BASE+6)
#define V4L2_CID_MPEG_STREAM_VBI_FMT 		(V4L2_CID_MPEG_BASE+7)
enum v4l2_mpeg_stream_vbi_fmt {
	V4L2_MPEG_STREAM_VBI_FMT_NONE = 0,  /* No VBI in the MPEG stream */
	V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV format */
};

There are also classes for controlling MPEG video, MPEG audio decoders and
encoders, and currently it currently supports mpeg1, mpeg2, mpeg4, H.263 and H.264
(all of them with at least one driver implementing it, and properly supported
by the v4l2 core).

Regards,
Mauro
