Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57125 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753004Ab3JUJmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 05:42:00 -0400
Date: Mon, 21 Oct 2013 12:41:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: sylwester.nawrocki@gmail.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [RFC] Multi format stream support
Message-ID: <20131021094156.GB18946@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,


(Resending; this time with linux-media included.)

I wanted to amend my frame format descriptor RFC support by a proposal for
supporting multiple independent data flows implemented by a single DMA
engine.

The frame format descriptors RFC v2 can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg67295.html>


The use cases are largely the same as for the frame descriptors: the frame
format descriptors do not answer to how the added data flows can be captured
in the user space. That's what this RFC is about.

Essentially we're talking about a single stream from a sensor that contains
multiple, independent kinds of data. In some cases (and I believe in future
increasingly so) the hardware can operate multiple buffer queues so the user
space will see multiple independent streams.


An example of a frame which contains metadata, the image data and again
metadata:

	- start of frame ---------------------------
	| line 0 (metadata)                        |
	| line 1 (metadata)                        |
	--------------------------------------------
	| line 0 (pixel data)                      |
	| line 1 (pixel data)                      |
	| ...                                      |
	| line n (pixel data)                      |
	--------------------------------------------
	| line 0 (metadata)                        |
	| line 1 (metadata)                        |
	- end of frame -----------------------------

Sometimes the bus protocol or the receiver can separate the three, sometimes
not. How the separation is done is more relevant in the context of the frame
format descriptors RFC.

Whereas the case for the frame format descriptors is relatively
straighforward, there are a few different approaches how to support them on
video nodes: multi-plane buffers and multiple video buffer queues. Both
would need extending to support multiple frame format capturing: multi-plane
buffers have a single format whilst there's exactly a single video buffer
queue per video node of any given type.


Multi-plane buffers as multi-format buffers
===========================================

The support for multi-plane buffers is provided essentially in the form
of the two structs:

struct v4l2_plane_pix_format {
	__u32		sizeimage;
	__u16		bytesperline;
	__u16		reserved[7];
} __attribute__ ((packed));

struct v4l2_pix_format_mplane {
	__u32                           width;
	__u32                           height;
	__u32                           pixelformat;
	__u32                           field;
	__u32                           colorspace;

	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
	__u8                            num_planes;
	__u8                            reserved[11];
} __attribute__ ((packed));

Now, this looks ideal for supporting multiple formats for a single video
buffer queue. Extending the concept of the multi-plane pixel format from
a single image to span multiple independent images seems like the way to
go, until you look at how many reserved fields there are left.

Seven 16-bit fields are hardly enough describing pixel format, width and
height and presumably there will be additional fields on top of those.

Extending the multi-plane buffers (in a nice way) has other issues,
independently of how the issue of free reserved space for additional fields:
multi-plane buffers with independent formats vs. real multi-plane formats:

* A way would need to be provided to different planes of the same image from
distinct images.

* Width, height, pixelformat, field and colorspace fields would no
longer be valid in struct v4l2_pix_format_mplane, as they'd be part of
the plane specific information (struct v4l2_plane_pix_format).

* Stacking multiple images onto a single multi-format buffer forces the
user to capture all images even (s)he'd be just interested in a single
one of them. E.g. four buffers could be relevant for video recording but
just one might be needed for capturing images while recording video from a
sensor that can provide both (small resolution YUV and a large resolution
JPEG).

* No backwards compatibility if new data structures and IOCTLs are needed.
Forward compatibility (for existing drivers) is possible in a similar
fashion than for the multi-planar API.

* Some buffers will finish earlier than others. In some cases it is
important to be able to pass this data to the user space as fast as
possible. Events could be used for this but that can be seen as a hack since
they work around the buffer queues.

/**
 * @queue_index: The index of the video buffer queue, specific to the queue
 * 		 type. Read-only for the user. Matches with the number of
 *               the frame descriptor entry.
 */
struct v4l2_multi_pix_format {
	__u32			sizeimage;
	__u32			bytesperline;
	__u32			width;
	__u32			height;
	__u32			pixelformat;
	__u32			field;
	__u32			colorspace;
	__u32			queue_index;
	__u32			flags;
};

/* Part of a multi-plane format */
#define V4L2_MULTI_PIX_FORMAT_FL_CONT	(1 << 0)

struct v4l2_pix_format_multi {
	struct v4l2_multi_pix_format	*mfmt[VIDEO_MAX_PLANES];
	__u8                            nr_of_mfmts;
};


Multiple buffer queues
======================

The other option to support multiple formats on a single DMA engine is
through multiple buffer queues. To choose the appropriate buffer queue, a
new integer field needs to be added to the argument structs of each format
and buffer queue related IOCTL:

	v4l2_format

		No reserved fields. 8 bytes can be pinched from fmt since
		there are 8 bytes unused (or only use by the raw field). The
		size of struct v4l2_pix_format_mplane is 192 bytes.

	v4l2_buffer
	v4l2_fmtdesc
	v4l2_requestbuffers
	v4l2_exportbuffer
	v4l2_create_buffers
	
		Reserved fields exist.

Additionally, a new IOCTL is needed to enumerate the multiple outputs
available. For backward compatibility the main image must always have index
zero.

Multiple buffer queues have the benefit that each buffer queue is
essentially independent of each other. The user has the freedom of choosing
the number of buffers in the queue: the life cycles of the buffers in the
user space may well be different, and thus different number of buffers may
be required for each queue.


Splitting the buffer queue type field
-------------------------------------

Instead of adding a new field for the multi format buffer queue, the 32-bit
buffer queue type field could be split into two 16-bit fields. 16 bits is
plenty for both. For instance,

struct v4l2_buffer {
	__u16	queue_index;
	__u16	type;
	...
};

Endianness handling is something to consider --- __LITTLE_ENDIAN /
__BIG_ENDIAN can be used to determine the order of the above fields.

Also, and perhaps more importantly, programs that used to set queue type and
not zero the struct would suffer if recompiled without changes. One option
to counter that could be recognising programs that are aware of multi format
support: they're the ones that enumerate the multiple queue formats.


Metadata buffer queue type
==========================

A less intrusive but also not generic option would be to provide a new
buffer queue type for metadata. While this matches well with the existing
interfaces, it has its shortcomings that make it by far less useful:

* Only a single metadata plane available, multiple metadata areas are not
possible.

* Multiple images will not be possible. Naturally it would be possible to
provide more buffer types for additional images but this definitely looks
like a hack.


Open questions
==============

Should visibility to other planes than the main image one be full in the
user space interface or not? Most use cases for the multi format support are
related to non-image data such as metadata but also image data is possible.

If the answer is "yes", then similar changes would be needed to the V4L2
sub-device interface as well (on top of the frame format descriptors RFC).
It's technically easier on that side since the IOCTL argument structs have
plenty of reserved fields.

The question can indeed be left for later: should this be implemented, a set
of IOCTLs becomes usable for other than main image format as well.


-- 
Best regards,

Sakari Ailus
sakari.ailus@iki.fi
