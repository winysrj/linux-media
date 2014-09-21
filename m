Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42603 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaIUJpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 05:45:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/3] vb2: fix VBI/poll regression
Date: Sun, 21 Sep 2014 12:45:46 +0300
Message-ID: <2473791.PZayTX8bYa@avalon>
In-Reply-To: <541E9BA2.40808@xs4all.nl>
References: <1411240597-2105-1-git-send-email-hverkuil@xs4all.nl> <4989071.vgGAHMadIH@avalon> <541E9BA2.40808@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 21 September 2014 11:34:26 Hans Verkuil wrote:
> On 09/21/2014 11:30 AM, Laurent Pinchart wrote:
> > On Sunday 21 September 2014 11:00:02 Hans Verkuil wrote:
> >> On 09/20/2014 09:26 PM, Laurent Pinchart wrote:
> >>> On Saturday 20 September 2014 21:16:35 Hans Verkuil wrote:
> >>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> 
> >>>> The recent conversion of saa7134 to vb2 unconvered a poll() bug that
> >>>> broke the teletext applications alevt and mtt. These applications
> >>>> expect that calling poll() without having called VIDIOC_STREAMON will
> >>>> cause poll() to return POLLERR. That did not happen in vb2.
> >>>> 
> >>>> This patch fixes that behavior. It also fixes what should happen when
> >>>> poll() is called when STREAMON is called but no buffers have been
> >>>> queued. In that case poll() will also return POLLERR, but only for
> >>>> capture queues since output queues will always return POLLOUT
> >>>> anyway in that situation.
> >>>> 
> >>>> This brings the vb2 behavior in line with the old videobuf behavior.
> >>>> 
> >>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>> 
> >>>>  drivers/media/v4l2-core/videobuf2-core.c | 17 ++++++++++++++---
> >>>>  include/media/videobuf2-core.h           |  4 ++++
> >>>>  2 files changed, 18 insertions(+), 3 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >>>> b/drivers/media/v4l2-core/videobuf2-core.c index 7e6aff6..a0aa694
> >>>> 100644
> >>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>>> @@ -977,6 +977,7 @@ static int __reqbufs(struct vb2_queue *q, struct
> >>>> v4l2_requestbuffers *req) * to the userspace.
> >>>> 
> >>>>  	 */
> >>>>  	
> >>>>  	req->count = allocated_buffers;
> >>>> 
> >>>> +	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> >>>> 
> >>>>  	return 0;
> >>>>  
> >>>>  }
> >>>> 
> >>>> @@ -1024,6 +1025,7 @@ static int __create_bufs(struct vb2_queue *q,
> >>>> struct
> >>>> v4l2_create_buffers *create memset(q->plane_sizes, 0,
> >>>> sizeof(q->plane_sizes));
> >>>> 
> >>>>  		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
> >>>>  		q->memory = create->memory;
> >>>> 
> >>>> +		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> >>> 
> >>> Wouldn't it be easier to set the flag when creating the queue and in
> >>> vb2_internal_streamoff() instead of in __create_bufs and __reqbufs ?
> >>> I'll
> >>> let you decide.
> >> 
> >> Sorry, I don't follow. 'When creating the queue'? __create_bufs and
> >> __reqbufs are the functions that create the queue (i.e. allocate the
> >> buffers).
> > 
> > I meant vb2_queue_init.
> 
> That's not an option as it is called only once at probe time.

I know :-)

> And this flag needs to be set every time you setup the queue for streaming,
> when you stop streaming and when you queue a buffer.

I was thinking it would be enough to set the flag when stopping the stream, as 
it would then be set for the next REQBUFS or CREATE_BUFS operation, but that 
would break if an application calls QBUF - close() - open() - ...

Let's proceed with your patch.

-- 
Regards,

Laurent Pinchart

