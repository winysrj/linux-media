Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S218fJ027746
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 22:01:08 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S20Muj022993
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 22:00:53 -0400
Date: Mon, 27 Oct 2008 21:00:21 -0500
From: Matt Porter <mporter@kernel.crashing.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081028020021.GA3684@gate.crashing.org>
References: <20081027211837.GA20197@gate.crashing.org>
	<200810272259.43058.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810272259.43058.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
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

On Mon, Oct 27, 2008 at 10:59:43PM +0100, Hans Verkuil wrote:
> Hi Matt,

Hi Hans,
 
> On Monday 27 October 2008 22:18:37 Matt Porter wrote:
> > I'm working on a driver for an internal image processing block in an
> > SoC. This functionality can combine a buffer stream in various
> > YUV/RGB formats (selectable) with the framebuffer (or any arbitrary
> > buffer one wishes to overlay).
> >
> > This fits quite well into the OUTPUT_OVERLAY support for the most
> > part. However, the driver will not have OUTPUT capability at all.
> > That is, there is not a direct external output from the image
> > processor so it doesn't not make sense to define OUTPUT capability.
> > The results of the image processing are left in a target buffer that
> > may be used for tv/lcd encoding or fed back in for additional image
> > processing operations.
> 
> Why wouldn't it make sense to define the OUTPUT capability? Based on 
> your description I would say that it definitely is an output device. 
> Whether the data ends up on a TV-out connector or in an internal target 
> buffer is irrelevant.

Ok. I guess it does make sense. I've been used to think in terms of
real-world outputs on previous driver work so that's where the confusion
set in. I can define an output that is the internal target buffer as you
suggest. Since it requires the standards ioctls it seems I'll have to 
define a driver specific standard id for a "system buffer". Perhaps that
should be generic...
 
> > So the idea is to set the OUTPUT_OVERLAY pix format to one of the
> > supported formats, set cropping/scaling/blending. Feed it buffers and
> > it blends with the framebuffer, shoving the result to the internal
> > target buffer.
> 
> Overlays use the v4l2_window struct, so you need the output capability 
> to be able to select the pix format.

Ok, that clarifies it. :)

> > The problem is that the V4L2 spec seems to imply that an
> > OUTPUT_OVERLAY device should not touch the fmtdesc pix fields.
> 
> Correct, VIDIOC_S_FMT for an overlay uses v4l2_window struct.

Ok

> > In my 
> > case, the user needs to configure 1 of N pixelformat types that can
> > be fed to the OUTPUT_OVERLAY device. Is this allowed or am I using
> > OUTPUT_OVERLAY differently than intended? It seems that overlay
> > devices may only be intended to be used with an associated OUTPUT (or
> > INPUT) device that defines the pix format.
> 
> Correct.
> 
> > The bottom line is: does it make sense to have a driver with only
> > OUTPUT_OVERLAY capability?
> 
> In this case I don't think it makes sense. But as I said, I think adding 
> an OUTPUT capability is not a problem.

Yes, seems reasonable to me now. There's one other thing this brings up.
Since my hardware can handle 5 different pixelformats as input I'll
obviously S_FMT those on the OUTPUT device. However, it is possible
to configure hardware such that the processed results in the target buffer
are in 4 different pixel formats. Within V4L, it seems that the
way to handle this would be to have 4 different custom (driver specific)
standards that correspond to the 4 possible pixel formats. Does that sound
right?

-Matt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
