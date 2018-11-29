Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57181 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbeK2TgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 14:36:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] Various fixes
Message-ID: <53932235-9f31-ac99-ba3e-76249c79aac0@xs4all.nl>
Date: Thu, 29 Nov 2018 09:31:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some more fixes for 4.20.

Four of these are related to the new Request API. Found after extending the
Request API tests in v4l2-compliance. Most relate to a new test where I
check what happens if STREAMON returns an error the first time it is called.

v4l2-compliance now has code to detect that it is testing the vivid driver
and it can now do error injection. It turned out that handling this error
(STREAMON fails) has been broken since forever, both with and without the
Request API.

These patches fix this.

The biggest change is "vb2: keep a reference to the request until dqbuf"
which was discovered after I added a test where I close the request fd
after the request was queued. Then the last reference to the request
itself goes away when vb2_buffer_done() was called, but that requires
the ability to use mutexes, and since that's not allowed from vb2_buffer_done
(both because a spinlock is held and because it can be called from irq context)
I got a BUG.

So this required some more work to keep a request reference while vb2 owns
the buffer. It all makes sense, but it takes a bit of time to figure it all
out.

Regards,

	Hans

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20o

for you to fetch changes up to 759683e3fa1695014690dfc5b22bbe09d55681e8:

  vicodec: set state resolution from raw format (2018-11-29 09:00:20 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Dan Carpenter (1):
      media: cedrus: Fix a NULL vs IS_ERR() check

Hans Verkuil (6):
      vb2: don't call __vb2_queue_cancel if vb2_start_streaming failed
      vb2: skip request checks for VIDIOC_PREPARE_BUF
      vb2: keep a reference to the request until dqbuf
      vb2: don't unbind/put the object when going to state QUEUED
      vivid: drop v4l2_ctrl_request_complete() from start_streaming
      vicodec: set state resolution from raw format

 drivers/media/common/videobuf2/videobuf2-core.c | 44 +++++++++++++++++++++++++++++++++++---------
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 11 +++++++----
 drivers/media/platform/vicodec/vicodec-core.c   | 13 ++++++++++---
 drivers/media/platform/vivid/vivid-sdr-cap.c    |  2 --
 drivers/media/platform/vivid/vivid-vbi-cap.c    |  2 --
 drivers/media/platform/vivid/vivid-vbi-out.c    |  2 --
 drivers/media/platform/vivid/vivid-vid-cap.c    |  2 --
 drivers/media/platform/vivid/vivid-vid-out.c    |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c  |  4 ++--
 include/media/videobuf2-core.h                  |  2 ++
 10 files changed, 56 insertions(+), 28 deletions(-)
