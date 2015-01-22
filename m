Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39719 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbbAVQE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:04:59 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIL00MWD608YP50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jan 2015 01:04:56 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org
Subject: [RFC v2 0/7] HDMI CEC framework
Date: Thu, 22 Jan 2015 17:04:32 +0100
Message-id: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the second version of my attempt at the CEC framework patches.
As mentioned in the previous cover letter the original work was done by
Hans Verkuil, but he was short of time and the CEC framework was stalled
for some time. The original cover letter attached below will surely shed
more light on the history of these patches.

Thank you very much for your comments to the v1 . It was near the end of the
year when I sent the previous version, so I really appreciate your time.

Apart from fixes and additions to the documentation this version of the RFC
tackles the subject of processing the key down/up from the remote. To make
the solution most flexible there are two modes. In the default the mesages
related to key presses on the remote are parsed and handled by the CEC
framework. In the pass-through mode the key down/up messages are not handled
by the CEC framewrok and are passed to the userspace. The mode can be changed by
an appropriate ioctl. I would especially welcome comment to the CEC keymap.

Best wishes,
Kamil Debski

Changes since v2
================
- documentation edited and moved to the Documentation folder
- added key up/down message handling
- add missing CEC commands to the cec.h file

Original cover letter
=====================

Hi,

The work on a common CEC framework was started over three years ago by Hans
Verkuil. Unfortunately the work has stalled. As I have received the task of
creating a driver for the CEC interface module present on the Exynos range of
SoCs, I got in touch with Hans. He repied that the work stalled due to his
lack of time.

The driver was done in the most part and there were only minor fixes that needed
to be implemented. I would like to bring back the discussion on a common CEC
interface framework.

There are a few things that were still left as TODO, I think they might need
some discussion - for instance the way how the remote controls should be
handled.

Best wishes,
Kamil Debski

Original RFC by Hans Verkuil/Martin Bugge
=========================================
https://www.mail-archive.com/linux-media@vger.kernel.org/msg28735.html

Hans Verkuil (3):
  v4l2-subdev: add cec ops.
  adv7604: add cec support.
  adv7511: add cec support.

Kamil Debski (4):
  ARM: dts: add hdmi cec driver to exynos4412-odroidu3
  media: rc: Add cec protocol handling
  cec: add new framework for cec support.
  s5p-cec: Add s5p-cec driver

 Documentation/cec.txt                              |  318 ++++++
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    7 +
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |   13 +
 drivers/media/Kconfig                              |    5 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1111 ++++++++++++++++++++
 drivers/media/i2c/adv7511.c                        |  325 +++++-
 drivers/media/i2c/adv7604.c                        |  182 ++++
 drivers/media/platform/Kconfig                     |    7 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    4 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  290 +++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |  113 ++
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-cec.c                  |  133 +++
 drivers/media/rc/rc-main.c                         |    1 +
 include/media/adv7511.h                            |    6 +-
 include/media/cec.h                                |  136 +++
 include/media/rc-core.h                            |    1 +
 include/media/rc-map.h                             |    5 +-
 include/media/v4l2-subdev.h                        |    8 +
 include/uapi/linux/cec.h                           |  276 +++++
 25 files changed, 3277 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/cec.txt
 create mode 100644 drivers/media/cec.c
 create mode 100644 drivers/media/platform/s5p-cec/Makefile
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
 create mode 100644 include/media/cec.h
 create mode 100644 include/uapi/linux/cec.h

-- 
1.7.9.5

