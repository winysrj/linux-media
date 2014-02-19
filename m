Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50386 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaBSRaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 12:30:55 -0500
Received: from avalon.localnet (unknown [91.178.208.133])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C50F435A46
	for <linux-media@vger.kernel.org>; Wed, 19 Feb 2014 18:29:53 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] Sensor drivers patches
Date: Wed, 19 Feb 2014 18:32:05 +0100
Message-ID: <19619219.WJ2Q48EY87@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to d57241e3cbde76b39d940570dbbfe12d6a70bcc6:

  mt9v032: Check return value of clk_prepare_enable/clk_set_rate (2014-02-19 
18:29:33 +0100)

----------------------------------------------------------------
Lad, Prabhakar (2):
      mt9p031: Check return value of clk_prepare_enable/clk_set_rate
      mt9v032: Check return value of clk_prepare_enable/clk_set_rate

Laurent Pinchart (5):
      ARM: omap2: cm-t35: Add regulators and clock for camera sensor
      mt9t001: Add regulator support
      mt9t001: Add clock support
      mt9p031: Fix typo in comment
      mt9p031: Add support for PLL bypass

 arch/arm/mach-omap2/board-cm-t35.c |  16 ++++
 drivers/media/i2c/mt9p031.c        |  49 +++++++++-
 drivers/media/i2c/mt9t001.c        | 229 ++++++++++++++++++++++++++++--------
 drivers/media/i2c/mt9v032.c        |  10 +-
 4 files changed, 248 insertions(+), 56 deletions(-)

-- 
Regards,

Laurent Pinchart

