Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58325 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbdBCOVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 09:21:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        hverkuil@xs4all.nl, Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org, p.zabel@pengutronix.de,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: vb2 queue_setup documentation clarification (was "Re: [PATCH v3 00/24] i.MX Media Driver")
Date: Fri, 03 Feb 2017 16:21:34 +0200
Message-ID: <1600727.suTjUfaXG8@avalon>
In-Reply-To: <2e1cf096-ecb8-ba3d-a554-f4cc6999ed4e@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <20170202185826.GV27312@n2100.armlinux.org.uk> <2e1cf096-ecb8-ba3d-a554-f4cc6999ed4e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

(stripping the CC list a bit and adding Sakari Ailus)

On Thursday 02 Feb 2017 11:12:41 Steve Longerbeam wrote:
> On 02/02/2017 10:58 AM, Russell King - ARM Linux wrote:

[snip]

> > It seems to me that if you don't take account of the existing queue
> > size, your camif_queue_setup() has the side effect that each time
> > either of these are called.  Hence, the vb2 queue increases by the
> > same amount each time, which is probably what you don't want.
> > 
> > The documentation on queue_setup() leaves much to be desired:
> >   * @queue_setup: called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS() 
> >   *          handlers before memory allocation. It can be  called
> >   *          twice: if the original number of requested  buffers
> >   *          could not be allocated, then it will be called a
> >   *          second time with the actually allocated number of
> >   *          buffers to verify if that is OK.
> >   *          The driver should return the required number of buffers
> >   *          in \*num_buffers, the required number of planes per
> >   *          buffer in \*num_planes, the size of each plane should be
> >   *          set in the sizes\[\] array and optional per-plane
> >   *          allocator specific device in the alloc_devs\[\] array.
> >   *          When called from VIDIOC_REQBUFS,() \*num_planes == 0,
> >   *          the driver has to use the currently configured format to
> >   *          determine the plane sizes and \*num_buffers is the total
> >   *          number of buffers that are being allocated. When called
> >   *          from VIDIOC_CREATE_BUFS,() \*num_planes != 0 and it
> >   *          describes the requested number of planes and sizes\[\]
> >   *          contains the requested plane sizes. If either
> >   *          \*num_planes or the requested sizes are invalid callback
> >   *          must return %-EINVAL. In this case \*num_buffers are
> >   *          being allocated additionally to q->num_buffers.
> >
> > That's really really ambiguous, because the "In this case" part doesn't
> > really tell you which case it's talking about - but it seems to me looking
> > at the code that it's referring to the VIDIOC_CREATE_BUFS case.
> 
> Yes, I caught this when adding fixes from v4l2-compliance testing, which
> is not part of the version 3 driver. I agree it is a confusing API. When
> called from VIDIOC_CREATE_BUFS (indicated by *num_planes != 0),
> *num_buffers is supposed to be requested buffers _in addition_ to
> already requested q->num_buffers, which is important info and
> should be emphasized a little more than the "oh by the way" fashion
> in the prototype description, IMHO.

Hans, Sakari, any opinion ?

[snip]

-- 
Regards,

Laurent Pinchart

