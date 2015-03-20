Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19142 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbCTQxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 12:53:17 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: [RFC v3 0/9] HDMI CEC framework
Date: Fri, 20 Mar 2015 17:52:34 +0100
Message-id: <1426870363-18839-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First of all - thank you so much for your comments to the two previous versions
of this RFC. This is the third version of the HDMI CEC framework patches.

In this version I have introduced a promiscuous mode in which all messages are
forwarded to the userspace. This is independent of parsing of the messages,
thus the key codes will be interpreted and sent as input events. This mode can
be used to eavesdrop on the messages transferred on the bus. This can be used
for e.g. to debug or listen look how other hardware communicates over the bus.

The original cover letter follows the changes summary.

Changes since v2
===============-
- added promiscuous mode
- added new key codes to the input framework
- add vendor ID reporting
- add the possibility to clear assigned logical addresses
- cleanup of the rc cec map

Changes since v1
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

Kamil Debski (6):
  dts: add hdmi-cec to to pinctrl definitions
  dts: add s5p-cec to exynos4412-odroidu3
  Input: add key codes specific to the HDMI CEC bus
  rc: add a map for devices communicating over the HDMI CEC bus
  cec: add new driver for cec support.
  s5p-cec: Add s5p-cec driver

 Documentation/cec.txt                              |  321 ++++++
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    7 +
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |   13 +
 drivers/media/Kconfig                              |    6 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1158 ++++++++++++++++++++
 drivers/media/i2c/adv7511.c                        |  325 +++++-
 drivers/media/i2c/adv7604.c                        |  182 +++
 drivers/media/platform/Kconfig                     |    7 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    4 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  290 +++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |  113 ++
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-cec.c                  |  144 +++
 drivers/media/rc/rc-main.c                         |    1 +
 include/media/adv7511.h                            |    6 +-
 include/media/cec.h                                |  137 +++
 include/media/rc-core.h                            |    1 +
 include/media/rc-map.h                             |    5 +-
 include/media/v4l2-subdev.h                        |    8 +
 include/uapi/linux/cec.h                           |  283 +++++
 include/uapi/linux/input.h                         |   12 +
 26 files changed, 3359 insertions(+), 9 deletions(-)
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

