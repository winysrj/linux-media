Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54148 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeDVK2o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 06:28:44 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/3] R-Car Gen2 support for FDP1
Date: Sun, 22 Apr 2018 13:28:46 +0300
Message-Id: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This small patch series improves support of the FDP1 on R-Car Gen2 platforms
by enabling compilation without requiring the Gen3-only FCP dependency.

As the Kconfig change (2/3) conflicts with a patch recently posted by Geert I
have included it in the series as 1/3. Patch 3/3 fixes indentation oddities I
have run across during development.

Geert Uytterhoeven (1):
  v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS

Laurent Pinchart (2):
  v4l: rcar_fdp1: Enable compilation on Gen2 platforms
  v4l: rcar_fdp1: Fix indentation oddities

 drivers/media/platform/Kconfig     |  4 ++--
 drivers/media/platform/rcar_fdp1.c | 28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 16 deletions(-)

-- 
Regards,

Laurent Pinchart
