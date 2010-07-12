Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33639 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab0GLJPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 05:15:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L5F00JQUTQ99C40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Jul 2010 10:15:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5F00D9ZTQ9NQ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Jul 2010 10:15:45 +0100 (BST)
Date: Mon, 12 Jul 2010 11:14:30 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC v4] Multi-plane buffer support for V4L2 API
In-reply-to: <201007101825.28446.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Hans de Goede' <hdegoede@redhat.com>,
	kyungmin.park@samsung.com
Message-id: <000e01cb21a2$a263a910$e72afb30$%osciak@samsung.com>
Content-language: pl
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com>
 <201007101825.28446.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for your comments as always.

>Hans Verkuil wrote <hverkuil@xs4all.nl>:
>Hi Pawel,
>
>Looks good, but I have a few small suggestions:
>
>On Friday 09 July 2010 20:59:45 Pawel Osciak wrote:

(snip)

>>  struct v4l2_format {
>>         enum v4l2_buf_type type;
>>         union {
>>                 struct v4l2_pix_format          pix;     /*
>V4L2_BUF_TYPE_VIDEO_CAPTURE */
>> +               struct v4l2_pix_format_mplane   mp_pix;  /*
>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
>
>I would probably go with pix_mp to be consistent with the name of the struct.
>

ok.

>> +/**
>> + * struct v4l2_pix_format_mplane - multiplanar format definition
>> + * @pix_fmt:   definition of an image format for all planes
>> + * @plane_fmt: per-plane information
>> + */
>> +struct v4l2_pix_format_mplane {
>> +       struct v4l2_pix_format          pix_fmt;
>> +       struct v4l2_plane_format        plane_fmt[VIDEO_MAX_PLANES];
>> +} __attribute__ ((packed));
>
>How do you know how many planes there are? I wonder whether it wouldn't be
>smarter
>to just copy the relevant fields from struct v4l2_pix_format to struct
>v4l2_pix_format_mplane
>instead of embedded that struct. That way you can 1) add a 'planes' field and
>2) get rid
>of the no longer needed bytesperline and sizeimage fields. And I think the
>priv field
>should also go, just have a reserved[2] instead.
>

By mean "planes" you mean a field indicating the number of planes in the
current format, right?
Number of planes can be inferred from fourcc, but you are right, it's still
useful to have to have a field for that.

What do you think of this:

/**
 * struct v4l2_pix_format_mplane - multiplanar format definition
 * @width:		image width in pixels
 * @height:		image height in pixels
 * @pixelformat:	little endian four character code (fourcc)
 * @field:		field order (for interlaced video)
 * @colorspace:		supplemental to pixelformat
 * @plane_fmt:		per-plane information
 * @num_planes:		number of planes for this format and number of valid
 * 			elements in plane_fmt array
 */
struct v4l2_pix_format_mplane {
	__u32				width;
	__u32				height;
	__u32				pixelformat;
	enum v4l2_field			field;
	enum v4l2_colorspace		colorspace;

	struct v4l2_plane_format	plane_fmt[VIDEO_MAX_PLANES];
	__u8				num_planes;
	__u8				reserved[11];
} __attribute__ ((packed));

v4l2_plane_format stays the same (see below).

8 * struct v4l2_plane_format + 3 * 4 + 2 * enum + 12 * 1 = 8 * 20 + 40 = 200


>> The plane format struct is as follows:
>>
>> +/**
>> + * struct v4l2_plane_format - additional, per-plane format definition
>> + * @sizeimage:         maximum size in bytes required for data, for which
>> + *                     this plane will be used
>> + * @bytesperline:      distance in bytes between the leftmost pixels in
>two
>> + *                     adjacent lines
>> + */
>> +struct v4l2_plane_format {
>> +       __u32           sizeimage;
>> +       __u16           bytesperline;
>> +       __u16           reserved[7];
>> +} __attribute__ ((packed));
>>
>> Note that bytesperline is u16 now, but that shouldn't hurt.
>>
>>
>> Fitting everything into v4l2_format's union (which is 200 bytes long):
>> v4l2_pix_format shouldn't be larger than 40 bytes.
>> 8 * struct v4l2_plane_format + struct v4l2_pix_format = 8 * 20 + 40 = 200
>>

(snip)

>> 2. Plane description struct
>> ----------------------------------
>>
>> +/**
>> + * struct v4l2_plane - plane info for multiplanar buffers
>> + * @bytesused: number of bytes occupied by data in the plane (payload)
>> + * @mem_off:   when memory in the associated struct v4l2_buffer is
>> + *             V4L2_MEMORY_MMAP, equals the offset from the start of the
>> + *             device memory for this plane (or is a "cookie" that should
>be
>> + *             passed to mmap() called on the video node)
>> + * @userptr:   when memory is V4L2_MEMORY_USERPTR, a userspace pointer
>pointing
>> + *             to this plane
>> + * @length:    size of this plane (NOT the payload) in bytes
>> + * @data_off:  offset in plane to the start of data/end of header, if
>relevant
>> + *
>> + * Multi-plane buffers consist of two or more planes, e.g. an YCbCr buffer
>> + * with two planes has one plane for Y, and another for interleaved CbCr
>> + * components. Each plane can reside in a separate memory buffer, or in
>> + * a completely separate memory chip even (e.g. in embedded devices).
>> + */
>> +struct v4l2_plane {
>> +       __u32                   bytesused;
>> +       __u32                   length;
>> +       union {
>> +               __u32           mem_off;
>
>Rename to mem_offset. This prevents confusion since 'off' can also be
>interpreted as the opposite of 'on'.
>
>> +               unsigned long   userptr;
>> +       } m;
>> +       __u32                   data_off;
>
>Rename to data_offset.
>

Ok to both.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





