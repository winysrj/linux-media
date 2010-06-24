Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15688 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0FXNAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 09:00:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L4I00F9ES5AVJ30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jun 2010 14:00:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L4I00J9JS5A2F@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jun 2010 14:00:46 +0100 (BST)
Date: Thu, 24 Jun 2010 14:59:43 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [RFC v3] Multi-plane buffer support for V4L2 API
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Cc: kyungmin.park@samsung.com
Message-id: <002401cb139d$1d5df080$5819d180$%osciak@samsung.com>
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would like to take up the multiplane discussion we had during the Helsinki
summit.

- You can find a detailed description in my original patch series here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg15850.html
(note: as videobuf will be undergoing a major redesign, the relevant parts
 are mostly only those concerning V4L2 API).

- The most recent patch, adding the proposed extensions to the API can be found
here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg16457.html


- The proposal has sparked more interest from various parties during the summit
and additional requirements and suggestions have been put forward, which I would
like to discuss again here and arrive at a consensus, hopefully reasonably
quickly (this issue has been blocking some our drivers from being posted for
some time already).


In short
===========================
The previous proposal involved adding a new struct v4l2_plane as an extension
to the current v4l2_buffer struct and has generally been accepted.

This RFC mainly concerns the need to add some more per-plane information,
but to the format definition, as opposed to per-buffer info in the case of
the v4l2_plane struct. In other words, metadata that does not change between
frames.


Discussion points
===========================

1. We would like to add some additional plane-related information for each
plane, e.g. a per-plane "bytesperline" field. Adding it to the v4l2_plane struct
would result in passing it back and forth on each frame though. It would be
better to pass it when setting up format instead. The following shows how it is
done for the single-plane case in the current API.

Passed to the S_FMT ioctl is the:

struct v4l2_format {
	enum v4l2_buf_type type;
	union {
		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
		__u8	raw_data[200];                   /* user-defined */
	} fmt;
};

where:

struct v4l2_pix_format {
        __u32                   width;
        __u32                   height;
        __u32                   pixelformat;
        enum v4l2_field         field;
        __u32                   bytesperline;   /* for padding, zero if unused */
        __u32                   sizeimage;
        enum v4l2_colorspace    colorspace;
        __u32                   priv;           /* private data, depends on pixelformat */
};

We have concluded that the way to go would be to add a new
v4l2_pix_format_mplane entry to the union in the v4l2_format struct:

struct v4l2_format {
	enum v4l2_buf_type type;
	union {
		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
		struct v4l2_pix_format_mplane	mp_pix;
		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
		__u8	raw_data[200];                   /* user-defined */
	} fmt;
};

And the actual struct can now either:

a) store the plane data in the remaining space (should fit if we go for 8 planes
as max I think)

struct v4l2_pix_format_mplane {
	struct v4l2_pix_format			pix_fmt;
	struct v4l2_plane_format		plane_fmt[VIDEO_MAX_PLANES];
};

b) pass a userspace pointer to a separate array

struct v4l2_pix_format_mplane {
	struct v4l2_pix_format			pix_fmt;
	__u32					num_planes;
	/* userspace pointer to an array of size num_planes */
	struct v4l2_plane_format		*plane_fmt;
};

and then fetch the array separately. The second solution would give us more
flexibility for future extensions (if we add a handful of reserved fields to the
v4l2_plane_format struct).

The main discussion point here though was how to select the proper member of the
fmt union from v4l2_format struct. It is normally being done with the type
field. Now, assuming that multiplane pix formats make sense only for CAPTURE and
OUTPUT types (right?), we would be adding two new v4l2_buf_type members:

V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE

which is not that big of a deal in my opinion after all.


2. There are other fields besides bytesperline that some parties are interested
in having in the plane format struct. Among those we had: sample range
(sorry, I am still not sure I remember this one correctly, please correct me)
and - optionally - memory type-related (more on this further below).

struct v4l2_plane_format {
	__u32			bytesperline;
	/* Anything else? */
	__u32			reserved[?];
};

Please provide your specific requirements for this struct.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center




