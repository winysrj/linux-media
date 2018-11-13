Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33156 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731503AbeKMTkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:40:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: [PATCH 0/9] vb2/cedrus: add tag support
Date: Tue, 13 Nov 2018 10:42:29 +0100
Message-Id: <20181113094238.48253-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As was discussed here (among other places):

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. A better idea is to use a 'tag' where the
application can assign a u64 tag to an output buffer, which is then 
copied to the capture buffer(s) derived from the output buffer.

A u64 is chosen since this allows userspace to also use pointers to
internal structures as 'tag'.

The first three patches add core tag support, the next patch document
the tag support, then a new helper function is added to v4l2-mem2mem.c
to easily copy data from a source to a destination buffer that drivers
can use.

Next a new supports_tags vb2_queue flag is added to indicate that
the driver supports tags. Ideally this should not be necessary, but
that would require that all m2m drivers are converted to using the
new helper function introduced in the previous patch. That takes more
time then I have now since we want to get this in for 4.20.

Finally the vim2m, vicodec and cedrus drivers are converted to support
tags.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary (u64 for the tag values).

Note that this might change further (Paul suggested using bitfields).

Also note that the cedrus code doesn't set the sequence counter, that's
something that should still be added before this driver can be moved
out of staging.

Note: if no buffer is found for a certain tag, then the dma address
is just set to 0. That happened before as well with invalid buffer
indices. This should be checked in the driver!

The previous RFC series was tested successfully with the cedrus driver.

Regards,

        Hans

Main changes since the RFC:

- Added new buffer capability flag
- Added m2m helper to copy data between buffers
- Added documentation
- Added tag logging in v4l2-ioctl.c

Hans Verkuil (9):
  videodev2.h: add tag support
  vb2: add tag support
  v4l2-ioctl.c: log v4l2_buffer tag
  buffer.rst: document the new buffer tag feature.
  v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
  vb2: add new supports_tags queue flag
  vim2m: add tag support
  vicodec: add tag support
  cedrus: add tag support

 Documentation/media/uapi/v4l/buffer.rst       | 61 ++++++++++++++++---
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
 .../media/common/videobuf2/videobuf2-v4l2.c   | 45 ++++++++++++--
 drivers/media/platform/vicodec/vicodec-core.c | 14 +----
 drivers/media/platform/vim2m.c                | 14 +----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ---
 drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 +++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++-
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 +++----
 .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
 include/media/v4l2-mem2mem.h                  | 21 +++++++
 include/media/videobuf2-core.h                |  2 +
 include/media/videobuf2-v4l2.h                | 21 ++++++-
 include/uapi/linux/v4l2-controls.h            | 14 ++---
 include/uapi/linux/videodev2.h                | 38 +++++++++++-
 17 files changed, 236 insertions(+), 73 deletions(-)

-- 
2.19.1
