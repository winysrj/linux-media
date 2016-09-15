Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44811 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753705AbcIOPsu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 11:48:50 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id 2A04918021F
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 17:48:45 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add SPI GS1662 driver
Message-ID: <be2252fc-1059-d829-bab6-e7fa6e219fed@xs4all.nl>
Date: Thu, 15 Sep 2016 17:48:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git gs1662

for you to fetch changes up to ec2890fd887f9ec68b6e1b87ead84ea659cee0c7:

  media Kconfig: improve the spi integration (2016-09-15 17:34:33 +0200)

----------------------------------------------------------------
Charles-Antoine Couret (3):
      SDI: add flag for SDI formats and SMPTE 125M definition
      Add GS1662 driver, a video serializer
      V4L2: Add documentation for SDI timings and related flags

Hans Verkuil (1):
      media Kconfig: improve the spi integration

 Documentation/media/uapi/v4l/vidioc-enuminput.rst    |  31 +++--
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst |  15 +++
 MAINTAINERS                                          |   7 ++
 drivers/media/Kconfig                                |   7 +-
 drivers/media/Makefile                               |   2 +-
 drivers/media/i2c/Kconfig                            |   2 +-
 drivers/media/spi/Kconfig                            |  14 +++
 drivers/media/spi/Makefile                           |   1 +
 drivers/media/spi/gs1662.c                           | 472 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c            |  11 +-
 include/uapi/linux/v4l2-dv-timings.h                 |  12 ++
 include/uapi/linux/videodev2.h                       |   8 ++
 12 files changed, 566 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/gs1662.c
