Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49863 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752535AbcKBKkl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 06:40:41 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 0/6] Add support for IR transmitters
Date: Wed, 02 Nov 2016 19:40:04 +0900
Message-id: <20161102104010.26959-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The main goal is to add support in the rc framework for IR
transmitters, which currently is only supported by lirc but that
is not the preferred way.

The last patch adds support for an IR transmitter driven by
the MOSI line of an SPI controller, it's the case of the Samsung
TM2(e) board which support is currently ongoing.

The last patch adds support for an IR transmitter driven by
the MOSI line of an SPI controller, it's the case of the Samsung
TM2(e) board which support is currently ongoing.

Thanks Sean for your prompt reviews.

Andi

Changelog from version 1:

The RFC is now PATCH. The main difference is that this version
doesn't try to add the any bit streaming protocol and doesn't
modify any LIRC interface specification.

patch 1: updates all the drivers using rc_allocate_device
patch 2: fixed errors and warning reported from the kbuild test
         robot
patch 5: this patch has been dropped and replaced with a new one
         which avoids waiting for transmitters.
patch 6: added new properties to the dts specification
patch 7: the driver uses the pulse/space input and converts it to
         a bit stream.


Changelog from version 2:

The original patch number 5 has been abandoned because it was not
bringing much benenfit.

patch 1: rebased on the new kernel.
patch 3: removed the sysfs attribute protocol for transmitters
patch 5: the binding has been moved to the leds section instead
         of the media. Fixed all the comments from Rob
patch 6: fixed all the comments from Sean added also Sean's
         review.

Andi Shyti (6):
  [media] rc-main: assign driver type during allocation
  [media] rc-main: split setup and unregister functions
  [media] rc-core: add support for IR raw transmitters
  [media] rc-ir-raw: do not generate any receiving thread for raw
    transmitters
  Documentation: bindings: add documentation for ir-spi device driver
  [media] rc: add support for IR LEDs driven through SPI

 .../devicetree/bindings/leds/spi-ir-led.txt        |  29 +++
 drivers/hid/hid-picolcd_cir.c                      |   3 +-
 drivers/media/common/siano/smsir.c                 |   3 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   2 +-
 drivers/media/pci/cx23885/cx23885-input.c          |  11 +-
 drivers/media/pci/cx88/cx88-input.c                |   3 +-
 drivers/media/pci/dm1105/dm1105.c                  |   3 +-
 drivers/media/pci/mantis/mantis_input.c            |   2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |   2 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |   3 +-
 drivers/media/pci/ttpci/budget-ci.c                |   2 +-
 drivers/media/rc/Kconfig                           |   9 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ati_remote.c                      |   3 +-
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/rc/fintek-cir.c                      |   3 +-
 drivers/media/rc/gpio-ir-recv.c                    |   3 +-
 drivers/media/rc/igorplugusb.c                     |   3 +-
 drivers/media/rc/iguanair.c                        |   3 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   2 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |   3 +-
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/rc/ir-hix5hd2.c                      |   3 +-
 drivers/media/rc/ir-spi.c                          | 205 +++++++++++++++++++++
 drivers/media/rc/ite-cir.c                         |   3 +-
 drivers/media/rc/mceusb.c                          |   3 +-
 drivers/media/rc/meson-ir.c                        |   3 +-
 drivers/media/rc/nuvoton-cir.c                     |   3 +-
 drivers/media/rc/rc-ir-raw.c                       |  17 +-
 drivers/media/rc/rc-loopback.c                     |   3 +-
 drivers/media/rc/rc-main.c                         | 181 ++++++++++--------
 drivers/media/rc/redrat3.c                         |   3 +-
 drivers/media/rc/st_rc.c                           |   3 +-
 drivers/media/rc/streamzap.c                       |   3 +-
 drivers/media/rc/sunxi-cir.c                       |   3 +-
 drivers/media/rc/ttusbir.c                         |   3 +-
 drivers/media/rc/winbond-cir.c                     |   3 +-
 drivers/media/usb/au0828/au0828-input.c            |   3 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |   2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   3 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   2 +-
 drivers/media/usb/tm6000/tm6000-input.c            |   3 +-
 drivers/staging/media/cec/cec-core.c               |   3 +-
 include/media/rc-core.h                            |  13 +-
 46 files changed, 409 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/spi-ir-led.txt
 create mode 100644 drivers/media/rc/ir-spi.c

-- 
2.10.1

