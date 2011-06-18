Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4733 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1FRTx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 15:53:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: Re: V4L2_PIX_FMT_MPEG and S_FMT
Date: Sat, 18 Jun 2011 21:53:55 +0200
Cc: linux-media@vger.kernel.org
References: <BANLkTikb1Row7_+-e30udc9e5KBjuwcaJg@mail.gmail.com>
In-Reply-To: <BANLkTikb1Row7_+-e30udc9e5KBjuwcaJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182153.55096.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 18, 2011 21:11:37 Christian Gmeiner wrote:
> Hi all,
> 
> I am still in the process of porting a driver to v4l2 framework. This
> device is capable of decoding MPEG-1 and MPEG-2 streams.

Are we talking about decoding multiplexed streams or elementary streams?
E.g., audio+video or just the elementary video stream?

For decoding elementary streams pixelformats are being defined in an
RFC by Kamil Debski:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/34229

For multiplexed streams ivtv just uses V4L2_PIX_FMT_MPEG which can be used
for any MPEG program or transport stream. There is currently no method of
communicating to userspace which audio/video formats inside that PS/TS stream
are supported.

The problem is that that information is hidden inside the stream. If your
hardware does multiplexed stream decoding, then what happens when you give
it an mpeg stream with unsupported codecs? Does the hardware give an error?

Regards,

	Hans

> See http://dxr3.sourceforge.net/about.html for more details.
> So I have programmed this:
> 
> static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
> 				struct v4l2_fmtdesc *fmt)
> {
> 	if (fmt->index > 0)
> 		return -EINVAL;
> 
> 	fmt->flags = V4L2_FMT_FLAG_COMPRESSED;
> 	fmt->pixelformat = V4L2_PIX_FMT_MPEG;
> 	strlcpy(fmt->description, "MPEG 1/2", sizeof(fmt->description));
> 
> 	return 0;
> }
> 
> There is nothing in struct v4l2_format which indicates MPEG1, MPEG2 or
> MPEG4. As a result
> of this, it is not possible to return -EINVAL if somebody wants to
> decode/playback MPEG4 content.
> 
> Any ideas how to achieve it?
> 
> Thanks
> --
> Christian Gmeiner, MSc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
