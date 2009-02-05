Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2582 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZBEH3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 02:29:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Question of V4L2 API spec for sliced VBI VIDIOC_S_FMT
Date: Thu, 5 Feb 2009 08:29:33 +0100
Cc: linux-media@vger.kernel.org
References: <1233807958.4422.21.camel@palomino.walls.org>
In-Reply-To: <1233807958.4422.21.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050829.33640.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 February 2009 05:25:58 Andy Walls wrote:
> The V4L2 spec has some funny languague in the VIDIOC_S_FMT, and
> VIDIOC_TRY_FMT documentation and section 4.8.3 on setting or trying
> sliced VBI formats.
>
> For VIDIOC_TRY_FMT for sliced vbi, the ioctl() is only supposed to fail
> if the v4l2_format->type is for sliced vbi capture or sliced vbi output
> and it is not supported.  Otherwise the ioctl() is to successfully
> return the sanitized v4l2_format->fmt.sliced.service_set and
> v4l2_format->fmt.sliced.service_lines, even if the sanitization returns
> them all as 0, implying no support for what was requested.  I'm OK with
> all that so far.
>
> For the VIDIOC_S_FMT for sliced vbi, the driver is supposed to return
> -EBUSY if the operation can happen right now (that's fine), or -EINVAL
> if the passed in parameters are "ambiguous".  What does ambiguous mean
> here?  Specifically, does that include a VIDIOC_S_FMT where the
> v4l2_format->fmt.sliced.service_set and
> v4l2_format->fmt.sliced.service_lines all come back as zero when
> sanitized as with VIDIOC_TRY_FMT?

This is wrong. However, the VIDIOC_S_FMT ioctl documentation is correct. The 
only way you can get an EINVAL is if the operation is not supported. I will 
update the spec accordingly. I saw some more weird stuff in there that 
looks like copy-and-pasted text from another section and that probably 
should be removed as well.

> I ask, becasue the cx18 driver, with VBI ioctl() code of ivtv origin,
> returns -EINVAL in this case, but that doesn't seem right to me.
> There's nothing ambiguous about a well formed request for a service set
> combination that isn't supported at all by the hardware.  It's a valid
> request, as affirmed by VIDIOC_TRY_FMT, even if it is a useless request
> as far as VIDIOC_S_FMT and actually capturing VBI data is concerned.

If you look at the latest ivtv code you will see that ivtv no longer returns 
EINVAL. It was an ivtv driver bug that was fixed after cx18 split off from 
ivtv.

> I suspect there might be some history or rationale I don't know about
> which would be fine.  I'd just like to clean up the ambiguous
> "ambiguous" in the V4L2 spec in that case.

I can state unambiguously that the ambiguous 'ambiguous' in the spec is 
indeed ambiguous and I will unambiguously remove that ambiguous 
statement. :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
