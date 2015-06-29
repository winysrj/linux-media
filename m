Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:23304 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbF2KZt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:25:49 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: [PATCHv7 00/15] HDMI CEC framework
Date: Mon, 29 Jun 2015 12:14:45 +0200
Message-Id: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The seventh version of this patchset addresses comments on the mailing list
and many changes due to the work I did on the cec-compliance and cec-ctl
utilities (will be posted in a separate patch series). Please see the
changelog below for details.

Note: I have taken over from Kamil: he no longer had the time to work on this,
whereas I needed to get this working. Many thanks to Kamil for the work he did!

While this is now in pretty good shape, there are a few TO DOs left before it
can be merged:

- Support for CDC messages needs to be improved (wrapper functions are needed,
  and the 'reply' functionality isn't working at the moment).
- The documentation is out-of-sync and needs to be updated.
- I need to verify the current driver against the CEC 2.0 spec.
- Standby handling will need more work (should be a high-level callback, but I
  need to check which messages would cause the device to go out of standby).
- More testing.
- The CEC core currently stores physical addresses that were broadcast. But these
  are not yet communicated to userspace. I need to think about this (and how to
  handle similar broadcast messages).

Best regards,

	Hans

Changes since v6
================
- added cec-funcs.h to provide wrapper functions that fill in the cec_msg struct.
  This header is needed both by the kernel and by applications.
- fix a missing rc_unregister_device call.
- added CEC support for the adv7842 and cobalt drivers.
- added CEC operand defines. Rename CEC message defines to CEC_MSG_ and operand
  defines now use CEC_OP_.
- the CEC_VERSION defines are dropped since we now have the CEC_OP_VERSION defines.
- ditto: CEC_PRIM_DEVTYPE_ is now CEC_OP_PRIM_DEVTYPE.
- ditto: CEC_FL_ALL_DEVTYPE_ is now CEC_OP_ALL_DEVTYPE.
- cec-ioc-g-adap-log-addrs.xml: document cec_versions field.
- cec-ioc-g-caps.xml: drop vendor_id and version fields.
- add MAINTAINERS entry.
- add CDC support (not yet fully functional).
- add a second debug level for message debugging.
- fix a nasty kernel Oops in cec_transmit_msg while waiting for transmit completion
  (adap->tx_queue[idx].func wasn't set to NULL).
- add support for CEC_MSG_REPORT_FEATURES (CEC 2.0 only).
- correctly abort unsupported messages.
- add support for the device power status feature.
- add support for the audio return channel (preliminary).
- add support for the CDC hotplug message (preliminary).
- added osd_name to struct cec_log_addrs.
- reported physical addresses are stored internally.
- fix enabling/disabling the CEC adapter (internal fields weren't cleared correctly).
- zero reserved fields.
- return an error if you try to receive/transmit and the adapter isn't configured.
- when creating the adapter provide the owner module and the parent device.
- add a CEC_VENDOR_ID_NONE define to signal if no vendor ID was set.
- add new capabilities: RC (remote control), ARC (audio return channel) and CDC
  (Capability Discovery and Control).
- applications that want to handle messages for a logical address need to set the
  CEC_LOG_ADDRS_FL_HANDLE_MSGS flag. Otherwise the CEC core will be the one handling
  all messages.
- Each logical address has its own all_device_types value. So this should be an array,
  not a single value.
- I'm sure I've forgotten some changes...

Changes since v5
================
- drop struct cec_timeval in favour of a __u64 that keeps the timestamp in ns
- remove userspace documentation from Documentation/cec.txt as userspace API
  is described in the DocBook
- add missing documentation for the passthrough mode to the DocBook
- add information about the number of events that can be queued
- fix misspelling of reply
- fix behaviour of posting an event in cec_received_msg, such that the behaviour
  is consistent with the documentation

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


Hans Verkuil (9):
  input.h: add BUS_CEC type
  cec: add HDMI CEC framework
  cec.txt: add CEC framework documentation
  DocBook/media: add CEC documentation
  v4l2-subdev: add HDMI CEC ops
  cec: adv7604: add cec support.
  adv7842: add cec support
  cec: adv7511: add cec support.
  cobalt: add cec support

Kamil Debski (6):
  dts: exynos4*: add HDMI CEC pin definition to pinctrl
  dts: exynos4: add node for the HDMI CEC device
  dts: exynos4412-odroid*: enable the HDMI CEC device
  HID: add HDMI CEC specific keycodes
  rc: Add HDMI CEC protocol handling
  cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/media/Makefile               |    2 +
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   74 +
 Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 +
 Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 ++
 .../DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml |  299 ++++
 .../DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml |   78 +
 .../DocBook/media/v4l/cec-ioc-g-adap-state.xml     |   87 ++
 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml |  138 ++
 .../DocBook/media/v4l/cec-ioc-g-event.xml          |  125 ++
 .../DocBook/media/v4l/cec-ioc-g-passthrough.xml    |   88 ++
 .../DocBook/media/v4l/cec-ioc-g-vendor-id.xml      |   70 +
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  185 +++
 Documentation/DocBook/media_api.tmpl               |    8 +-
 Documentation/cec.txt                              |  166 ++
 .../devicetree/bindings/media/s5p-cec.txt          |   31 +
 MAINTAINERS                                        |   11 +
 arch/arm/boot/dts/exynos4.dtsi                     |   12 +
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi          |    7 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    4 +
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |    7 +
 drivers/media/Kconfig                              |    6 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec.c                                | 1580 ++++++++++++++++++++
 drivers/media/i2c/adv7511.c                        |  350 ++++-
 drivers/media/i2c/adv7604.c                        |  219 ++-
 drivers/media/i2c/adv7842.c                        |  211 ++-
 drivers/media/pci/cobalt/cobalt-driver.c           |   37 +-
 drivers/media/pci/cobalt/cobalt-driver.h           |    2 +
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  110 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    2 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 +++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  283 ++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |   76 +
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-cec.c                  |  144 ++
 drivers/media/rc/rc-main.c                         |    1 +
 include/media/adv7511.h                            |    6 +-
 include/media/cec.h                                |  161 ++
 include/media/rc-core.h                            |    1 +
 include/media/rc-map.h                             |    5 +-
 include/media/v4l2-subdev.h                        |    9 +
 include/uapi/linux/Kbuild                          |    2 +
 include/uapi/linux/cec-funcs.h                     | 1516 +++++++++++++++++++
 include/uapi/linux/cec.h                           |  709 +++++++++
 include/uapi/linux/input.h                         |   13 +
 52 files changed, 7485 insertions(+), 30 deletions(-)
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
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-passthrough.xml
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
 create mode 100644 include/uapi/linux/cec-funcs.h
 create mode 100644 include/uapi/linux/cec.h

-- 
2.1.4

