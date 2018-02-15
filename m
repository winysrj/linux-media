Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44682 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1163046AbeBOSbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 13:31:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Add tda1997x.c
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Tim Harvey <tharvey@gateworks.com>
Message-ID: <80317de5-c7d1-600d-2851-fb4ba8227aaa@xs4all.nl>
Date: Thu, 15 Feb 2018 19:31:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull requests adds the new tda1997x HDMI receiver.

Regards,

	Hans

The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tda

for you to fetch changes up to feecd372500a8470d68a4320996201e47b0f19f9:

  media: i2c: Add TDA1997x HDMI receiver driver (2018-02-15 19:25:54 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-dv-timings: add v4l2_hdmi_colorimetry()

Tim Harvey (5):
      media: v4l-ioctl: fix clearing pad for VIDIOC_DV_TIMINGS_CAP
      media: add digital video decoder entity functions
      MAINTAINERS: add entry for NXP TDA1997x driver
      media: dt-bindings: Add bindings for TDA1997X
      media: i2c: Add TDA1997x HDMI receiver driver

 Documentation/devicetree/bindings/media/i2c/tda1997x.txt |  178 +++
 Documentation/media/uapi/mediactl/media-types.rst        |   11 +
 MAINTAINERS                                              |    8 +
 drivers/media/i2c/Kconfig                                |    9 +
 drivers/media/i2c/Makefile                               |    1 +
 drivers/media/i2c/tda1997x.c                             | 2820 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tda1997x_regs.h                        |  641 +++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c                |  141 +++
 drivers/media/v4l2-core/v4l2-ioctl.c                     |    2 +-
 include/dt-bindings/media/tda1997x.h                     |   74 ++
 include/media/i2c/tda1997x.h                             |   42 +
 include/media/v4l2-dv-timings.h                          |   21 +
 include/uapi/linux/media.h                               |    5 +
 13 files changed, 3952 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 drivers/media/i2c/tda1997x.c
 create mode 100644 drivers/media/i2c/tda1997x_regs.h
 create mode 100644 include/dt-bindings/media/tda1997x.h
 create mode 100644 include/media/i2c/tda1997x.h
