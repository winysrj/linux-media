Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38530 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727532AbeKITgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 14:36:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [RFC PATCH 0/5] vb2/cedrus: add cookie support
Date: Fri,  9 Nov 2018 10:56:08 +0100
Message-Id: <20181109095613.28272-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As was discussed here (among other places):

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. A better idea is to use 'cookies' (a better name is
welcome!) where the application can assign a u64 cookie to an output
buffer, which is then copied to the capture buffer(s) derived from the
output buffer.

A u64 is chosen since this allows userspace to also use pointers to
internal structures as 'cookie'.

The first two patches add core cookie support, the next two patches
add cookie support to vim2m and vicodec, and the final patch (compile
tested only!) adds support to the cedrus driver.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary (u64 for the cookie values).

The cedrus code now also copies the timestamps (didn't happen before)
but the sequence counter is still not set, that's something that should
still be added.

Note: if no buffer is found for a certain cookie, then the dma address
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

Hans Verkuil (5):
  videodev2.h: add cookie support
  vb2: add cookie support
  vim2m: add cookie support
  vicodec: add cookie support
  cedrus: add cookie support

 .../media/common/videobuf2/videobuf2-v4l2.c   | 41 ++++++++++++++++---
 drivers/media/platform/vicodec/vicodec-core.c |  3 ++
 drivers/media/platform/vim2m.c                |  3 ++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 +++++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 23 +++++------
 include/media/videobuf2-v4l2.h                | 18 ++++++++
 include/uapi/linux/v4l2-controls.h            | 14 +++----
 include/uapi/linux/videodev2.h                | 36 +++++++++++++++-
 10 files changed, 126 insertions(+), 39 deletions(-)

-- 
2.19.1
