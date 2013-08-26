Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32083 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3HZOcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 10:32:09 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS500GGI6VVSD40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Aug 2013 10:32:07 -0400 (EDT)
Date: Mon, 26 Aug 2013 11:32:01 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] videobuf2-core: Verify planes lengths for output buffers
Message-id: <20130826113201.5384bb49@samsung.com>
In-reply-to: <521B5E54.7030101@samsung.com>
References: <1350401832-22186-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <2162328.PEQByhq36m@avalon> <52038BA6.9000409@samsung.com>
 <4398539.RWQLsyW34a@avalon> <521B5E54.7030101@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Aug 2013 15:55:32 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> Hi All,
> 
> On 08/08/2013 02:35 PM, Laurent Pinchart wrote:
> > Hi Marek,
> > 
> > On Thursday 08 August 2013 14:14:30 Marek Szyprowski wrote:
> >> On 8/7/2013 12:44 PM, Laurent Pinchart wrote:
> >>> On Monday 12 November 2012 12:35:35 Laurent Pinchart wrote:
> >>>> On Friday 09 November 2012 15:33:22 Pawel Osciak wrote:
> >>>>> On Tue, Oct 16, 2012 at 8:37 AM, Laurent Pinchart wrote:
> >>>>>> For output buffers application provide to the kernel the number of
> >>>>>> bytes they stored in each plane of the buffer. Verify that the value
> >>>>>> is smaller than or equal to the plane length.
> >>>>>>
> >>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>>> ---
> >>>>>
> >>>>> Acked-by: Pawel Osciak <pawel@osciak.com>
> >>>>
> >>>> You're listed, as well as Marek and Kyungmin, as videobuf2 maintainers.
> >>>> When you ack a videobuf2 patch, should we assume that you will take it
> >>>> in your git tree ?
> >>>
> >>> Ping ? I'd like to get this patch in v3.12, should I send a pull request ?
> >>
> >> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >>
> >> Feel free to include it in your pull-request. I'm sorry for so huge
> >> delay in my response.
> > 
> > No worries. I'll send a pull request to Mauro.
> > 
> >>>>>>  drivers/media/v4l2-core/videobuf2-core.c |   39 +++++++++++++++++++
> >>>>>>  1 files changed, 39 insertions(+), 0 deletions(-)
> >>>>>>
> >>>>>> Changes compared to v1:
> >>>>>>
> >>>>>> - Sanity check the data_offset value for each plane.
> >>>>>>
> >>>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>> b/drivers/media/v4l2-core/videobuf2-core.c index 432df11..479337d
> >>>>>> 100644
> >>>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>>>>> @@ -296,6 +296,41 @@ static int __verify_planes_array(struct
> >>>>>> vb2_buffer
> >>>>>> *vb, const struct v4l2_buffer>
> >>>>>>
> >>>>>>  }
> >>>>>>  
> >>>>>>  /**
> >>>>>>
> >>>>>> + * __verify_length() - Verify that the bytesused value for each
> >>>>>> plane
> >>>>>> fits in
> >>>>>> + * the plane length and that the data offset doesn't exceed the
> >>>>>> bytesused value.
> >>>>>> + */
> >>>>>> +static int __verify_length(struct vb2_buffer *vb, const struct
> >>>>>> v4l2_buffer *b)
> >>>>>> +{
> >>>>>> +       unsigned int length;
> >>>>>> +       unsigned int plane;
> >>>>>> +
> >>>>>> +       if (!V4L2_TYPE_IS_OUTPUT(b->type))
> >>>>>> +               return 0;
> >>>>>> +
> >>>>>> +       if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> >>>>>> +               for (plane = 0; plane < vb->num_planes; ++plane) {
> >>>>>> +                       length = (b->memory == V4L2_MEMORY_USERPTR)
> >>>>>> +                              ? b->m.planes[plane].length
> >>>>>> +                              : vb->v4l2_planes[plane].length;
> >>>>>> +
> >>>>>> +                       if (b->m.planes[plane].bytesused > length)
> >>>>>> +                               return -EINVAL;
> >>>>>> +                       if (b->m.planes[plane].data_offset >=
> >>>>>> +                           b->m.planes[plane].bytesused)
> >>>>>> +                               return -EINVAL;
> 
> 
> This patch causes regressions. After kernel upgrade applications that
> zero the planes array and don't set bytesused will stop working.
> We could say that these are buggy applications, but if it has been 
> allowed for several kernel releases failing VIDIOC_QBUF on this check
> now is plainly a regression IMO. I guess Linus wouldn't be happy about
> a change like this.
> 
> With this patch it is no longer possible to queue a buffer with bytesused 
> set to 0. I think it shouldn't be disallowed to queue a buffer with no 
> data to be used. So the check should likely be instead:
> 
>  if (b->m.planes[plane].bytesused > 0 &&
>      b->m.planes[plane].data_offset >=
>      b->m.planes[plane].bytesused)
> 	return -EINVAL;
> 
> Sorry for the late review of this.

Makes sense. Could you please send such patch?

Regards,
Mauro
> 
> >>>>>> +               }
> >>>>>> +       } else {
> >>>>>> +               length = (b->memory == V4L2_MEMORY_USERPTR)
> >>>>>> +                      ? b->length : vb->v4l2_planes[0].length;
> >>>>>> +
> >>>>>> +               if (b->bytesused > length)
> >>>>>> +                       return -EINVAL;
> >>>>>> +       }
> >>>>>> +
> >>>>>> +       return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>> +/**
> >>>>>>
> >>>>>>   * __buffer_in_use() - return true if the buffer is in use and
> >>>>>>   * the queue cannot be freed (by the means of REQBUFS(0)) call
> >>>>>>   */
> >>>>>>
> >>>>>> @@ -975,6 +1010,10 @@ static int __buf_prepare(struct vb2_buffer
> >>>>>> *vb,
> >>>>>> const struct v4l2_buffer *b)>
> >>>>>>
> >>>>>>         struct vb2_queue *q = vb->vb2_queue;
> >>>>>>         int ret;
> >>>>>>
> >>>>>> +       ret = __verify_length(vb, b);
> >>>>>> +       if (ret < 0)
> >>>>>> +               return ret;
> >>>>>> +
> >>>>>>
> >>>>>>         switch (q->memory) {
> >>>>>>         
> >>>>>>         case V4L2_MEMORY_MMAP:
> >>>>>>                 ret = __qbuf_mmap(vb, b);
> > 
> 
> Regards,


-- 

Cheers,
Mauro
