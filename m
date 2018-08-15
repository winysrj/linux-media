Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58213 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbeHOQdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCHv2 0/5] Handling of reduced FPS in V4L2
Date: Wed, 15 Aug 2018 15:40:51 +0200
Message-Id: <20180815134056.98830-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is a v2 patch series of an old patch series from Jose:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg110275.html

It's rebased, I updated the documentation and implemented this for
the adv7842 which is one of the very few receivers that can detect
the received pixelclock frequency with sufficient precision to tell
the difference between 60 and 59.94 Hz.

I also verified that the adv7604 definitely can NOT do this.

Back in March 2017 I promised Jose that I would test this on my
setup with a cobalt driver and an adv7842 receiver 'within a week'.
Hmmm... Let's just say: better late than never.

Regards,

	Hans

Hans Verkuil (2):
  vidioc-g-dv-timings.rst: document V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
  adv7842: enable reduced fps detection

Jose Abreu (3):
  videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
  v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
  cobalt: Use v4l2_calc_timeperframe helper

 .../media/uapi/v4l/vidioc-g-dv-timings.rst    | 27 +++++++++----
 drivers/media/i2c/adv7842.c                   |  9 +++++
 drivers/media/pci/cobalt/cobalt-v4l2.c        |  9 ++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 39 +++++++++++++++++++
 include/media/v4l2-dv-timings.h               | 11 ++++++
 include/uapi/linux/videodev2.h                |  7 ++++
 6 files changed, 92 insertions(+), 10 deletions(-)

-- 
2.18.0
