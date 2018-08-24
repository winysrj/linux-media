Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44354 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbeHXLze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:55:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH 0/5] Post-v18: Request API updates
Date: Fri, 24 Aug 2018 10:21:51 +0200
Message-Id: <20180824082156.6986-1-hverkuil@xs4all.nl>
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

Driver visible changes (important for the cedrus driver!):

Drivers should set the new vb2_queue 'supports_request' bitfield to 1
if a vb2_queue can support requests. Otherwise the queue cannot be
used with requests.

This bitfield is also used to fill in the new capabilities field
in struct v4l2_requestbuffers and v4l2_create_buffers.

There will be a follow-up documentation patch incorporating
Laurent's comments, but that doesn't change any APIs.

Regards,

	Hans

Hans Verkuil (5):
  media-request: return -EINVAL for invalid request_fds
  v4l2-ctrls: return -EACCES if request wasn't completed
  buffer.rst: only set V4L2_BUF_FLAG_REQUEST_FD for QBUF
  videodev2.h: add new capabilities for buffer types
  vb2: set reqbufs/create_bufs capabilities

 Documentation/media/uapi/v4l/buffer.rst       |  6 ++--
 .../media/uapi/v4l/vidioc-create-bufs.rst     | 10 +++++-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     | 36 +++++++++----------
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  | 12 +++----
 .../media/uapi/v4l/vidioc-reqbufs.rst         | 36 ++++++++++++++++++-
 .../media/common/videobuf2/videobuf2-v4l2.c   | 19 +++++++++-
 drivers/media/media-request.c                 |  6 ++--
 drivers/media/platform/vim2m.c                |  1 +
 drivers/media/platform/vivid/vivid-core.c     |  5 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c          |  5 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  4 +--
 include/media/videobuf2-core.h                |  2 ++
 include/uapi/linux/videodev2.h                | 13 +++++--
 14 files changed, 118 insertions(+), 41 deletions(-)

-- 
2.18.0
