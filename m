Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2136 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0GEGxB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 02:53:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC v3] Multi-plane buffer support for V4L2 API
Date: Mon, 5 Jul 2010 08:55:12 +0200
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	kyungmin.park@samsung.com
References: <002401cb139d$1d5df080$5819d180$%osciak@samsung.com>
In-Reply-To: <002401cb139d$1d5df080$5819d180$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007050855.12059.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 24 June 2010 14:59:43 Pawel Osciak wrote:
> Hello,
> 
> I would like to take up the multiplane discussion we had during the Helsinki
> summit.
> 
> - You can find a detailed description in my original patch series here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg15850.html
> (note: as videobuf will be undergoing a major redesign, the relevant parts
>  are mostly only those concerning V4L2 API).
> 
> - The most recent patch, adding the proposed extensions to the API can be found
> here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg16457.html
> 
> 
> - The proposal has sparked more interest from various parties during the summit
> and additional requirements and suggestions have been put forward, which I would
> like to discuss again here and arrive at a consensus, hopefully reasonably
> quickly (this issue has been blocking some our drivers from being posted for
> some time already).
> 
> 
> In short
> ===========================
> The previous proposal involved adding a new struct v4l2_plane as an extension
> to the current v4l2_buffer struct and has generally been accepted.
> 
> This RFC mainly concerns the need to add some more per-plane information,
> but to the format definition, as opposed to per-buffer info in the case of
> the v4l2_plane struct. In other words, metadata that does not change between
> frames.
> 
> 
> Discussion points
> ===========================
> 
> 1. We would like to add some additional plane-related information for each
> plane, e.g. a per-plane "bytesperline" field. Adding it to the v4l2_plane struct
> would result in passing it back and forth on each frame though. It would be
> better to pass it when setting up format instead. The following shows how it is
> done for the single-plane case in the current API.
> 
> Passed to the S_FMT ioctl is the:
> 
> struct v4l2_format {
> 	enum v4l2_buf_type type;
> 	union {
> 		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
> 		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
> 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
> 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> 		__u8	raw_data[200];                   /* user-defined */
> 	} fmt;
> };
> 
> where:
> 
> struct v4l2_pix_format {
>         __u32                   width;
>         __u32                   height;
>         __u32                   pixelformat;
>         enum v4l2_field         field;
>         __u32                   bytesperline;   /* for padding, zero if unused */
>         __u32                   sizeimage;
>         enum v4l2_colorspace    colorspace;
>         __u32                   priv;           /* private data, depends on pixelformat */
> };
> 
> We have concluded that the way to go would be to add a new
> v4l2_pix_format_mplane entry to the union in the v4l2_format struct:
> 
> struct v4l2_format {
> 	enum v4l2_buf_type type;
> 	union {
> 		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
> 		struct v4l2_pix_format_mplane	mp_pix;
> 		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
> 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
> 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> 		__u8	raw_data[200];                   /* user-defined */
> 	} fmt;
> };
> 
> And the actual struct can now either:
> 
> a) store the plane data in the remaining space (should fit if we go for 8 planes
> as max I think)
> 
> struct v4l2_pix_format_mplane {
> 	struct v4l2_pix_format			pix_fmt;
> 	struct v4l2_plane_format		plane_fmt[VIDEO_MAX_PLANES];
> };

8 planes means that struct v4l2_plane_format can have 20 bytes. That seems
reasonable. If we make bytesperline a u16 and 'pack' the struct, then we
have enough reserved fields I think.

> 
> b) pass a userspace pointer to a separate array
> 
> struct v4l2_pix_format_mplane {
> 	struct v4l2_pix_format			pix_fmt;
> 	__u32					num_planes;
> 	/* userspace pointer to an array of size num_planes */
> 	struct v4l2_plane_format		*plane_fmt;
> };
> 
> and then fetch the array separately. The second solution would give us more
> flexibility for future extensions (if we add a handful of reserved fields to the
> v4l2_plane_format struct).

Due to the complexity of handling userspace pointers I don't think this is the
way to go. In my opinion there is enough spare room in the v4l2_plane_format
struct.

> 
> The main discussion point here though was how to select the proper member of the
> fmt union from v4l2_format struct. It is normally being done with the type
> field. Now, assuming that multiplane pix formats make sense only for CAPTURE and
> OUTPUT types (right?), we would be adding two new v4l2_buf_type members:
> 
> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
> 
> which is not that big of a deal in my opinion after all.

We will also need to add a new flag to struct v4l2_fmtdesc: V4L2_FMT_FLAG_MPLANE.
When enumerating the formats userspace needs to determine whether it is a
multiplane format or not.

It might also be a good idea to take one of the reserved fields and let that
return the number of planes associated with this format. What do you think?

> 
> 
> 2. There are other fields besides bytesperline that some parties are interested
> in having in the plane format struct. Among those we had: sample range
> (sorry, I am still not sure I remember this one correctly, please correct me)

No, that will be handled by new colorspace defines.

> and - optionally - memory type-related (more on this further below).

Where 'further below'?

> 
> struct v4l2_plane_format {
> 	__u32			bytesperline;
> 	/* Anything else? */
> 	__u32			reserved[?];
> };
> 
> Please provide your specific requirements for this struct.

This seems reasonable:

struct v4l2_plane_format {
	__u16			bytesperline;
	__u16			reserved[9];
} __attribute__ ((packed));


Regarding the main multi-plane proposal: as we discussed on IRC that should
perhaps be combined with pre-registration.

But thinking about it, you would still need to have a struct v4l2_plane: if the
plane memory is allocated by the kernel, then you still need to get the plane
info to the application via QUERYBUF. Pre-registration is no help there. So a
V4L2_MEMORY_MMAP_MPLANE is certainly needed. Whether a V4L2_MEMORY_USERPTR_MPLANE
is needed is less clear: it is likely that in practice you want to preregister
the memory, so there we might want to use a frame memory descriptor thingy instead.
On the other hand, that would make the API asymmetrical, which is not nice.

Comments? I think I prefer having a symmetrical API, so adding USERPTR_MPLANE as
well. It is probably trivial to do in videobuf2.

What about mixed mmap and userptr planes?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
