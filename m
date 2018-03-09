Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:36224 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbeCIXtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:23 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [RFC 0/8] Preparing the request API
Date: Sat, 10 Mar 2018 01:48:44 +0200
Message-Id: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This preliminary RFC patchset prepares for the request API. What's new
here is support for binding arbitrary configuration or resources to
requests.

There are a few new concepts here:

Class --- a type of configuration or resource a driver (or e.g. the V4L2
framework) can attach to a resource. E.g. a video buffer queue would be a
class.

Object --- an instance of the class. This may be either configuration (in
which case the setting will stay until changed, e.g. V4L2 format on a
video node) or a resource (such as a video buffer).

Reference --- a reference to an object. If a configuration is not changed
in a request, instead of allocating a new object, a reference to an
existing object is used. This saves time and memory.

I expect Laurent to comment on aligning the concept names between the
request API and DRM. As far as I understand, the respective DRM names
would be "object" and "state".

The drivers will need to interact with the requests in three ways:

- Allocate new configurations or resources. Drivers are free to store
  their own data into request objects as well. These callbacks are
  specific to classes.

- Validate and queue callbacks. These callbacks are used to try requests
  (validate only) as well as queue them (validate and queue). These
  callbacks are media device wide, at least for now.

The lifetime of the objects related to requests is based on refcounting
both requests and request objects. This fits well for existing use cases
whether or not based on refcounting; what still needs most of the
attention is likely that the number of gets and puts matches once the
object is no longer needed.

Configuration can be bound to the request the usual way (V4L2 IOCTLs with
the request_fd field set to the request). Once queued, request completion
is signalled through polling the request file handle (POLLPRI).

I'm posting this as an RFC because it's not complete yet; I'll continue
working on it next week.

Todo list:

- Better separation of request support between media-device.c and
  media-request.c. The intent is that mostly IOCTL handling would be in
  media-device.c.

- Request support in a few drivers as well as the control framework.

- Request support for V4L2 formats.

- Provide means to iterate over references in a request. This would be
  useful for drivers. The exact needs will be clearer once support for a
  few drivers has been added.

- Reinit support.

In the future, support for changing e.g. Media controller link state or
V4L2 sub-device formats will need to be added. Those are not in my
immediate plans though.

Comments and questions are welcome.


Open questions:

- How to tell at complete time whether a request failed? Return error code
  on release? What's the behaviour with reinit then --- fail on error? Add
  another request command to ask for status?


Alexandre Courbot (1):
  videodev2.h: add request_fd field to v4l2_ext_controls

Hans Verkuil (1):
  videodev2.h: Add request_fd field to v4l2_buffer

Laurent Pinchart (1):
  media: Add request API

Sakari Ailus (5):
  media: Support variable size IOCTL arguments
  media: Support polling for completed requests
  media: Add support for request classes and objects
  staging: media: atomisp: Remove v4l2_buffer.reserved2 field hack
  vb2: Add support for requests

 drivers/media/Makefile                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  43 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |  24 +-
 drivers/media/media-device.c                       | 483 ++++++++++++++++++++-
 drivers/media/media-request.c                      | 287 ++++++++++++
 drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   6 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  17 +-
 include/media/media-device.h                       |  80 +++-
 include/media/media-request.h                      | 229 ++++++++++
 include/media/videobuf2-core.h                     |  19 +
 include/media/videobuf2-v4l2.h                     |   2 +
 include/uapi/linux/media.h                         |  10 +
 include/uapi/linux/videodev2.h                     |   6 +-
 15 files changed, 1186 insertions(+), 41 deletions(-)
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.7.4
