Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1055 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752304AbbAMMB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:27 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 00/16] [media] adv7180: Add support for different chip
Date: Tue, 13 Jan 2015 13:01:05 +0100
Message-Id: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 is part of a larger family of chips which all implement
different features from a feature superset. This patch series step by step
extends the current adv7180 with features from the superset that are
currently not supported and gradually adding support for more variations of
the chip.

The first half of this series contains fixes and cleanups while the second
half adds new features and support for new chips.

- Lars

Lars-Peter Clausen (16):
  [media] adv7180: Do not request the IRQ again during resume
  [media] adv7180: Pass correct flags to request_threaded_irq()
  [media] adv7180: Use inline function instead of macro
  [media] adv7180: Cleanup register define naming
  [media] adv7180: Do implicit register paging
  [media] adv7180: Reset the device before initialization
  [media] adv7180: Add media controller support
  [media] adv7180: Consolidate video mode setting
  [media] adv7180: Prepare for multi-chip support
  [media] adv7180: Add support for the ad7182
  [media] adv7180: Add support for the adv7280/adv7281/adv7282
  [media] adv7180: Add support for the
    adv7280-m/adv7281-m/adv7281-ma/adv7282-m
  [media] adv7180: Add I2P support
  [media] adv7180: Add fast switch support
  [media] adv7180: Add free run mode controls
  [media] Add MAINTAINERS entry for the adv7180

 MAINTAINERS                       |    7 +
 drivers/media/i2c/Kconfig         |    2 +-
 drivers/media/i2c/adv7180.c       | 1137 ++++++++++++++++++++++++++++++-------
 drivers/media/pci/sta2x11/Kconfig |    1 +
 drivers/media/platform/Kconfig    |    2 +-
 5 files changed, 947 insertions(+), 202 deletions(-)

-- 
1.8.0

