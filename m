Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51654 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731311AbeHCPOt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 11:14:49 -0400
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 19B3E112
        for <linux-media@vger.kernel.org>; Fri,  3 Aug 2018 15:18:29 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.19] SPDX headers for Renesas media drivers
Date: Fri, 03 Aug 2018 16:19:10 +0300
Message-ID: <4114024.G5LE1Ta99a@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2c3449fb95c318920ca8dc645d918d408db219ac:

  media: usb: hackrf: Replace GFP_ATOMIC with GFP_KERNEL (2018-08-02 19:16:17 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/renesas/spdx

for you to fetch changes up to e4df82294fcd03c22522457c51117092a688805f:

  media: sh_mobile_ceu: convert to SPDX identifiers (2018-08-03 16:17:26 +0300)

----------------------------------------------------------------
Kuninori Morimoto (9):
      media: soc_camera_platform: convert to SPDX identifiers
      media: rcar-vin: convert to SPDX identifiers
      media: rcar-fcp: convert to SPDX identifiers
      media: rcar_drif: convert to SPDX identifiers
      media: rcar_fdp1: convert to SPDX identifiers
      media: rcar_jpu: convert to SPDX identifiers
      media: sh_veu: convert to SPDX identifiers
      media: sh_vou: convert to SPDX identifiers
      media: sh_mobile_ceu: convert to SPDX identifiers

 drivers/media/platform/rcar-fcp.c                        | 6 +-----
 drivers/media/platform/rcar-vin/Kconfig                  | 1 +
 drivers/media/platform/rcar-vin/Makefile                 | 1 +
 drivers/media/platform/rcar-vin/rcar-core.c              | 8 ++------
 drivers/media/platform/rcar-vin/rcar-dma.c               | 6 +-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c              | 6 +-----
 drivers/media/platform/rcar-vin/rcar-vin.h               | 6 +-----
 drivers/media/platform/rcar_drif.c                       | 8 ++------
 drivers/media/platform/rcar_fdp1.c                       | 6 +-----
 drivers/media/platform/rcar_jpu.c                        | 5 +----
 drivers/media/platform/sh_veu.c                          | 5 +----
 drivers/media/platform/sh_vou.c                          | 5 +----
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 6 +-----
 drivers/media/platform/soc_camera/soc_camera_platform.c  | 5 +----
 14 files changed, 16 insertions(+), 58 deletions(-)

-- 
Regards,

Laurent Pinchart
