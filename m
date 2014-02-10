Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42212 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBJVxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 16:53:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/5] mt9t001 and mt9p031 sensors drivers patches
Date: Mon, 10 Feb 2014 22:54:39 +0100
Message-Id: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a set of miscellaneous patches for the mt9t001 and mt9p031 sensors
drivers. Please see individual commit messages for details.

The mt9t001 driver receives support for regulators and clocks. As a
prerequisite, patch 1/5 registers a fixed rate clock and two fixed voltage
regulators for the CM-T35 board camera sensor.

Laurent Pinchart (5):
  ARM: omap2: cm-t35: Add regulators and clock for camera sensor
  mt9t001: Add regulator support
  mt9t001: Add clock support
  mt9p031: Fix typo in comment
  mt9p031: Add support for PLL bypass

 arch/arm/mach-omap2/board-cm-t35.c |  16 +++
 drivers/media/i2c/mt9p031.c        |  34 +++++-
 drivers/media/i2c/mt9t001.c        | 229 +++++++++++++++++++++++++++++--------
 3 files changed, 228 insertions(+), 51 deletions(-)

-- 
Regards,

Laurent Pinchart

