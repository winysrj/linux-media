Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:36085 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbcLERhA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 12:37:00 -0500
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
Subject: [PATCH v5 0/2] Add support for Omnivision OV5647
Date: Mon,  5 Dec 2016 17:36:32 +0000
Message-Id: <cover.1480958609.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in Raw 8.

This is the fifth version of the OV5647 camera driver patchset.

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
  Add support for OV5647 sensor

 .../devicetree/bindings/media/i2c/ov5647.txt       |  19 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  12 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 866 +++++++++++++++++++++
 5 files changed, 905 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.10.2


