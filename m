Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40371 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752216AbdJJHR2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:17:28 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Walls <awalls.cx18@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH v3 00/26] lirc scancode interface, and more
Date: Tue, 10 Oct 2017 08:17:26 +0100
Message-Id: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce lirc scancode mode, use that to port lirc_zilog to rc-core
using that interface, and then remove the lirc kernel api.

In summary:
 - This removes the lirc staging directory.
 - lirc IR TX can use in-kernel encoders for scancode encoding
 - lirc_zilog uses the same interface
 - lirc kapi (not uapi!) is gone
 - The reading lirc scancode gives more information (e.g. protocol,
   toggle, repeat). So you can determine what protocol variant a remotes uses
 - Line count is actually down and code cleaner (imo)

v2:
 - Add MAINTAINERS entries
 - Fixes for nec repeat
 - Validate scancode for tx
 - Minor bugfixes

v3:
 - Review comments from Hans Verkuil
 - Documented and fixed rc_validate_scancode()
 - Fix a bug in kfifo on arm 32-bit
 - this inferface won't be used for cec remote control passthrough

Sean Young (26):
  media: lirc: implement scancode sending
  media: lirc: use the correct carrier for scancode transmit
  media: rc: auto load encoder if necessary
  media: lirc_zilog: remove receiver
  media: lirc_zilog: fix variable types and other ugliness
  media: lirc_zilog: port to rc-core using scancode tx interface
  media: promote lirc_zilog out of staging
  media: lirc: remove LIRCCODE and LIRC_GET_LENGTH
  media: lirc: lirc interface should not be a raw decoder
  media: lirc: validate scancode for transmit
  media: rc: document and fix rc_validate_scancode()
  media: lirc: merge lirc_dev_fop_ioctl and ir_lirc_ioctl
  media: lirc: use kfifo rather than lirc_buffer for raw IR
  media: lirc: move lirc_dev->attached to rc_dev->registered
  media: lirc: do not call rc_close() on unregistered devices
  media: lirc: create rc-core open and close lirc functions
  media: lirc: remove name from lirc_dev
  media: lirc: remove last remnants of lirc kapi
  media: lirc: implement reading scancode
  media: rc: ensure lirc device receives nec repeats
  media: lirc: document LIRC_MODE_SCANCODE
  media: lirc: introduce LIRC_SET_POLL_MODES
  media: lirc: scancode rc devices should have a lirc device too
  media: MAINTAINERS: remove lirc staging area
  media: MAINTAINERS: add entry for zilog_ir
  kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit

 Documentation/media/kapi/rc-core.rst               |    5 -
 Documentation/media/lirc.h.rst.exceptions          |   31 +
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |   68 +-
 Documentation/media/uapi/rc/lirc-func.rst          |    2 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |   17 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   44 -
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    5 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |    2 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   15 +-
 .../media/uapi/rc/lirc-set-poll-modes.rst          |   52 +
 Documentation/media/uapi/rc/lirc-write.rst         |   19 +-
 MAINTAINERS                                        |   12 +-
 drivers/media/rc/Kconfig                           |   41 +-
 drivers/media/rc/Makefile                          |    6 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    1 +
 drivers/media/rc/ir-lirc-codec.c                   |  566 ++++---
 drivers/media/rc/ir-mce_kbd-decoder.c              |   12 +-
 drivers/media/rc/ir-nec-decoder.c                  |    1 +
 drivers/media/rc/ir-rc5-decoder.c                  |    1 +
 drivers/media/rc/ir-rc6-decoder.c                  |    1 +
 drivers/media/rc/ir-sanyo-decoder.c                |    1 +
 drivers/media/rc/ir-sharp-decoder.c                |    1 +
 drivers/media/rc/ir-sony-decoder.c                 |    1 +
 drivers/media/rc/lirc_dev.c                        |  489 +-----
 drivers/media/rc/rc-core-priv.h                    |   54 +-
 drivers/media/rc/rc-ir-raw.c                       |   56 +-
 drivers/media/rc/rc-main.c                         |  166 +-
 drivers/media/rc/zilog_ir.c                        |  742 +++++++++
 drivers/staging/media/Kconfig                      |    3 -
 drivers/staging/media/Makefile                     |    1 -
 drivers/staging/media/lirc/Kconfig                 |   21 -
 drivers/staging/media/lirc/Makefile                |    6 -
 drivers/staging/media/lirc/TODO                    |   36 -
 drivers/staging/media/lirc/lirc_zilog.c            | 1653 --------------------
 include/linux/kfifo.h                              |    3 +-
 include/media/lirc_dev.h                           |  192 ---
 include/media/rc-core.h                            |   55 +-
 include/media/rc-map.h                             |   54 +-
 include/uapi/linux/lirc.h                          |   91 ++
 39 files changed, 1734 insertions(+), 2792 deletions(-)
 delete mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-poll-modes.rst
 create mode 100644 drivers/media/rc/zilog_ir.c
 delete mode 100644 drivers/staging/media/lirc/Kconfig
 delete mode 100644 drivers/staging/media/lirc/Makefile
 delete mode 100644 drivers/staging/media/lirc/TODO
 delete mode 100644 drivers/staging/media/lirc/lirc_zilog.c
 delete mode 100644 include/media/lirc_dev.h

-- 
2.13.6
