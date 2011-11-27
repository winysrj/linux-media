Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1K0Vjl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 16:39:41 -0500
Message-ID: <4ED2AE12.3050601@redhat.com>
Date: Sun, 27 Nov 2011 19:39:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Andreas Oberritter <obi@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <4ED0116A.6050108@linuxtv.org> <201111260655.54570@orion.escape-edv.de> <201111261249.09740.hverkuil@xs4all.nl> <CAHFNz9+0_wQffFKRmPLGN8A_78KbOpssrY5OKVrqMw5saPU4-g@mail.gmail.com> <4ED2899F.5090807@redhat.com> <CAHFNz9L_U29JH2DgOyFTDU8YPKjuZqHHEfUK78R-MLY+tMuajA@mail.gmail.com>
In-Reply-To: <CAHFNz9L_U29JH2DgOyFTDU8YPKjuZqHHEfUK78R-MLY+tMuajA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-11-2011 17:27, Manu Abraham escreveu:
> On Mon, Nov 28, 2011 at 12:33 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 26-11-2011 19:58, Manu Abraham escreveu:
>>> On Sat, Nov 26, 2011 at 5:19 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On Saturday, November 26, 2011 06:55:52 Oliver Endriss wrote:
>>>>> On Friday 25 November 2011 23:06:34 Andreas Oberritter wrote:
>>>>>> On 25.11.2011 17:51, Manu Abraham wrote:
>>>>>>> On Fri, Nov 25, 2011 at 9:56 PM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em 25-11-2011 14:03, Andreas Oberritter escreveu:
>>>>>>>>> On 25.11.2011 16:38, Mauro Carvalho Chehab wrote:
>>>>>>>>>> Em 25-11-2011 12:41, Andreas Oberritter escreveu:
>>>>>>>>>>> On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
>>>>>>>>>>>> If your complain is about the removal of audio.h, video.h
>>>>>>>>>>>
>>>>>>>>>>> We're back on topic, thank you!
>>>>>>>>>>>
>>>>>>>>>>>> and osd.h, then my proposal is
>>>>>>>>>>>> to keep it there, writing a text that they are part of a deprecated API,
>>>>>>>>>>>
>>>>>>>>>>> That's exactly what I proposed. Well, you shouldn't write "deprecated",
>>>>>>>>>>> because it's not. Just explain - inside this text - when V4L2 should be
>>>>>>>>>>> preferred over DVB.
>>>>>>>>>>
>>>>>>>>>> It is deprecated, as the API is not growing to fulfill today's needs, and
>>>>>>>>>> no patches adding new stuff to it to it will be accepted anymore.
>>>>>>>>>
>>>>>>>>> Haha, nice one. "It doesn't grow because I don't allow it to." Great!
>>>>>>>>
>>>>>>>> No. It didn't grow because nobody cared with it for years:
>>>>>>>>
>>>>>>>> Since 2.6.12-rc2 (start of git history), no changes ever happened at osd.h.
>>>>>>>>
>>>>>>>> Excluding Hans changes for using it on a pure V4L device, and other trivial
>>>>>>>> patches not related to API changes, the last API change on audio.h and video.h
>>>>>>>> was this patch:
>>>>>>>>        commit f05cce863fa399dd79c5aa3896d608b8b86d8030
>>>>>>>>        Author: Andreas Oberritter <obi@linuxtv.org>
>>>>>>>>        Date:   Mon Feb 27 00:09:00 2006 -0300
>>>>>>>>
>>>>>>>>            V4L/DVB (3375): Add AUDIO_GET_PTS and VIDEO_GET_PTS ioctls
>>>>>>>>
>>>>>>>>        (yet not used on any upstream driver)
>>>>>>>>
>>>>>>>> An then:
>>>>>>>>        commit 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
>>>>>>>>        Author: Linus Torvalds <torvalds@ppc970.osdl.org>
>>>>>>>>        Date:   Sat Apr 16 15:20:36 2005 -0700
>>>>>>>>
>>>>>>>>            Linux-2.6.12-rc2
>>>>>>>>
>>>>>>>> No changes adding support for any in-kernel driver were ever added there.
>>>>>>>>
>>>>>>>> So, it didn't grow over the last 5 or 6 years because nobody submitted
>>>>>>>> driver patches requiring new things or _even_ using it.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>>> but keeping
>>>>>>>>>>>> the rest of the patches
>>>>>>>>>>>
>>>>>>>>>>> Which ones?
>>>>>>>>>>
>>>>>>>>>> V4L2, ivtv and DocBook patches.
>>>>>>>>>
>>>>>>>>> Fine.
>>>>>>>>>
>>>>>>>>>>>> and not accepting anymore any submission using them
>>>>>>>>>>>
>>>>>>>>>>> Why? First you complain about missing users and then don't want to allow
>>>>>>>>>>> any new ones.
>>>>>>>>>>
>>>>>>>>>> I didn't complain about missing users. What I've said is that, between a
>>>>>>>>>> one-user API and broad used APIs like ALSA and V4L2, the choice is to freeze
>>>>>>>>>> the one-user API and mark it as deprecated.
>>>>>>>>>
>>>>>>>>> Your assumtion about only one user still isn't true.
>>>>>>>>>
>>>>>>>>>> Also, today's needs are properly already covered by V4L/ALSA/MC/subdev.
>>>>>>>>>> It is easier to add what's missing there for DVB than to work the other
>>>>>>>>>> way around, and deprecate V4L2/ALSA/MC/subdev.
>>>>>>>>>
>>>>>>>>> Yes. Please! Add it! But leave the DVB API alone!
>>>>>>>>>
>>>>>>>>>>>> , removing
>>>>>>>>>>>> the ioctl's that aren't used by av7110 from them.
>>>>>>>>>>>
>>>>>>>>>>> That's just stupid. I can easily provide a list of used and valuable
>>>>>>>>>>> ioctls, which need to remain present in order to not break userspace
>>>>>>>>>>> applications.
>>>>>>>>>>
>>>>>>>>>> Those ioctl's aren't used by any Kernel driver, and not even documented.
>>>>>>>>>> So, why to keep/maintain them?
>>>>>>>>>
>>>>>>>>> If you already deprecated it, why bother deleting random stuff from it
>>>>>>>>> that people are using?
>>>>>>>>>
>>>>>>>>> There's a difference in keeping and maintaining something. You don't
>>>>>>>>> need to maintain ioctls that haven't changed in years. Deleting
>>>>>>>>> something is more work than letting it there to be used by those who
>>>>>>>>> want to.
>>>>>>>>
>>>>>>>> Ok. Let's just keep the headers as is, just adding a comment that it is now
>>>>>>>> considered superseded.
>>>>>>
>>>>>> Thank you! This is a step into the right direction.
>>>>>>
>>>>>>> http://dictionary.reference.com/browse/superseded
>>>>>>>
>>>>>>> to set aside or cause to be set aside as void, useless, or obsolete, usually
>>>>>>> in favor of something mentioned; make obsolete: They superseded the
>>>>>>> old statute with a new one.
>>>>>>>
>>>>>>> No, that's not acceptable. New DVB devices as they come will make use
>>>>>>> of the API and API changes might be applied.
>>>>>>
>>>>>> Honestly, I think we all should accept this proposal and just hope that
>>>>>> the comment is going to be written objectively.
>>>>>
>>>>> 'Hoping' is not enough for me anymore. I am deeply disappointed.
>>>>> Mauro and Hans have severely damaged my trust, that v4ldvb APIs are
>>>>> stable in Linux, and how things are handled in this project.
>>>>>
>>>>> So I request a public statement from the subsystem maintainer that
>>>>> 1. The DVB Decoder API will not be removed.
>>>>> 2. It can be updated if required (e.g. adding a missing function).
>>>>> 3. New drivers are allowed to use this architecture.
>>>>> 4. These driver will be accepted, if they follow the kernel standards.
>>>>>
>>>>> The reason is simple: I need to know, whether this project is still
>>>>> worth investing some time, or it is better to do something else.
>>>>
>>>> 1) There are two APIs that do the same thing: the DVB decoder API and the
>>>>   V4L2 API.
>>>> 2) That's bad because it confuses driver developers and application developers
>>>>   who have to support *two* APIs to do the same thing.
>>>> 3) The DVB decoder API is used in only one DVB driver (av7110), and in one
>>>>   V4L2 driver (ivtv). The latter is easily converted to V4L2 which leaves only
>>>>   one driver, av7110.
>>>> 4) A decoder API has nothing to do with DVB as a standard, it simply takes
>>>>   the output of the DVB part of the hardware and decodes it to the output.
>>>>   That's basic V4L2 functionality.
>>>
>>>
>>> It does, with newer scrambling systems, the decoder is tightly tied to the
>>> CA system(s) associated.
>>>
>>> According to the CI+ specification:
>>>
>>> "It is mandatory for the Application MMI to provide limited control
>>> over the MPEG
>>> decoders which enable the broadcast video and audio of the current service to
>>> be presented, additionally a full frame I-frame may be used to provide rich
>>> graphics backgrounds. The MMI Application may deny the application MMI
>>> control of the MPEG decoder if a resource conflict results."
>>>
>>> What you are talking about is FTA decoders which don't have any scrambling
>>> control, but almost all newer DVB decoders supporting CI+ work that way.
>>> If you look at any new digital TV/service, it comes with CI+ and many providers
>>> switching over.
>>>
>>> Because of a wrong decision, users cannot be denied using the same.
>>
>> What is saying there doesn't tell how the implementation should happen, but only
>> what features should be there. The control over the MPEG decoders is directly
>> available either using the audio/video DVB API or the V4L API.
>>
>> Also, as defined into item 3.3 - Abbreviations [1], MMI is the Man Machine Interface.
>> This is how ITU-T and ITU-R calls the GUI interface. Other standardization bureaus
>> share the same definition.
>>
>> [1] http://www.ci-plus.com/data/ci_plus_specification_v1.2.pdf
>>
>> As stated on item 12.1:
>>
>>        The CI Plus Application MMI shall take precedence over any existing
>>        application environment and may optionally be presented on the host
>>        native graphics plane, application plane or another display plane
>>        that may exist between the host display and application, this is shown
>>        as a number of conceptual planes in Figure 12.3
>>
>> Figure 12.3 is interesting, as it shows that the Application MMI is one of the
>> planes that the user will view on his screen.
>>
>> A proper implementation of something like figure 12.3 is one of the things that
>> it is easily done via V4L2 and its integration with framebuffer and the
>> upcoming integration with the GPU using the shared framebuffers patches that
>> are under discussions between mm, media and gpu subsystems.
>>
>> I can't see any way of implementing the composing of the video planes shown at
>> figure 12.3 (background, video planes, optional application planes, CI Plus
>> Application MMI plane, Native Graphics planes) with just the DVB API.
>>
>> As said there:
>>
>>        The Application MMI shall support full video transparency enabling text
>>        and graphics to be overlaid over the video (and possibly any native
>>         application). The Application MMI has a native SD resolution of
>>        720x576 pixels and shall be scaled to full screen to match the current
>>        video aspect ratio in both SD and HD environments.
>>
>> The pipeline setup via the MC allows setting such planes, and the GPU/V4L2
>> shared buffer allows passing the CI+ Application MMI to the GPU. V4L2 subdev
>> API can be used to control the scaler required to convert from 720x576 pixels
>> to the displayed resolution, and to adjust the DV timings of the output.
> 
> 
> You don't have any planes that you can control in software. There is *no*
> GPU involved, the output of the decoder goes through HDMI/HDCP to the
> display.

The GPU how it is called the piece of the hardware that outputs displays data.
Ok, if the device is too simple, it may use just one framebuffer for output, but,
in general, SoC chips contain several image processing blocks there, in order
to do scaling, composition, etc.

> The whole concept is to avoid the user to touch/copy the video
> stream/components. The host is decoder on which the MMI application
> runs in secure mode. You can't take any control over those with V4L2 or
> anything as you state.

Media drivers support three ways for output:

1) V4L2 output;
2) framebuffer output;
3) shared buffer between a decoder driver and the GPU.

Patches for (3) are currently under development, and several patches were already
proposed, and should reach upstream soon.

On all 3 cases, the data doesn't go to userspace. The controls are there to allow
specifying the size of the image, and its position/resolution at the screen. There
are controls for adjusting HDMI timings (e. g. resolution, frames per second, etc),
in the case of (1).

Please, don't mix V4L2 output with V4L2 input. V4L2 input is used when a decoded
video should be sent to userspace. Most V4L2 drivers are input devices (webcams,
analog TV cards, grabber cards). The ivtv card is one example of PC device that
implements both V4L2 input and output. Most SoC V4L drivers support both input
and output, and the actual setup is made by setting the pipelines, among the ones
that are supported by the hardware.

In the case of a DVB device watching to an encrypted channel using the CI+ module,
only the V4L2 output would be used.

Regards,
Mauro
