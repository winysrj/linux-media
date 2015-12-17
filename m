Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44649 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbLQIkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:40:40 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 00/48] Request API and proof-of-concept implementation
Date: Thu, 17 Dec 2015 10:39:38 +0200
Message-Id: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series is my first proposal for the V4L2 request API.

The concept is based on Hans Verkuil's initial implementation. A recently
rebased version is available at

	http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=requests2

I have reworked the initial proposal extensively and implemented proof of
concept support for requests in the Renesas VSP1 driver. The VSP1 hardware is
a good candidate here as it supports applying configurations stored in system
memory atomically.

As the first use case for the request API with the VSP1 driver is to configure
pad formats I have decided to concentrate on that feature and have dropped
Hans' support for the API in the V4L2 control framework. By no mean does this
imply that I consider controls as a invalid or even second class use case, I
just had to pick a reasonable initial target without trying to save the world
straight away. I will include support for controls as a second step as I will
eventually need them for the VSP1 driver as well.


Patches 01/48 to 20/48 rework the VSP1 driver to prepare for request API
support. I won't go as far as saying there's nothing interesting there, but
feel free to skip review of those patches if your main interest here is the
request API itself.

Patches 21/48 to 24/48 add support for the request API to the media controller
framework. The corresponding DocBook documentation is available in patch
35/48. As those patches touch the media controller core I will rebase them on
top of the ongoing media controller rework when it will be finalized.

Patches 25/48 to 27/48 then add support for the request API to the V4L2
userspace API, in particular for buffers (25/48), formats (26/48) and subdev
formats and selections (27/48). The corresponding DocBook documentation is
available in patches 36/48 to 38/40.

Patch 28/48 implement in-kernel support for requests in format operations,
patches 29/48 to 31/48 in the subdev operations, and patches 32/48 to 34/48 in
videobuf2.

Patches 39/48 to 48/48 finally make use of all the new infrastructure and
add request API support in the VSP1 driver.


The code depends on several VSP1 and DU patch series previously posted. For
convenience you can access it on top of its dependencies at

	git://linuxtv.org/pinchartl/media.git vsp1-kms-request-20151217


As this series introduces a new API, support for it in userspace is needed. I
have implemented quick & dirty request API support in yavta and media-ctl for
testing purpose. The code is available in the following git trees.

	git://git.ideasonboard.org/yavta.git requests
	git://linuxtv.org/pinchartl/v4l-utils.git requests


Last but not least, the procedure I've followed for the simplest tests on the
Renesas Koelsch board is as follows.

1. Configure a simple memory-to-memory pipeline

$ media-ctl -d /dev/media0 -r
$ media-ctl -d /dev/media0 -l "'fe928000.vsp1 rpf.0':1 -> 'fe928000.vsp1 wpf.0':0 [1]"
$ media-ctl -d /dev/media0 -l "'fe928000.vsp1 wpf.0':1 -> 'fe928000.vsp1 wpf.0 output':0 [1]"
$ media-ctl -d /dev/media0 -V "'fe928000.vsp1 rpf.0':0 [fmt:AYUV32/1024x768]"
$ media-ctl -d /dev/media0 -V "'fe928000.vsp1 wpf.0':0 [fmt:AYUV32/1024x768]"
$ media-ctl -d /dev/media0 -V "'fe928000.vsp1 wpf.0':1 [fmt:AYUV32/1024x768]"

2. Create and fill a request with media-ctl

$ media-ctl -i
req:alloc
'fe928000.vsp1 rpf.0':0 [fmt:AYUV32/1024x768]
'fe928000.vsp1 wpf.0':0 [fmt:AYUV32/1024x768]
'fe928000.vsp1 wpf.0':1 [fmt:AYUV32/1024x768]

(do not exit media-ctl at this point)

This allocates and fills request number 1.

3. Queue buffers on the input and output video nodes

$ yavta --request 1 -c1 -n 1 -f YUYV -s 1024x768 /dev/video0
$ yavta --request 1 -c1 -n 1 -f YUYV -s 1024x768 -F /dev/video5

4. Queue the request in the running media-ctl -i session

req:queue

At this point the two yavta commands should complete.

5. Create and fill a scond request with different parameters in the same
media-ctl -i session

req:alloc
'fe928000.vsp1 rpf.0':0 [fmt:AYUV32/640x480]
'fe928000.vsp1 wpf.0':0 [fmt:AYUV32/640x480]
'fe928000.vsp1 wpf.0':1 [fmt:AYUV32/640x480]

(do not exit media-ctl at this point)

This allocates and fills request number 2.

6. Queue buffers on the input and output video nodes

$ yavta --request 1 -c1 -n 1 -f YUYV -s 640x480 /dev/video0
$ yavta --request 1 -c1 -n 1 -f YUYV -s 640x480 -F /dev/video5

7. Queue the request in the running media-ctl -i session

req:queue

At this point the two yavta commands should complete.


I will work on automating the procedure and test tools, suggestions are
welcome.


Hans Verkuil (3):
  videodev2.h: Add request field to v4l2_buffer
  vb2: Add allow_requests flag
  vb2: Add helper function to queue request-specific buffer.

Laurent Pinchart (45):
  v4l: vsp1: Use pipeline display list to decide how to write to modules
  v4l: vsp1: Always setup the display list
  v4l: vsp1: Simplify frame end processing
  v4l: vsp1: Split display list manager from display list
  v4l: vsp1: Store the display list manager in the WPF
  v4l: vsp1: bru: Don't program background color in control set handler
  v4l: vsp1: rwpf: Don't program alpha value in control set handler
  v4l: vsp1: sru: Don't program intensity in control set handler
  v4l: vsp1: Don't setup control handler when starting streaming
  v4l: vsp1: Enable display list support for the HS[IT], LUT, SRU and
    UDS
  v4l: vsp1: Don't configure RPF memory buffers before calculating
    offsets
  v4l: vsp1: Remove unneeded entity streaming flag
  v4l: vsp1: Document calling context of vsp1_pipeline_propagate_alpha()
  v4l: vsp1: Fix 80 characters per line violations
  v4l: vsp1: Add header display list support
  v4l: vsp1: Use display lists with the userspace API
  v4l: vsp1: Move subdev initialization code to vsp1_entity_init()
  v4l: vsp1: Consolidate entity ops in a struct vsp1_entity_operations
  v4l: vsp1: Fix BRU try compose rectangle storage
  v4l: vsp1: Add race condition FIXME comment
  media: Move media_device link_notify operation to an ops structure
  media: Add per-file-handle data support
  media: Add request API
  media: Add per-entity request data support
  videodev2.h: Add request field to v4l2_pix_format_mplane
  v4l2-subdev.h: Add request field to format and selection structures
  v4l: Support the request API in format operations
  v4l: subdev: Add pad config allocator and init
  v4l: subdev: Call pad init_cfg operation when opening subdevs
  v4l: subdev: Support the request API in format and selection
    operations
  vb2: Add helper function to check for request buffers
  DocBook: media: Document the media request API
  DocBook: media: Document the V4L2 request API
  DocBook: media: Document the subdev selection API
  DocBook: media: Document the V4L2 subdev request API
  v4l: vsp1: Implement and use the subdev pad::init_cfg configuration
  v4l: vsp1: Store active formats in a pad config structure
  v4l: vsp1: Store active selection rectangles in a pad config structure
  v4l: vsp1: Create a new configure operation to setup modules
  v4l: vsp1: Merge RPF and WPF pad ops structures
  v4l: vsp1: Pass a media request to the module configure operations
  v4l: vsp1: Use __vsp1_video_try_format to initialize format at init
    time
  v4l: vsp1: Support video device formats stored in requests
  v4l: vsp1: Pass display list explicitly to configure functions
  v4l: vsp1: Support the request API

 Documentation/DocBook/media/v4l/common.xml         |   2 +
 Documentation/DocBook/media/v4l/io.xml             |  12 +-
 .../DocBook/media/v4l/media-controller.xml         |   1 +
 .../DocBook/media/v4l/media-ioc-request-cmd.xml    | 194 +++++++++++
 Documentation/DocBook/media/v4l/request-api.xml    |  90 ++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   9 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   6 +
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |  33 +-
 .../media/v4l/vidioc-subdev-g-selection.xml        |  65 +++-
 drivers/media/media-device.c                       | 275 ++++++++++++++++
 drivers/media/media-devnode.c                      |  19 +-
 drivers/media/media-entity.c                       |  11 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   6 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |  13 -
 drivers/media/platform/vsp1/vsp1_bru.c             | 354 +++++++++++----------
 drivers/media/platform/vsp1/vsp1_bru.h             |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c              | 343 ++++++++++++--------
 drivers/media/platform/vsp1/vsp1_dl.h              |  42 ++-
 drivers/media/platform/vsp1/vsp1_drm.c             |  71 ++---
 drivers/media/platform/vsp1/vsp1_drm.h             |   5 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  28 +-
 drivers/media/platform/vsp1/vsp1_entity.c          | 200 +++++++-----
 drivers/media/platform/vsp1/vsp1_entity.h          |  53 ++-
 drivers/media/platform/vsp1/vsp1_hsit.c            | 104 +++---
 drivers/media/platform/vsp1/vsp1_lif.c             | 147 ++++-----
 drivers/media/platform/vsp1/vsp1_lut.c             | 113 ++++---
 drivers/media/platform/vsp1/vsp1_pipe.c            | 118 ++++---
 drivers/media/platform/vsp1/vsp1_pipe.h            |  13 +-
 drivers/media/platform/vsp1/vsp1_request.c         | 126 ++++++++
 drivers/media/platform/vsp1/vsp1_request.h         |  41 +++
 drivers/media/platform/vsp1/vsp1_rpf.c             | 226 +++++--------
 drivers/media/platform/vsp1/vsp1_rwpf.c            | 189 ++++++++---
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  67 ++--
 drivers/media/platform/vsp1/vsp1_sru.c             | 205 ++++++------
 drivers/media/platform/vsp1/vsp1_sru.h             |   2 +
 drivers/media/platform/vsp1/vsp1_uds.c             | 209 ++++++------
 drivers/media/platform/vsp1/vsp1_uds.h             |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 170 ++++++----
 drivers/media/platform/vsp1/vsp1_wpf.c             | 267 +++++++---------
 drivers/media/usb/cpia2/cpia2_v4l.c                |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 125 +++++++-
 drivers/media/v4l2-core/v4l2-subdev.c              | 246 ++++++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  55 ++++
 drivers/staging/media/omap4iss/iss.c               |   6 +-
 include/media/media-device.h                       |  62 +++-
 include/media/media-devnode.h                      |  18 +-
 include/media/media-entity.h                       |  12 +
 include/media/v4l2-dev.h                           |  13 +
 include/media/v4l2-subdev.h                        |  22 ++
 include/media/videobuf2-core.h                     |   2 +
 include/media/videobuf2-v4l2.h                     |   5 +
 include/uapi/linux/media.h                         |  12 +
 include/uapi/linux/v4l2-subdev.h                   |  15 +-
 include/uapi/linux/videodev2.h                     |   8 +-
 57 files changed, 2982 insertions(+), 1468 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
 create mode 100644 Documentation/DocBook/media/v4l/request-api.xml
 create mode 100644 drivers/media/platform/vsp1/vsp1_request.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_request.h

-- 
Regards,

Laurent Pinchart

