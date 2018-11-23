Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51594 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731874AbeKWTQ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 14:16:29 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21 v2] Various fixes
Message-ID: <8755ff2e-8c5a-483b-f3f2-918bd6f668cc@xs4all.nl>
Date: Fri, 23 Nov 2018 09:33:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(fixed my SoB mess in this v2)

Various fixes, mostly related to issues found by syzbot.

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21b2

for you to fetch changes up to 3f444acfa6f43e2e9b23907fc820e3e51339565c:

  vivid: free bitmap_cap when updating std/timings/etc. (2018-11-23 09:31:39 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (6):
      vim2m: use cancel_delayed_work_sync instead of flush_schedule_work
      adv*/tc358743/ths8200: fill in min width/height/pixelclock
      vb2: check memory model for VIDIOC_CREATE_BUFS
      MAINTAINERS fixups
      v4l2-tpg: array index could become negative
      vivid: free bitmap_cap when updating std/timings/etc.

 MAINTAINERS                                     | 10 ++++------
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   |  2 +-
 drivers/media/common/videobuf2/videobuf2-core.c |  3 +++
 drivers/media/i2c/ad9389b.c                     |  2 +-
 drivers/media/i2c/adv7511.c                     |  2 +-
 drivers/media/i2c/adv7604.c                     |  4 ++--
 drivers/media/i2c/adv7842.c                     |  4 ++--
 drivers/media/i2c/tc358743.c                    |  2 +-
 drivers/media/i2c/ths8200.c                     |  2 +-
 drivers/media/platform/vim2m.c                  |  3 ++-
 drivers/media/platform/vivid/vivid-vid-cap.c    |  2 ++
 11 files changed, 20 insertions(+), 16 deletions(-)
