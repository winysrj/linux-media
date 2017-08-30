Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34065 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751586AbdH3QKs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 12:10:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Subject: [PATCHv3 0/5] cec-gpio: add HDMI CEC GPIO-based driver
Date: Wed, 30 Aug 2017 18:10:39 +0200
Message-Id: <20170830161044.26571-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver adds support for CEC implementations that use a pull-up
GPIO pin. While SoCs exist that do this, the primary use-case is to
turn a single-board computer into a cheap CEC debugger.

Together with 'cec-ctl --monitor-pin' you can do low-level CEC bus
monitoring and do protocol analysis. And error injection is also
planned for the future.

Here is an example using the Raspberry Pi 3:

https://hverkuil.home.xs4all.nl/rpi3-cec.jpg

While this example is for the Rpi, this driver will work for any
SoC with a pull-up GPIO pin.

In addition the cec-gpio driver can optionally monitor the HPD pin.
The state of the HPD pin influences the CEC behavior so it is very
useful to be able to monitor both.

And some HDMI sinks are known to quickly toggle the HPD when e.g.
switching between inputs. So it is useful to be able to see an event
when the HPD changes value.

The first two patches add support for the new HPD events. The last
three patches are for the cec-gpio driver itself.

Regards,

        Hans

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

 .../devicetree/bindings/media/cec-gpio.txt         |  22 ++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  18 ++
 MAINTAINERS                                        |   9 +
 drivers/media/cec/cec-adap.c                       |  18 +-
 drivers/media/cec/cec-api.c                        |  18 +-
 drivers/media/platform/Kconfig                     |   9 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cec-gpio/Makefile           |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         | 237 +++++++++++++++++++++
 include/media/cec-pin.h                            |   4 +
 include/media/cec.h                                |  12 +-
 include/uapi/linux/cec.h                           |   2 +
 12 files changed, 346 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c

-- 
2.14.1
