Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967327AbeF1QVp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:45 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 00/21] TVP5150 fixes and new features
Date: Thu, 28 Jun 2018 18:20:32 +0200
Message-Id: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First some fixes were made which may possibly interesting for other
kernel versions.

Then I picked most of the patches from Philipp [1] and ported them
to the recent media_tree master branch [3].

But the main purpose of this series is to convert the proprietary
connector DT property into the generic input port property. I picked commit
('partial revert of "[media] tvp5150: add HW input connectors support"')
to have a clean working base and used the results of the discussion [2].

[1] https://patchwork.linuxtv.org/patch/33464/
[2] https://patchwork.linuxtv.org/patch/33852/
[3] https://git.linuxtv.org/media_tree.git/log/

Javier Martinez Canillas (1):
  partial revert of "[media] tvp5150: add HW input connectors support"

Marco Felsch (10):
  [media] tvp5150: fix width alignment during set_selection()
  [media] tvp5150: fix switch exit in set control handler
  [media] tvp5150: make use of regmap_update_bits
  [media] v4l2-rect.h: add position and equal helpers
  [media] tvp5150: add FORMAT_TRY support for get/set selection handlers
  [media] tvp5150: add default format helper
  [media] tvp5150: add g_std callback
  [media] tvp5150: add input source selection of_graph support
  [media] tvp5150: Add input port connectors DT bindings
  [media] tvp5150: Change default input source selection behaviour

Michael Tretter (1):
  [media] tvp5150: initialize subdev before parsing device tree

Philipp Zabel (10):
  [media] tvp5150: convert register access to regmap
  [media] tvp5150: trigger autodetection on subdev open to reset
    cropping
  [media] tvp5150: fix standard autodetection
  [media] tvp5150: split reset/enable routine
  [media] tvp5150: remove pin configuration from initialization tables
  [media] tvp5150: Add sync lock interrupt handling
  [media] tvp5150: disable output while signal not locked
  [media] tvp5150: issue source change events
  [media] tvp5150: add sync lock/loss signal debug messages
  [media] tvp5150: add querystd

 .../devicetree/bindings/media/i2c/tvp5150.txt | 118 ++-
 drivers/media/i2c/tvp5150.c                   | 959 ++++++++++++------
 drivers/media/i2c/tvp5150_reg.h               |   3 +
 include/dt-bindings/media/tvp5150.h           |   2 -
 include/media/v4l2-rect.h                     |  27 +
 5 files changed, 812 insertions(+), 297 deletions(-)

-- 
2.17.1
