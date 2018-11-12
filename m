Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53956 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726221AbeKLSZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 13:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org
Subject: [RFC PATCHv2 0/5] vb2/cedrus: add tag support
Date: Mon, 12 Nov 2018 09:33:00 +0100
Message-Id: <20181112083305.22618-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As was discussed here (among other places):

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. A better idea is to use a 'tag' (thanks to Alexandre
for the excellent name; it's much better than 'cookie') where the 
application can assign a u64 tag to an output buffer, which is then 
copied to the capture buffer(s) derived from the output buffer.

A u64 is chosen since this allows userspace to also use pointers to
internal structures as 'tag'.

The first two patches add core tag support, the next two patches
add tag support to vim2m and vicodec, and the final patch (compile
tested only!) adds support to the cedrus driver.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary (u64 for the tag values).

The cedrus code now also copies the timestamps (didn't happen before)
but the sequence counter is still not set, that's something that should
still be added.

Note: if no buffer is found for a certain tag, then the dma address
is just set to 0. That happened before as well with invalid buffer
indices. This should be checked in the driver!

Also missing in this series are documentation updates, which is why
it is marked RFC.

I would very much appreciate it if someone can test the cedrus driver
with these changes. If it works, then I can prepare a real patch series
for 4.20. It would be really good if the API is as stable as we can make
it before 4.20 is released.

Regards,

        Hans

Changes since v1:

- cookie -> tag
- renamed v4l2_tag to v4l2_buffer_tag
- dropped spurious 'to' in the commit log of patch 1

Hans Verkuil (5):
  videodev2.h: add tag support
  vb2: add tag support
  vim2m: add tag support
  vicodec: add tag support
  cedrus: add tag support

 .../media/common/videobuf2/videobuf2-v4l2.c   | 43 ++++++++++++++++---
 drivers/media/platform/vicodec/vicodec-core.c |  3 ++
 drivers/media/platform/vim2m.c                |  3 ++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 +++++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
 include/media/videobuf2-v4l2.h                | 18 ++++++++
 include/uapi/linux/v4l2-controls.h            | 14 +++---
 include/uapi/linux/videodev2.h                | 37 +++++++++++++++-
 10 files changed, 127 insertions(+), 39 deletions(-)

-- 
2.19.1
