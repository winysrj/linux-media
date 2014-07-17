Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35973 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaGQKh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 06:37:27 -0400
Received: from avalon.localnet (unknown [91.178.197.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4EC79359FA
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:36:23 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] mt9v032 sensor patches
Date: Thu, 17 Jul 2014 12:37:33 +0200
Message-ID: <1413181.WhPVLKM5Ev@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 0a7db4ceaa58c01bce53e33928049491fd9215fc:

  mt9v032: use regmap (2014-07-17 12:35:39 +0200)

----------------------------------------------------------------
Philipp Zabel (5):
      mt9v032: fix hblank calculation
      mt9v032: do not clear reserved bits in read mode register
      mt9v032: add support for mt9v022 and mt9v024
      mt9v032: register v4l2 asynchronous subdevice
      mt9v032: use regmap

 drivers/media/i2c/Kconfig   |   1 +
 drivers/media/i2c/mt9v032.c | 166 ++++++++++++++++++++++++-------------------
 2 files changed, 93 insertions(+), 74 deletions(-)

-- 
Regards,

Laurent Pinchart

