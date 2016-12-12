Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51255 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932216AbcLLVNr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:47 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v5 00/18] Use sysfs filter for winbond & nuvoton wakeup
Date: Mon, 12 Dec 2016 21:13:41 +0000
Message-Id: <cover.1481575826.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series introduces IR encoders and also makes winbond-cir and
nuvoton-cir use the sysfs filter wakeup interface for programmable 
IR wakeup.

Changes since v4:
 - ImgTec now also uses wakeup_protocols; all rc drivers which do wakeup
   now use the same sysfs interface
 - Implemented all IR encoders except for xmp for which I cannot find
   useful documentation
 - ir_raw_encode_scancode() now takes u32 scancode, rather than a
   rc_scancode_filter, since it cannot encode a mask.
 - All encoders have been tested extensively by round-tripping over
   rc-loopback and generating random scancodes. No problems found
   other than known nec32 issue[1].
 - winbond-cir has seen more testing 

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg104623.html

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

Sean Young (9):
  [media] rc: change wakeup_protocols to list all protocol variants
  [media] img-ir: use new wakeup_protocols sysfs mechanism
  [media] rc: Add scancode validation
  [media] winbond-cir: use sysfs wakeup filter
  [media] rc: raw IR drivers cannot handle cec, unknown or other
  [media] rc: ir-jvc-decoder: Add encode capability
  [media] rc: ir-sanyo-decoder: Add encode capability
  [media] rc: ir-sharp-decoder: Add encode capability
  [media] rc: ir-sony-decoder: Add encode capability

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
 drivers/media/rc/img-ir/img-ir-hw.c            |   5 +-
 drivers/media/rc/img-ir/img-ir-hw.h            |   2 +-
 drivers/media/rc/img-ir/img-ir-jvc.c           |   2 +-
 drivers/media/rc/img-ir/img-ir-nec.c           |   6 +-
 drivers/media/rc/img-ir/img-ir-rc5.c           |   2 +-
 drivers/media/rc/img-ir/img-ir-rc6.c           |   2 +-
 drivers/media/rc/img-ir/img-ir-sanyo.c         |   2 +-
 drivers/media/rc/img-ir/img-ir-sharp.c         |   2 +-
 drivers/media/rc/img-ir/img-ir-sony.c          |  11 +-
 drivers/media/rc/ir-hix5hd2.c                  |   2 +-
 drivers/media/rc/ir-jvc-decoder.c              |  39 +++
 drivers/media/rc/ir-nec-decoder.c              |  81 ++++++
 drivers/media/rc/ir-rc5-decoder.c              |  97 ++++++++
 drivers/media/rc/ir-rc6-decoder.c              | 117 +++++++++
 drivers/media/rc/ir-sanyo-decoder.c            |  43 ++++
 drivers/media/rc/ir-sharp-decoder.c            |  50 ++++
 drivers/media/rc/ir-sony-decoder.c             |  48 ++++
 drivers/media/rc/ite-cir.c                     |   2 +-
 drivers/media/rc/mceusb.c                      |   2 +-
 drivers/media/rc/meson-ir.c                    |   2 +-
 drivers/media/rc/nuvoton-cir.c                 | 122 +++++++--
 drivers/media/rc/rc-core-priv.h                | 107 ++++++++
 drivers/media/rc/rc-ir-raw.c                   | 245 +++++++++++++++++-
 drivers/media/rc/rc-loopback.c                 |  41 ++-
 drivers/media/rc/rc-main.c                     | 330 +++++++++++++++++++++----
 drivers/media/rc/redrat3.c                     |   2 +-
 drivers/media/rc/serial_ir.c                   |   2 +-
 drivers/media/rc/st_rc.c                       |   2 +-
 drivers/media/rc/streamzap.c                   |   2 +-
 drivers/media/rc/sunxi-cir.c                   |   2 +-
 drivers/media/rc/ttusbir.c                     |   2 +-
 drivers/media/rc/winbond-cir.c                 | 259 +++++++++----------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c        |   2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c     |   2 +-
 include/media/rc-core.h                        |  13 +-
 include/media/rc-map.h                         |  19 ++
 46 files changed, 1456 insertions(+), 270 deletions(-)

-- 
2.9.3

