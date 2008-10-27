Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RM0hZq028144
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 18:00:43 -0400
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9RLxvXT008678
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 17:59:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Mon, 27 Oct 2008 22:59:43 +0100
References: <20081027211837.GA20197@gate.crashing.org>
In-Reply-To: <20081027211837.GA20197@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272259.43058.hverkuil@xs4all.nl>
Cc: 
Subject: Re: output overlay driver and pix format
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Matt,

On Monday 27 October 2008 22:18:37 Matt Porter wrote:
> I'm working on a driver for an internal image processing block in an
> SoC. This functionality can combine a buffer stream in various
> YUV/RGB formats (selectable) with the framebuffer (or any arbitrary
> buffer one wishes to overlay).
>
> This fits quite well into the OUTPUT_OVERLAY support for the most
> part. However, the driver will not have OUTPUT capability at all.
> That is, there is not a direct external output from the image
> processor so it doesn't not make sense to define OUTPUT capability.
> The results of the image processing are left in a target buffer that
> may be used for tv/lcd encoding or fed back in for additional image
> processing operations.

Why wouldn't it make sense to define the OUTPUT capability? Based on 
your description I would say that it definitely is an output device. 
Whether the data ends up on a TV-out connector or in an internal target 
buffer is irrelevant.

> So the idea is to set the OUTPUT_OVERLAY pix format to one of the
> supported formats, set cropping/scaling/blending. Feed it buffers and
> it blends with the framebuffer, shoving the result to the internal
> target buffer.

Overlays use the v4l2_window struct, so you need the output capability 
to be able to select the pix format.

> The problem is that the V4L2 spec seems to imply that an
> OUTPUT_OVERLAY device should not touch the fmtdesc pix fields.

Correct, VIDIOC_S_FMT for an overlay uses v4l2_window struct.

> In my 
> case, the user needs to configure 1 of N pixelformat types that can
> be fed to the OUTPUT_OVERLAY device. Is this allowed or am I using
> OUTPUT_OVERLAY differently than intended? It seems that overlay
> devices may only be intended to be used with an associated OUTPUT (or
> INPUT) device that defines the pix format.

Correct.

> The bottom line is: does it make sense to have a driver with only
> OUTPUT_OVERLAY capability?

In this case I don't think it makes sense. But as I said, I think adding 
an OUTPUT capability is not a problem.

Regards,

	Hans

>
> Any clues here are appreciated.
>
> Thanks,
> Matt
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
