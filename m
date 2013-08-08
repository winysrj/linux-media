Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10428 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab3HHMOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:14:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR700NVQOO64T80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Aug 2013 13:14:32 +0100 (BST)
Message-id: <52038BA6.9000409@samsung.com>
Date: Thu, 08 Aug 2013 14:14:30 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2] videobuf2-core: Verify planes lengths for output buffers
References: <1350401832-22186-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <CAMm-=zCd3T=YnkjxTPej_2J-MaiCtsrH5entkiz5GgKCBg31rw@mail.gmail.com>
 <1628324.o2sLjPETOy@avalon> <2162328.PEQByhq36m@avalon>
In-reply-to: <2162328.PEQByhq36m@avalon>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 8/7/2013 12:44 PM, Laurent Pinchart wrote:
> On Monday 12 November 2012 12:35:35 Laurent Pinchart wrote:
> > On Friday 09 November 2012 15:33:22 Pawel Osciak wrote:
> > > On Tue, Oct 16, 2012 at 8:37 AM, Laurent Pinchart wrote:
> > > > For output buffers application provide to the kernel the number of bytes
> > > > they stored in each plane of the buffer. Verify that the value is
> > > > smaller than or equal to the plane length.
> > > >
> > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > >
> > > Acked-by: Pawel Osciak <pawel@osciak.com>
> >
> > You're listed, as well as Marek and Kyungmin, as videobuf2 maintainers. When
> > you ack a videobuf2 patch, should we assume that you will take it in your
> > git tree ?
>
> Ping ? I'd like to get this patch in v3.12, should I send a pull request ?

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Feel free to include it in your pull-request. I'm sorry for so huge 
delay in my response.

> > > >  drivers/media/v4l2-core/videobuf2-core.c |   39 +++++++++++++++++++++++
> > > >  1 files changed, 39 insertions(+), 0 deletions(-)
> > > >
> > > > Changes compared to v1:
> > > >
> > > > - Sanity check the data_offset value for each plane.
> > > >
> > > > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > > > b/drivers/media/v4l2-core/videobuf2-core.c index 432df11..479337d 100644
> > > > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > > > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > > > @@ -296,6 +296,41 @@ static int __verify_planes_array(struct vb2_buffer
> > > > *vb, const struct v4l2_buffer>
> > > >
> > > >  }
> > > >
> > > >  /**
> > > > + * __verify_length() - Verify that the bytesused value for each plane
> > > > fits in
> > > > + * the plane length and that the data offset doesn't exceed the
> > > > bytesused value.
> > > > + */
> > > > +static int __verify_length(struct vb2_buffer *vb, const struct
> > > > v4l2_buffer *b)
> > > > +{
> > > > +       unsigned int length;
> > > > +       unsigned int plane;
> > > > +
> > > > +       if (!V4L2_TYPE_IS_OUTPUT(b->type))
> > > > +               return 0;
> > > > +
> > > > +       if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> > > > +               for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > +                       length = (b->memory == V4L2_MEMORY_USERPTR)
> > > > +                              ? b->m.planes[plane].length
> > > > +                              : vb->v4l2_planes[plane].length;
> > > > +
> > > > +                       if (b->m.planes[plane].bytesused > length)
> > > > +                               return -EINVAL;
> > > > +                       if (b->m.planes[plane].data_offset >=
> > > > +                           b->m.planes[plane].bytesused)
> > > > +                               return -EINVAL;
> > > > +               }
> > > > +       } else {
> > > > +               length = (b->memory == V4L2_MEMORY_USERPTR)
> > > > +                      ? b->length : vb->v4l2_planes[0].length;
> > > > +
> > > > +               if (b->bytesused > length)
> > > > +                       return -EINVAL;
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +/**
> > > >   * __buffer_in_use() - return true if the buffer is in use and
> > > >   * the queue cannot be freed (by the means of REQBUFS(0)) call
> > > >   */
> > > > @@ -975,6 +1010,10 @@ static int __buf_prepare(struct vb2_buffer *vb,
> > > > const struct v4l2_buffer *b)>
> > > >         struct vb2_queue *q = vb->vb2_queue;
> > > >         int ret;
> > > >
> > > > +       ret = __verify_length(vb, b);
> > > > +       if (ret < 0)
> > > > +               return ret;
> > > > +
> > > >         switch (q->memory) {
> > > >         case V4L2_MEMORY_MMAP:
> > > >                 ret = __qbuf_mmap(vb, b);
>

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


