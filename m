Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49632 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbbGYGFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2015 02:05:06 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NS100I3Y4WDV560@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 25 Jul 2015 15:05:01 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC media driver updates for 4.3
Date: Sat, 25 Jul 2015 08:04:02 +0200
Message-id: <1437804242-29656-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.3/media/next-1

for you to fetch changes up to 689b0b369a78dc85cb7b8cdaa412cee455b0c650:

  s5p-jpeg: Eliminate double kfree() (2015-07-25 07:12:31 +0200)

----------------------------------------------------------------
Andrzej Pietrasiewicz (1):
      s5p-jpeg: Eliminate double kfree()

Krzysztof Kozlowski (1):
      s5p-tv: Drop owner assignment from i2c_driver

Marek Szyprowski (2):
      s5p-mfc: add return value check in mfc_sys_init_cmd
      s5p-mfc: add additional check for incorrect memory configuration

Nicholas Mc Guire (1):
      s5p-tv: fix wait_event_timeout return handling

Seung-Woo Kim (1):
      s5p-mfc: fix state check from encoder queue_setup

 drivers/media/platform/s5p-jpeg/jpeg-core.c     |   14 ++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    6 +++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    9 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   11 +++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   12 +++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 +++++---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c     |    1 -
 drivers/media/platform/s5p-tv/mixer_reg.c       |   12 +++++-------
 drivers/media/platform/s5p-tv/sii9234_drv.c     |    1 -
 10 files changed, 41 insertions(+), 35 deletions(-)

--
Regards,
Sylwester

