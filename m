Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40901 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032250AbdAFMtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/9] Teach lirc how to send and receive scancodes
Date: Fri,  6 Jan 2017 12:49:03 +0000
Message-Id: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series introduces a new lirc mode, LIRC_MODE_SCANCODE. This
allows scancodes to be sent and received. This depends on earlier
series which introduces IR encoders.

Hans: do cec devices need a method for sending scancodes and if so,
would this be a useful interface? If not, should cec devices not have
a lirc char device? With these patches, cec devices will get a lirc 
char device too.

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

Sean Young (9):
  [media] lirc: lirc interface should not be a raw decoder
  [media] lirc: exorcise struct irctl
  [media] lirc: use plain kfifo rather than lirc_buffer
  [media] lirc: implement scancode sending
  [media] rc: use the correct carrier for scancode transmit
  [media] rc: auto load encoder if necessary
  [media] lirc: implement reading scancode
  [media] lirc: scancode rc devices should have a lirc device too
  [media] lirc: LIRC_MODE_SCANCODE documentation

 Documentation/media/uapi/rc/lirc-dev-intro.rst    |  21 +-
 Documentation/media/uapi/rc/lirc-get-features.rst |  14 +
 drivers/media/rc/Kconfig                          |  15 +-
 drivers/media/rc/Makefile                         |   6 +-
 drivers/media/rc/ir-jvc-decoder.c                 |   1 +
 drivers/media/rc/ir-lirc-codec.c                  | 336 +++++++++++++--------
 drivers/media/rc/ir-nec-decoder.c                 |   1 +
 drivers/media/rc/ir-rc5-decoder.c                 |   1 +
 drivers/media/rc/ir-rc6-decoder.c                 |   1 +
 drivers/media/rc/ir-sanyo-decoder.c               |   1 +
 drivers/media/rc/ir-sharp-decoder.c               |   1 +
 drivers/media/rc/ir-sony-decoder.c                |   1 +
 drivers/media/rc/lirc_dev.c                       | 339 ++++++++++------------
 drivers/media/rc/rc-core-priv.h                   |  54 +++-
 drivers/media/rc/rc-ir-raw.c                      |  49 +++-
 drivers/media/rc/rc-main.c                        |  66 +++--
 drivers/staging/media/lirc/lirc_sasem.c           |   1 -
 include/media/lirc_dev.h                          |  25 ++
 include/media/rc-core.h                           |   8 +-
 include/media/rc-map.h                            |  52 +---
 include/uapi/linux/lirc.h                         |  66 +++++
 21 files changed, 639 insertions(+), 420 deletions(-)

-- 
2.9.3

