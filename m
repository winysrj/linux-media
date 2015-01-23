Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1076 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbbAWPwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:38 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 00/15] [media] adv7180: Add support for more chip variants
Date: Fri, 23 Jan 2015 16:52:19 +0100
Message-Id: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes from v1:
	* Reserved custom user control range for the fast switch control
	* Dropped the free-run mode control patch for now. The controls should
	  probably be standardized first, but that is going to be a different
	  patch series.

Original cover letter below:

The adv7180 is part of a larger family of chips which all implement
different features from a feature superset. This patch series step by step
extends the current adv7180 with features from the superset that are
currently not supported and gradually adding support for more variations of
the chip.

The first half of this series contains fixes and cleanups while the second
half adds new features and support for new chips


Lars-Peter Clausen (15):
  [media] adv7180: Do not request the IRQ again during resume
  [media] adv7180: Pass correct flags to request_threaded_irq()
  [media] adv7180: Use inline function instead of macro
  [media] adv7180: Cleanup register define naming
  [media] adv7180: Do implicit register paging
  [media] adv7180: Reset the device before initialization
  [media] adv7180: Add media controller support
  [media] adv7180: Consolidate video mode setting
  [media] adv7180: Prepare for multi-chip support
  [media] adv7180: Add support for the adv7182
  [media] adv7180: Add support for the adv7280/adv7281/adv7282
  [media] adv7180: Add support for the
    adv7280-m/adv7281-m/adv7281-ma/adv7282-m
  [media] adv7180: Add I2P support
  [media] adv7180: Add fast switch support
  [media] Add MAINTAINERS entry for the adv7180

 MAINTAINERS                        |    7 +
 drivers/media/i2c/Kconfig          |    2 +-
 drivers/media/i2c/adv7180.c        | 1016 +++++++++++++++++++++++++++++-------
 drivers/media/pci/sta2x11/Kconfig  |    1 +
 drivers/media/platform/Kconfig     |    2 +-
 include/uapi/linux/v4l2-controls.h |    4 +
 6 files changed, 831 insertions(+), 201 deletions(-)

-- 
1.8.0

