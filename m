Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:48849 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbeDYLAY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 07:00:24 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] media: i2c: mt9t112: Add OF tree support
Date: Wed, 25 Apr 2018 13:00:12 +0200
Message-Id: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

    this small series add device tree support for the MT9T112 image
sensor.

As in the device tree bindings I used 'semi-standard' name for the
'powerdown' GPIO, I have changed that for all other users of the mt9t112
driver (SH Ecovec only).

A note on clock: as the mt9t112 driver expects to receive the PPL parameter
configuration from platform data (I know...), new OF users are only supported
with an external clock frequency of 24MHz.

Thanks
   j

Jacopo Mondi (2):
  dt-bindings: media: i2c: Add mt9t111 image sensor
  media: i2c: mt9t112: Add device tree support

 Documentation/devicetree/bindings/mt9t112.txt | 41 +++++++++++++
 arch/sh/boards/mach-ecovec24/setup.c          |  4 +-
 drivers/media/i2c/mt9t112.c                   | 87 +++++++++++++++++++++++----
 3 files changed, 118 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mt9t112.txt

--
2.7.4
