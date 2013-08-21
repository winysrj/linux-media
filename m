Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55080 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557Ab3HUOjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 10:39:49 -0400
Date: Wed, 21 Aug 2013 17:39:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	thomas.vajzovic@irisys.co.uk
Subject: [RFC v2] Frame format descriptors
Message-ID: <20130821143944.GG20717@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an update to the original Frame format descriptors RFC I posted 
back in February last year:

<URL:http://www.spinics.net/lists/linux-media/msg44629.html>

Since that limited frame format descriptor support has been added to
mainline, supporting a subset of potential use cases:

<URL:http://www.spinics.net/lists/linux-media/msg53790.html>

I believe that such a simple get/set-type type interface isn't generic 
enough for manipulating frame descriptors; a more expressive interface 
is required. This RFC does not address does not address setting frame 
descriptors: most devices still do not allow changing the frame 
descriptor and the behaviour of the get operation should not be 
dependent on how the descriptor is constructed.


Background
==========

I want to first begin by listing known use cases. There are a number of
variations of these use cases that would be nice to be supported. It 
depends not only on the sensor but also on the receiver driver i.e. how 
it is able to handle the data it receives.

1. Sensor metadata. Sensors produce interesting kinds of metadata. 
Typically the metadata format is very hardware specific. It is known the 
metadata can consist e.g. register values or floating point numbers 
describing sensor state. The metadata may have certain length or it can 
span a few lines at the beginning or the end of the frame, or both.

2. JPEG images or other compressed data. JPEG images are produced by 
some sensors either separately or combined with the regular image data 
frame. The data type is always octets for these formats.

2.1. Compressed image with defined width and height for the benefit of
receivers that do not support variable size (or JPEG) images.

3. Interleaved YUV and JPEG data. Separating the two may only done in
software, so the driver has no option but to consider both as blobs.

4. Regular image data frames. Described by struct v4l2_mbus_framefmt
already.

5. Multi-format images. See the end of the message for more information.

Some busses such as the CSI-2 are able to transport some of this on 
separate channels. This provides logical separation of different parts 
of the frame while still sharing the same physical bus. However most 
sensors are known to send the metadata on the same channel as the 
regular image data frame; this could be related to limitations on some 
CSI-2 receiver implementations.

It should be thus not assumed that even if a given bus provides logical 
separation between different parts of the image that feature was 
actually used: instead, the width and height fields are to be used for 
this purpose: the entries are in the structure in the same order as sent 
by the sensor. There must be no overlap or redundancy in the descriptors.

The frame descriptor may change as a result of an action performed by 
the user, such as changing the pad format from the user space. The frame 
format must be thus queried from the transmitting device before starting 
streamin. Changing frame descriptor while streaming is not allowed.

This leads me to think we need two relatively independent things: to 
describe frame format and provide ways to provide the non-image part of 
the frame to user space.

Most of the time it's possible to use the hardware to separate the 
different parts of the buffer e.g. into separate memory areas or into 
separate planes of a multi-plane buffer, but not quite always (the case 
we don't care about).

There are currently two ways to do this: either a separate video node or 
a multi-plane buffer. Neither seems entirely satisfactory: the 
multi-plane buffer is only available to the user space once the last 
part of it is done. On the other hand, separate video nodes cause the 
need to create new video nodes based on what kind of data is produced by 
a sensor, possibly relating to its configuration.


Frame format descriptor
=======================

The frame format descriptor describes the layout of the frame, not only 
the image data but also other parts of it. What struct 
v4l2_mbus_framefmt describes is part of it. Changes to 
v4l2_mbus_framefmt affect the frame format descriptor rather than the 
other way around.

struct v4l2_mbus_frame_desc {
	struct v4l2_mbus_frame_desc_entry \
		entry[V4L2_MBUS_FRAME_DESC_ENTRY_MAX];
	unsigned short num_entries;
};

#define V4L2_MBUS_FRAME_DESC_ENTRY_FLAG_BLOB		(1 << 0)
#define V4L2_MBUS_FRAME_DESC_ENTRY_FLAG_LEN_IS_MAX	(1 << 1)

enum {
	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
};

struct v4l2_mbus_frame_desc_entry {
	u8 bpp;
	u16 flags;
	u32 pixelcode;
	union {
		struct {
			u16 width;
			u16 height;
			u16 start_line;
		};
		u32 length; /* if BLOB flag is set */
	};
	unsigned int type;
	union {
		struct v4l2_mbus_frame_desc_entry_csi2 csi2;
		struct v4l2_mbus_frame_desc_entry_ccp2 ccp2;
		struct v4l2_mbus_frame_desc_entry_parallel par;
	};
};

struct v4l2_mbus_frame_desc_entry_csi2 {
	u8 channel;
};

struct v4l2_mbus_frame_desc_entry_ccp2 {
};

struct v4l2_mbus_frame_desc_entry_parallel {
};

The frame format is defined by the sensor, and the sensor provides a 
subdev pad op to obtain the frame format. This op is used by the csi-2 
receiver driver.

Width and height are the width and height of the actual raw data sent over
the bus. Compressed formats that are transferred as a raw 8-bit image have
width and height that are different from the actual width and height of the
image.


Non-image data (metadata or other blobs)
========================================

There are several ways to pass non-image data to user space. Often the
receiver is able to write the metadata to a different memory location 
than the image data whereas sometimes the receiver isn't able to 
separate the two. Separating the two has one important benefit: the 
metadata is available for the user space automatic exposure algorithm as 
soon as it has been written to system memory. We have two cases:

1. Metadata part of the same buffer (receiver unable to separate the 
two). The receiver uses multi-plane buffer type. Multi-plane buffer's 
each plane should have independent pixelcode field: the sensor metadata 
formats are highly sensor dependent whereas the image formats are not.

2. Non-videodata arrives through a separate buffer queue. The user may
activate the link to second video node to activate metadata capture.
Multiple buffer queues should be supported in this case per video node for
capture, a topic for another RFC.

Then, how does the user decide which one to choose when the sensor 
driver would be able to separate the two but the user might not want 
that? The user might also want to just not capture the metadata in the 
first place, even if the sensor produced it.


Multi-format image frames
=========================

This is actually another use case. I separated the further description 
from the others since this topic could warrant an RFC on its own.

Some sensors are able to produce snapshots (downscaled versions of the 
same frames) when capturing still photos. This kind of sensors are 
typically used in conjunction with simple receivers without ISP.

How to control this feeature? The link between the sensor and the 
receiver models both the physical connection and the properties of the 
images produced at one end and consumed in the other.

One option would be to add one layer of abstraction and provide multiple
v4l2_mbus_framefmt's in user space. It'd also be necessary to provide
enumeration support for them as well as a way to enable and disable them
should the hardware allow it. An alternative idea could be to use multiple
links for the purpose, but that would not match with the idea of a link as
as a physical connection.


Questions and comments are most welcome.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
