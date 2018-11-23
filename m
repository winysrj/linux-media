Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42431 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390006AbeKWTMj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 14:12:39 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21 v2] Various fixes
Message-ID: <56ee9942-8afb-0456-80a2-757f83618fe8@xs4all.nl>
Date: Fri, 23 Nov 2018 09:29:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(fixed up my SoB mess)

Just one note: the "cec: keep track of outstanding transmits" is CC-ed to stable
for v4.18 and up, but I prefer to wait until v4.21 before merging it to give it
more test time. It is not something that happens in normal usage, so delaying
this isn't a problem.

Regards,

	Hans

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21a2

for you to fetch changes up to 9001e4d520f11d344f10092d3217156ec10c6934:

  vivid: fill in media_device bus_info (2018-11-23 09:26:54 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (7):
      adv7604: add CEC support for adv7611/adv7612
      cec: report Vendor ID after initialization
      cec: add debug_phys_addr module option
      cec: keep track of outstanding transmits
      vivid: fix error handling of kthread_run
      vivid: set min width/height to a value > 0
      vivid: fill in media_device bus_info

Julia Lawall (4):
      media: vicodec: constify v4l2_ctrl_ops structure
      media: rockchip/rga: constify v4l2_m2m_ops structure
      media: vimc: constify structures stored in fields of v4l2_subdev_ops structure
      media: rockchip/rga: constify video_device structure

Sean Young (1):
      media: v4l uapi docs: few minor corrections and typos

 Documentation/media/uapi/v4l/app-pri.rst         |  2 +-
 Documentation/media/uapi/v4l/audio.rst           |  2 +-
 Documentation/media/uapi/v4l/dev-capture.rst     |  2 +-
 Documentation/media/uapi/v4l/dev-teletext.rst    |  2 +-
 Documentation/media/uapi/v4l/format.rst          |  2 +-
 Documentation/media/uapi/v4l/mmap.rst            | 22 +++++++++----------
 Documentation/media/uapi/v4l/open.rst            |  2 +-
 Documentation/media/uapi/v4l/tuner.rst           |  4 ++--
 Documentation/media/uapi/v4l/userp.rst           |  8 +++----
 Documentation/media/uapi/v4l/video.rst           |  4 ++--
 drivers/media/cec/cec-adap.c                     | 34 ++++++++++++++++++++++--------
 drivers/media/cec/cec-core.c                     |  6 ++++++
 drivers/media/i2c/adv7604.c                      | 63 ++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/platform/rockchip/rga/rga.c        |  4 ++--
 drivers/media/platform/vicodec/vicodec-core.c    |  2 +-
 drivers/media/platform/vimc/vimc-sensor.c        |  2 +-
 drivers/media/platform/vivid/vivid-core.c        |  2 ++
 drivers/media/platform/vivid/vivid-kthread-cap.c |  5 ++++-
 drivers/media/platform/vivid/vivid-kthread-out.c |  5 ++++-
 drivers/media/platform/vivid/vivid-vid-common.c  |  2 +-
 include/media/cec.h                              |  1 +
 21 files changed, 125 insertions(+), 51 deletions(-)
