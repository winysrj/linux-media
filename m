Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42405 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2BZQdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 11:33:31 -0500
Received: by eekc41 with SMTP id c41so402893eek.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 08:33:29 -0800 (PST)
Message-ID: <4F4A5ED0.4060204@gmail.com>
Date: Sun, 26 Feb 2012 17:33:20 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com,
	g.liakhovetski@gmx.de, dacohen@gmail.com
Subject: Re: [RFC] Frame format descriptors
References: <20120225034915.GH12602@valkosipuli.localdomain>
In-Reply-To: <20120225034915.GH12602@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thank you for the RFC. Nice work!

On 02/25/2012 04:49 AM, Sakari Ailus wrote:
> Hi all,
> 
> We've been talking some time about frame format desciptors. I don't mean just
> image data --- there can be metadata and image data which cannot be
> currently described using struct v4l2_mbus_framefmt, such as JPEG images and
> snapshots. I thought it was about the time to write an RFC.
> 
> I think we should have additional ways to describe the frame format, a part
> of thee frame is already described by struct v4l2_mbus_framefmt which only
> describes image data.
> 
> 
> Background
> ==========
> 
> I want to first begin by listing known use cases. There are a number of
> variations of these use cases that would be nice to be supported. It depends
> not only on the sensor but also on the receiver driver i.e. how it is able
> to handle the data it receives.
> 
> 1. Sensor metadata. Sensors produce interesting kinds of metadata. Typically
> the metadata format is very hardware specific. It is known the metadata can
> consist e.g. register values or floating point numbers describing sensor
> state. The metadata may have certain length or it can span a few lines at
> the beginning or the end of the frame, or both.
> 
> 2. JPEG images. JPEG images are produced by some sensors either separately
> or combined with the regular image data frame.
> 
> 3. Interleaved YUV and JPEG data. Separating the two may only done in
> software, so the driver has no option but to consider both as blobs.
> 
> 4. Regular image data frames. Described by struct v4l2_mbus_framefmt.
> 
> 5. Multi-format images. See the end of the messagefor more information.
> 
> Some busses such as the CSI-2 are able to transport some of this on separate
> channels. This provides logical separation of different parts of the frame
> while still sharing the same physical bus. Some sensors are known to send

AFAICS data on separate channels are mostly considered as separate streams,
like JPEG, MPEG or audio. Probably more often parts of same stream are
just carried with different Data Type, or not even that.

> the metadata on the same channel as the regular image data frame.
> 
> I currently don't know of cases where the frame format could be
> significantly changed, with the exception that the sensor may either produce
> YUV, JPEG or both of the two. Changing the frame format is best done by
> other means than referring to the frame format itself: there hardly is
> reason to inform the user about the frame format, at least currently.

Not quite so. User space is usually interested where each data can be found 
in memory. Either we provide this information through a fourcc or in some 
other ways. Snapshot in V4L2 is currently virtually not supported. 
For instance, consider a use case where camera produces a data frame which 
consists of JPEG compressed frame with 3000 x 2000 pixel resolution and 
320x240 pixels YUYV frame. JPEG data is padded so the YUYV data starts at 
a specific offset within the container frame, known to the sensor. 
Something like:

+---------------------+
|                     |
|                     |
|  JPEG  3000 x 2000  |
|                     |
|                     |
+~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~+
| JPEG buffer padding |
|                     |
+---------------------+ YUYV data offset
|                     |
|  YUYV 320 x 240     |
|                     |
+---------------------+ Thumbnail data offset
|                     |
|YUV or JPEG thumbnail|
|     96 x 72         |
+---------------------+

There is additionally a third plane there, that contains the thumbnail image 
data.

So user space wants to know all the offsets and sizes in order to interpret 
what's in a v4l2 buffer.

This information could be provided to user space in several ways, using:

- controls,
- private ioctl at sensor subdev,
- additional v4l2 buffer plane containing all required data with some
  pre-defined layout,
- ... 


> Most of the time it's possible to use the hardware to separate the different
> parts of the buffer e.g. into separate memory areas or into separate planes
> of a multi-plane buffer, but not quite always (the case we don't care
> about).

I'm wondering, if there is any sensor/bridge pair in mainline that is capable
of storing data into separate memory regions ?

> This leads me to think we need two relatively independent things: to describe
> frame format and provide ways to provide the non-image part of the frame to
> user space.
> 
> 
> Frame format descriptor
> =======================
> 
> The frame format descriptor describes the layout of the frame, not only the
> image data but also other parts of it. What struct v4l2_mbus_framefmt
> describes is part of it. Changes to v4l2_mbus_framefmt affect the frame
> format descriptor rather than the other way around.
> 
> enum {
> 	V4L2_SUBDEV_FRAME_FORMAT_TYPE_CSI2,
> 	V4L2_SUBDEV_FRAME_FORMAT_TYPE_CCP2,
> 	V4L2_SUBDEV_FRAME_FORMAT_TYPE_PARALLEL,
> };
> 
> struct v4l2_subdev_frame_format {
> 	int type;
> 	struct v4l2_subdev_frame_format_entry *ent[];
> 	int nent;
> };
> 
> #define V4L2_SUBDEV_FRAME_FORMAT_ENTRY_FLAG_BLOB	(1<<  0)
> #define V4L2_SUBDEV_FRAME_FORMAT_ENTRY_FLAG_LEN_IS_MAX	(1<<  1)

I'm just wondering whether flags indicating explicitly if the format entry 
corresponds to frame header/footer are needed, e.g. 

#define V4L2_SUBDEV_FRAMEFMT_ENTRY_FL_HEADER	(1 << 2)
#define V4L2_SUBDEV_FRAMEFMT_ENTRY_FL_FOOTER	(1 << 3)

> struct v4l2_subdev_frame_format_entry {
> 	u8 bpp;
> 	u16 flags;
> 	u32 pixelcode;
> 	union {
> 		struct {
> 			u16 width;
> 			u16 height;
> 		};
> 		u32 length; /* if BLOB flag is set */
> 	};

I would prefer to not use a union for these. It would be nice to ensure 
the subdevs are able to expose pixel resolution _and_ the data frame length.

Additionally it would be quite essential to contain the entry offset in here. 

> 	union {
> 		struct v4l2_subdev_frame_format_entry_csi2 csi2;
> 		struct v4l2_subdev_frame_format_entry_ccp2 ccp2;
> 		struct v4l2_subdev_frame_format_entry_parallel par;
> 	};
> };
> 
> struct v4l2_subdev_frame_format_entry_csi2 {
> 	u8 channel;

Didn't you consider adding the Data Type field here for User Defined data 
formats ? Data multiplexing on physical CSI2 bus may be done with different 
channels, different data types, or both.

> };
> 
> struct v4l2_subdev_frame_format_entry_ccp2 {
> };
> 
> struct v4l2_subdev_frame_format_entry_parallel {
> };
> 
> The frame format is defined by the sensor, and the sensor provides a subdev
> pad op to obtain the frame format. This op is used by the csi-2 receiver
> driver.
> 
> 
> Non-image data (metadata or other blobs)
> ========================================
> 
> There are several ways to pass non-image data to user space. Often the
> receiver is able to write the metadata to a different memory location than
> the image data whereas sometimes the receiver isn't able to separate the
> two. Separating the two has one important benefit: the metadata is available
> for the user space automatic exposure algorithm as soon as it has been
> written to system memory. We have two cases:
> 
> 1. Metadata part of the same buffer (receiver unable to separate the two).
> The receiver uses multi-plane buffer type. Multi-plane buffer's each plane
> should have independent pixelcode field: the sensor metadata formats are
> highly sensor dependent whereas the image formats are not.

I guess we could try and add a pixelcode field to struct v4l2_pix_format_mplane
and a special "pixelformat" value that would indicate that per-plane pixelcodes 
should be used.

> 2. Non-videodata arrives through a separate buffer queue (and thus also
> video node). The user may activate the link to second video node to activate
> metadata capture.
>
> Then, how does the user decide which one to choose when the sensor driver
> would be able to separate the two but the user might not want that? The user

Things like these are normally done by setting required data format on video 
nodes, aren't they ?

And wouldn't link activation/deactivation be enough for the metadata part ?
Some links/video nodes might just remain unused.

> might also want to just not capture the metadata in the first place, even if
> the sensor produced it.

Perhaps, just properly interpreting VIDIOC_STREAMOFF/STREAMON on such video
node would do ?

> The same decision also affects the number of links from the receiver to
> video nodes, as well as the number of video nodes: the media graph would
> have to be dynamic rather than static. Dynamic graphs are not supported
> currently either.
> 
> 
> Multi-format image frames
> =========================
> 
> This is actually another use case. I separated the further description from
> the others since this topic could warrant an RFC on its own.
> 
> Some sensors are able to produce snapshots (downscaled versions of the same
> frames) when capturing still photos. This kind of sensors are typically used
> in conjunction with simple receivers without ISP.
> 
> How to control this feeature? The link between the sensor and the receiver
> models both the physical connection and the properties of the images
> produced at one end and consumed in the other.
> 
> With the above proposal, the snapshots could be provided to user space as
> blobs, with sensor drivers providing private ioctl or two to control the
> feature. How many such sensors do we currently have and how uniformly is the
> snapshot feature implemented in them?

There is one sensor I know of that produces downscaled version of still image
in RAW (YUV) format - M-5MOLS. It's is called a post-view image. And this 
feature is not supported currently in mainline. I expect one more sensor like
that one in near future. Most likely ISPs inside Application Processors that
run their own firmware will support something similar.

> 
> Questions and comments are the most welcome.

--

Regards,
Sylwester
