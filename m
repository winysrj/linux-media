Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3028 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab1FIHIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 03:08:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC] Media kernelspace-userspace API specs (V4L/DVB/IR) - Was: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
Date: Thu, 9 Jun 2011 09:08:41 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20110608172311.0d350ab7@pedra> <4DF01FEB.4050205@redhat.com>
In-Reply-To: <4DF01FEB.4050205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090908.41992.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, June 09, 2011 03:20:43 Mauro Carvalho Chehab wrote:
> 2) CURRENT STATUS
>    ==============
> 
> After the last day patches, the end result of is that:
> 
> 	- API gaps on both V4L and DVB parts are now shown;
> 
> 	- The V4L gaps were already fixed;
> 
> 	- include/linux/osd.h: the API is not documented. I decided to
> keep it outside the documentation, as it is being used only by a legacy
> driver, and the API violates several Linux CodingStyle rules. I suspect
> that we can just deprecate this API, instead of propagating its usage.

Agreed.

> 	- 100% of the DVB data structures are now documented;

Great!

> 	- there are 22 DVB ioctl's not documented at the API (excluding
> 	  the osd ones), from the total amount of 111 ioctl's. So, about
> 	  20% of the ioctl's are not documented yet.
> 
> 	- the API specs contain several IOCTL's and data structures
> that are used only by one or two old drivers, without any recent
> driver needing to use them;
> 
> 	- there are some overlap area between DVB Video/Audio API's and V4L API;
> 
> 	- there are some overlap area between DVB Audio API and ALSA API;
> 
> 	- there are still some gaps at the Remote Controller API. Basically, 
> 	  the sysfs nodes are not documented yet;
> 
> 	- currently, there's no Makefile "magic" to double check discrepancies
> 	  at the Remote Controller and at the Media Controller API's.
> 
> 3) PROPOSALS
>    =========
> 
> A badly documented API is something very bad, as:
> 
> - userspace developers need to figure out how the driver and core works in
>   order to write their code. Worse than that, if a driver has a bug and is
>   doing something wrong, the userspace developer may assume that the broken
>  behavior is the correct one. So, a latter fix at the driver will break the
>  userspace application;
> 
> - kernelspace developers may have different opinions about how to implement
>   some feature, leading into different, incompatible implementations.
> 
> So, we need to be sure that the API is properly documenting what's the expected 
> behavior, otherwise the specs are useless.
> 
> I got some interesting statistics at the annex part of this RFC. Based on that,
> I propose to:
> 
> a) Put a notice at the specs that the AUDIO, VIDEO and OSD ioctl's
>    are deprecated and shouldn't be used on newer drivers.
>    We don't need to remove them from the drivers, but, at least on
>    ivtv, we should expand the V4L/ALSA support if needed, in order
>    to implement what's missed there.

Agreed.

> d) The API usage inside drivers/media and drivers/staging is given by:

I'll comment on those ioctls used by ivtv:

> AUDIO_SET_MUTE
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c

Used to mute the audio when playing back an mpeg stream.

We can use the AUDIO_MUTE control for this. This will require some work in
ivtv since at the moment all video nodes share the same controls. In this case
the video output node should get its own MUTE control.

> AUDIO_CHANNEL_SELECT
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c

How to playback normal MPEG audio: left, right, stereo, swapped.

> AUDIO_BILINGUAL_CHANNEL_SELECT
> drivers/media/video/ivtv/ivtv-ioctl.c

How to playback bilingual MPEG audio: left, right, stereo, swapped.

The decoder will automatically detect whether the source is bilingual or not
and select either CHANNEL_SELECT or BILINGUAL_CHANNEL_SELECT as needed for the
audio output.

I'm not sure what to do with these. There are multiple options:

- Reimplement them as menu controls.
- Add them to VIDIOC_DECODER_CMD, either as a separate command or as part of
  the PLAY command. I'm not enthusiastic about this since these properties
  can be changed while decoding is in progress. It does not really fit my
  idea of a 'decoder command'.
- Add support for this to VIDIOC_G/S_AUDOUT. Any decoder with audio output
  should have this ioctl. There is a currently unused 'mode' field in struct
  v4l2_audioout that might be used for this purpose.

I think either controls or using AUDOUT is the way to go. I am leaning towards
controls since they will automatically appear in properly written applications
and this is really a user-driven setting. And with menu controls it is easy
to extend the number of options.

> VIDEO_STOP
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c
> VIDEO_PLAY
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c
> VIDEO_FREEZE
> drivers/media/dvb/ttpci/av7110.c
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c
> VIDEO_CONTINUE
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c

Stop/Play/Pause/Continue MPEG decoding.

There should all be deprecated and replaced with VIDIOC_DECODER_CMD.

> VIDEO_SELECT_SOURCE
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c

Select passthrough mode where the input is directly linked to the output in
the hardware. This really changes the topology of the device. The media
controller does just that, so ivtv should implement the MC.

There are no applications that use this to my knowledge other than ivtv-ctl
in v4l-utils.

> VIDEO_GET_EVENT
> drivers/media/dvb/ttpci/av7110_av.c
> drivers/media/video/ivtv/ivtv-ioctl.c

Already deprecated: use the V4L event APIs for that (VIDIOC_DQEVENT et al).

> AUDIO_SET_EXT_ID
> AUDIO_SET_ATTRIBUTES
> AUDIO_SET_KARAOKE
> VIDEO_SET_SYSTEM
> VIDEO_SET_HIGHLIGHT
> VIDEO_SET_SPU
> VIDEO_SET_SPU_PALETTE
> VIDEO_GET_NAVI
> VIDEO_SET_ATTRIBUTES
> VIDEO_SET_ID
> VIDEO_GET_FRAME_RATE

These are only seen in audio.h/video.h and fs/compat_ioctl.c. Remove these
ioctls + associated structs?

> VIDEO_GET_PTS
> drivers/media/video/ivtv/ivtv-ioctl.c

Returns the current PTS of the decoder. Perhaps a read-only MPEG control is
more suitable?

> VIDEO_GET_FRAME_COUNT
> drivers/media/video/ivtv/ivtv-ioctl.c

Returns the number of decoded frames since the decoder started. Make this a
read-only MPEG control?

> VIDEO_COMMAND
> drivers/media/dvb/ttpci/av7110_hw.h
> drivers/media/video/ivtv/ivtv-ioctl.c
> VIDEO_TRY_COMMAND
> drivers/media/video/ivtv/ivtv-ioctl.c

These to command the decoder (play/stop/pause/continue with various additional
flags/attributes to facilitate fast/slow forward/backward). This should become
a traditional V4L2 API: VIDIOC_(TRY_)DECODER_CMD.

So, to summarize: in order to add the decoder API to V4L2 we would need to do:

- Add two controls to select the audio output channels.
- Add two read-only controls for the PTS and frame count.
- Copy and paste the old VIDEO_(TRY_)COMMAND to VIDIOC_(TRY_)DECODER_CMD.

And ivtv needs to use the MC and implement AUDIO_MUTE for output video nodes.

Comments? If not, then I'll see if I can work on an RFC for this next week.
It's less work than I expected.

Regards,

	Hans
