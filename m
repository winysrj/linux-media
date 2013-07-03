Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43753 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab3GCF4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:56:15 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH v3 0/7] marvell-ccic: update ccic driver to support some features
Date: Wed, 3 Jul 2013 13:55:57 +0800
Message-ID: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch set adds some feature into the marvell ccic driver

Patch 1: Support MIPI sensor
Patch 2: Support clock tree
Patch 3: reset ccic when stop streaming, which makes CCIC more stable
Patch 4: refine the mcam_set_contig_buffer function
Patch 5: add some new fmts to support
Patch 6: add SOF-EOF pair check to make the CCIC more stable
Patch 7: use resource managed allocation

change log:
Patch 1:
  fix the unlock issue
  add some comments
  remove int mipi_enabled in struct mmp_camera_platform_data
  get "mipi" clk at first in mmpcam_power_up()
Patch 2:
  Add mcam_deinit_clk function
  Some changes in mcam_init_clk function
Patch 7:
  A little adjustment based patch 2 change

Libin Yang (7):
  marvell-ccic: add MIPI support for marvell-ccic driver
  marvell-ccic: add clock tree support for marvell-ccic driver
  marvell-ccic: reset ccic phy when stop streaming for stability
  marvell-ccic: refine mcam_set_contig_buffer function
  marvell-ccic: add new formats support for marvell-ccic driver
  marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
  marvell-ccic: switch to resource managed allocation and request

 drivers/media/platform/marvell-ccic/cafe-driver.c |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   |  325 +++++++++++++++++----
 drivers/media/platform/marvell-ccic/mcam-core.h   |   50 +++-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |  274 ++++++++++++++---
 include/media/mmp-camera.h                        |   18 ++
 5 files changed, 578 insertions(+), 93 deletions(-)

-- 
1.7.9.5

