Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3311 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0IMMXW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:23:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: how can deal with the stream in only on-the-fly-output available HW block??
Date: Mon, 13 Sep 2010 14:23:18 +0200
Cc: linux-media@vger.kernel.org
References: <022601cb533c$b7bde610$2739b230$%kim@samsung.com>
In-Reply-To: <022601cb533c$b7bde610$2739b230$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131423.18698.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, September 13, 2010 14:10:55 Kim, HeungJun wrote:
> Hi all,
> 
>  
> 
> What if some SoC's specific HW block supports only on-the-fly mode for
> stream output??

What do you mean with 'on-the-fly mode'? Does that mean that two HW blocks
are linked together so that the video stream goes directly from one to the
other without ever being DMA-ed to memory?

> 
> In this case, what is the suitable buf_type??

Suitable buf_type for doing what?

You probably need the upcoming media API to be able to correctly deal with
these issues. Check the mailing list for the patches done by Laurent Pinchart.

The current V4L2 API is really not able to handle changes in the internal
video stream topology.

Regards,

	Hans

> 
> I'm faced with such problem.
> 
>  
> 
> As explanation for my situation briefly, the processor I deal with now has 3
> Multimedia H/W blocks, and the problem-one in the 3 blocks do the work for
> sensor-interfacing and pre-processing.
> 
> It supports CCD or CMOS for input, and DMA or On-The-Fly for output.
> Exactly, it has two cases - DMA mode using memory bus & On-The-Fly mode
> connected with any other multimedia blocks.
> 
> Also, it use only one format "Bayer RGB" in case of mode the DMA and
> On-The-Fly mode both.
> 
>  
> 
> So, when the device operates in the On-The-Fly mode, is it alright the
> driver's current type is  V4L2_BUF_TYPE_VIDEO_CAPTURE? or something else?
> 
> or if setting buf_type is wrong itself, what v4l2 API flow is right for
> driver or userspace??
> 
>  
> 
> the v4l2 buf_type enumeratinos is defined here, but I have no idea about
> suitable enum value in this case, also except for any other under enums too.
> 
>  
> 
> V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
> 
> V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
> 
> V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
> 
> V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
> 
> V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
> 
> V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
> 
> V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
> 
> V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
> 
> V4L2_BUF_TYPE_PRIVATE              = 0x80,
> 
>  
> 
> I'll thanks for any idea or answer.
> 
>  
> 
> Regards,
> 
> HeungJun, Kim
> 
>  
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
