Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54354 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1JCJyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 05:54:05 -0400
Received: by gyg10 with SMTP id 10so3222927gyg.19
        for <linux-media@vger.kernel.org>; Mon, 03 Oct 2011 02:54:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110031039.27849.laurent.pinchart@ideasonboard.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <4E891B22.1020204@infradead.org> <201110030830.25364.hverkuil@xs4all.nl> <201110031039.27849.laurent.pinchart@ideasonboard.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 3 Oct 2011 11:53:44 +0200
Message-ID: <CAAwP0s0bTcUPvkVT-aB2EKskS_60CdW4P3orQLvSJMMkEWBpqw@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 3, 2011 at 10:39 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Hans,
>
> On Monday 03 October 2011 08:30:25 Hans Verkuil wrote:
>> On Monday, October 03, 2011 04:17:06 Mauro Carvalho Chehab wrote:
>> > Em 02-10-2011 18:18, Javier Martinez Canillas escreveu:
>> > > On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus wrote:
>
> [snip]
>
>> > >>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
>> > >>>
>> > >>>       .s_routing = tvp5150_s_routing,
>> > >>>
>> > >>> +     .s_stream = tvp515x_s_stream,
>> > >>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
>> > >>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
>> > >>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
>> > >>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
>> > >>> +     .g_parm = tvp515x_g_parm,
>> > >>> +     .s_parm = tvp515x_s_parm,
>> > >>> +     .s_std_output = tvp5150_s_std,
>> > >>
>> > >> Do we really need both video and pad format ops?
>> > >
>> > > Good question, I don't know. Can this device be used as a standalone
>> > > v4l2 device? Or is supposed to always be a part of a video streaming
>> > > pipeline as a sub-device with a source pad? Sorry if my questions are
>> > > silly but as I stated before, I'm a newbie with v4l2 and MCF.
>> >
>> > The tvp5150 driver is used on some em28xx devices. It is nice to add
>> > auto-detection code to the driver, but converting it to the media bus
>> > should be done with enough care to not break support for the existing
>> > devices.
>>
>> So in other words, the tvp5150 driver needs both pad and non-pad ops.
>> Eventually all non-pad variants in subdev drivers should be replaced by the
>> pad variants so you don't have duplication of ops. But that will take a lot
>> more work.
>
> What about replacing direct calls to non-pad operations with core V4L2
> functions that would use the subdev non-pad operation if available, and
> emulate if with the pad operation otherwise ? I think this would ease the
> transition, as subdev drivers could be ported to pad operations without
> worrying about the bridges that use them, and bridge drivers could be switched
> to the new wrappers with a simple search and replace.

Ok, that is a good solution. I'll do that. Implement V4L2 core
operations as wrappers of the subdev pad operations.

>
>> > Also, as I've argued with Laurent before, the expected behavior is that
>> > the standards format selection should be done via the video node, and
>> > not via the media controller node. The V4L2 API has enough support for
>> > all you need to do with the video decoder, so there's no excuse to
>> > duplicate it with any other API.
>>
>> This is relevant for bridge drivers, not for subdev drivers.
>>
>> > The media controller API is there not to replace V4L2, but to complement
>> > it where needed.
>>
>> That will be a nice discussion during the workshop :-)
>
> I don't think we disagree on that, but we probably disagree on what it means
> :-)
>
> --
> Regards,
>
> Laurent Pinchart
>

Laurent, I have a few questions about MCF and the OMAP3ISP driver if
you are so kind to answer.

1- User-space programs that are not MCF aware negotiate the format
with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
pad. But the real format is driven by the analog video format in the
source pad (i.e: tvp5151).

I modified the ISP driver to get the data format from the source pad
and set the format for each pad on the pipeline accordingly but I've
read from the documentation [1] that is not correct to propagate a
data format from source pads to sink pads, that the correct thing is
to do it from sink to source.

So, in this case an administrator has to externally configure the
format for each pad and to guarantee a coherent format on the whole
pipeline?. Or does exist a way to do this automatic?. i.e: The output
entity on the pipeline promotes the capabilities of the source pad so
applications can select a data format and this format gets propagated
all over the pipeline from the sink pad to the source?

[1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html

2- If the application want a different format that the default
provided by the tvp5151, (i.e: 720x576 for PAL), where do I have to
crop the image? I thought this can be made using the CCDC, copying
less lines to memory or the RESIZER if the application wants a bigger
image. What is the best approach for this?

3- When using embedded sync, CCDC doesn't have an external vertical
sync signal, so we have to manually configure when we want the VD0
interrupt to raise. This works for progressive frames, since each
frame has the same size but in the case of interlaced video,
sub-frames have different sizes (i.e: 313 and 312 vertical lines for
PAL).

What I did is to reconfigure the CCDC on the VD1 interrupt handler,
but I think this is more a hack than a clean solution. What do you
think is the best approach to solve this?

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
