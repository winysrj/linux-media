Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59870 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbAVMLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 07:11:41 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id AEB7920AEF
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2015 13:07:30 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] VSP1 fixes
Date: Thu, 22 Jan 2015 14:12:15 +0200
Message-ID: <10158734.57ijZY4TKD@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1fc77d013ba85a29e2edfaba02fd21e8c8187fae:

  [media] cx23885: Hauppauge WinTV-HVR5525 (2014-12-30 10:48:04 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 63a9e32eb6862386ac7acd6bd773d57d11a64a78:

  v4l: vsp1: Fix VI6_DISP_IRQ_STA_LNE macro (2015-01-22 14:11:11 +0200)

----------------------------------------------------------------
Nobuhiro Iwamatsu (2):
      v4l: vsp1: Fix VI6_DISP_IRQ_ENB_LNEE macro
      v4l: vsp1: Fix VI6_DISP_IRQ_STA_LNE macro

Takanari Hayama (1):
      v4l: vsp1: bru: Fix minimum input pixel size

 drivers/media/platform/vsp1/vsp1_bru.c  | 2 +-
 drivers/media/platform/vsp1/vsp1_regs.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

