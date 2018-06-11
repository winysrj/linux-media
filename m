Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:38693 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbeFKPRw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 11:17:52 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/2] media: i2c: mt9v111 sensor driver
Date: Mon, 11 Jun 2018 17:17:31 +0200
Message-Id: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this is a sensor level driver for Aptina MT9V111.

The driver supports YUYV_2X8 output formats and VGA,QVGA,QQVGA,CIF and QCIF
resolution.

The driver allows control of frame rate through s_frame_interval or
V4L2_CID_H/VBLANK control. In order to allow manual frame control, the chip
is initialized with auto-exposure control, auto white balancing and flickering
control disabled.

Tested VGA, QVGA QQVGA resolutions at 5, 10, 15 and 30 frame per second.

Thanks
   j

Jacopo Mondi (2):
  dt-bindings: media: i2c: Document MT9V111 bindings
  media: i2c: Add driver for Aptina MT9V111

 .../bindings/media/i2c/aptina,mt9v111.txt          |   46 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/mt9v111.c                        | 1297 ++++++++++++++++++++
 5 files changed, 1364 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
 create mode 100644 drivers/media/i2c/mt9v111.c

--
2.7.4
