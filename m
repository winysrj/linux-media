Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60475 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751659AbdGGJwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:52:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/6] Generic Raspberry Pi IR transmitters
Date: Fri,  7 Jul 2017 10:51:56 +0100
Message-Id: <cover.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These drivers are generic, but they've been tested on Raspberry Pi.

Note that the gpio-ir-recv is a separate driver, so you will end up
with two /dev/lircN devices if you want a receiver and a transmitter,
whilst with the lirc_rpi driver you have one /dev/lircN device.

Also note that it might be possible for the Nokia N900 to use the
pwm-ir-tx driver, making ir-rx51 obsolete. The pwm-ir-tx driver is
shorter and simpler.

Changes since v2:
 - Removed pointless suspend handling from pwm-ir-tx
 - Split out device tree bindings to separate commits

Sean Young (6):
  [media] rc-core: rename input_name to device_name
  [media] rc: mce kbd decoder not needed for IR TX drivers
  [media] rc: gpio-ir-tx: add new driver
  [media] rc: pwm-ir-tx: add new driver
  [media] dt-bindings: gpio-ir-tx: add support for GPIO IR Transmitter
  [media] dt-bindings: pwm-ir-tx: Add support for PWM IR Transmitter

 .../devicetree/bindings/leds/irled/gpio-ir-tx.txt  |  11 ++
 .../devicetree/bindings/leds/irled/pwm-ir-tx.txt   |  13 ++
 MAINTAINERS                                        |  12 ++
 drivers/hid/hid-picolcd_cir.c                      |   2 +-
 drivers/media/cec/cec-core.c                       |   4 +-
 drivers/media/common/siano/smsir.c                 |   4 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   2 +-
 drivers/media/pci/cx23885/cx23885-input.c          |   2 +-
 drivers/media/pci/cx88/cx88-input.c                |   2 +-
 drivers/media/pci/dm1105/dm1105.c                  |   2 +-
 drivers/media/pci/mantis/mantis_common.h           |   2 +-
 drivers/media/pci/mantis/mantis_input.c            |   4 +-
 drivers/media/pci/saa7134/saa7134-input.c          |   2 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |   4 +-
 drivers/media/pci/smipcie/smipcie.h                |   2 +-
 drivers/media/pci/ttpci/budget-ci.c                |   2 +-
 drivers/media/rc/Kconfig                           |  23 +++
 drivers/media/rc/Makefile                          |   2 +
 drivers/media/rc/ati_remote.c                      |   2 +-
 drivers/media/rc/ene_ir.c                          |   4 +-
 drivers/media/rc/fintek-cir.c                      |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |   2 +-
 drivers/media/rc/gpio-ir-tx.c                      | 189 +++++++++++++++++++++
 drivers/media/rc/igorplugusb.c                     |   2 +-
 drivers/media/rc/iguanair.c                        |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   2 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |   2 +-
 drivers/media/rc/imon.c                            |   2 +-
 drivers/media/rc/ir-hix5hd2.c                      |   2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   3 +
 drivers/media/rc/ir-spi.c                          |   1 +
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/rc/meson-ir.c                        |   2 +-
 drivers/media/rc/mtk-cir.c                         |   2 +-
 drivers/media/rc/nuvoton-cir.c                     |   2 +-
 drivers/media/rc/pwm-ir-tx.c                       | 138 +++++++++++++++
 drivers/media/rc/rc-loopback.c                     |   2 +-
 drivers/media/rc/rc-main.c                         |   8 +-
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/rc/serial_ir.c                       |  10 +-
 drivers/media/rc/sir_ir.c                          |   2 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/streamzap.c                       |   2 +-
 drivers/media/rc/sunxi-cir.c                       |   2 +-
 drivers/media/rc/ttusbir.c                         |   2 +-
 drivers/media/rc/winbond-cir.c                     |   2 +-
 drivers/media/usb/au0828/au0828-input.c            |   2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   5 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   2 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   2 +-
 drivers/media/usb/tm6000/tm6000-input.c            |   2 +-
 include/media/cec.h                                |   2 +-
 include/media/rc-core.h                            |   6 +-
 55 files changed, 453 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
 create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
 create mode 100644 drivers/media/rc/gpio-ir-tx.c
 create mode 100644 drivers/media/rc/pwm-ir-tx.c

-- 
2.9.4
