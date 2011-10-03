Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46223 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1JCHMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 03:12:08 -0400
Received: by gyg10 with SMTP id 10so3120832gyg.19
        for <linux-media@vger.kernel.org>; Mon, 03 Oct 2011 00:12:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110030830.25364.hverkuil@xs4all.nl>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
 <4E891B22.1020204@infradead.org> <201110030830.25364.hverkuil@xs4all.nl>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 3 Oct 2011 09:11:48 +0200
Message-ID: <CAAwP0s2j1hHE-c7JAruJhNyFXU=sD0X_oUZj0b85sVp_MdD+fw@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 3, 2011 at 8:30 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday, October 03, 2011 04:17:06 Mauro Carvalho Chehab wrote:
>> Em 02-10-2011 18:18, Javier Martinez Canillas escreveu:
>> >
>> > Yes, I'll change that.
>> >
>> >>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
>> >>>       .s_routing = tvp5150_s_routing,
>> >>> +     .s_stream = tvp515x_s_stream,
>> >>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
>> >>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
>> >>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
>> >>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
>> >>> +     .g_parm = tvp515x_g_parm,
>> >>> +     .s_parm = tvp515x_s_parm,
>> >>> +     .s_std_output = tvp5150_s_std,
>> >>
>> >> Do we really need both video and pad format ops?
>> >>
>> >
>> > Good question, I don't know. Can this device be used as a standalone
>> > v4l2 device? Or is supposed to always be a part of a video streaming
>> > pipeline as a sub-device with a source pad? Sorry if my questions are
>> > silly but as I stated before, I'm a newbie with v4l2 and MCF.
>>
>> The tvp5150 driver is used on some em28xx devices. It is nice to add auto-detection
>> code to the driver, but converting it to the media bus should be done with
>> enough care to not break support for the existing devices.
>
> So in other words, the tvp5150 driver needs both pad and non-pad ops.
> Eventually all non-pad variants in subdev drivers should be replaced by the
> pad variants so you don't have duplication of ops. But that will take a lot
> more work.
>

Great, that was a doubt I had, thanks for the clarification.

>
>> In the specific code of standards auto-detection, a few drivers currently support
>> this feature. They're (or should be) coded to do is:
>>
>> If V4L2_STD_ALL is used, the driver should autodetect the video standard of the
>> currently tuned channel.
>
> Actually, this is optional. As per the spec:
>
> "When the standard set is ambiguous drivers may return EINVAL or choose any of
> the requested standards."
>
> Nor does the spec say anything about doing an autodetect when STD_ALL is passed
> in. Most drivers will just set the std to PAL or NTSC in this case.
>
> If you want to autodetect, then use QUERYSTD. Applications cannot rely on drivers
> to handle V4L2_STD_ALL the way you say.
>
>> The detected standard can be returned to userspace via VIDIOC_G_STD.
>
> No! G_STD always returns the current *selected* standard. Only QUERYSTD returns
> the detected standard.
>
>>
>> If otherwise, another standard mask is sent to the driver via VIDIOC_S_STD,
>> the expected behavior is that the driver should select the standards detector
>> to conform with the desired mask. If an unsupported configuration is requested,
>> the driver should return the mask it actually used at the return of VIDIOC_S_STD
>> call.
>
> S_STD is a write-only ioctl, so the mask isn't updated.
>
>> For example, if V4L2_STD_NTSC_M_JP is used, the driver should disable the
>> auto-detector, and use NTSC/M with the Japanese audio standard. both S_STD
>> and G_STD will return V4L2_STD_NTSC_M_JP.
>> If V4L2_STD_MN is used and the driver can auto-detect between all those formats,
>> the driver should detect if the standard is PAL or NTSC and detect between
>> STD/M or STD/M (and the corresponding audio standards).
>>
>> If an unsupported mask like V4L2_STD_PAL_J | V4L2_STD_NTSC_M_JP is used, the driver
>> should return a valid combination to S_STD (for example, returning V4L2_STD_PAL_J.
>>
>> In any case, on V4L2_G_STD, if the driver can't detect what's the standard, it should
>> just return the current detection mask to userspace (instead of returning something
>> like STD_INVALID).
>
> G_STD must always return the currently selected standard, never the detected standard.
> That's QUERYSTD.
>
> When the driver is first loaded it must pre-select a standard (usually in the probe
> function), either hardcoded (NTSC or PAL), or by doing an initial autodetect. But
> the standard should always be set to something. This allows you to start streaming
> immediately.
>
> Regards,
>
>        Hans
>
>> I hope that helps,
>> Mauro.
>>
>

Thanks Mauro and Hans for your comments.

I plan to work on the autodetect code and the issues called out by
Sakari and resubmit the patch, can you point me a driver that got
auto-detect the right way so I can use it as a reference?

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
