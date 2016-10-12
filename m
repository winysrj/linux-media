Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:36983 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753663AbcJLQCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 12:02:53 -0400
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        davem@davemloft.net, geert@linux-m68k.org,
        akpm@linux-foundation.org, kvalo@codeaurora.org,
        linux@roeck-us.net, hverkuil@xs4all.nl, lars@metafoo.de,
        pavel@ucw.cz, robert.jarzmik@free.fr, slongerbeam@gmail.com,
        dheitmueller@kernellabs.com, pali.rohar@gmail.com,
        CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Subject: [PATCH v3 0/2] OV5647 Sensor driver
Date: Wed, 12 Oct 2016 17:02:20 +0100
Message-Id: <cover.1476286687.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in Raw 8.

v3: Re-sending after no reply to previous patch.

Ramiro Oliveira (2):
  Add OV5647 device tree documentation
  Add support for Omnivision OV5647

 .../devicetree/bindings/media/i2c/ov5647.txt       |  19 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  12 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 891 +++++++++++++++++++++
 5 files changed, 930 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.9.3


