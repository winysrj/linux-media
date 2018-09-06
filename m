Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39143 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbeIFLFF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 07:05:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20 (request_api branch)] Request API: follow-up
 patches
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c20be431-4187-7e05-982a-c3d7b884d6fc@xs4all.nl>
Date: Thu, 6 Sep 2018 08:31:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the remaining changes to the Request API topic
branch.

Userspace visible changes:

- Invalid request_fd values now return -EINVAL instead of -ENOENT to be consistent
  with e.g. dmabuf fds.
- It is no longer possible to use VIDIOC_G_EXT_CTRLS for requests
  that are not completed. -EACCES is returned in that case.
- Attempting to use requests if requests are not supported by the driver
  will result in -EACCES instead of -EPERM.
- Attempting to mix direct QBUF with queueing buffers via a request
  will result in -EBUSY instead of -EPERM.
- Added capabilities to VIDIOC_REQBUFS/CREATE_BUFS: tells the user which
  streaming I/O methods are available and if the request API can be used.

Driver visible changes:

Drivers should set the new vb2_queue 'supports_request' bitfield to 1
if a vb2_queue can support requests. Otherwise the queue cannot be
used with requests.

This bitfield is also used to fill in the new capabilities field
in struct v4l2_requestbuffers and v4l2_create_buffers.

This series also contains a bug fix to prevent a race condition when
you are accessing request data (media_request_(un)lock_for_access).

Regards,

	Hans

The following changes since commit 757fdb51c14fda221ccb6999a865f7f895c79750:

  media: vivid: add request support (2018-08-31 11:26:06 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git reqv18-1

for you to fetch changes up to 051dfd971de1317626d322581546257b748ebde1:

  media-request: update documentation (2018-09-04 11:34:57 +0200)

----------------------------------------------------------------
Hans Verkuil (10):
      media-request: return -EINVAL for invalid request_fds
      v4l2-ctrls: return -EACCES if request wasn't completed
      buffer.rst: only set V4L2_BUF_FLAG_REQUEST_FD for QBUF
      videodev2.h: add new capabilities for buffer types
      vb2: set reqbufs/create_bufs capabilities
      media-request: add media_request_(un)lock_for_access
      v4l2-ctrls: use media_request_(un)lock_for_access
      v4l2-ctrls: improve media_request_(un)lock_for_update
      media-request: EPERM -> EACCES/EBUSY
      media-request: update documentation

 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst |  3 +-
 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst | 16 ++++-------
 Documentation/media/uapi/mediactl/request-api.rst             | 55 +++++++++++++++++++----------------
 Documentation/media/uapi/mediactl/request-func-close.rst      |  1 +
 Documentation/media/uapi/mediactl/request-func-poll.rst       |  2 +-
 Documentation/media/uapi/v4l/buffer.rst                       | 22 +++++++++-----
 Documentation/media/uapi/v4l/vidioc-create-bufs.rst           | 14 ++++++++-
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst           | 48 +++++++++++++++----------------
 Documentation/media/uapi/v4l/vidioc-qbuf.rst                  | 35 ++++++++++++-----------
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst               | 42 ++++++++++++++++++++++++++-
 drivers/media/common/videobuf2/videobuf2-core.c               |  2 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c               | 24 ++++++++++++++--
 drivers/media/media-request.c                                 | 20 ++++++++++---
 drivers/media/platform/vim2m.c                                |  1 +
 drivers/media/platform/vivid/vivid-core.c                     |  5 ++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c                 |  4 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c                          | 32 +++++++++++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c                          |  4 +--
 include/media/media-request.h                                 | 62 ++++++++++++++++++++++++++++++++++++++--
 include/media/videobuf2-core.h                                |  2 ++
 include/uapi/linux/videodev2.h                                | 13 +++++++--
 21 files changed, 294 insertions(+), 113 deletions(-)
