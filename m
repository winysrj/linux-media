Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44436 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbeLCNwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:55 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com
Subject: [PATCHv3 0/9] vb2/cedrus: add tag support
Date: Mon,  3 Dec 2018 14:51:34 +0100
Message-Id: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

As was discussed here (among other places):

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. A better idea is to use a 'tag' where the
application can assign a u32 tag to an output buffer, which is then 
copied to the capture buffer(s) derived from the output buffer.

It has been suggested that the timestamp can be used for this. But
there are a number of reasons why this is a bad idea:

1) the struct timeval is converted to a u64 in vb2. So there can be
   all sorts of unexpected conversion issues. In particular, the
   output of ns_to_timeval(timeval_to_ns(tv)) does not necessarily
   match the input.

2) it gets worse with the y2038 code where userspace either deals
   with a 32 bit tv_sec value or a 64 bit value.

In other words, using timestamp for this is not a good idea.

This implementation adds a new tag field in a union with the timecode
field. Right now timecode is not actually used in any driver, except
that m2m drivers are supposed to copy it from the OUTPUT queue to the
CAPTURE queue (it can be set by userspace, so it should be copied by
the driver). An alternative would be to use the reserved2 field in
struct v4l2_buffer for the tag. But then we have no more room for
a fence fd. But if we decide on a struct v4l2_ext_buffer API going
forward, then we might just use that for fences as well and we can
just take the reserved2 field for the tag instead.

I have no strong opinion on this.

The first three patches add core tag support, the next patch document
the tag support, then a new helper function is added to v4l2-mem2mem.c
to easily copy data from a source to a destination buffer that drivers
can use.

Next a new supports_tags vb2_queue flag is added to indicate that
the driver supports tags. Ideally this should not be necessary, but
that would require that all m2m drivers are converted to using the
new helper function introduced in the previous patch. That takes more
time then I have now.

Finally the vim2m, vicodec and cedrus drivers are converted to support
tags.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary.

Note that this might change further (Paul suggested using bitfields).

Also note that the cedrus code doesn't set the sequence counter, that's
something that should still be added before this driver can be moved
out of staging.

Note: if no buffer is found for a certain tag, then the dma address
is just set to 0. That happened before as well with invalid buffer
indices. This should be checked in the driver!

Regards,

        Hans

Changes since v2:

- rebased
- added Reviewed-by tags
- fixed a few remaining references in the documentation to the old
  v4l2_buffer_tag struct that was used in early versions of this
  series.

Changes since v1:

- changed to a u32 tag. Using a 64 bit tag was overly complicated due
  to the bad layout of the v4l2_buffer struct, and there is no real
  need for it by applications.

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

 Documentation/media/uapi/v4l/buffer.rst       | 32 +++++++++----
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
 .../media/common/videobuf2/videobuf2-v4l2.c   | 45 ++++++++++++++++---
 drivers/media/platform/vicodec/vicodec-core.c | 14 ++----
 drivers/media/platform/vim2m.c                | 14 ++----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
 drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 ++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
 .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
 include/media/v4l2-mem2mem.h                  | 21 +++++++++
 include/media/videobuf2-core.h                |  2 +
 include/media/videobuf2-v4l2.h                | 21 ++++++++-
 include/uapi/linux/v4l2-controls.h            | 14 +++---
 include/uapi/linux/videodev2.h                |  9 +++-
 17 files changed, 178 insertions(+), 73 deletions(-)

-- 
2.19.1
