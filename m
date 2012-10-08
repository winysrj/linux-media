Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2965 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JHLPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 07:15:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 18/25] v4l: add buffer exporting via dmabuf
Date: Mon, 8 Oct 2012 13:15:03 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <201210081154.57646.hverkuil@xs4all.nl> <5072ADD8.90709@samsung.com>
In-Reply-To: <5072ADD8.90709@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081315.03555.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 8 2012 12:41:28 Tomasz Stanislawski wrote:
> Hi Hans,
> 
> On 10/08/2012 11:54 AM, Hans Verkuil wrote:
> > On Mon October 8 2012 11:40:37 Tomasz Stanislawski wrote:
> >> Hi Hans,
> >>
> >> On 10/07/2012 04:17 PM, Hans Verkuil wrote:
> >>> On Sun October 7 2012 15:38:30 Laurent Pinchart wrote:
> >>>> Hi Hans,
> >>>>
> >>>> On Friday 05 October 2012 10:55:40 Hans Verkuil wrote:
> >>>>> On Tue October 2 2012 16:27:29 Tomasz Stanislawski wrote:
> >>>>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as
> >>>>>> file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer
> >>>>>> offset used by mmap and return a file descriptor on success.
> >>>>>>
> >>>>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> [snip]
> >>>>>> +struct v4l2_exportbuffer {
> >>>>>> +	__s32		fd;
> >>>>>> +	__u32		flags;
> >>>>>> +	__u32		type; /* enum v4l2_buf_type */
> >>>>>> +	__u32		index;
> >>>>>> +	__u32		plane;
> >>>>>
> >>>>> As suggested in my comments in the previous patch, I think it is a more
> >>>>> natural order to have the type/index/plane fields first in this struct.
> >>>>>
> >>>>> Actually, I think that flags should also come before fd:
> >>>>>
> >>>>> struct v4l2_exportbuffer {
> >>>>> 	__u32		type; /* enum v4l2_buf_type */
> >>>>> 	__u32		index;
> >>>>> 	__u32		plane;
> >>>>> 	__u32		flags;
> >>>>> 	__s32		fd;
> >>>>> 	__u32		reserved[11];
> >>>>> };
> >>>>
> >>>> It would indeed feel more natural, but putting them right before the reserved 
> >>>> fields allows creating an anonymous union around type, index and plane and 
> >>>> extending it with reserved fields if needed. That's (at least to my 
> >>>> understanding) the rationale behind the current structure layout.
> >>>
> >>> The anonymous union argument makes no sense to me, to be honest.
> >>
> >> I agree that the anonymous unions are not good solutions because they are not
> >> supported in many C dialects. However I have nothing against using named unions.
> > 
> > Named or unnamed, I don't see how a union will help. What do you want to do
> > with a union?
> > 
> 
> Currently, there exist three sane layouts of the structure, that use
> only one reserved field:
> 
> A)
> struct v4l2_exportbuffer {
> 	__s32		fd;
> 	__u32		flags;
> 	__u32		type; /* enum v4l2_buf_type */
> 	__u32		index;
> 	__u32		plane;
> 	__u32		reserved[11];
> }
> 
> B)
> struct v4l2_exportbuffer {
> 	__u32		type; /* enum v4l2_buf_type */
> 	__u32		index;
> 	__u32		plane;
> 	__u32		flags;
> 	__s32		fd;
> 	__u32		reserved[11];
> }
> 
> C)
> struct v4l2_exportbuffer {
> 	__u32		type; /* enum v4l2_buf_type */
> 	__u32		index;
> 	__u32		plane;
> 	__u32		reserved[11];
> 	__u32		flags;
> 	__s32		fd;
> }
> 
> Only the layout B follows 'input/output/reserved' rule.
> 
> The layouts A and C allows to extend (type/index/plane) tuple without mixing
> it with (flags,fd).
> 
> For layouts A and C it is possible to use unions to provide new
> means of describing a buffer to be exported.
> 
> struct v4l2_exportbuffer {
> 	__s32		fd;
> 	__u32		flags;
> 	union {
> 		struct by_tip { /* type, index, plane */
> 			__u32		type; /* enum v4l2_buf_type */
> 			__u32		index;
> 			__u32		plane;
> 		} by_tip;
> 		struct by_userptr {
> 			u64	userptr;
> 			u64	length;
> 		} by_userptr;
> 		__u32	reserved[6];
> 	} b;
> 	__u32	union_type; /* BY_TIP or BY_USERPTR */
> 	__u32	reserved[4];
> };
> 
> No such an extension can be applied for layout B.

You are overengineering. If we ever want to export something that is *not*
a buffer created with REQBUFS/CREATE_BUFS, then you want to do that with a
new ioctl. If we want for some reason to export a userptr, then that should
either be from a queued/prepared buffer, or we need a separate API to create
a dmabuf from a userptr. After all, that would be completely generic and not
V4L2 specific.

Anyway, introducing such a union later won't work either because then instead
of writing expbuf.type you'd have to write expbuf.by_tip.type: API change.

BTW, I think it makes sense as well in the case of a userptr to only export
the buffer if it is under control of the kernel (e.g. after QBUF or PREPARE_BUF).
When exporting the buffer the driver has all the information it needs to do so
safely.

> The similar scheme can be used for layout C. Moreover it support
> extensions and variants for (flags/fd) tuple. It might be
> useful if one day we would like to export a buffer as something
> different from DMABUF file descriptors.
> 
> Anyway, we have to choose between the elegance of the layout
> and the extensibility.
> 
> I think that layout A is a good trade-off.
> We could swap fd and flags to get little closer to "the rule".
> 
> >>
> >>> It's standard practice within V4L2 to have the IN fields first, then the OUT fields, followed
> >>> by reserved fields for future expansion.
> >>
> >> IMO, the "input/output/reserved rule" is only a recommendation.
> >> The are places in V4L2 where this rule is violated with structure
> >> v4l2_buffer being the most notable example.
> >>
> >> Notice that if at least one of the reserved fields becomes an input
> >> file then "the rule" will be violated anyway.
> > 
> > Sure, but there is no legacy yet, so why not keep to the recommendation?
> > 
> >>> Should we ever need a, say, sub-plane
> >>> index (whatever that might be), then we can use one of the reserved fields.
> >>
> >> Maybe not subplane :).
> >> But maybe some data_offset for exporting only a part of the buffer will
> >> be needed some day.
> >> Moreover, the integration of DMABUF with the DMA synchronization framework
> >> may involve passing additional parameters from the userspace.
> >>
> >> Notice that flags and fd fields are not logically connected with
> >> (type/index/plane) tuple.
> >> Therefore both field sets should be separated by some reserved fields to
> >> ensure that any of them can be extended if needed.
> >>
> >> This was the rationale for the structure layout in v9.
> > 
> > It's a bad idea to add multiple 'reserved' arrays, that makes userspace harder
> > since it has to zero all of them instead of just one. Actually, the same applies
> > to kernel space, which has to zero them as well.
> 
> Userspace usually cleans the whole structure using memset call.

'usually', yes. :-)

> Notice that memset is a build-in functions therefore fields
> are not zeroed if they are initialized just below memset.
> 
> The number of reserved fields has no impact on initialization code.
> There has also negligible impact on performance (if any at all).

Performance is not an issue here. It's about conforming to existing conventions
and making it possible to use INFO_FL_CLEAR() in v4l2-ioctl.c to have the struct
zeroed automatically after all the IN arguments, thus making it easier on drivers.

Regards,

	Hans
