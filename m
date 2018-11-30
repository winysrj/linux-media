Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbeK3M75 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 07:59:57 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 90A3B553
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 02:52:21 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.21] Xilinx media drivers updates
Date: Fri, 30 Nov 2018 03:52:50 +0200
Message-ID: <2073802.cUNYQbHYTa@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 
-0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git xilinx/next

for you to fetch changes up to 672d25bacfce9b50168b0ab7db872d66ae3aa4a6:

  media: xilinx: fix typo in formats table (2018-11-30 03:37:24 +0200)

----------------------------------------------------------------
Andrea Merello (1):
      media: xilinx: fix typo in formats table

Dhaval Shah (1):
      media: xilinx: Use SPDX-License-Identifier

 drivers/media/platform/xilinx/Kconfig       | 2 ++
 drivers/media/platform/xilinx/Makefile      | 2 ++
 drivers/media/platform/xilinx/xilinx-dma.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-dma.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-tpg.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vip.c  | 7 ++-----
 drivers/media/platform/xilinx/xilinx-vip.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.c | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.h | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.h  | 5 +----
 include/dt-bindings/media/xilinx-vip.h      | 5 +----
 12 files changed, 15 insertions(+), 41 deletions(-)

-- 
Regards,

Laurent Pinchart
