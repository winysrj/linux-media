Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56493
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753366AbdDJSN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 14:13:56 -0400
Date: Mon, 10 Apr 2017 15:13:45 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: [PATCH v3 1/8] v4l: Add metadata buffer type and format
Message-ID: <20170410151345.5744cbb6@vento.lan>
In-Reply-To: <9012f4cc-f13f-b3b2-3599-c4f693acf70c@xs4all.nl>
References: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170228155648.12051-2-laurent.pinchart+renesas@ideasonboard.com>
        <20170410142355.196d4eb4@vento.lan>
        <9012f4cc-f13f-b3b2-3599-c4f693acf70c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Apr 2017 19:58:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/10/2017 07:23 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 28 Feb 2017 17:56:41 +0200
> > Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
> >   
> >> The metadata buffer type is used to transfer metadata between userspace
> >> and kernelspace through a V4L2 buffers queue. It comes with a new
> >> metadata capture capability and format description.
> >>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >> Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  Documentation/media/uapi/v4l/buffer.rst          |  3 ++
> >>  Documentation/media/uapi/v4l/dev-meta.rst        | 62 ++++++++++++++++++++++++
> >>  Documentation/media/uapi/v4l/devices.rst         |  1 +
> >>  Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 ++
> >>  Documentation/media/videodev2.h.rst.exceptions   |  2 +
> >>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    | 19 ++++++++
> >>  drivers/media/v4l2-core/v4l2-dev.c               | 16 +++---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c             | 34 +++++++++++++
> >>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  3 ++
> >>  include/media/v4l2-ioctl.h                       | 17 +++++++
> >>  include/trace/events/v4l2.h                      |  1 +
> >>  include/uapi/linux/videodev2.h                   | 13 +++++
> >>  12 files changed, 168 insertions(+), 6 deletions(-)
> >>  create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
> >>
> >> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> >> index 5c58db98ab7a..02834ce7fa4d 100644
> >> --- a/Documentation/media/uapi/v4l/buffer.rst
> >> +++ b/Documentation/media/uapi/v4l/buffer.rst
> >> @@ -418,6 +418,9 @@ enum v4l2_buf_type
> >>        - 12
> >>        - Buffer for Software Defined Radio (SDR) output stream, see
> >>  	:ref:`sdr`.
> >> +    * - ``V4L2_BUF_TYPE_META_CAPTURE``
> >> +      - 13
> >> +      - Buffer for metadata capture, see :ref:`metadata`.
> >>  
> >>  
> >>  
> >> diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
> >> new file mode 100644
> >> index 000000000000..b6044c54082a
> >> --- /dev/null
> >> +++ b/Documentation/media/uapi/v4l/dev-meta.rst
> >> @@ -0,0 +1,62 @@
> >> +.. -*- coding: utf-8; mode: rst -*-
> >> +
> >> +.. _metadata:
> >> +
> >> +******************
> >> +Metadata Interface
> >> +******************
> >> +
> >> +Metadata refers to any non-image data that supplements video frames with
> >> +additional information. This may include statistics computed over the image
> >> +or frame capture parameters supplied by the image source. This interface is
> >> +intended for transfer of metadata to userspace and control of that operation.
> >> +
> >> +The metadata interface is implemented on video capture device nodes. The device
> >> +can be dedicated to metadata or can implement both video and metadata capture
> >> +as specified in its reported capabilities.
> >> +
> >> +.. note::
> >> +
> >> +    This is an :ref:`experimental` interface and may
> >> +    change in the future.  
> > 
> > While I'm ok with this comment, in practice, this comment is bogus. Once we
> > merge it, it is unlikely that we'll be able to change it.
> > 
> > That would just add a task on our TODO list that we'll need to remove this
> > comment some day.  
> 
> I'll remove this. These notes were all removed some time ago. This patch was most
> likely made when these notes were still in use.
> 
> >   
> >> +
> >> +Querying Capabilities
> >> +=====================
> >> +
> >> +Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
> >> +flag in the ``device_caps`` field of the
> >> +:c:type:`v4l2_capability` structure returned by the :c:func:`VIDIOC_QUERYCAP`
> >> +ioctl. That flag means the device can capture metadata to memory.
> >> +
> >> +At least one of the read/write or streaming I/O methods must be supported.
> >> +
> >> +
> >> +Data Format Negotiation
> >> +=======================
> >> +
> >> +The metadata device uses the :ref:`format` ioctls to select the capture format.
> >> +The metadata buffer content format is bound to that selected format. In addition
> >> +to the basic :ref:`format` ioctls, the :c:func:`VIDIOC_ENUM_FMT` ioctl must be
> >> +supported as well.
> >> +
> >> +To use the :ref:`format` ioctls applications set the ``type`` field of the
> >> +:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` and use the
> >> +:c:type:`v4l2_meta_format` ``meta`` member of the ``fmt`` union as needed per
> >> +the desired operation. Both drivers and applications must set the remainder of
> >> +the :c:type:`v4l2_format` structure to 0.
> >> +
> >> +.. _v4l2-meta-format:  
> > 
> > Better to add an space after the label. My experience with random versions
> > of Sphinx is that it doesn't like to have different types of paragraph
> > without at least one blank line between them.  
> 
> You mean 'Better to add a newline after the label'? It's a bit confusing.

Yes, that's what I meant.

> 
> Regards,
> 
> 	Hans



Thanks,
Mauro
