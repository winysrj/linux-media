Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47837 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753530AbdBUUnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:46 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 00/19] Teach lirc how to send and receive scancodes
Date: Tue, 21 Feb 2017 20:43:24 +0000
Message-Id: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series has some general cleanup work, then the lirc scancode
interface (v2) and lirc documentation fixes. The cleanups are needed for
the new scancode interface.

lirc already supports LIRC_MODE_LIRCCODE, but that mode is entirely
driver dependant and makes no provision for protocol information.

Receiving LIRC_MODE_SCANCODE
----------------------------
If a lirc device has the LIRC_CAN_REC_SCANCODE feature, LIRC_MODE_SCANCODE
can be set set using LIRC_SET_REC_MODE ioctl. Now when you read from the
device you receive struct lirc_scancode. In this structure you have
the scancode, rc_type, and flags. RC_TYPE_* is now in uapi, so now you
can see exactly which protocol variant was used. flags might contain
LIRC_SCANCODE_FLAGS_TOGGLE (rc5, rc6) or LIRC_SCANCODE_FLAGS_REPEAT (nec).

Using this interface, you can see what IR protocol a remote is using. This
was not easy to do before.

Sending LIRC_MODE_SCANCODE
--------------------------
If a lirc device has the LIRC_CAN_SEND_SCANCODE features, LIRC_MODE_SCANCODE
can be set using the LIRC_SET_SEND_MODE ioctl. Now you can write
struct lirc_scancode. flags should be 0, rc_type to the RC_TYPE_* and
the scancode must be set. You can only tranmsit one lirc_scancode at a time.

This interface uses the in-kernel IR encoders to work. Using this interface
it will be possible to port lirc_zilog to rc-core. This device cannot send
raw IR, so it will not use the IR encoders but provide the same userspace
interface.

Other user-visible changes
--------------------------
Now all RC devices will have a lirc char device, including devices which
do not produce raw IR. They will be fixed in mode LIRC_MODE_SCANCODE.

Changes v1 -> v2:
 - changed the scancode to 64 bit. There are many IR protocols which encode
   more than 32 bits; we don't support any at the moment but might as 
   well future-proof it
   http://www.hifi-remote.com/wiki/index.php?title=DecodeIR
 - Various small fixes.
 - Added documentation

Sean Young (19):
  [media] lirc: document lirc modes better
  [media] lirc: return ENOTTY when ioctl is not supported
  [media] lirc: return ENOTTY when device does support ioctl
  [media] winbond: allow timeout to be set
  [media] gpio-ir: do not allow a timeout of 0
  [media] rc: lirc keymap no longer makes any sense
  [media] lirc: advertise LIRC_CAN_GET_REC_RESOLUTION and improve
  [media] lirc: use refcounting for lirc devices
  [media] mce_kbd: add encoder
  [media] serial_ir: iommap is a memory address, not bool
  [media] lirc: lirc interface should not be a raw decoder
  [media] lirc: exorcise struct irctl
  [media] lirc: use plain kfifo rather than lirc_buffer
  [media] lirc: implement scancode sending
  [media] rc: use the correct carrier for scancode transmit
  [media] rc: auto load encoder if necessary
  [media] lirc: implement reading scancode
  [media] lirc: scancode rc devices should have a lirc device too
  [media] lirc: document LIRC_MODE_SCANCODE

 Documentation/media/uapi/rc/lirc-dev-intro.rst     |  73 +++-
 Documentation/media/uapi/rc/lirc-get-features.rst  |  28 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   3 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |   8 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |   8 +-
 Documentation/media/uapi/rc/lirc-read.rst          |  22 +-
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |   2 +-
 Documentation/media/uapi/rc/lirc-write.rst         |  25 +-
 drivers/media/rc/Kconfig                           |  15 +-
 drivers/media/rc/Makefile                          |   6 +-
 drivers/media/rc/gpio-ir-recv.c                    |   2 +-
 drivers/media/rc/igorplugusb.c                     |   2 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   1 +
 drivers/media/rc/ir-lirc-codec.c                   | 361 ++++++++++-------
 drivers/media/rc/ir-mce_kbd-decoder.c              |  57 ++-
 drivers/media/rc/ir-nec-decoder.c                  |   1 +
 drivers/media/rc/ir-rc5-decoder.c                  |   1 +
 drivers/media/rc/ir-rc6-decoder.c                  |   1 +
 drivers/media/rc/ir-sanyo-decoder.c                |   1 +
 drivers/media/rc/ir-sharp-decoder.c                |   1 +
 drivers/media/rc/ir-sony-decoder.c                 |   1 +
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-lirc.c                 |  42 --
 drivers/media/rc/lirc_dev.c                        | 431 +++++++++------------
 drivers/media/rc/rc-core-priv.h                    |  56 ++-
 drivers/media/rc/rc-ir-raw.c                       |  55 ++-
 drivers/media/rc/rc-main.c                         |  77 ++--
 drivers/media/rc/serial_ir.c                       |   4 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/winbond-cir.c                     |   4 +-
 drivers/staging/media/lirc/lirc_sasem.c            |   3 +-
 drivers/staging/media/lirc/lirc_zilog.c            | 109 +++---
 include/media/lirc_dev.h                           |  29 +-
 include/media/rc-core.h                            |  15 +-
 include/media/rc-map.h                             | 109 ++----
 include/uapi/linux/lirc.h                          |  68 ++++
 36 files changed, 974 insertions(+), 650 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c

-- 
2.9.3
