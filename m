Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51147 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRRLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:11:06 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 5670020BD6
	for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 18:07:46 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] Renesas VSP1 changes
Date: Thu, 18 Dec 2014 19:11:09 +0200
Message-ID: <19725843.ovEOsgocJG@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal 
(2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to c87bdd51972b9f7148732e359407f8038b572e8f:

  v4l: vsp1: Always enable virtual RPF when BRU is in use (2014-12-18 19:09:14 
+0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: vsp1: Remove support for platform data

Takanari Hayama (2):
      v4l: vsp1: Reset VSP1 RPF source address
      v4l: vsp1: Always enable virtual RPF when BRU is in use

 drivers/media/platform/Kconfig          |  2 +-
 drivers/media/platform/vsp1/vsp1.h      | 14 ++++++-
 drivers/media/platform/vsp1/vsp1_drv.c  | 81 ++++++++++++--------------------
 drivers/media/platform/vsp1/vsp1_rpf.c  | 18 +++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h |  1 +
 drivers/media/platform/vsp1/vsp1_wpf.c  | 13 ++++---
 include/linux/platform_data/vsp1.h      | 27 --------------
 7 files changed, 68 insertions(+), 88 deletions(-)
 delete mode 100644 include/linux/platform_data/vsp1.h

-- 
Regards,

Laurent Pinchart

