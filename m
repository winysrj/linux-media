Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43923 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbeHMRdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:22 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 10/14] staging: media: tegra-vde: Keep VDE in reset when unused
Date: Mon, 13 Aug 2018 16:50:23 +0200
Message-Id: <20180813145027.16346-11-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

There is no point in keeping the VDE module out of reset when it is not
in use. Reset it on runtime suspend.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 3bc0bfcfe34e..4b3c6ab3c77e 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -1226,6 +1226,7 @@ static int tegra_vde_runtime_suspend(struct device *dev)
 	}
 
 	reset_control_assert(vde->rst_bsev);
+	reset_control_assert(vde->rst);
 
 	usleep_range(2000, 4000);
 
-- 
2.17.0
