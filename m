Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1773 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZKEMel (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 07:34:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC] v1.1: Multi-plane (discontiguous) buffers
Date: Thu, 5 Nov 2009 13:34:36 +0100
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45382@bssrvexch01.BS.local> <7e82ade47f528c59e82018a67e4e2982.squirrel@webmail.xs4all.nl> <000001ca521b$1defcd50$59cf67f0$%osciak@samsung.com>
In-Reply-To: <000001ca521b$1defcd50$59cf67f0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051334.36700.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 October 2009 08:52:55 Pawel Osciak wrote:
> Hello,
> 
> thank you for your comments.
> 
> Hans Verkuil [mailto:hverkuil@xs4all.nl] wrote:
> >>
> >> 3. The multi_info_ptr would contain a userspace pointer to a structure
> >> further
> >> describing the buffer:
> >>
> >> + struct v4l2_multiplane_info {
> >> +         __u32  count;
> >
> >Rather than introducing this new struct, perhaps it would be better to
> >reuse the v4l2_buffer length field as a 'count' for multiplanes. That
> >length field is currently unused for multiplane formats.
> >
> 
> Good idea. This way we can copy whole v4l2_plane array in one shot.
> Now we can substitute the multi_info_ptr with a direct pointer to the
> array of v4l2_plane structs and copy it in one shot instead of two.
> 
> 
> >> + struct v4l2_plane {
> >> +         __u32   parent_index;
> >> +         __u32   bytesused;
> >> +         union {
> >> +                 __u32 offset;
> >> +                 unsigned long userptr;
> >> +         } m;
> >> +         __u32   flags;
> >> +         __u32   length;
> >> +         __u32   reserved;
> >
> >Make this reserved[4].
> >
> 
> Right.
> 
> >> + };
> >>
> >> parent_index - index of the parent v4l2_buffer
> >
> >Why do we need this index?
> 
> The idea was to have a reverse mapping to the parent (i.e. the v4l2_buffer
> struct) to simplify mmap() (see below). But the userspace doesn't need this,
> so I guess we should take this out and handle it differently.
> 
> >> flags - one flag currently: V4L2_PLANE_FLAG_MAPPED
> >> (or reuse V4L2_BUF_FLAG_MAPPED for that)
> >
> >Isn't this just a copy of the v4l2_buffer flags? Why do we need it again?
> >
> 
> mmap() will have to be called once per each plane. That said, we cannot have
> a v4l2_buffer mapped "fully" (it's state may be "partially mapped"). Only when
> all its planes are mapped, we can mark the parent v4l2_buffer as mapped.
> 
> This is also the reason for the parent_index member of v4l2_plane struct: when
> mmaping, we would be marking the plane as mapped. Then we would have to check
> whether all the other planes in the buffer are already mapped and only then mark
> the whole buffer as mapped.
> 
> There are other ways to do that though:
> 
> 1. Lazy check.
> 
> Get rid of both parent_index and flags from the plane and verify that the buffer
> is mapped during qbuf. Something like that:
> 
> v4l2_buffer *buf;
> 
> if (buf->memory & V4L2_MEMORY_MULTI_MMAP) {
>         if (!(buf->flags & V4L2_BUF_FLAG_MAPPED)) {
>                  if (verify_all_planes_mapped(buf)) {
>                           buf->flags |= V4L2_BUF_FLAG_MAPPED;
>                           /* Continue qbuf. In next qbuf the flag will be set
> 				 * already.
>                            */
>                  } else {
>                           /* Not all planes are mmapped() */
>                           return -EINVAL;
>                  }
>         }
> } else {
>         /* Handle other buffer memory types as usual */
> }
> 
> 
> 2. Let the driver (videobuffer framework) handle it however it wants.
> 
> For example, store the "PLANE_MMAPED" somewhere in internal structures and do not
> expose the plane mapped state to the userspace.
> 
> What do you think? I'm leaning towards the first solution...

I think that option 2 is best. The videobuf framework needs to be updated
anyway to support multiplanes, and I'm pretty sure that that will also
involve administrating which planes have been mapped. So I suspect that all
the information needed to determine whether all planes are mapped will be
available.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
