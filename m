Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:42640 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727359AbeH3S7C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 14:59:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Add detection of reduced FPS
Message-ID: <2c6a5a23-77e4-aae2-82e7-aeaf894d6aff@xs4all.nl>
Date: Thu, 30 Aug 2018 16:56:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some HDMI receivers are able to tell the difference between 59.94 and 60 Hz,
but there was no way to expose that to userspace.

Add the V4L2_DV_FL_CAN_DETECT_REDUCED_FPS flag and allow receivers to set
the V4L2_DV_FL_REDUCED_FPS if they detect this.

Implemented and tested this with the adv7842, which is one of the rare
receivers that is accurate enough.

This pull request contains the v2 patch series:

https://www.spinics.net/lists/linux-media/msg139144.html

It's just rebased to 4.19.

Regards,

	Hans

The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:

  media: camss: add missing includes (2018-08-29 14:02:06 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git reduced-fps

for you to fetch changes up to 80cc532774debbef408b105ddcbae05114bce5f3:

  adv7842: enable reduced fps detection (2018-08-30 16:51:08 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      vidioc-g-dv-timings.rst: document V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
      adv7842: enable reduced fps detection

Jose Abreu (3):
      videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
      v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
      cobalt: Use v4l2_calc_timeperframe helper

 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst | 27 +++++++++++++++++++--------
 drivers/media/i2c/adv7842.c                          |  9 +++++++++
 drivers/media/pci/cobalt/cobalt-v4l2.c               |  9 +++++++--
 drivers/media/v4l2-core/v4l2-dv-timings.c            | 39 +++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h                      | 11 +++++++++++
 include/uapi/linux/videodev2.h                       |  7 +++++++
 6 files changed, 92 insertions(+), 10 deletions(-)
