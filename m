Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:44010 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753045AbeENL4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:56:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC PATCH 0/6] v4l2 core: push ioctl lock down to ioctl handler
Date: Mon, 14 May 2018 13:55:56 +0200
Message-Id: <20180514115602.9791-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While working on the DMA fence API and the Request API it became
clear that the core ioctl scheme was done at a too-high level.

Being able to actually look at the struct passed as the ioctl
argument would help a lot in decide what lock(s) to take.

This patch series pushes the lock down into v4l2-ioctl.c, after
video_usercopy() was called.

The first patch is for the only driver that does not set
unlocked_ioctl to video_ioctl2: pvrusb2. It actually does
call it in its own unlocked_ioctl function.

Mike, can you test this patch? I tried to test it but my pvrusb2
fails in a USB transfer (unrelated to this patch). I'll mail you
separately with the details, since I've no idea what is going on.

The second patch pushes the lock down.

The third patch adds support for mem2mem devices by selecting
the correct queue lock (capture vs output): this was never
possible before.

Note: in practice it appears that all m2m devices use the same
lock for both capture and output queues. Perhaps this should
be standardized?

The final three patches require that queue->lock is always
set. There are some drivers that do not set this (and Ezequiel
will look at that and provide patches that will have to go
in between patch 3 and 4 of this RFC series), but without that
you will have performance issues with a blocking DQBUF (it
will never release the core ioctl serialization lock while
waiting for a new frame).

I have added a test for this to v4l2-compliance. We never tested
this before.

Another note: the gspca vb2 conversion series I posted yesterday
also remove the v4l2_disable_ioctl_locking() function, so that
cleans up another little locking-related dark corner in the core.

Regards,

	Hans

Hans Verkuil (6):
  pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
  v4l2-core: push taking ioctl mutex down to ioctl handler.
  v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
  videobuf2-core: require q->lock
  videobuf2: assume q->lock is always set
  v4l2-ioctl.c: assume queue->lock is always set

 .../media/common/videobuf2/videobuf2-core.c   | 22 ++---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 27 ++----
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      | 83 +++++++------------
 drivers/media/v4l2-core/v4l2-dev.c            |  6 --
 drivers/media/v4l2-core/v4l2-ioctl.c          | 75 +++++++++++++++--
 drivers/media/v4l2-core/v4l2-subdev.c         | 17 +++-
 include/media/v4l2-dev.h                      |  9 --
 include/media/v4l2-ioctl.h                    | 12 ---
 include/media/videobuf2-core.h                |  2 -
 9 files changed, 133 insertions(+), 120 deletions(-)

-- 
2.17.0
