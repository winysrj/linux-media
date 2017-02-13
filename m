Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:37215 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbdBML1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 06:27:42 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v8 0/2] Add support Add support for Omnivision OV56477
Date: Mon, 13 Feb 2017 11:25:01 +0000
Message-Id: <cover.1486984040.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patchset adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in RAW 8.

This is the eighth version of the OV5647 camera driver patchset.

v8:
 - Remove a part of the initialization procedure which wasn't doing 
 anything
 - Check for i2c read/writes return values
 - Add stream_on/off functions

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
 drivers/media/i2c/ov5647.c                         | 736 +++++++++++++++++++++
 5 files changed, 791 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.11.0
