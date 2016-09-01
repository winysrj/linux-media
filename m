Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51708 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbcIAVkY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 17:40:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/4] v4l: Add metadata buffer type and format
Date: Fri, 02 Sep 2016 00:40:18 +0300
Message-ID: <6187282.rGRMgY1WYC@avalon>
In-Reply-To: <2431560.80mbed248J@avalon>
References: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160829091339.GN12130@valkosipuli.retiisi.org.uk> <2431560.80mbed248J@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 02 Sep 2016 00:22:42 Laurent Pinchart wrote:
> On Monday 29 Aug 2016 12:13:40 Sakari Ailus wrote:
> > On Wed, Aug 17, 2016 at 03:20:27PM +0300, Laurent Pinchart wrote:
> >> The metadata buffer type is used to transfer metadata between userspace
> >> and kernelspace through a V4L2 buffers queue. It comes with a new
> >> metadata capture capability and format description.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> >> Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> Changes since v1:
> >> 
> >> - Rebased on top of the DocBook to reST conversion
> >> 
> >>  Documentation/media/uapi/v4l/buffer.rst          |  8 +++
> >>  Documentation/media/uapi/v4l/dev-meta.rst        | 69 +++++++++++++++++
> >>  Documentation/media/uapi/v4l/devices.rst         |  1 +
> >>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 14 +++--
> >>  Documentation/media/videodev2.h.rst.exceptions   |  2 +
> >>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    | 19 +++++++
> >>  drivers/media/v4l2-core/v4l2-dev.c               | 16 +++---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c             | 41 ++++++++++++++
> >>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  3 ++
> >>  include/media/v4l2-ioctl.h                       | 17 ++++++
> >>  include/uapi/linux/videodev2.h                   | 14 +++++
> >>  11 files changed, 195 insertions(+), 9 deletions(-)
> >>  create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
> 
> [snip]
> 
> >> diff --git a/Documentation/media/uapi/v4l/dev-meta.rst
> >> b/Documentation/media/uapi/v4l/dev-meta.rst new file mode 100644
> >> index 000000000000..252ed05b4841
> >> --- /dev/null
> >> +++ b/Documentation/media/uapi/v4l/dev-meta.rst
> >> @@ -0,0 +1,69 @@
> >> +.. -*- coding: utf-8; mode: rst -*-
> >> +
> >> +.. _metadata:
> >> +
> >> +******************
> >> +Metadata Interface
> >> +******************
> >> +
> >> +Metadata refers to any non-image data that supplements video frames
> >> with
> >> +additional information. This may include statistics computed over the
> >> image +or frame capture parameters supplied by the image source. This
> >> interface is +intended for transfer of metadata to userspace and control
> >> of that operation. +
> >> +The metadata interface is implemented on video capture device nodes.
> >> The
> >> device +can be dedicated to metadata or can implement both video and
> >> metadata capture +as specified in its reported capabilities.
> >> +
> >> +.. note::
> >> +
> >> +    This is an :ref:`experimental` interface and may
> >> +    change in the future.
> >> +
> >> +Querying Capabilities
> >> +=====================
> >> +
> >> +Device nodes supporting the metadata interface set the
> >> ``V4L2_CAP_META_CAPTURE`` +flag in the ``device_caps`` field of the
> >> +:ref:`v4l2_capability <v4l2-capability>` structure returned by the
> >> +:ref:`VIDIOC_QUERYCAP` ioctl. That flag means the device can capture
> >> +metadata to memory.
> >> +
> >> +At least one of the read/write or streaming I/O methods must be
> >> supported.
> >> +
> >> +
> >> +Data Format Negotiation
> >> +=======================
> >> +
> >> +The metadata device uses the :ref:`format` ioctls to select the capture
> >> format. +The metadata buffer content format is bound to that selected
> >> format. In addition +to the basic :ref:`format` ioctls, the
> >> 
> >> :ref:`VIDIOC_ENUM_FMT` ioctl must be +supported as well.
> >> 
> >> +
> >> +To use the :ref:`format` ioctls applications set the ``type`` of the
> >> +:ref:`v4l2_format <v4l2-format>` structure to
> >> ``V4L2_BUF_TYPE_META_CAPTURE`` +and use the :ref:`v4l2_meta_format
> >> <v4l2-meta-format>` ``meta`` member of the +``fmt`` union as needed per
> >> the desired operation. The :ref:`v4l2-meta-format` +structure contains
> >> two fields, ``dataformat`` is set by applications to the V4L2
> > 
> > I might not specify the number of number of fields here. It has high
> > chances of not getting updated when more fields are added. Up to you.
> 
> This has been copied from dev-sdr.rst. I can drop the last sentence
> completely as the parameters are described in the table below. Hans, any
> opinion ?

How about this ?

To use the :ref:`format` ioctls applications set the ``type`` of the
:ref:`v4l2_format <v4l2-format>` structure to ``V4L2_BUF_TYPE_META_CAPTURE``
and use the :ref:`v4l2_meta_format <v4l2-meta-format>` ``meta`` member of the
``fmt`` union as needed per the desired operation. Both drivers and 
applications must set the remainder of the :ref:`v4l2_format <v4l2-format>` 
structure to 0.

> >> +FourCC code of the desired format, and ``buffersize`` set by drivers to
> >> the
> >> +maximum buffer size (in bytes) required for data transfer.
> >> +
> >> +.. _v4l2-meta-format:
> >> +.. flat-table:: struct v4l2_meta_format
> >> +    :header-rows:  0
> >> +    :stub-columns: 0
> >> +    :widths:       1 1 2
> >> +
> >> +    * - __u32
> >> +      - ``dataformat``
> >> +      - The data format, set by the application. This is a little
> >> endian
> >> +        :ref:`four character code <v4l2-fourcc>`. V4L2 defines metadata
> >> formats
> >> +        in :ref:`meta-formats`.
> >> +    * - __u32
> >> +      - ``buffersize``
> >> +      - Maximum buffer size in bytes required for data. The value is
> >> set by the
> >> +        driver.
> > 
> > We'll need to add width and heigth as well but it could be done later on.
> 
> Unless you have a use case you can upstream now for those fields we'll have
> to add them later.
> 
> >> +    * - __u8
> >> +      - ``reserved[24]``
> >> +      - This array is reserved for future extensions. Drivers and
> >> applications
> >> +        must set it to zero.
> > 
> > struct v4l2_pix_format has grown without use of reserved fields and it's
> > been around for ages.
> > 
> > It's not directly used in an IOCTL but within an union in another struct
> > so this is possible. I would consider doing the same here. Or at least
> > increasing the number of reserved fields (and possibly making the type
> > u32) if you feel we shouldn't go that way.
> 
> I'm fine with dropping the reserved fields.

-- 
Regards,

Laurent Pinchart

