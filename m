Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:34216 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbeBEUKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:10:25 -0500
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing with a mask
Date: Mon,  5 Feb 2018 21:09:57 +0100
Message-Id: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In one Renesas driver, I found a typo which turned an intended bit shift ('<<')
into a comparison ('<'). Because this is a subtle issue, I looked tree wide for
similar patterns. This small patch series is the outcome.

Buildbot and checkpatch are happy. Only compile-tested. To be applied
individually per sub-system, I think. I'd think only the net: amd: patch needs
to be conisdered for stable, but I leave this to people who actually know this
driver.

CCing Dan. Maybe he has an idea how to add a test to smatch? In my setup, only
cppcheck reported a 'coding style' issue with a low prio.

Wolfram Sang (4):
  v4l: vsp1: fix mask creation for MULT_ALPHA_RATIO
  drm/exynos: fix comparison to bitshift when dealing with a mask
  v4l: dvb-frontends: stb0899: fix comparison to bitshift when dealing
    with a mask
  net: amd-xgbe: fix comparison to bitshift when dealing with a mask

 drivers/gpu/drm/exynos/regs-fimc.h        | 2 +-
 drivers/media/dvb-frontends/stb0899_reg.h | 8 ++++----
 drivers/media/platform/vsp1/vsp1_regs.h   | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.11.0
