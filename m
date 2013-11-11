Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3KKCEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 21:04:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: Pawel Osciak <posciak@chromium.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v1 00/19] UVC 1.5 VP8 support for uvcvideo
Date: Mon, 11 Nov 2013 03:05:08 +0100
Message-ID: <2118858.3GAjxvYvyO@avalon>
In-Reply-To: <CAPueXH7+tU7L2dU_CoLJ5gx3phKRUuRsXWW=ztDNrAZ2TjaSbg@mail.gmail.com>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <CAPueXH7+tU7L2dU_CoLJ5gx3phKRUuRsXWW=ztDNrAZ2TjaSbg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

On Thursday 10 October 2013 11:27:37 Paulo Assis wrote:
> Hi,
> just want t know the current state on this series.
> 
> I'm currently adding h264 stream preview support to guvcview.
> It's already working fine on uvc 1.1 cameras like the BCC950

Great ! Is the code already available ?

> but for uvc 1.5 devices like the c930e it could really use some driver
> support.

I'm nearly done reviewing the patches (although 19/19 is a huge beast that 
will take a bit of time to tame :-)). Getting the code to mainline will still 
need some time, but it seems to be going in the right direction. We'll get 
hardware compression support for UVC 1.5 in the driver one way or another, it 
won't be left to userspace to implement (you will of course have to adapt 
existing applications to use the new features, but it should hopefully not be 
too complex).

> 2013/8/30 Pawel Osciak <posciak@chromium.org>:
> > Hello everyone,
> > 
> > This series adds support for UVC 1.5 and VP8 encoding cameras to the
> > uvcvideo driver. The official specification for the new standard can be
> > found here: http://www.usb.org/developers/devclass_docs.
> > 
> > The main change in 1.5 is support for encoding cameras. Those cameras
> > contain additional UVC entities, called Encoding Units, with their own
> > set of controls governing encode parameters. Typical encoding cameras
> > (see examples in class spec) expose two USB Video Streaming Interfaces
> > (VSIs): one for raw stream formats and one for encoded streams.
> > Typically, both get their source stream from a single sensor, producing
> > raw and encoded versions of the video feed simultaneously.
> > Encoding Units may also support the so-called "simulcast" formats, which
> > allow additional sub-streams, or layers, used to achieve temporal
> > scalability. The spec allows up to 4 simulcast layers. Those layers are
> > encoded in the same format, but encoding parameters, such as resolution,
> > bitrate, etc., may, depending on the camera capabilities, be changed
> > independently for each layer, and their streaming state may also be
> > controlled independently as well. The layers are streamed from the same
> > USB VSI, and the information which layer a frame belongs to is contained
> > in its payload header.
> > 
> > In V4L2 API, a separate video node is created for each VSI: one for raw
> > formats VSI and another for the encoded formats VSI. Both can operate
> > completely independently from each other. In addition, if the Encoding
> > Unit supports simulcast, one V4L2 node is created for each stream layer
> > instead, and each can be controlled independently, including
> > streamon/streamoff state, setting resolution and controls. Once a
> > simulcast format is successfully set for one of the simulcast video nodes
> > however, it cannot be changed, unless all connected nodes are idle, i.e.
> > they are not streaming and their buffers are freed.
> > 
> > The userspace can discover if a set of nodes belongs to one encoding unit
> > by traversing media controller topology of the camera.
> > 
> > 
> > I will be gradually posting documentation changes for new features after
> > initial rounds of reviews. This is a relatively major change to the UVC
> > driver and although I tried to keep the existing logic for UVC <1.5
> > cameras intact as much as possible, I would very much appreciate it if
> > these patches could get some testing from you as well, on your own
> > devices/systems.
> > 
> > Thanks,
> > Pawel Osciak
> > 
> > Pawel Osciak (19):
> >       uvcvideo: Add UVC query tracing.
> >       uvcvideo: Return 0 when setting probe control succeeds.
> >       uvcvideo: Add support for multiple chains with common roots.
> >       uvcvideo: Create separate debugfs entries for each streaming
> >       interface.
> >       uvcvideo: Add support for UVC1.5 P&C control.
> >       uvcvideo: Recognize UVC 1.5 encoding units.
> >       uvcvideo: Unify error reporting during format descriptor parsing.
> >       uvcvideo: Add UVC1.5 VP8 format support.
> >       uvcvideo: Reorganize uvc_{get,set}_le_value.
> >       uvcvideo: Support UVC 1.5 runtime control property.
> >       uvcvideo: Support V4L2_CTRL_TYPE_BITMASK controls.
> >       uvcvideo: Reorganize next buffer handling.
> >       uvcvideo: Unify UVC payload header parsing.
> >       v4l: Add v4l2_buffer flags for VP8-specific special frames.
> >       uvcvideo: Add support for VP8 special frame flags.
> >       v4l: Add encoding camera controls.
> >       uvcvideo: Add UVC 1.5 Encoding Unit controls.
> >       v4l: Add V4L2_PIX_FMT_VP8_SIMULCAST format.
> >       uvcvideo: Add support for UVC 1.5 VP8 simulcast.
> >  
> >  drivers/media/usb/uvc/uvc_ctrl.c     | 960 +++++++++++++++++++++++++++---
> >  drivers/media/usb/uvc/uvc_debugfs.c  |   3 +-
> >  drivers/media/usb/uvc/uvc_driver.c   | 604 ++++++++++++++--------
> >  drivers/media/usb/uvc/uvc_entity.c   | 129 ++++-
> >  drivers/media/usb/uvc/uvc_isight.c   |  12 +-
> >  drivers/media/usb/uvc/uvc_queue.c    |  25 +-
> >  drivers/media/usb/uvc/uvc_v4l2.c     | 284 +++++++++--
> >  drivers/media/usb/uvc/uvc_video.c    | 704 ++++++++++++++++---------
> >  drivers/media/usb/uvc/uvcvideo.h     | 214 +++++++-
> >  drivers/media/v4l2-core/v4l2-ctrls.c |  29 ++
> >  include/uapi/linux/usb/video.h       |  45 ++
> >  include/uapi/linux/v4l2-controls.h   |  31 ++
> >  include/uapi/linux/videodev2.h       |   8 +
> >  13 files changed, 2421 insertions(+), 627 deletions(-)

-- 
Regards,

Laurent Pinchart

