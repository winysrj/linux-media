Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38691 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaIPK27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 06:28:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient buffer underruns
Date: Tue, 16 Sep 2014 13:29 +0300
Message-ID: <2160177.8xkXcAKlxC@avalon>
In-Reply-To: <5416CA2B.1080004@xs4all.nl>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <2394481.2zcs5YKt7z@avalon> <5416CA2B.1080004@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 15 September 2014 13:14:51 Hans Verkuil wrote:
> On 06/06/2014 03:42 PM, Laurent Pinchart wrote:
> > On Friday 06 June 2014 11:58:18 Hans Verkuil wrote:
> >> On 06/06/2014 11:50 AM, Hans de Goede wrote:
> >>> Hi,
> >>> 
> >>> On 06/05/2014 02:23 PM, Laurent Pinchart wrote:
> >>>> The V4L2 specification states that
> >>>> 
> >>>> "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
> >>>> the poll() function succeeds, but sets the POLLERR flag in the revents
> >>>> field."
> >>>> 
> >>>> The vb2_poll() function sets POLLERR when the queued buffers list is
> >>>> empty, regardless of whether this is caused by the stream not being
> >>>> active yet, or by a transient buffer underrun.
> >>>> 
> >>>> Bring the implementation in line with the specification by returning
> >>>> POLLERR only when the queue is not streaming. Buffer underruns during
> >>>> streaming are not treated specially anymore and just result in poll()
> >>>> blocking until the next event.
> >>> 
> >>> After your patch the implementation is still not inline with the spec,
> >>> queuing buffers, then starting a thread doing the poll, then doing the
> >>> streamon in the main thread will still cause the poll to return POLLERR,
> >>> even though buffers are queued, which according to the spec should be
> >>> enough for the poll to block.
> >>> 
> >>> The correct check would be:
> >>> 
> >>> if (list_empty(&q->queued_list) && !vb2_is_streaming(q))
> >>> 
> >>> 	eturn res | POLLERR;
> >> 
> >> Good catch! I should have seen that :-(
> 
> Urgh. This breaks vbi capture tools like alevt and mtt. These rely on poll
> returning POLLERR if buffers are queued but STREAMON has not been called
> yet.

Then there's something I don't get. Before this commit, the implementation was

    /*
     * There is nothing to wait for if no buffers have already been queued.
     */
    if (list_empty(&q->queued_list))
            return res | POLLERR;

If buffers are queued and STREAMON hasn't been called yet, vb2_poll() would 
not return POLLERR.

> See bug report https://bugzilla.kernel.org/show_bug.cgi?id=84401
> 
> The spec also clearly says that poll should return POLLERR if STREAMON
> was not called.

The V4L2 specification says

"When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet the 
poll() function succeeds, but sets the POLLERR flag in the revents field."

How about then

- adding a flag to vb2_queue that tells that no buffer has been queued
- clearing the flag when a buffer is queued
- setting the flag when the stream is stopped
- modifying the poll implementation to

    if (q->no_buffer || !vb2_is_streaming(q) || q->error)
            return res | POLLERR;

(a better name is probably needed for the flag)

This would make poll() not return immediately during transient buffer 
underruns.

The other option would be to modify the V4L2 specification to state that 
poll() will return immediately with POLLERR at any time no buffer is queued, 
and forcing all userspace applications to implement an explicit buffer 
underrun check. I don't really like that though.

> But that would clash with this multi-thread example.
> 
> Hans, was this based on actual code that needed this?
> 
> I am inclined to update alevt and mtt: all that is needed to make it work
> is a single line that explicitly calls the vbi handler before entering the
> main loop. This is effectively the same as what happens when the first
> select gets a POLLERR.
> 
> We maintain alevt (dvb-apps) and mtt (xawtv3), so that's easy enough to
> fix.
> 
> Note that the spec is now definitely out-of-sync since poll no longer
> returns POLLERR if buffers are queued but STREAMON wasn't called.

-- 
Regards,

Laurent Pinchart

