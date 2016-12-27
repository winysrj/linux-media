Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:53864 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbcL0N70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 08:59:26 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pavel@ucw.cz,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, Ramiro.Oliveira@synopsys.com,
        CARLOS.PALMINHA@synopsys.com
Subject: [PATCH v7 0/2] Add support for Omnivision OV5647
Date: Tue, 27 Dec 2016 13:59:01 +0000
Message-Id: <cover.1482846784.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in Raw 8.

This is the seventh version of the OV5647 camera driver patchset.

v7:
 - Remove "0x" and leading 0 from DT documentation examples

v6:
 - Add example to DT documentation
 - Remove data-lanes and clock-lane property from DT
 - Add external clock property to DT
 - Order includes
 - Remove unused variables and functions
 - Add external clock handling
 - Add power on counter
 - Change from g/s_parm to g/s_frame_interval

v5:
 - Refactor code 
 - Change comments
 - Add missing error handling in some functions

v4: 
 - Add correct license
 - Revert debugging info to generic infrastructure
 - Turn defines into enums
 - Correct code style issues
 - Remove unused defines
 - Make sure all errors where being handled
 - Rename some functions to make code more readable
 - Add some debugging info

v3: 
 - No changes. Re-submitted due to lack of responses

v2: 
 - Corrections in DT documentation

Ramiro Oliveira (2):
  Add OV5647 device tree documentation
  Add support for OV5647 sensor.

 .../devicetree/bindings/media/i2c/ov5647.txt       |  35 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  12 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 718 +++++++++++++++++++++
 5 files changed, 773 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.11.0


