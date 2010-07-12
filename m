Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2159 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0GLMXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 08:23:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC v4] Multi-plane buffer support for V4L2 API
Date: Mon, 12 Jul 2010 14:23:13 +0200
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Hans de Goede'" <hdegoede@redhat.com>, kyungmin.park@samsung.com
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com> <201007101825.28446.hverkuil@xs4all.nl> <000e01cb21a2$a263a910$e72afb30$%osciak@samsung.com>
In-Reply-To: <000e01cb21a2$a263a910$e72afb30$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121423.13546.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 July 2010 11:14:30 Pawel Osciak wrote:
> Hi Hans,
> 
> thank you for your comments as always.
> 
> >Hans Verkuil wrote <hverkuil@xs4all.nl>:
> >Hi Pawel,
> >
> >Looks good, but I have a few small suggestions:
> >
> >On Friday 09 July 2010 20:59:45 Pawel Osciak wrote:
> 
> (snip)
> 
> >>  struct v4l2_format {
> >>         enum v4l2_buf_type type;
> >>         union {
> >>                 struct v4l2_pix_format          pix;     /*
> >V4L2_BUF_TYPE_VIDEO_CAPTURE */
> >> +               struct v4l2_pix_format_mplane   mp_pix;  /*
> >V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
> >
> >I would probably go with pix_mp to be consistent with the name of the struct.
> >
> 
> ok.
> 
> >> +/**
> >> + * struct v4l2_pix_format_mplane - multiplanar format definition
> >> + * @pix_fmt:   definition of an image format for all planes
> >> + * @plane_fmt: per-plane information
> >> + */
> >> +struct v4l2_pix_format_mplane {
> >> +       struct v4l2_pix_format          pix_fmt;
> >> +       struct v4l2_plane_format        plane_fmt[VIDEO_MAX_PLANES];
> >> +} __attribute__ ((packed));
> >
> >How do you know how many planes there are? I wonder whether it wouldn't be
> >smarter
> >to just copy the relevant fields from struct v4l2_pix_format to struct
> >v4l2_pix_format_mplane
> >instead of embedded that struct. That way you can 1) add a 'planes' field and
> >2) get rid
> >of the no longer needed bytesperline and sizeimage fields. And I think the
> >priv field
> >should also go, just have a reserved[2] instead.
> >
> 
> By mean "planes" you mean a field indicating the number of planes in the
> current format, right?

Right.

> Number of planes can be inferred from fourcc, but you are right, it's still
> useful to have to have a field for that.

You really don't want to have a switch on the fourcc just to determine the number
of planes. Creating a separate field will make life much easier.

> 
> What do you think of this:
> 
> /**
>  * struct v4l2_pix_format_mplane - multiplanar format definition
>  * @width:		image width in pixels
>  * @height:		image height in pixels
>  * @pixelformat:	little endian four character code (fourcc)
>  * @field:		field order (for interlaced video)
>  * @colorspace:		supplemental to pixelformat
>  * @plane_fmt:		per-plane information
>  * @num_planes:		number of planes for this format and number of valid
>  * 			elements in plane_fmt array
>  */
> struct v4l2_pix_format_mplane {
> 	__u32				width;
> 	__u32				height;
> 	__u32				pixelformat;
> 	enum v4l2_field			field;
> 	enum v4l2_colorspace		colorspace;
> 
> 	struct v4l2_plane_format	plane_fmt[VIDEO_MAX_PLANES];
> 	__u8				num_planes;
> 	__u8				reserved[11];
> } __attribute__ ((packed));
> 
> v4l2_plane_format stays the same (see below).
> 
> 8 * struct v4l2_plane_format + 3 * 4 + 2 * enum + 12 * 1 = 8 * 20 + 40 = 200

Looks good. 

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
