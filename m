Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:28812 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaIOMCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 08:02:31 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBX00B8WYS6F080@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 08:02:30 -0400 (EDT)
Date: Mon, 15 Sep 2014 09:02:24 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
Message-id: <20140915090224.5a2889a1.m.chehab@samsung.com>
In-reply-to: <5416CA2B.1080004@xs4all.nl>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <53918EDB.3090908@redhat.com> <539190BA.8060006@xs4all.nl>
 <2394481.2zcs5YKt7z@avalon> <5416CA2B.1080004@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Sep 2014 13:14:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

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
> returning POLLERR if buffers are queued but STREAMON has not been called yet.
> 
> See bug report https://bugzilla.kernel.org/show_bug.cgi?id=84401
> 
> The spec also clearly says that poll should return POLLERR if STREAMON
> was not called.
> 
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

No, the best is to revert the patch ASAP, as this is a regression.

We can then work to change alevt and mtt to do it, but we need to check
other tools, like zvbi.

Only after having this change at the VBI tools for a while we can change
the Kernel again, (if it makes sense: as you said, this patch is violating
the spec on VB2).

> 
> Note that the spec is now definitely out-of-sync since poll no longer returns
> POLLERR if buffers are queued but STREAMON wasn't called.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > I'll update the patch accordingly.
> > 
> >> v4l2-compliance should certainly be extended to test this as well.
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>> Regards,
> >>>
> >>> Hans
> >>>
> >>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>>
> >>>>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >>>> b/drivers/media/v4l2-core/videobuf2-core.c index 349e659..fd428e0 100644
> >>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>>> @@ -2533,9 +2533,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> >>>> file *file, poll_table *wait)>> 
> >>>>  	}
> >>>>  	
> >>>>  	/*
> >>>>
> >>>> -	 * There is nothing to wait for if no buffers have already been 
> > queued.
> >>>> +	 * There is nothing to wait for if the queue isn't streaming.
> >>>>
> >>>>  	 */
> >>>>
> >>>> -	if (list_empty(&q->queued_list))
> >>>> +	if (!vb2_is_streaming(q))
> >>>>
> >>>>  		return res | POLLERR;
> >>>>  	
> >>>>  	if (list_empty(&q->done_list))
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
