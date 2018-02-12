Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932413AbeBLWIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 17:08:00 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 0/5] Add support for i2c_new_secondary_device
Date: Mon, 12 Feb 2018 22:07:48 +0000
Message-Id: <1518473273-6333-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Back in 2014, Jean-Michel provided patches [0] to implement a means of
describing software defined I2C addresses for devices through the DT nodes.

The patch to implement the function "i2c_new_secondary_device()" was integrated,
but the corresponding driver update didn't get applied.

This short series re-bases Jean-Michel's patch to mainline for the ADV7604 driver
in linux-media, and also provides a patch for the ADV7511 DRM Bridge driver taking
the same approach.

This series allows us to define the I2C address allocations of these devices in
the device tree for the Renesas D3 platform where these two devices reside on
the same bus and conflict with each other presently..

[0] https://lkml.org/lkml/2014/10/22/468
[1] https://lkml.org/lkml/2014/10/22/469

v2:
 - dt bindings split from driver changes
 - fixed up dt binding property descriptions
 - Update missing edid-i2c address setting (adv7511)
 - Provide update for r8a7792 DTB to account for address conflict

v3:
 - Split map register addresses into individual declarations across all uses


Jean-Michel Hautbois (2):
  dt-bindings: media: adv7604: Add support for i2c_new_secondary_device
  media: adv7604: Add support for i2c_new_secondary_device

Kieran Bingham (3):
  dt-bindings: adv7511: Add support for i2c_new_secondary_device
  [RFT] ARM: dts: wheat: Fix ADV7513 address usage
  drm: adv7511: Add support for i2c_new_secondary_device

 .../bindings/display/bridge/adi,adv7511.txt        | 18 ++++++-
 .../devicetree/bindings/media/i2c/adv7604.txt      | 18 ++++++-
 arch/arm/boot/dts/r8a7792-wheat.dts                | 12 ++++-
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  6 +++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 42 +++++++++------
 drivers/media/i2c/adv7604.c                        | 62 ++++++++++++++--------
 6 files changed, 115 insertions(+), 43 deletions(-)

-- 
2.7.4
