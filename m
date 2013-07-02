Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:52267 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab3GBDfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 23:35:33 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH v2 0/7] marvell-ccic: update ccic driver to support some features
Date: Tue, 2 Jul 2013 11:31:01 +0800
Message-ID: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
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

Libin Yang (7):
  marvell-ccic: add MIPI support for marvell-ccic driver
  marvell-ccic: add clock tree support for marvell-ccic driver
  marvell-ccic: reset ccic phy when stop streaming for stability
  marvell-ccic: refine mcam_set_contig_buffer function
  marvell-ccic: add new formats support for marvell-ccic driver
  marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
  marvell-ccic: switch to resource managed allocation and request

 drivers/media/platform/marvell-ccic/cafe-driver.c |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   |  323 +++++++++++++++++----
 drivers/media/platform/marvell-ccic/mcam-core.h   |   51 +++-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |  267 ++++++++++++++---
 include/media/mmp-camera.h                        |   19 ++
 5 files changed, 563 insertions(+), 101 deletions(-)

-- 
1.7.9.5

