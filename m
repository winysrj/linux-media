Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38027 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbcD2Nwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 09:52:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk
Subject: [PATCHv16 00/13] HDMI CEC framework
Date: Fri, 29 Apr 2016 15:52:15 +0200
Message-Id: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

The sixteenth version of this patchset does some final cleanup and
I'll post a pull request on the linux-media list for this patch series.

At first I didn't want to post a v16 at all, but there were just a bit
too many changes, even though each change itself was trivial.

While the pull request will be for 4.7 I think it is more likely that
it will end up in 4.8 given how late we are in the 4.7 cycle.

I dropped the RFC patches for the pulse8 and ARC/CDC support since those
aren't ready for mainlining. Same for the omap4 support patches I posted
today.

See the changelog below for more details.

The cec-ctl and cec-compliance utilities used to test the CEC framework
can be found here:
  
http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=cec

Best regards,

        Hans

Changes since v15
=================

- Properly document cec-edid.h
- Fix various sparse/smatch warnings
- Fixed several DocBook issues
- Fixed incorrect return values in the adv drivers that caused an
  otherwise harmless WARN_ON.

Changes since v14
=================
- Dropped the Samsung dts patches, these will go in via the samsung tree.
- CEC_LOG_STATUS is replaced by a debugfs status file.
- Dropped the reserved fields in the API, use versioning instead. Two
  flags field were added instead.
- Extended cec_caps with a version field.
- Dropped CEC_CAP_IS_SOURCE as it is not needed in practice.
- The adv drivers now create the CEC adapter themselves instead of leaving
  that to the bridge. It greatly simplifies the code and it was really a
  left-over from the early days of the framework.
- The CEC implementation of the adv drivers is now configured through
  a separate config option. CEC is an optional HDMI feature and you may not
  want to compile this in if your hardware hasn't hooked up the CEC pin.
- The EDID CEC helper functions have been split off into their own cec-edid
  module. You likely need them even if MEDIA_CEC is not set.
- Added missing copyright statements.
- Added RFC code for the pulse-eight USB CEC adapter.

Changes since v13
=================
- Removed CEC_CAP_STATE and _VENDOR_ID
- Removed CEC_ADAP_G/S_STATE and CEC_ADAP_G/S_VENDOR_ID
- Add vendor_id to struct cec_log_addrs
- CEC_EVENT_STATE_CHANGE now reports the physical address, the logical
  address mask and the logical address type mask.
- Add the logical address mask and the logical address type mask to
  struct cec_log_addrs.
- Dropped cec_enable, instead enable/disable the adapter based on the
  physical address.
- Once a valid physical address is available and userspace or driver
  specified the requested logical address configuration the framework
  will automatically claim the needed logical addresses. It will retry
  the last used addresses first, as per the recommendation in the CEC
  specification.
- Dropped CEC power status handling: it's not clear if the kernel should
  handle that, and if it has to, whether this is the correct way.
- Dropped CEC_EVENT_PHYS_ADDR_CHANGE, this is now handled by
  CEC_EVENT_STATE_CHANGE.
- Add helper functions for manipulating physical addresses.
- Updated documentation.
- Dropped ninputs field in struct cec_caps.
- Dropped CEC_EVENT_INPUTS_CHANGE, was never used and it is unclear if it
  is needed.

Changes since v12
=================
- Added driver and name fields to the cec_caps struct. Without this it was
  very difficult to tell CEC adapters apart in a human readable manner.
- Renamed CEC_CAP_IO to CEC_CAP_TRANSMIT, which better describes this
  capability. 
- Added the CEC_ADAP_LOG_STATUS to log the current status of the CEC adapter.
  Very useful when debugging.
- Added comments to the cec.c source.
- Added a timeout when waiting for a transmit to finish. Without the timeout
  the state machine could lock up when dealing with broken CEC adapter drivers
  or just unlucky situations.
- Commenting the code also found a number of bugs which have been fixed.
- Trying to poll yourself is now handled by the framework since different
  hardware would give different results. The framework will just NACK it.
- Disabling the CEC adapter doesn't clear the physical address anymore.
  This turned out to be quite painful for applications.
- Merged the CLAIM/RELEASE, G/S_MONITOR and G_PASSTHROUGH ioctls into two
  G/S_MODE ioctls. This allows you to tell the driver which initiator and
  follower modes you want, and greatly simplifies how these modes are
  handled.

Changes since v11
=================
- Add a new CEC_EVENT_PHYS_ADDR_CHANGED to report when the physical address
  of the CEC adapter changes. Since the physical address is obtained from the
  EDID the application has to be informed when the kernel (or userspace for
  that matter) sets that.
- Add a new internal cec_set_phys_addr() function to change the physical
  address and post the event.
- Modified the retry-transmit mechanism: the framework will do the retry if
  the low-level driver returns a TX_STATUS error, but does not set the
  CEC_TX_STATUS_MAX_RETRIES status bit. In that case the framework assumes
  that there is no hardware retry and it will retry itself. This used to be
  through the 'retries' pointer argument (set to 0 if there is no retry support)
  but that doesn't work for hardware that does retry for some error conditions
  but not for others.
- Added the missing CEC_TX_STATUS_LOW_DRIVE bit and low_drive_cnt error counter.
  I missed that potential CEC bus error condition.
- By passing a NULL pointer to cec_claim_log_addrs() drivers can clear the
  logical addresses.
- When a source loses the HPD the source has to clear the logical addresses
  and update its physical address. Implement this in the cobalt driver.
- Improve tx_status handling in the various low-level drivers.

Changes since v10
=================
- Split the msg.status field into tx_status and rx_status.
- Add counters for various CEC protocol errors that can occur during
  transmit.
- Add tx_status bits for the ARB_LOST and NACK status and add a generic
  CEC_TX_STATUS_ERROR bit.
- Add retry support to the CEC framework for hardware that does not have
  retry support.
- Improve event handling: on open() generate events that report the initial
  CEC adapter status and the number of connected inputs. Also ensure that
  you never loose important events (intermediate events may be lost, but
  never the last event). The basic mechanism has been taken from the V4L2
  event implementation which works very well.
- CEC emulation support was added to vivid which makes it much easier to
  test CEC applications without having hardware present.
- Improve handling of timings and timeouts in the cec framework.
- Improve locking.
- Fixed buggy rc cleanup.
- All CEC messages are now fully supported in cec-funcs.h (specifically
  handling of UI Commands and short audio descriptors).

Changes since v9
================
- Updated cec.txt
- Added a promiscuous capability to signal those adapters that can monitor
  all CEC traffic, not just directed and broadcast messages. I have one
  adapter that can do this. Added code in the framework to handle such
  messages correctly.
- The status field is now value and no longer a bitmask.
- Renamed the kernel config from CEC to MEDIA_CEC
- The adap_transmit() callback now has a retries argument.
- Use the new CEC_MAX_MSG_SIZE define instead of hardcoding it as 16
- Add support to wait for a reply after a broadcast message: this was
  forbidden, but it is a valid use-case.
- Make sure you can't send a message to yourself.
- Waiting for a transmit to succeed would never timeout (and couldn't be
  interrupted). Fixed.
- The message status was not updated correctly if it was CEC_MSG_FEATURE_ABORTed.
- Fixed a nasty kernel oops when deleting a cec adapter.
- Removed the owner check: the module owner is NULL if it is compiled into
  the kernel instead of as a module.
- Added separate register/unregister calls: this is safer and actually made
  it possible to drop the ugly 'cec_ready' v4l2_subdev op. Suggested by
  Russell, and that was a good idea.
- Added missing support for 32-bit to 64-bit ioctl conversion.
- Move the v4l2_subdev cec ops into a v4l2_subdev_cec_ops struct.

Changes since v8
================
- Addressed the comments Russell King made about how the cec character
  devices should be allocated/freed.
- Updated the DocBook documentation.

Changes since v7
================

- I thought that the core thread could handle out-of-order messages, but that
  turned out to be wrong. After careful analysis I realized that I had to
  rewrite this part in cec.c in order to make it work.
- Added new CEC-specific keys to input.h and use them in the CEC rc keymap.
  Replaced KEY_PLAY/PAUSE/STOP with KEY_PLAYCD/PAUSECD/STOPCD to clarify that
  these are media operations and not the Pause key on the keyboard.
- Added CEC_PHYS_ADDR_INVALID (0xffff)
- Added monitor support to monitor CEC traffic
- Replaced CAP_TRANSMIT and CAP_RECEIVE by a single CAP_IO.
- Replaced CAP_CDC by CAP_CDC_HPD since this only applies to the HPD part of
  the CDC messages.
- Add CAP_IS_SOURCE.
- Add ninputs field to cec_caps to export the number of inputs of the device.
- Drop CEC_LOG_ADDRS_FL_HANDLE_MSGS and the flags field (see next change for
  more info).
- Add CEC_CLAIM and CEC_RELEASE to explicitly start/stop processing CEC messages.
  This also implies ownership of the CEC interface, so other filehandles can
  only receive but not transmit.
- Reworked event handling: report adapter state changes, input changes and
  if the message receive queue is full.
- cec-funcs.h: added CDC HEC support.
- Renamed G/S_ADAP ioctls to ADAP_G/S: this made it clearer which ioctls deal
  with the adapter configuration and which deal with CEC messages/events.
- Clarified which CEC messages are passed on to userspace and which aren't.
  Specifically if CAP_ARC is set, then all ARC messages are handled by the kernel.
  If CAP_CDC_HPD is set, then all CDC hotplug messages are handled by the kernel.
  Otherwise these messages are passed on to userspace.

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


Hans Verkuil (10):
  input.h: add BUS_CEC type
  cec: add HDMI CEC framework
  cec/TODO: add TODO file so we know why this is still in staging
  cec: add compat32 ioctl support
  cec.txt: add CEC framework documentation
  DocBook/media: add CEC documentation
  cec: adv7604: add cec support.
  cec: adv7842: add cec support
  cec: adv7511: add cec support.
  vivid: add CEC emulation

Kamil Debski (3):
  HID: add HDMI CEC specific keycodes
  rc: Add HDMI CEC protocol handling
  cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/device-drivers.tmpl          |    4 +
 Documentation/DocBook/media/Makefile               |    2 +
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   72 +
 Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 +
 Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 +
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 +
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  140 ++
 .../DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  324 +++
 .../DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   82 +
 .../DocBook/media/v4l/cec-ioc-dqevent.xml          |  190 ++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml |  245 ++
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  260 ++
 Documentation/DocBook/media_api.tmpl               |    6 +-
 Documentation/cec.txt                              |  267 +++
 .../devicetree/bindings/media/s5p-cec.txt          |   31 +
 Documentation/video4linux/vivid.txt                |   36 +-
 MAINTAINERS                                        |   23 +
 drivers/media/Kconfig                              |    3 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec-edid.c                           |  139 ++
 drivers/media/i2c/Kconfig                          |   27 +
 drivers/media/i2c/adv7511.c                        |  401 +++-
 drivers/media/i2c/adv7604.c                        |  332 ++-
 drivers/media/i2c/adv7842.c                        |  368 ++-
 drivers/media/platform/Kconfig                     |   11 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    2 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   38 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  209 ++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 +
 drivers/media/platform/s5p-cec/s5p_cec.c           |  295 +++
 drivers/media/platform/s5p-cec/s5p_cec.h           |   76 +
 drivers/media/platform/vivid/Kconfig               |    9 +
 drivers/media/platform/vivid/Makefile              |    4 +
 drivers/media/platform/vivid/vivid-cec.c           |  254 ++
 drivers/media/platform/vivid/vivid-cec.h           |   33 +
 drivers/media/platform/vivid/vivid-core.c          |  119 +-
 drivers/media/platform/vivid/vivid-core.h          |   27 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   11 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   23 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    7 +
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-cec.c                  |  174 ++
 drivers/media/rc/rc-main.c                         |    1 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/cec/Kconfig                  |    8 +
 drivers/staging/media/cec/Makefile                 |    1 +
 drivers/staging/media/cec/TODO                     |   13 +
 drivers/staging/media/cec/cec.c                    | 2481 ++++++++++++++++++++
 fs/compat_ioctl.c                                  |   12 +
 include/linux/cec-funcs.h                          | 1871 +++++++++++++++
 include/linux/cec.h                                |  985 ++++++++
 include/media/cec-edid.h                           |  103 +
 include/media/cec.h                                |  236 ++
 include/media/i2c/adv7511.h                        |    6 +-
 include/media/rc-map.h                             |    5 +-
 include/uapi/linux/input-event-codes.h             |   30 +
 include/uapi/linux/input.h                         |    1 +
 61 files changed, 10296 insertions(+), 129 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
 create mode 100644 Documentation/cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/s5p-cec.txt
 create mode 100644 drivers/media/cec-edid.c
 create mode 100644 drivers/media/platform/s5p-cec/Makefile
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h
 create mode 100644 drivers/media/platform/vivid/vivid-cec.c
 create mode 100644 drivers/media/platform/vivid/vivid-cec.h
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
 create mode 100644 drivers/staging/media/cec/Kconfig
 create mode 100644 drivers/staging/media/cec/Makefile
 create mode 100644 drivers/staging/media/cec/TODO
 create mode 100644 drivers/staging/media/cec/cec.c
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h
 create mode 100644 include/media/cec-edid.h
 create mode 100644 include/media/cec.h

-- 
2.8.1

