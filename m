Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33933 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbeEDMtO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 08:49:14 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH 0/2] add support for TI SCAN921226H video deserializer
Date: Fri,  4 May 2018 14:49:01 +0200
Message-Id: <20180504124903.6276-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds a binding and the corresponding V4L subdev driver for
the TI SCAN921226H video deserializer. Although the device doesn't need
to be configured, it can be controlled via GPIOs to allow multiple
sensors on the same parallel video bus.

Jan Luebbe (2):
  media: dt-bindings: add binding for TI SCAN921226H video deserializer
  media: platform: add driver for TI SCAN921226H video deserializer

 .../bindings/media/ti,scan921226h.txt         |  59 +++
 drivers/media/platform/Kconfig                |   7 +
 drivers/media/platform/Makefile               |   2 +
 drivers/media/platform/scan921226h.c          | 353 ++++++++++++++++++
 4 files changed, 421 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,scan921226h.txt
 create mode 100644 drivers/media/platform/scan921226h.c

-- 
2.17.0
