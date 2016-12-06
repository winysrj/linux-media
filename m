Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42217 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbcLFKTX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4 00/13] Use sysfs filter for winbond & nuvoton wakeup
Date: Tue,  6 Dec 2016 10:19:08 +0000
Message-Id: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series resurrects an earlier series with a new approach.

I've modified wakeup_protocols so that only one protocol variant can
be selected, and the ir_raw_encode_scancode() now takes an enum rc_type
rather than a protocol bitmask.

These changes make it possible for the winbond-cir to use the wakeup
filter, and I've tested this.

For the nuvoton I have merged the v3 code forward and otherwise it is
largely untouched. I do not have the hardware to test this, although 
v3 reportedly worked.

It would be relatively easy to add encoders for the remaining protocols
which can be done in follow-on work.

Antti Seppälä (3):
  [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
  [media] rc: ir-rc6-decoder: Add encode capability
  [media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback

James Hogan (6):
  [media] rc: rc-ir-raw: Add scancode encoder callback
  [media] rc: rc-ir-raw: Add pulse-distance modulation helper
  [media] rc: ir-rc5-decoder: Add encode capability
  [media] rc: ir-nec-decoder: Add encode capability
  [media] rc: rc-core: Add support for encode_wakeup drivers
  [media] rc: rc-loopback: Add loopback of filter scancodes

Sean Young (4):
  [media] rc: change wakeup_protocols to list all protocol variants
  [media] rc: Add scancode validation
  [media] winbond-cir: use sysfs wakeup filter
  [media] rc: raw IR drivers cannot handle cec, unknown or other

 Documentation/ABI/testing/sysfs-class-rc       |  14 +-
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst |  13 +-
 drivers/hid/hid-picolcd_cir.c                  |   2 +-
 drivers/media/common/siano/smsir.c             |   2 +-
 drivers/media/pci/cx23885/cx23885-input.c      |  14 +-
 drivers/media/rc/ene_ir.c                      |   2 +-
 drivers/media/rc/fintek-cir.c                  |   2 +-
 drivers/media/rc/gpio-ir-recv.c                |   2 +-
 drivers/media/rc/igorplugusb.c                 |   4 +-
 drivers/media/rc/iguanair.c                    |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c            |   2 -
 drivers/media/rc/ir-hix5hd2.c                  |   2 +-
 drivers/media/rc/ir-nec-decoder.c              |  94 +++++++
 drivers/media/rc/ir-rc5-decoder.c              | 116 +++++++++
 drivers/media/rc/ir-rc6-decoder.c              | 120 +++++++++
 drivers/media/rc/ite-cir.c                     |   2 +-
 drivers/media/rc/mceusb.c                      |   2 +-
 drivers/media/rc/meson-ir.c                    |   2 +-
 drivers/media/rc/nuvoton-cir.c                 | 128 +++++++++-
 drivers/media/rc/nuvoton-cir.h                 |   1 +
 drivers/media/rc/rc-core-priv.h                |  89 +++++++
 drivers/media/rc/rc-ir-raw.c                   | 191 +++++++++++++-
 drivers/media/rc/rc-loopback.c                 |  40 ++-
 drivers/media/rc/rc-main.c                     | 334 +++++++++++++++++++++----
 drivers/media/rc/redrat3.c                     |   2 +-
 drivers/media/rc/serial_ir.c                   |   2 +-
 drivers/media/rc/st_rc.c                       |   2 +-
 drivers/media/rc/streamzap.c                   |   2 +-
 drivers/media/rc/sunxi-cir.c                   |   2 +-
 drivers/media/rc/ttusbir.c                     |   2 +-
 drivers/media/rc/winbond-cir.c                 | 254 ++++++++++---------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c        |   2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c     |   2 +-
 include/media/rc-core.h                        |  14 +-
 include/media/rc-map.h                         |  10 +
 35 files changed, 1249 insertions(+), 225 deletions(-)

-- 
2.9.3

