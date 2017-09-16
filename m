Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60602 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751234AbdIPO2c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 10:28:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCHv5 0/5] cec-gpio: add HDMI CEC GPIO-based driver
Date: Sat, 16 Sep 2017 16:28:22 +0200
Message-Id: <20170916142827.5878-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver adds support for CEC implementations that use a pull-up
GPIO line. While SoCs exist that do this, the primary use-case is to
turn a single-board computer into a cheap CEC debugger.

Together with 'cec-ctl --monitor-pin' you can do low-level CEC bus
monitoring and do protocol analysis. And error injection is also
planned for the future.

Here is an example using the Raspberry Pi 3:

https://hverkuil.home.xs4all.nl/rpi3-cec.jpg

While this example is for the Rpi, this driver will work for any
SoC with a pull-up GPIO line.

In addition the cec-gpio driver can optionally monitor the HPD line.
The state of the HPD line influences the CEC behavior so it is very
useful to be able to monitor both.

And some HDMI sinks are known to quickly toggle the HPD when e.g.
switching between inputs. So it is useful to be able to see an event
when the HPD changes value.

The first two patches add support for the new HPD events. The last
three patches are for the cec-gpio driver itself.

Regards,

        Hans

Changes since v4:

- cec-gpio.txt: *-gpio -> *-gpios
- cec-gpio.txt: document hdmi-phandle. To be used when cec-gpio is
  associated with an HDMI receiver/transmitter.
- cec-gpio.txt: remove incorrect @7 from dts example.

Changes since v3:

- cec-gpio.txt: refer to lines instead of pins and use OPEN_DRAIN
  in the example.
- Kconfig: add select GPIOLIB
- cec-gpio.c: switch to gpiod.
- cec-core.c: initialize the devnode mutex/list in allocate_adapter.
  Doing this in register_adapter is too late if the HPD is high.

Changes since v2:

- Add support for HPD events.
- Switch from pin BCM4 to pin BCM7 in the bindings example

Changes since v1:

- Updated the bindings doc to not refer to the driver, instead
  refer to the hardware.

Hans Verkuil (5):
  cec: add CEC_EVENT_PIN_HPD_LOW/HIGH events
  cec-ioc-dqevent.rst: document new CEC_EVENT_PIN_HPD_LOW/HIGH events
  dt-bindings: document the CEC GPIO bindings
  cec-gpio: add HDMI CEC GPIO driver
  MAINTAINERS: add cec-gpio entry

 .../devicetree/bindings/media/cec-gpio.txt         |  29 +++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  18 ++
 MAINTAINERS                                        |   9 +
 drivers/media/cec/cec-adap.c                       |  18 +-
 drivers/media/cec/cec-api.c                        |  18 +-
 drivers/media/cec/cec-core.c                       |   8 +-
 drivers/media/platform/Kconfig                     |  10 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cec-gpio/Makefile           |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         | 236 +++++++++++++++++++++
 include/media/cec-pin.h                            |   4 +
 include/media/cec.h                                |  12 +-
 include/uapi/linux/cec.h                           |   2 +
 13 files changed, 357 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c

-- 
2.14.1
