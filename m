Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756879Ab0EJUu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 16:50:59 -0400
Date: Mon, 10 May 2010 22:45:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Confusing mediabus formats
In-Reply-To: <201005091032.07893.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1005102154490.15250@axis700.grange>
References: <201005091032.07893.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added Laurent to CC as he once asked me about these on IRC too)

On Sun, 9 May 2010, Hans Verkuil wrote:

> Hi Guennadi,
> 
> I'm preparing a patch series that replaces enum/g/try/s_fmt with
> enum/g/try/s/_mbus_fmt in all subdevs. While doing that I stumbled on a
> confusing definition of the YUV mediabus formats. Currently we have these:
> 
>         V4L2_MBUS_FMT_YUYV8_2X8_LE,
>         V4L2_MBUS_FMT_YVYU8_2X8_LE,
>         V4L2_MBUS_FMT_YUYV8_2X8_BE,
>         V4L2_MBUS_FMT_YVYU8_2X8_BE,
> 
> The meaning of "2X8" is defined as: 'one pixel is transferred in
> two 8-bit samples'.
> 
> This is confusing since you cannot really say that a Y and U pair constitutes
> one pixel. And is it Y or U/V which constitutes the 'most-significant bits' in
> such a 16-bit number?

To recap, as we discussed it earlier this notation was one of your 
suggestions:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/12830/focus=13394

Yes, I certainly agree, that LE and BE notations are not necessarily very 
logical here, as you say, they don't make much sense in the YUV case. But 
they do, e.g., in RGB565 case, as we discussed this with Laurent on IRC. 
Basically, the information we want to include in the name is:

pixel format family (YUYV8)
number of samples, that constitute one "pixel" (*) and bits per sample
order of samples in "pixel"

(*) "pixel" is not necessarily a "complete pixel," i.e., might not carry 
all colours in it. E.g., in YUYV "pixel" refers to any of the YU and YV 
pairs. In other words, this is just = frame size * 8 / number of pixels / 
bits-per-sample.

> In my particular case I have to translate a V4L2_PIX_FMT_UYVY to a suitable
> mediabus format. I think it would map to V4L2_MBUS_FMT_YUYV8_2X8_LE, but
> frankly I'm not sure.
> 
> My suggestion is to rename these mediabus formats to:
> 
>         V4L2_MBUS_FMT_YUYV8_1X8,
>         V4L2_MBUS_FMT_YVYU8_1X8,
>         V4L2_MBUS_FMT_UYVY8_1X8,
>         V4L2_MBUS_FMT_VYUY8_1X8,


But what do you do with, e.g., RGB565? Y>ou have to differentiate between

rrrrrggggggbbbbb
bbbbbggggggrrrrr
gggrrrrrbbbbbggg
gggbbbbbrrrrrggg

with the current notation they are

RGB565_2X8_BE
BGR565_2X8_BE
BGR565_2X8_LE
RGB565_2X8_LE

and how would you call them? And what do you do with Y10_2X8_LE and _BE 
(padding omitted for simplicity)?

Also, Laurent has suggested

	V4L2_MBUS_FMT_YUYV8_2X8,
	V4L2_MBUS_FMT_YVYU8_2X8,
	V4L2_MBUS_FMT_UYVY8_2X8,
	V4L2_MBUS_FMT_VYUY8_2X8,

and I like that better, than "1X8," but still it doesn't resolve my above 
doubts.

Ideas? Suggestions?

> Here it is immediately clear what is going on. This scheme is also used with
> the Bayer formats, so it would be consistent with that as well.
> 
> However, does V4L2_MBUS_FMT_YUYV8_2X8_LE map to V4L2_MBUS_FMT_YUYV8_1X8 or to
> V4L2_MBUS_FMT_UYVY8_1X8? I still don't know.
> 
> What do you think?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
