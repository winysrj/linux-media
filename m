Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53775 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbeIRSr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 14:47:58 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v3 0/9] TVP5150 fixes and new features
Date: Tue, 18 Sep 2018 15:14:44 +0200
Message-Id: <20180918131453.21031-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is my v3 with the integrated reviews from my v2 [1]. This serie
applies to Mauro's experimental.git [2].

@Mauro:
Patch ("media: tvp5150: fix irq_request error path during probe") is new
in this series. Maybe you can squash them with ("media: tvp5150: Add sync lock
interrupt handling"), thanks.

I've tested this series on a customer dt-based board. Unfortunately I
haven't a device which use the em28xx driver. So other tester a welcome :)

[1] https://www.spinics.net/lists/devicetree/msg244129.html
[2] https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-4

Javier Martinez Canillas (1):
  partial revert of "[media] tvp5150: add HW input connectors support"

Marco Felsch (7):
  media: tvp5150: fix irq_request error path during probe
  media: tvp5150: add input source selection of_graph support
  media: dt-bindings: tvp5150: Add input port connectors DT bindings
  media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
  media: v4l2-subdev: fix v4l2_subdev_get_try_* dependency
  media: tvp5150: add FORMAT_TRY support for get/set selection handlers
  media: tvp5150: add s_power callback

Michael Tretter (1):
  media: tvp5150: initialize subdev before parsing device tree

 .../devicetree/bindings/media/i2c/tvp5150.txt |  92 ++-
 drivers/media/i2c/tvp5150.c                   | 657 +++++++++++++-----
 include/dt-bindings/media/tvp5150.h           |   2 -
 include/media/v4l2-subdev.h                   |  15 +-
 4 files changed, 584 insertions(+), 182 deletions(-)

-- 
2.19.0
