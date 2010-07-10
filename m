Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3648 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0GJQX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 12:23:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC v4] Multi-plane buffer support for V4L2 API
Date: Sat, 10 Jul 2010 18:25:28 +0200
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Hans de Goede'" <hdegoede@redhat.com>, kyungmin.park@samsung.com
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
In-Reply-To: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101825.28446.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Looks good, but I have a few small suggestions:

On Friday 09 July 2010 20:59:45 Pawel Osciak wrote:
> Hello,
> 
> This is the fourth version of the multi-plane API extensions proposal.
> I think that we have reached a stage at which it is more or less finalized.
> 
> Rationale can be found at the beginning of the original thread:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11212
> 
> 
> ===============================================
> I. Multiplanar API description/negotiation
> ===============================================
> 
> 1. Maximum number of planes
> ----------------------------------
> 
> We've chosen the maximum number of planes to be 8 per buffer:
> 
> +#define VIDEO_MAX_PLANES               8
> 
> 
> 2. Capability checks
> ----------------------------------
> 
> If a driver supports multiplanar API, it can turn on one (or both) of the
> new capability flags:
> 
> +/* Is a video capture device that supports multiplanar formats */
> +#define V4L2_CAP_VIDEO_CAPTURE_MPLANE  0x00001000
> +/* Is a video output device that supports multiplanar formats */
> +#define V4L2_CAP_VIDEO_OUTPUT_MPLANE   0x00002000
> 
> - any combination of those flags is valid;
> - any combinations with the old, non-multiplanar V4L2_CAP_VIDEO_CAPTURE and
>   V4L2_CAP_VIDEO_OUTPUT flags are also valid;
> - the new flags indicate, that a driver supports the new API, but it does NOT
>   have to actually use multiplanar formats; it is perfectly possible and valid
>   to use the new API for 1-plane buffers as well;
>   using the new API for both 1-planar and n-planar formats makes the
>   applications simpler, as they do not have to fall back to the old API in the
>   former case.
> 
> 
> 3. Describing multiplanar formats
> ----------------------------------
> 
> To describe multiplanar formats, we have to extend the format struct:
> 
>  struct v4l2_format {
>         enum v4l2_buf_type type;
>         union {
>                 struct v4l2_pix_format          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
> +               struct v4l2_pix_format_mplane   mp_pix;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */

I would probably go with pix_mp to be consistent with the name of the struct.

>                 struct v4l2_window              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>                 struct v4l2_vbi_format          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>                 struct v4l2_sliced_vbi_format   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
>                 __u8    raw_data[200];                   /* user-defined */
>         } fmt;
>  };
> 
> We need a new buffer type to recognize when to use mp_pix instead of pix.
> Or, actually, two buffer types, for both OUTPUT and CAPTURE:
> 
>  enum v4l2_buf_type {
>         /* ... */
> +       V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
> +       V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
>         /* ... */
>  };
> 
> 
> For those buffer types, we use struct v4l2_pix_format_mplane:
> 
> +/**
> + * struct v4l2_pix_format_mplane - multiplanar format definition
> + * @pix_fmt:   definition of an image format for all planes
> + * @plane_fmt: per-plane information
> + */
> +struct v4l2_pix_format_mplane {
> +       struct v4l2_pix_format          pix_fmt;
> +       struct v4l2_plane_format        plane_fmt[VIDEO_MAX_PLANES];
> +} __attribute__ ((packed));

How do you know how many planes there are? I wonder whether it wouldn't be smarter
to just copy the relevant fields from struct v4l2_pix_format to struct v4l2_pix_format_mplane
instead of embedded that struct. That way you can 1) add a 'planes' field and 2) get rid
of the no longer needed bytesperline and sizeimage fields. And I think the priv field
should also go, just have a reserved[2] instead.

> 
> The pix_fmt member is to be used in the same way as in the old API. Its fields:
> - width, height, field, colorspace, priv retain their old meaning;
> - pixelformat is still fourcc, but new fourcc values have to be introduced
>   for multiplanar formats;
> - bytesperline, sizeimage lose their meanings and are replaced by their
>   counterparts in the new, per-plane format struct.
> 
> 
> The plane format struct is as follows:
> 
> +/**
> + * struct v4l2_plane_format - additional, per-plane format definition
> + * @sizeimage:         maximum size in bytes required for data, for which
> + *                     this plane will be used
> + * @bytesperline:      distance in bytes between the leftmost pixels in two
> + *                     adjacent lines
> + */
> +struct v4l2_plane_format {
> +       __u32           sizeimage;
> +       __u16           bytesperline;
> +       __u16           reserved[7];
> +} __attribute__ ((packed));
> 
> Note that bytesperline is u16 now, but that shouldn't hurt.
> 
> 
> Fitting everything into v4l2_format's union (which is 200 bytes long):
> v4l2_pix_format shouldn't be larger than 40 bytes.
> 8 * struct v4l2_plane_format + struct v4l2_pix_format = 8 * 20 + 40 = 200
> 
> 
> 4. Format enumeration
> ----------------------------------
> struct v4l2_fmtdesc, used for format enumeration, does include the v4l2_buf_type
> enum as well, so the new types can be handled properly here as well.
> For drivers supporting both versions of the API, 1-plane formats should be
> returned for multiplanar buffer types as well, for consistency. In other words,
> for multiplanar buffer types, the formats returned are a superset of those
> returned when enumerating with the old buffer types.
> 
> 
> 5. Requesting buffers (buffer allocation)
> ----------------------------------
> VIDIOC_REQBUFS includes v4l2_buf_type as well, so everything works as expected.
> 
> 
> ===============================================
> II. Multiplanar buffer and plane descriptors
> ===============================================
> 
> 1. Adding plane info to v4l2_buffer
> ----------------------------------
> 
>  struct v4l2_buffer {
>         /* ... */ 
>         enum v4l2_buf_type      type;
>         /* ... */ 
>         union {
>                 __u32           offset;
>                 unsigned long   userptr;
> +               struct v4l2_plane __user *planes;
>         } m;
>         __u32                   length;
>         /* ... */
>  };
> 
> Multiplanar buffers are also recognized using the new v4l2_buf_types.
> 
> (Note to readers familiar with the old proposal: we do not use any new memory
> types for multiplanar buffers anymore, buffer types are enough. So no more
> V4L2_MEMORY_MULTI_MMAP and V4L2_MEMORY_MULTI_USERPTR.)
> 
> 
> For new buffer types, we choose the "planes" member of the union. It contains
> a userspace pointer to an array of struct v4l2_plane. The size of this array
> is to be passed in "length", as it is not relevant for multiplanar buffers.
> 
> 2. Plane description struct
> ----------------------------------
> 
> +/**
> + * struct v4l2_plane - plane info for multiplanar buffers
> + * @bytesused: number of bytes occupied by data in the plane (payload)
> + * @mem_off:   when memory in the associated struct v4l2_buffer is
> + *             V4L2_MEMORY_MMAP, equals the offset from the start of the
> + *             device memory for this plane (or is a "cookie" that should be
> + *             passed to mmap() called on the video node)
> + * @userptr:   when memory is V4L2_MEMORY_USERPTR, a userspace pointer pointing
> + *             to this plane
> + * @length:    size of this plane (NOT the payload) in bytes
> + * @data_off:  offset in plane to the start of data/end of header, if relevant
> + *
> + * Multi-plane buffers consist of two or more planes, e.g. an YCbCr buffer
> + * with two planes has one plane for Y, and another for interleaved CbCr
> + * components. Each plane can reside in a separate memory buffer, or in
> + * a completely separate memory chip even (e.g. in embedded devices).
> + */
> +struct v4l2_plane {
> +       __u32                   bytesused;
> +       __u32                   length;
> +       union {
> +               __u32           mem_off;

Rename to mem_offset. This prevents confusion since 'off' can also be
interpreted as the opposite of 'on'.

> +               unsigned long   userptr;
> +       } m;
> +       __u32                   data_off;

Rename to data_offset.

> +       __u32                   reserved[11];
> +};
> 
> If a plane contents include not only data, but also a header, a driver may use
> the data_off member to indicate the offset in bytes to the start of data.
> 
> Union m works in the same way as it does in the old API for v4l2_buffer.
> offset has been renamed to mem_off, so as not to be confused with data_off.
> Which of the two to choose is decided as in the old API, by checking the
> memory field in struct v4l2_buffer.
> 
> 
> ===============================================
> III. Handling ioctl()s and mmap()
> ===============================================
> 
> * VIDIOC_S/G/TRY_FMT:
> Pass a new buffer type and use the new mp_pix member of the struct.
> 
> * VIDIOC_ENUM_FMT:
> Pass a new buffer type.
> 
> * VIDIOC_REQBUFS:
> Pass a new buffer type and count of video frames (not plane count) normally.
> Expect the driver to return count (of buffers, not planes) as usual or EINVAL
> if multiplanar API is not supported.
> (The number of planes is already known, specified by the currently chosen
> format.)
> 
> * VIDIOC_QUERYBUFS:
> Pass a v4l2_buffer struct as usual, set a multiplane buffer type and put a
> pointer to an array of v4l2_plane structures under 'planes'.  Place the size
> of that array in 'length'. Expect the driver to fill mem_off fields in each
> v4l2_plane struct, analogically to offsets in non-multiplanar v4l2_buffers.
> 
> * VIDIOC_QBUF
> As in the case of QUERYBUFS, pass the array of planes and its size in 'length'.
> Fill all the fields required by non-multiplanar versions of this call, although
> some of them in the planes' array members.
> 
> * VIDIOC_DQBUF
> An array of planes does not have to be passed, but if you do pass it, you will
> have it filled with data, just like in case of the non-multiplanar version.
> 
> * mmap()
> Basically just like in non-multiplanar buffer case, but with planes instead of
> buffers and one mmap() call per each plane.
> 
> Call mmap() once for each plane, passing the offsets provided in v4l2_plane
> structs. Repeat for all buffers ((num_planes * num_buffers) calls to mmap).
> There is no need for those calls to be in any particular order.
> 
> A v4l2_buffer changes state to mapped (V4L2_BUF_FLAG_MAPPED flag) only after all
> of its planes have been mmapped successfully.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
