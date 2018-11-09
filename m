Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:34398 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbeKJAS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 19:18:27 -0500
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTPSA id wA9EbX6C011321
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-media@vger.kernel.org>; Fri, 9 Nov 2018 14:37:34 GMT
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.21] Various fixes
Message-ID: <728ac8e5-26e0-c613-489d-9fc2eacd8c5b@cisco.com>
Date: Fri, 9 Nov 2018 15:37:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes, mostly related to issues found by syzbot.

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21b

for you to fetch changes up to d0783331c8aa9074e8235ea6d7e73e7010450d90:

  vivid: free bitmap_cap when updating std/timings/etc. (2018-11-09 15:29:13 +0100)

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
