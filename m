Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab1FIMhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 08:37:35 -0400
Message-ID: <4DF0BE8D.1060505@redhat.com>
Date: Thu, 09 Jun 2011 09:37:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC] Media kernelspace-userspace API specs (V4L/DVB/IR) - Was:
 Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra> <4DF01FEB.4050205@redhat.com> <201106090908.41992.hverkuil@xs4all.nl>
In-Reply-To: <201106090908.41992.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-06-2011 04:08, Hans Verkuil escreveu:
> On Thursday, June 09, 2011 03:20:43 Mauro Carvalho Chehab wrote:
>> d) The API usage inside drivers/media and drivers/staging is given by:
> 
> I'll comment on those ioctls used by ivtv:
> 
>> AUDIO_SET_MUTE
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Used to mute the audio when playing back an mpeg stream.
> 
> We can use the AUDIO_MUTE control for this. This will require some work in
> ivtv since at the moment all video nodes share the same controls. In this case
> the video output node should get its own MUTE control.
> 
>> AUDIO_CHANNEL_SELECT
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> How to playback normal MPEG audio: left, right, stereo, swapped.
> 
>> AUDIO_BILINGUAL_CHANNEL_SELECT
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> How to playback bilingual MPEG audio: left, right, stereo, swapped.
> 
> The decoder will automatically detect whether the source is bilingual or not
> and select either CHANNEL_SELECT or BILINGUAL_CHANNEL_SELECT as needed for the
> audio output.
> 
> I'm not sure what to do with these. There are multiple options:
> 
> - Reimplement them as menu controls.
> - Add them to VIDIOC_DECODER_CMD, either as a separate command or as part of
>   the PLAY command. I'm not enthusiastic about this since these properties
>   can be changed while decoding is in progress. It does not really fit my
>   idea of a 'decoder command'.
> - Add support for this to VIDIOC_G/S_AUDOUT. Any decoder with audio output
>   should have this ioctl. There is a currently unused 'mode' field in struct
>   v4l2_audioout that might be used for this purpose.
> 
> I think either controls or using AUDOUT is the way to go. I am leaning towards
> controls since they will automatically appear in properly written applications
> and this is really a user-driven setting. And with menu controls it is easy
> to extend the number of options.

I think that using AUDOUT would be more coherent. There are two fields there 
that are reserved: "capability" and "mode". We can add capability
flags to indicate that the audout supports channel mode changes and use the
"mode" on a way similar to rxsubchans to select between the channel outputs.

Yet, MPEG AAC supports up to 48 channels and multiple languages. We may
need to have a way to get the information from the hardware about what
channels are available, and how they're grouped.

>> VIDEO_STOP
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
>> VIDEO_PLAY
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
>> VIDEO_FREEZE
>> drivers/media/dvb/ttpci/av7110.c
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
>> VIDEO_CONTINUE
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Stop/Play/Pause/Continue MPEG decoding.
> 
> There should all be deprecated and replaced with VIDIOC_DECODER_CMD.

Another alternative would be to consider:
	VIDIOC_STREAMON = VIDEO_PLAY
	VIDIOC_STREAMOFF = VIDEO_STOP
And add VIDIOC_FREEZE/VIDIOC_CONTINUE.

Adding a VIDIOC_DECODER_CMD ioctl that also controls play/stop seems
to be a bad idea, as we'll have some API overlap here.

>> VIDEO_SELECT_SOURCE
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Select passthrough mode where the input is directly linked to the output in
> the hardware. This really changes the topology of the device. The media
> controller does just that, so ivtv should implement the MC.
> 
> There are no applications that use this to my knowledge other than ivtv-ctl
> in v4l-utils.

We don't need to use MC for that. The VIDIOC_*_AUDIOOUT already provides the
elements to enumerate and select the audio output.

>> VIDEO_GET_EVENT
>> drivers/media/dvb/ttpci/av7110_av.c
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Already deprecated: use the V4L event APIs for that (VIDIOC_DQEVENT et al).

OK.

>> AUDIO_SET_EXT_ID
>> AUDIO_SET_ATTRIBUTES
>> AUDIO_SET_KARAOKE
>> VIDEO_SET_SYSTEM
>> VIDEO_SET_HIGHLIGHT
>> VIDEO_SET_SPU
>> VIDEO_SET_SPU_PALETTE
>> VIDEO_GET_NAVI
>> VIDEO_SET_ATTRIBUTES
>> VIDEO_SET_ID
>> VIDEO_GET_FRAME_RATE
> 
> These are only seen in audio.h/video.h and fs/compat_ioctl.c. Remove these
> ioctls + associated structs?

Yes, that sounds the right way to do it. As nobody is using it, I don't think
we need to add it at the list of the Kernel features to be removed. as this
is unused stuff. So, no regressions will happen.

> 
>> VIDEO_GET_PTS
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Returns the current PTS of the decoder. Perhaps a read-only MPEG control is
> more suitable?

Yes, a MPEG control for it seems to be enough.

>> VIDEO_GET_FRAME_COUNT
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> Returns the number of decoded frames since the decoder started. Make this a
> read-only MPEG control?

Yes, a MPEG control for it seems to be enough.

>> VIDEO_COMMAND
>> drivers/media/dvb/ttpci/av7110_hw.h
>> drivers/media/video/ivtv/ivtv-ioctl.c
>> VIDEO_TRY_COMMAND
>> drivers/media/video/ivtv/ivtv-ioctl.c
> 
> These to command the decoder (play/stop/pause/continue with various additional
> flags/attributes to facilitate fast/slow forward/backward). This should become
> a traditional V4L2 API: VIDIOC_(TRY_)DECODER_CMD.

Ah, now I see why you're proposing a decoder command: due to those additional flags.
Ok, it may actually make sense, but I would avoid to do overlaps with 
VIDIOC_STREAMON/STREAMOFF, as it may make the API messy.

> So, to summarize: in order to add the decoder API to V4L2 we would need to do:
> 
> - Add two controls to select the audio output channels.
> - Add two read-only controls for the PTS and frame count.
> - Copy and paste the old VIDEO_(TRY_)COMMAND to VIDIOC_(TRY_)DECODER_CMD.
> 
> And ivtv needs to use the MC and implement AUDIO_MUTE for output video nodes.
> 
> Comments? If not, then I'll see if I can work on an RFC for this next week.
> It's less work than I expected.

Cheers,
Mauro
