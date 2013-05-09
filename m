Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37050 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3EIMNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:13:25 -0400
Received: from avalon.localnet (unknown [91.178.157.175])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A79FC35A4D
	for <linux-media@vger.kernel.org>; Thu,  9 May 2013 14:12:58 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] Sensor fixes
Date: Thu, 09 May 2013 14:13:40 +0200
Message-ID: <16097691.OYFisSBvO7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 02615ed5e1b2283db2495af3cf8f4ee172c77d80:

  [media] cx88: make core less verbose (2013-04-28 12:40:52 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to aa254fcdce3d103731a097906569d13be9b528f7:

  s5k6aa: Convert to devm_gpio_request_one() (2013-05-09 13:34:11 +0200)

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      mt9p031: Power down the sensor if no supported device has been detected

Laurent Pinchart (10):
      mt9p031: Use gpio_is_valid()
      mt9v032: Free control handler in cleanup paths
      tvp514x: Fix double free
      media: i2c: Convert to gpio_request_one()
      media: i2c: Convert to devm_kzalloc()
      media: i2c: Convert to devm_gpio_request_one()
      media: i2c: Convert to devm_regulator_bulk_get()
      m5mols: Convert to devm_request_irq()
      s5c73m3: Convert to devm_gpio_request_one()
      s5k6aa: Convert to devm_gpio_request_one()

 drivers/media/i2c/ad9389b.c              |  8 +---
 drivers/media/i2c/adp1653.c              |  5 +--
 drivers/media/i2c/adv7170.c              |  3 +-
 drivers/media/i2c/adv7175.c              |  3 +-
 drivers/media/i2c/adv7180.c              |  4 +-
 drivers/media/i2c/adv7183.c              | 38 +++++++------------
 drivers/media/i2c/adv7393.c              |  8 +---
 drivers/media/i2c/adv7604.c              | 11 ++----
 drivers/media/i2c/ak881x.c               |  4 +-
 drivers/media/i2c/as3645a.c              |  7 +---
 drivers/media/i2c/bt819.c                |  4 +-
 drivers/media/i2c/bt856.c                |  3 +-
 drivers/media/i2c/bt866.c                |  3 +-
 drivers/media/i2c/cs5345.c               |  4 +-
 drivers/media/i2c/cs53l32a.c             |  4 +-
 drivers/media/i2c/cx25840/cx25840-core.c |  4 +-
 drivers/media/i2c/cx25840/cx25840-ir.c   |  7 +---
 drivers/media/i2c/ir-kbd-i2c.c           | 10 ++---
 drivers/media/i2c/ks0127.c               |  3 +-
 drivers/media/i2c/m52790.c               |  3 +-
 drivers/media/i2c/m5mols/m5mols_core.c   | 43 +++++++++-------------
 drivers/media/i2c/msp3400-driver.c       |  5 +--
 drivers/media/i2c/mt9m032.c              |  4 +-
 drivers/media/i2c/mt9p031.c              | 14 +++----
 drivers/media/i2c/mt9t001.c              |  4 +-
 drivers/media/i2c/mt9v011.c              |  6 +--
 drivers/media/i2c/mt9v032.c              |  8 ++--
 drivers/media/i2c/noon010pc30.c          | 40 ++++++--------------
 drivers/media/i2c/ov7640.c               |  5 +--
 drivers/media/i2c/ov7670.c               |  5 +--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 79 +++++++++++--------------------
 drivers/media/i2c/s5k6aa.c               | 73 +++++++++++--------------------
 drivers/media/i2c/saa6588.c              | 10 ++---
 drivers/media/i2c/saa7110.c              |  4 +-
 drivers/media/i2c/saa7115.c              |  4 +-
 drivers/media/i2c/saa7127.c              |  4 +-
 drivers/media/i2c/saa717x.c              |  5 +--
 drivers/media/i2c/saa7185.c              |  3 +-
 drivers/media/i2c/saa7191.c              |  4 +-
 drivers/media/i2c/smiapp/smiapp-core.c   | 18 +++------
 drivers/media/i2c/sony-btf-mpx.c         |  3 +-
 drivers/media/i2c/sr030pc30.c            |  4 +-
 drivers/media/i2c/tda7432.c              |  4 +-
 drivers/media/i2c/tda9840.c              |  3 +-
 drivers/media/i2c/tea6415c.c             |  3 +-
 drivers/media/i2c/tea6420.c              |  3 +-
 drivers/media/i2c/tlv320aic23b.c         |  4 +-
 drivers/media/i2c/tvaudio.c              |  5 +--
 drivers/media/i2c/tvp514x.c              |  1 -
 drivers/media/i2c/tvp5150.c              | 14 ++-----
 drivers/media/i2c/tw2804.c               |  5 +--
 drivers/media/i2c/tw9903.c               |  5 +--
 drivers/media/i2c/tw9906.c               |  5 +--
 drivers/media/i2c/uda1342.c              |  3 +-
 drivers/media/i2c/upd64031a.c            |  3 +-
 drivers/media/i2c/upd64083.c             |  3 +-
 drivers/media/i2c/vp27smpx.c             |  3 +-
 drivers/media/i2c/vpx3220.c              |  5 +--
 drivers/media/i2c/vs6624.c               | 20 +++-------
 drivers/media/i2c/wm8739.c               |  4 +-
 drivers/media/i2c/wm8775.c               |  4 +-
 61 files changed, 186 insertions(+), 392 deletions(-)
-- 
Regards,

Laurent Pinchart

