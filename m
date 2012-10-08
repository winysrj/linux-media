Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3523 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHJzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 05:55:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 18/25] v4l: add buffer exporting via dmabuf
Date: Mon, 8 Oct 2012 11:54:57 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <201210071617.03213.hverkuil@xs4all.nl> <50729F95.70003@samsung.com>
In-Reply-To: <50729F95.70003@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081154.57646.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 8 2012 11:40:37 Tomasz Stanislawski wrote:
> Hi Hans,
> 
> On 10/07/2012 04:17 PM, Hans Verkuil wrote:
> > On Sun October 7 2012 15:38:30 Laurent Pinchart wrote:
> >> Hi Hans,
> >>
> >> On Friday 05 October 2012 10:55:40 Hans Verkuil wrote:
> >>> On Tue October 2 2012 16:27:29 Tomasz Stanislawski wrote:
> >>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as
> >>>> file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer
> >>>> offset used by mmap and return a file descriptor on success.
> >>>>
> >>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>
> >> [snip]
> >>
> >>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>>> index e04a73e..f429b6a 100644
> >>>> --- a/include/linux/videodev2.h
> >>>> +++ b/include/linux/videodev2.h
> >>>> @@ -688,6 +688,33 @@ struct v4l2_buffer {
> >>>>
> >>>>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
> >>>>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> >>>>
> >>>> +/**
> >>>> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> >>>> descriptor + *
> >>>> + * @fd:		file descriptor associated with DMABUF (set by driver)
> >>>> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
> >>>> + *		supported, refer to manual of open syscall for more details
> >>>> + * @index:	id number of the buffer
> >>>> + * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
> >>>> + *		multiplanar buffers);
> >>>> + * @plane:	index of the plane to be exported, 0 for single plane queues
> >>>> + *
> >>>> + * Contains data used for exporting a video buffer as DMABUF file
> >>>> descriptor. + * The buffer is identified by a 'cookie' returned by
> >>>> VIDIOC_QUERYBUF + * (identical to the cookie used to mmap() the buffer to
> >>>> userspace). All + * reserved fields must be set to zero. The field
> >>>> reserved0 is expected to + * become a structure 'type' allowing an
> >>>> alternative layout of the structure + * content. Therefore this field
> >>>> should not be used for any other extensions. + */
> >>>> +struct v4l2_exportbuffer {
> >>>> +	__s32		fd;
> >>>> +	__u32		flags;
> >>>> +	__u32		type; /* enum v4l2_buf_type */
> >>>> +	__u32		index;
> >>>> +	__u32		plane;
> >>>
> >>> As suggested in my comments in the previous patch, I think it is a more
> >>> natural order to have the type/index/plane fields first in this struct.
> >>>
> >>> Actually, I think that flags should also come before fd:
> >>>
> >>> struct v4l2_exportbuffer {
> >>> 	__u32		type; /* enum v4l2_buf_type */
> >>> 	__u32		index;
> >>> 	__u32		plane;
> >>> 	__u32		flags;
> >>> 	__s32		fd;
> >>> 	__u32		reserved[11];
> >>> };
> >>
> >> It would indeed feel more natural, but putting them right before the reserved 
> >> fields allows creating an anonymous union around type, index and plane and 
> >> extending it with reserved fields if needed. That's (at least to my 
> >> understanding) the rationale behind the current structure layout.
> > 
> > The anonymous union argument makes no sense to me, to be honest.
> 
> I agree that the anonymous unions are not good solutions because they are not
> supported in many C dialects. However I have nothing against using named unions.

Named or unnamed, I don't see how a union will help. What do you want to do
with a union?

> 
> > It's standard practice within V4L2 to have the IN fields first, then the OUT fields, followed
> > by reserved fields for future expansion.
> 
> IMO, the "input/output/reserved rule" is only a recommendation.
> The are places in V4L2 where this rule is violated with structure
> v4l2_buffer being the most notable example.
> 
> Notice that if at least one of the reserved fields becomes an input
> file then "the rule" will be violated anyway.

Sure, but there is no legacy yet, so why not keep to the recommendation?

> > Should we ever need a, say, sub-plane
> > index (whatever that might be), then we can use one of the reserved fields.
> 
> Maybe not subplane :).
> But maybe some data_offset for exporting only a part of the buffer will
> be needed some day.
> Moreover, the integration of DMABUF with the DMA synchronization framework
> may involve passing additional parameters from the userspace.
> 
> Notice that flags and fd fields are not logically connected with
> (type/index/plane) tuple.
> Therefore both field sets should be separated by some reserved fields to
> ensure that any of them can be extended if needed.
> 
> This was the rationale for the structure layout in v9.

It's a bad idea to add multiple 'reserved' arrays, that makes userspace harder
since it has to zero all of them instead of just one. Actually, the same applies
to kernel space, which has to zero them as well.

I still don't know why you want to use a non-standard field order.

Regards,

	Hans
