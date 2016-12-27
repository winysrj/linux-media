Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42803 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbcL0Upv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 15:45:51 -0500
Date: Tue, 27 Dec 2016 20:45:48 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 4.11] RC updates
Message-ID: <20161227204548.GA18181@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request is for the ir-spi driver, wakeup changes along
with the required IR encoders, staging updates.

Thanks,
Sean

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.11a

for you to fetch changes up to 6879b07e70442f41ce96376e99288c2ba44cf9e0:

  [media] staging: lirc_imon: port remaining usb ids to imon and remove (2016-12-27 18:04:32 +0000)

----------------------------------------------------------------
Andi Shyti (6):
      [media] rc-main: assign driver type during allocation
      [media] rc-main: split setup and unregister functions
      [media] rc-core: add support for IR raw transmitters
      [media] rc-ir-raw: do not generate any receiving thread for raw transmitters
      [media] Documentation: bindings: add documentation for ir-spi device driver
      [media] rc: add support for IR LEDs driven through SPI

Antti Seppälä (3):
      [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
      [media] rc: ir-rc6-decoder: Add encode capability
      [media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback

Heiner Kallweit (1):
      [media] rc: refactor raw handler kthread

James Hogan (6):
      [media] rc: rc-ir-raw: Add scancode encoder callback
      [media] rc: rc-ir-raw: Add pulse-distance modulation helper
      [media] rc: ir-rc5-decoder: Add encode capability
      [media] rc: ir-nec-decoder: Add encode capability
      [media] rc: rc-core: Add support for encode_wakeup drivers
      [media] rc: rc-loopback: Add loopback of filter scancodes

Sean Young (23):
      [media] cxusb: port to rc-core
      [media] mceusb: LIRC_SET_SEND_CARRIER returns 0 on success
      [media] lirc_dev: LIRC_{G,S}ET_REC_MODE do not work
      [media] lirc: LIRC_{G,S}ET_SEND_MODE fail if device cannot transmit
      [media] em28xx: IR protocol not reported correctly
      [media] serial_ir: generate timeout
      [media] rc: allow software timeout to be set
      [media] rc5x: 6th command bit is S2 bit
      [media] rc5x: document that this is the 20 bit variant
      [media] rc: change wakeup_protocols to list all protocol variants
      [media] rc: Add scancode validation
      [media] rc: unify nec32 protocol scancode format
      [media] winbond-cir: use sysfs wakeup filter
      [media] rc: raw IR drivers cannot handle cec, unknown or other
      [media] rc: ir-jvc-decoder: Add encode capability
      [media] rc: ir-sanyo-decoder: Add encode capability
      [media] rc: ir-sharp-decoder: Add encode capability
      [media] rc: ir-sony-decoder: Add encode capability
      [media] ir-rx51: port to rc-core
      [media] staging: lirc_sir: port to rc-core
      [media] staging: lirc_parallel: remove
      [media] staging: lirc_bt829: remove
      [media] staging: lirc_imon: port remaining usb ids to imon and remove

 Documentation/ABI/testing/sysfs-class-rc           |  14 +-
 .../devicetree/bindings/leds/irled/spi-ir-led.txt  |  29 +
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst     |  13 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |   8 +-
 drivers/hid/hid-picolcd_cir.c                      |   5 +-
 drivers/media/cec/cec-core.c                       |   3 +-
 drivers/media/common/siano/smsir.c                 |   5 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   2 +-
 drivers/media/pci/cx23885/cx23885-input.c          |  25 +-
 drivers/media/pci/cx88/cx88-input.c                |   3 +-
 drivers/media/pci/dm1105/dm1105.c                  |   3 +-
 drivers/media/pci/mantis/mantis_input.c            |   2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |   2 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |   3 +-
 drivers/media/pci/ttpci/budget-ci.c                |   2 +-
 drivers/media/rc/Kconfig                           |  11 +-
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ati_remote.c                      |   3 +-
 drivers/media/rc/ene_ir.c                          |   5 +-
 drivers/media/rc/fintek-cir.c                      |   5 +-
 drivers/media/rc/gpio-ir-recv.c                    |   5 +-
 drivers/media/rc/igorplugusb.c                     |   7 +-
 drivers/media/rc/iguanair.c                        |   9 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |  15 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |  21 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |   3 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |  26 +-
 drivers/media/rc/imon.c                            | 134 ++-
 drivers/media/rc/ir-hix5hd2.c                      |   5 +-
 drivers/media/rc/ir-jvc-decoder.c                  |  39 +
 drivers/media/rc/ir-lirc-codec.c                   |  10 +-
 drivers/media/rc/ir-nec-decoder.c                  |  86 +-
 drivers/media/rc/ir-rc5-decoder.c                  | 105 ++-
 drivers/media/rc/ir-rc6-decoder.c                  | 117 +++
 drivers/media/rc/ir-rx51.c                         | 332 +++----
 drivers/media/rc/ir-sanyo-decoder.c                |  43 +
 drivers/media/rc/ir-sharp-decoder.c                |  50 ++
 drivers/media/rc/ir-sony-decoder.c                 |  48 +
 drivers/media/rc/ir-spi.c                          | 199 +++++
 drivers/media/rc/ite-cir.c                         |   5 +-
 drivers/media/rc/keymaps/Makefile                  |   3 +
 drivers/media/rc/keymaps/rc-d680-dmb.c             |  75 ++
 drivers/media/rc/keymaps/rc-dvico-mce.c            |  85 ++
 drivers/media/rc/keymaps/rc-dvico-portable.c       |  76 ++
 drivers/media/rc/keymaps/rc-tivo.c                 |  86 +-
 drivers/media/rc/lirc_dev.c                        |   4 +-
 drivers/media/rc/mceusb.c                          |   9 +-
 drivers/media/rc/meson-ir.c                        |   5 +-
 drivers/media/rc/nuvoton-cir.c                     | 125 ++-
 drivers/media/rc/rc-core-priv.h                    | 109 ++-
 drivers/media/rc/rc-ir-raw.c                       | 308 ++++++-
 drivers/media/rc/rc-loopback.c                     |  44 +-
 drivers/media/rc/rc-main.c                         | 524 ++++++++---
 drivers/media/rc/redrat3.c                         |   5 +-
 drivers/media/rc/serial_ir.c                       |  29 +-
 drivers/media/rc/st_rc.c                           |   5 +-
 drivers/media/rc/streamzap.c                       |   5 +-
 drivers/media/rc/sunxi-cir.c                       |   5 +-
 drivers/media/rc/ttusbir.c                         |  10 +-
 drivers/media/rc/winbond-cir.c                     | 262 +++---
 drivers/media/usb/au0828/au0828-input.c            |   3 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |   2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   3 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  | 312 ++-----
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   2 +-
 drivers/media/usb/em28xx/em28xx-input.c            |  15 +-
 drivers/media/usb/tm6000/tm6000-input.c            |   3 +-
 drivers/staging/media/lirc/Kconfig                 |  22 +-
 drivers/staging/media/lirc/Makefile                |   3 -
 drivers/staging/media/lirc/lirc_bt829.c            | 401 ---------
 drivers/staging/media/lirc/lirc_imon.c             | 979 ---------------------
 drivers/staging/media/lirc/lirc_parallel.c         | 741 ----------------
 drivers/staging/media/lirc/lirc_parallel.h         |  26 -
 drivers/staging/media/lirc/lirc_sir.c              | 296 ++-----
 include/linux/platform_data/media/ir-rx51.h        |   6 +-
 include/media/rc-core.h                            |  32 +-
 include/media/rc-map.h                             |  30 +-
 80 files changed, 2664 insertions(+), 3396 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt
 create mode 100644 drivers/media/rc/ir-spi.c
 create mode 100644 drivers/media/rc/keymaps/rc-d680-dmb.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-mce.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-portable.c
 delete mode 100644 drivers/staging/media/lirc/lirc_bt829.c
 delete mode 100644 drivers/staging/media/lirc/lirc_imon.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.h
