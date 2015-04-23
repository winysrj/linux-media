Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:15042 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbDWND1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 09:03:27 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 00/10] HDMI CEC framework
Date: Thu, 23 Apr 2015 15:03:03 +0200
Message-id: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the fourth version of the HDMI CEC framework. I would like to thank
for all the comments and suggestions to the previous versions of this patch.
I believe that the code has matured enough to be tagged as PATCH and not RFC
as in previous version.

This patchset is base on the linux-next tree. I believe that there will be
some comments to it and there will be some things to fix, hence I am sending
this version now. The next version with appropriate fixes will be based on the
next RC (which I guess will be released soon).

The promiscuous mode included in the previous version caused some discussion and
I decided to drop it. In my opinion it can be useful for debugging, but on the
other hand I believe it can be easily added at a later time, if appropriate.

Best wishes,
Kamil Debski

Changes since v3
================
- remove the promiscuous mode
- rewrite the devicetree patches
- fixes, expansion and partial rewrite of the documentation
- reorder of API structures and addition of reserved fields
- use own struct to report time (32/64 bit safe)
- fix of handling events
- add cec.h to include/uapi/linux/Kbuild
- fixes in the adv76xx driver (add missing methods, change adv7604 to adv76xx)
- cleanup of debug messages in s5p-cec driver
- remove non necessary claiming of a gpio in the s5p-cec driver
- cleanup headers of the s5p-cec driver

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
SoCs, I got in touch with Hans. He replied that the work stalled due to his
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

Hans Verkuil (4):
  cec: add HDMI CEC framework
  v4l2-subdev: add HDMI CEC ops
  cec: adv7604: add cec support.
  cec: adv7511: add cec support.

Kamil Debski (6):
  dts: exynos4*: add HDMI CEC pin definition to pinctrl
  dts: exynos4: add node for the HDMI CEC device
  dts: exynos4412-odroid*: enable the HDMI CEC device
  HID: add HDMI CEC specific keycodes
  rc: Add HDMI CEC protoctol handling
  cec: s5p-cec: Add s5p-cec driver

 Documentation/cec.txt                              |  396 +++++++
 .../devicetree/bindings/media/s5p-cec.txt          |   33 +
 arch/arm/boot/dts/exynos4.dtsi                     |   12 +
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi          |    7 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    4 +
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |    7 +
 drivers/media/Kconfig                              |    6 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1161 ++++++++++++++++++++
 drivers/media/i2c/adv7511.c                        |  347 +++++-
 drivers/media/i2c/adv7604.c                        |  207 +++-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    4 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  283 +++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |   76 ++
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-cec.c                  |  144 +++
 drivers/media/rc/rc-main.c                         |    1 +
 include/media/adv7511.h                            |    6 +-
 include/media/cec.h                                |  140 +++
 include/media/rc-core.h                            |    1 +
 include/media/rc-map.h                             |    5 +-
 include/media/v4l2-subdev.h                        |    8 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/cec.h                           |  303 +++++
 include/uapi/linux/input.h                         |   12 +
 30 files changed, 3507 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/s5p-cec.txt
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

