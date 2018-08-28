Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51307 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727785AbeH1Rk7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 13:40:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCHv2 00/10] Post-v18: Request API updates
Date: Tue, 28 Aug 2018 15:49:01 +0200
Message-Id: <20180828134911.44086-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This patch series sits on top of my v18 series for the Request API.
It makes some final (?) changes as discussed in:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg134419.html

and:

https://www.spinics.net/lists/linux-media/msg138596.html

The combined v18 patches + this series is available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv18-1

Updated v4l-utils for this is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

Userspace visible changes:

- Invalid request_fd values now return -EINVAL instead of -ENOENT.
- It is no longer possible to use VIDIOC_G_EXT_CTRLS for requests
  that are not completed. -EACCES is returned in that case.
- Attempting to use requests if requests are not supported by the driver
  will result in -EACCES instead of -EPERM.

Driver visible changes (important for the cedrus driver!):

Drivers should set the new vb2_queue 'supports_request' bitfield to 1
if a vb2_queue can support requests. Otherwise the queue cannot be
used with requests.

This bitfield is also used to fill in the new capabilities field
in struct v4l2_requestbuffers and v4l2_create_buffers.

Changes since v1:

- Updated patch 4/10 to explain how to query the capabilities
  with REQBUFS/CREATE_BUFS with a minimum of side-effects
  (requested by Tomasz).
- Added patches 6-10:
  6: Sakari found a corner case: when accessing a request the
     request has to be protected from being re-inited. New
     media_request_(un)lock_for_access helpers are added for this.
  7: use these helpers in g_ext_ctrls.
  8: make s/try_ext_ctrls more robust by keeping the request
     references until we're fully done setting/trying the controls.
  9: Change two more EPERM's to EACCES. EPERM suggests that you can
     fix it by changing permissions somehow, but in this case the
     driver simply doesn't support requests at all.
  10: Update the request documentation based on Laurent's comments:
      https://www.spinics.net/lists/linux-media/msg139152.html
      To do: split off the V4L2 specifics into a V4L2 specific
      rst file. But this will take more time and is for later.

Regards,

	Hans

Hans Verkuil (10):
  media-request: return -EINVAL for invalid request_fds
  v4l2-ctrls: return -EACCES if request wasn't completed
  buffer.rst: only set V4L2_BUF_FLAG_REQUEST_FD for QBUF
  videodev2.h: add new capabilities for buffer types
  vb2: set reqbufs/create_bufs capabilities
  media-request: add media_request_(un)lock_for_access
  v4l2-ctrls: use media_request_(un)lock_for_access
  v4l2-ctrls: improve media_request_(un)lock_for_update
  media-request: EPERM -> EACCES
  media-request: update documentation

 .../uapi/mediactl/media-ioc-request-alloc.rst |  3 +-
 .../uapi/mediactl/media-request-ioc-queue.rst |  7 +--
 .../media/uapi/mediactl/request-api.rst       | 51 +++++++++++--------
 .../uapi/mediactl/request-func-close.rst      |  1 +
 .../media/uapi/mediactl/request-func-poll.rst |  2 +-
 Documentation/media/uapi/v4l/buffer.rst       | 22 +++++---
 .../media/uapi/v4l/vidioc-create-bufs.rst     | 14 ++++-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     | 48 +++++++++--------
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  | 32 +++++++-----
 .../media/uapi/v4l/vidioc-reqbufs.rst         | 42 ++++++++++++++-
 .../media/common/videobuf2/videobuf2-v4l2.c   | 19 ++++++-
 drivers/media/media-request.c                 | 20 ++++++--
 drivers/media/platform/vim2m.c                |  1 +
 drivers/media/platform/vivid/vivid-core.c     |  5 ++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          | 32 +++++++-----
 drivers/media/v4l2-core/v4l2-ioctl.c          |  4 +-
 include/media/media-request.h                 | 46 +++++++++++++++++
 include/media/videobuf2-core.h                |  2 +
 include/uapi/linux/videodev2.h                | 13 ++++-
 20 files changed, 269 insertions(+), 99 deletions(-)

-- 
2.18.0
