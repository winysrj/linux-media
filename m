Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40796 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2BYDtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 22:49:20 -0500
Date: Sat, 25 Feb 2012 05:49:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: snjw23@gmail.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com,
	g.liakhovetski@gmx.de, dacohen@gmail.com
Subject: [RFC] Frame format descriptors
Message-ID: <20120225034915.GH12602@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We've been talking some time about frame format desciptors. I don't mean just
image data --- there can be metadata and image data which cannot be
currently described using struct v4l2_mbus_framefmt, such as JPEG images and
snapshots. I thought it was about the time to write an RFC.

I think we should have additional ways to describe the frame format, a part
of thee frame is already described by struct v4l2_mbus_framefmt which only
describes image data.


Background
==========

I want to first begin by listing known use cases. There are a number of
variations of these use cases that would be nice to be supported. It depends
not only on the sensor but also on the receiver driver i.e. how it is able
to handle the data it receives.

1. Sensor metadata. Sensors produce interesting kinds of metadata. Typically
the metadata format is very hardware specific. It is known the metadata can
consist e.g. register values or floating point numbers describing sensor
state. The metadata may have certain length or it can span a few lines at
the beginning or the end of the frame, or both.

2. JPEG images. JPEG images are produced by some sensors either separately
or combined with the regular image data frame.

3. Interleaved YUV and JPEG data. Separating the two may only done in
software, so the driver has no option but to consider both as blobs.

4. Regular image data frames. Described by struct v4l2_mbus_framefmt.

5. Multi-format images. See the end of the messagefor more information.

Some busses such as the CSI-2 are able to transport some of this on separate
channels. This provides logical separation of different parts of the frame
while still sharing the same physical bus. Some sensors are known to send
the metadata on the same channel as the regular image data frame.

I currently don't know of cases where the frame format could be
significantly changed, with the exception that the sensor may either produce
YUV, JPEG or both of the two. Changing the frame format is best done by
other means than referring to the frame format itself: there hardly is
reason to inform the user about the frame format, at least currently.

Most of the time it's possible to use the hardware to separate the different
parts of the buffer e.g. into separate memory areas or into separate planes
of a multi-plane buffer, but not quite always (the case we don't care
about).

This leads me to think we need two relatively independent things: to describe
frame format and provide ways to provide the non-image part of the frame to
user space.


Frame format descriptor
=======================

The frame format descriptor describes the layout of the frame, not only the
image data but also other parts of it. What struct v4l2_mbus_framefmt
describes is part of it. Changes to v4l2_mbus_framefmt affect the frame
format descriptor rather than the other way around.

enum {
	V4L2_SUBDEV_FRAME_FORMAT_TYPE_CSI2,
	V4L2_SUBDEV_FRAME_FORMAT_TYPE_CCP2,
	V4L2_SUBDEV_FRAME_FORMAT_TYPE_PARALLEL,
};

struct v4l2_subdev_frame_format {
	int type;
	struct v4l2_subdev_frame_format_entry *ent[];
	int nent;
};

#define V4L2_SUBDEV_FRAME_FORMAT_ENTRY_FLAG_BLOB	(1 << 0)
#define V4L2_SUBDEV_FRAME_FORMAT_ENTRY_FLAG_LEN_IS_MAX	(1 << 1)

struct v4l2_subdev_frame_format_entry {
	u8 bpp;
	u16 flags;
	u32 pixelcode;
	union {
		struct {
			u16 width;
			u16 height;
		};
		u32 length; /* if BLOB flag is set */
	};
	union {
		struct v4l2_subdev_frame_format_entry_csi2 csi2;
		struct v4l2_subdev_frame_format_entry_ccp2 ccp2;
		struct v4l2_subdev_frame_format_entry_parallel par;
	};
};

struct v4l2_subdev_frame_format_entry_csi2 {
	u8 channel;
};

struct v4l2_subdev_frame_format_entry_ccp2 {
};

struct v4l2_subdev_frame_format_entry_parallel {
};

The frame format is defined by the sensor, and the sensor provides a subdev
pad op to obtain the frame format. This op is used by the csi-2 receiver
driver.


Non-image data (metadata or other blobs)
========================================

There are several ways to pass non-image data to user space. Often the
receiver is able to write the metadata to a different memory location than
the image data whereas sometimes the receiver isn't able to separate the
two. Separating the two has one important benefit: the metadata is available
for the user space automatic exposure algorithm as soon as it has been
written to system memory. We have two cases:

1. Metadata part of the same buffer (receiver unable to separate the two).
The receiver uses multi-plane buffer type. Multi-plane buffer's each plane
should have independent pixelcode field: the sensor metadata formats are
highly sensor dependent whereas the image formats are not.

2. Non-videodata arrives through a separate buffer queue (and thus also
video node). The user may activate the link to second video node to activate
metadata capture.

Then, how does the user decide which one to choose when the sensor driver
would be able to separate the two but the user might not want that? The user
might also want to just not capture the metadata in the first place, even if
the sensor produced it.

The same decision also affects the number of links from the receiver to
video nodes, as well as the number of video nodes: the media graph would
have to be dynamic rather than static. Dynamic graphs are not supported
currently either.


Multi-format image frames
=========================

This is actually another use case. I separated the further description from
the others since this topic could warrant an RFC on its own.

Some sensors are able to produce snapshots (downscaled versions of the same
frames) when capturing still photos. This kind of sensors are typically used
in conjunction with simple receivers without ISP.

How to control this feeature? The link between the sensor and the receiver
models both the physical connection and the properties of the images
produced at one end and consumed in the other.

With the above proposal, the snapshots could be provided to user space as
blobs, with sensor drivers providing private ioctl or two to control the
feature. How many such sensors do we currently have and how uniformly is the
snapshot feature implemented in them?


Questions and comments are the most welcome.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
