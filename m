Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59740 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3FNXbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 19:31:42 -0400
Received: from avalon.localnet (unknown [91.177.128.27])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id AF86D35A4D
	for <linux-media@vger.kernel.org>; Sat, 15 Jun 2013 01:31:34 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] Sensor patches
Date: Sat, 15 Jun 2013 01:31:53 +0200
Message-ID: <1802886.BERXc0cPX4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull these two patches for the mt9p031 sensor.

The following changes since commit ab5060cdb8829c0503b7be2b239b52e9a25063b4:

  [media] drxk_hard: Remove most 80-cols checkpatch warnings (2013-06-08 
22:11:39 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 697dea9078ff4d495206082eb7d4941cf536a689:

  mt9p031: Use bulk regulator API (2013-06-10 11:48:29 +0200)

----------------------------------------------------------------
Lad, Prabhakar (1):
      media: i2c: mt9p031: add OF support

Laurent Pinchart (1):
      mt9p031: Use bulk regulator API

 Documentation/devicetree/bindings/media/i2c/mt9p031.txt | 40 ++++++++++++++
 drivers/media/i2c/mt9p031.c                             | 72 ++++++++++++----
 2 files changed, 95 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt

-- 
Regards,

Laurent Pinchart

