Return-path: <mchehab@gaivota>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2370 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0LSVbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 16:31:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Subject: Re: lot of bugs in cx88-blackbird
Date: Sun, 19 Dec 2010 22:31:12 +0100
Cc: linux-media@vger.kernel.org
References: <201012192101.27700.martin.dauskardt@gmx.de>
In-Reply-To: <201012192101.27700.martin.dauskardt@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192231.13062.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday, December 19, 2010 21:01:27 Martin Dauskardt wrote:
> The HVR1300 driver has several bugs:
> 
> 1.
> When executing VIDIOC_S_EXT_CTRLS or VIDIOC_S_FREQUENCY on the mpeg device 
> while the mpeg device is active (capturing), the driver calls 
> blackbird_stop_codec(). This stops the encoder (API call 
> CX2341X_ENC_STOP_CAPTURE).
> Unfortunately, the encoder gets never restarted after the ioctl is finished. 
> 
> To restart the encoder, we now need to stop capturing and restart reading.
> But if this is required anyway, the code could be much easier when the driver 
> would simply return EBUSY.
> 
> I think the bug was introduced in May 2007 (!) with this patch:
> (V4L/DVB (6828): cx88-blackbird: audio improvements)
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f9e54e0c84da869ad9bc372fb4eab26d558dbfc2
> 
> The necessary CX2341X_ENC_START_CAPTURE API command to restart the encoder was 
> moved with this patch from blackbird_initialize_codec() to a new function 
> blackbird_start_codec(), but this new function is not called.
> 
> For vidioc_s_ext_ctrls the patch ("Stop the mpeg encoder when changing 
> parameters ") totally misses a solution to restart the encoder.
> 
> The different methods to switch channels with mpeg encoder cards have been 
> discussed in the ivtv-devel list lately:
> http://www.gossamer-threads.com/lists/ivtv/devel/41154
> 
> My suggestion is that the driver should return EBUSY for VIDIOC_S_FREQUENCY 
> and all critical settings (standard, bitrate, format, ...) while a capture is 
> in progess. This should happen not only on the mpeg device but also on the 
> analogue device.
> 
>  
> 2.
> On this hybrid card, we have an analogue and an mpeg device. As far as I  know 
> there is still no application which knows how to handle this. 
> If the User Controls (Brightness, Contrast, Saturation, Hue, Volume) are 
> executed on the analogue device while the mpeg device is active, the result is 
> static on audio+video. We need to stop reading and re-tune the current 
> frequency by executing VIDIOC_S_FREQUENCY on the mpeg device. 
> 
> 3.
> When executing VIDIOC_S_FREQENCY or any other ioctl on the analogue device, 
> the result is always static video+audio. v4l2-ctl --get-freq still shows the 
> right frequency, but the tuner is obviously on another frequency.
> 
> 4.
> If we use VIDIOC_S_STD on the analogue device, a following "v4l2-ctl --get-
> standard" (executed on the mpeg device) shows still the previous standard.
> 
> 5.
> The default video size for mpeg is 720x480 (which is right for the default 
> standard NTSC-M). If we change the standard to PAL-BG, the size is still 
> 720x480. As far as I remember, the cx2341x does only work properly with height 
> 576 when the video standard is 50Hz. The ivtv driver adjustes this 
> automatically.
> 
> 6.
> Setting the video size with VIDIOC_S_FMT for V4L2_BUF_TYPE_VIDEO_CAPTURE works 
> only when executed on the mpeg device. How should an application know this? 
> (for cards with saa7134-empress it is vice versa, VIDIOC_S_FMT works only on 
> the analogue device...)
> 
> 7.
> switching from an external input back to TV (input 0) often results in audio 
> static. Re-setting the video standard helps.
> 
> 8. 
> The external input "S-Video" has no colour although an Y/C signal is supplied.
> 
> 9.
> reading from mpeg device fails randomly with Input/output error. Even a driver 
> reload is not sufficient - I have to reboot my machine to get it working 
> again.
> 
> 10.
> vidioc_s_ext_ctrls  only supports V4L2_CTRL_CLASS_MPEG,  but not 
> V4L2_CTRL_CLASS_USER. The driver should internally pass these to vidioc_s_ctrl 
> instead of returning EINVAL.
> 
> 11.
> When switching from input Television to Input Composite1 , then switching to a 
> radio channel and switching back to Composite 1, the video comes from 
> Composite1 but the audio from Television (previous TV channel). Directly 
> switching from Television to radio and then to Composite1 has no problems.
> 
> 
> I am not a driver developer and can't fix this myself. But I could do testings 
> and hope there is a developer who is willing to have a look at these problems.

Some of these problems are related to control handling. One of the items on my
(very long) TODO list is to convert cx88 to use the new control framework.
Although I would very much appreciate it if someone else could take on that job.

The main problem is that there is no active maintainer for this driver. Unless
someone is willing to put in the hours needed I don't expect to see any
improvements :-(

One option is that you try to step in. If you know C, then doing driver
programming isn't really that magical. You already know a lot about V4L2, so
that will definitely help.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
