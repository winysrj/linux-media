Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:35412 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbeJIEZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 00:25:50 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] mfd/pinctrl: add initial support of TI DS90Ux9xx ICs
Date: Tue,  9 Oct 2018 00:11:58 +0300
Message-Id: <20181008211205.2900-1-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The published drivers describe the essential and generic parts of
TI DS90Ux9xx series of ICs, which allow to transfer video, audio and
control signals between FPD-Link III serializers and deserializers.

The placement of TI DS90Ux9xx I2C client driver was selected to be
drivers/mfd as the most natural location of a true MFD driver,
apparently drivers/media/i2c is for another type of device drivers,
also DS90Ux9xx I2C bridge subcontroller driver is placed nearby,
because drivers/i2c for it would be an inappropriate destination
as well. Informally the TI DS90Ux9xx ICs serve a similar function
to SMSC/Microchip MOST, and its drivers are in drivers/staging/most,
the final destination is unknown to me. Please feel free to advise
a better location for the published drivers, at the moment the core
drivers are in drivers/mfd, but I select linux-media as a mailing list.

The published drivers instantly give a chance to test video bridge
functionality to a TI DS90Ux9xx deserializer equipped display panel
with the aide of Laurent's "lvds-encoder" driver by misusing it
as a generic and transparent drm bridge with no particular LVDS
specifics in it, for that it should be sufficient just to add the
corresponding device node and input/output ports as children of
a serializer connected to an application controller.

While the selected scheme of IC description by a list of subdevices,
where each one described in its own device node, works pretty well,
it might lead to unnecessary overcomplicated description of connections
between subdevices on serializer and deserializer sides, i.e. for
proper description of links/connections video serializer should
be linked to video deserializer, audio serializer should be linked
to audio deserializer and so on, however formally there is just one
FPD-III Link connection between two ICs.

The series of patches is rebased on top of linux-next, and there are
more changes in the queue to provide better support of TI DS90Ux9xx ICs.

The introduction to the ICs and drivers can be found in my presentation
https://schd.ws/hosted_files/ossalsjp18/8a/vzapolskiy_als2018.pdf

Sandeep Jain (1):
  dt-bindings: mfd: ds90ux9xx: add description of TI DS90Ux9xx ICs

Vladimir Zapolskiy (6):
  dt-bindings: mfd: ds90ux9xx: add description of TI DS90Ux9xx I2C bridge
  dt-bindings: pinctrl: ds90ux9xx: add description of TI DS90Ux9xx pinmux
  mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD driver
  mfd: ds90ux9xx: add I2C bridge/alias and link connection driver
  pinctrl: ds90ux9xx: add TI DS90Ux9xx pinmux and GPIO controller driver
  MAINTAINERS: add entry for TI DS90Ux9xx FPD-Link III drivers

 .../bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt  |  61 ++
 .../devicetree/bindings/mfd/ti,ds90ux9xx.txt  |  66 ++
 .../bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt |  83 ++
 MAINTAINERS                                   |  10 +
 drivers/mfd/Kconfig                           |  22 +
 drivers/mfd/Makefile                          |   2 +
 drivers/mfd/ds90ux9xx-core.c                  | 879 ++++++++++++++++
 drivers/mfd/ds90ux9xx-i2c-bridge.c            | 764 ++++++++++++++
 drivers/pinctrl/Kconfig                       |  11 +
 drivers/pinctrl/Makefile                      |   1 +
 drivers/pinctrl/pinctrl-ds90ux9xx.c           | 970 ++++++++++++++++++
 include/linux/mfd/ds90ux9xx.h                 |  42 +
 12 files changed, 2911 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt
 create mode 100644 drivers/mfd/ds90ux9xx-core.c
 create mode 100644 drivers/mfd/ds90ux9xx-i2c-bridge.c
 create mode 100644 drivers/pinctrl/pinctrl-ds90ux9xx.c
 create mode 100644 include/linux/mfd/ds90ux9xx.h

-- 
2.17.1
