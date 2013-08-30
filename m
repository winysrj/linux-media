Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49200 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3H3CR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:28 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so1229809pbc.16
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:28 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v1 00/19] UVC 1.5 VP8 support for uvcvideo
Date: Fri, 30 Aug 2013 11:16:59 +0900
Message-Id: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

This series adds support for UVC 1.5 and VP8 encoding cameras to the uvcvideo
driver. The official specification for the new standard can be found here:
http://www.usb.org/developers/devclass_docs.

The main change in 1.5 is support for encoding cameras. Those cameras contain
additional UVC entities, called Encoding Units, with their own set of controls
governing encode parameters. Typical encoding cameras (see examples in class
spec) expose two USB Video Streaming Interfaces (VSIs): one for raw stream
formats and one for encoded streams. Typically, both get their source stream
from a single sensor, producing raw and encoded versions of the video feed
simultaneously.
Encoding Units may also support the so-called "simulcast" formats, which allow
additional sub-streams, or layers, used to achieve temporal scalability.
The spec allows up to 4 simulcast layers. Those layers are encoded in the same
format, but encoding parameters, such as resolution, bitrate, etc., may,
depending on the camera capabilities, be changed independently for each layer,
and their streaming state may also be controlled independently as well. The
layers are streamed from the same USB VSI, and the information which layer
a frame belongs to is contained in its payload header.

In V4L2 API, a separate video node is created for each VSI: one for raw formats
VSI and another for the encoded formats VSI. Both can operate completely
independently from each other. In addition, if the Encoding Unit supports
simulcast, one V4L2 node is created for each stream layer instead, and each
can be controlled independently, including streamon/streamoff state, setting
resolution and controls. Once a simulcast format is successfully set for one
of the simulcast video nodes however, it cannot be changed, unless all connected
nodes are idle, i.e. they are not streaming and their buffers are freed.

The userspace can discover if a set of nodes belongs to one encoding unit
by traversing media controller topology of the camera.


I will be gradually posting documentation changes for new features after initial
rounds of reviews. This is a relatively major change to the UVC driver and
although I tried to keep the existing logic for UVC <1.5 cameras intact as much
as possible, I would very much appreciate it if these patches could get some
testing from you as well, on your own devices/systems.

Thanks,
Pawel Osciak


Pawel Osciak (19):
      uvcvideo: Add UVC query tracing.
      uvcvideo: Return 0 when setting probe control succeeds.
      uvcvideo: Add support for multiple chains with common roots.
      uvcvideo: Create separate debugfs entries for each streaming interface.
      uvcvideo: Add support for UVC1.5 P&C control.
      uvcvideo: Recognize UVC 1.5 encoding units.
      uvcvideo: Unify error reporting during format descriptor parsing.
      uvcvideo: Add UVC1.5 VP8 format support.
      uvcvideo: Reorganize uvc_{get,set}_le_value.
      uvcvideo: Support UVC 1.5 runtime control property.
      uvcvideo: Support V4L2_CTRL_TYPE_BITMASK controls.
      uvcvideo: Reorganize next buffer handling.
      uvcvideo: Unify UVC payload header parsing.
      v4l: Add v4l2_buffer flags for VP8-specific special frames.
      uvcvideo: Add support for VP8 special frame flags.
      v4l: Add encoding camera controls.
      uvcvideo: Add UVC 1.5 Encoding Unit controls.
      v4l: Add V4L2_PIX_FMT_VP8_SIMULCAST format.
      uvcvideo: Add support for UVC 1.5 VP8 simulcast.

 drivers/media/usb/uvc/uvc_ctrl.c     | 960 ++++++++++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_debugfs.c  |   3 +-
 drivers/media/usb/uvc/uvc_driver.c   | 604 ++++++++++++++--------
 drivers/media/usb/uvc/uvc_entity.c   | 129 ++++-
 drivers/media/usb/uvc/uvc_isight.c   |  12 +-
 drivers/media/usb/uvc/uvc_queue.c    |  25 +-
 drivers/media/usb/uvc/uvc_v4l2.c     | 284 +++++++++--
 drivers/media/usb/uvc/uvc_video.c    | 704 ++++++++++++++++---------
 drivers/media/usb/uvc/uvcvideo.h     | 214 +++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c |  29 ++
 include/uapi/linux/usb/video.h       |  45 ++
 include/uapi/linux/v4l2-controls.h   |  31 ++
 include/uapi/linux/videodev2.h       |   8 +
 13 files changed, 2421 insertions(+), 627 deletions(-)
