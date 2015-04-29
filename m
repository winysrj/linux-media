Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26491 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbbD2KC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 06:02:59 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v5 00/11] HDMI CEC framework
Date: Wed, 29 Apr 2015 12:02:33 +0200
Message-id: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the fifth version of the HDMI CEC framework patches. All the
previous version have spun many discussions and quite a few changes.
Hopefully, in this version, the code of the framework matured and got
closer to meeting our requirements.

Again, thank you so much for all the discussion and comments. With your
help the code of the framework improved.

The major change is an introduction of a new special mode - the passthrough
mode. It might look that it is similar to the long gone promiscuous mode,
however its purpose is different. After the comment by Lars Op den Kamp,
we decided that it is necessary to introduce the passthrough mode. In this
mode the framework takes minimal part in handling CEC messages.

Why this mode is necessary? It turns out that handling of CEC communication
is very vendor specific. The libCEC library handles most of these vendor quirks
however it requires low level access to the messages on the CEC bus. In the
passthrough mode the messages are forwarded to the userspace with very little
handling by the kernel CEC framework.

Without passthrough enabled the kernel handles message replies etc. as defined
in the spec. This should work well with well-mannered systems that follow the
spec and have little vendor specific quirks.

Comments are welcome.

Best wishes,
Kamil Debski

Changes since v4
================
- add sequence numbering to transmitted messages
- add sequence number handling to event hanlding
- add passthrough mode
- change reserved field sizes
- fixed CEC version defines and addec CEC 2.0 commands
- add DocBook documentation

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

Background
==========

The work on a common CEC framework was started over three years ago by Hans
Verkuil. Unfortunately the work has stalled. As I have received the task of
creating a driver for the CEC interface module present on the Exynos range of
SoCs, I got in touch with Hans. He replied that the work stalled due to his
lack of time.

Original RFC by Hans Verkuil/Martin Bugge
=========================================
https://www.mail-archive.com/linux-media@vger.kernel.org/msg28735.html


Hans Verkuil (5):
  cec: add HDMI CEC framework
  v4l2-subdev: add HDMI CEC ops
  cec: adv7604: add cec support.
  cec: adv7511: add cec support.
  DocBook/media: add CEC documentation

Kamil Debski (6):
  dts: exynos4*: add HDMI CEC pin definition to pinctrl
  dts: exynos4: add node for the HDMI CEC device
  dts: exynos4412-odroid*: enable the HDMI CEC device
  HID: add HDMI CEC specific keycodes
  rc: Add HDMI CEC protoctol handling
  cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/media/Makefile               |    4 +-
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   74 ++
 Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 ++
 Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 ++
 .../DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml |  275 +++++
 .../DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml |   78 ++
 .../DocBook/media/v4l/cec-ioc-g-adap-state.xml     |   87 ++
 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml |  167 +++
 .../DocBook/media/v4l/cec-ioc-g-event.xml          |  142 +++
 .../DocBook/media/v4l/cec-ioc-g-vendor-id.xml      |   70 ++
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  185 +++
 Documentation/DocBook/media_api.tmpl               |    6 +-
 Documentation/cec.txt                              |  396 +++++++
 .../devicetree/bindings/media/s5p-cec.txt          |   33 +
 arch/arm/boot/dts/exynos4.dtsi                     |   12 +
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi          |    7 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    4 +
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |    7 +
 drivers/media/Kconfig                              |    6 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1200 ++++++++++++++++++++
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
 include/media/cec.h                                |  142 +++
 include/media/rc-core.h                            |    1 +
 include/media/rc-map.h                             |    5 +-
 include/media/v4l2-subdev.h                        |    8 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/cec.h                           |  337 ++++++
 include/uapi/linux/input.h                         |   12 +
 45 files changed, 4992 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
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

