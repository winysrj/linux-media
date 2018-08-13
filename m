Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39561 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbeHMRdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:14 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 05/14] staging: media: tegra-vde: Properly mark invalid entries
Date: Mon, 13 Aug 2018 16:50:18 +0200
Message-Id: <20180813145027.16346-6-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Entries in the reference picture list are marked as invalid by setting
the frame ID to 0x3f.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 275884e745df..0ce30c7ccb75 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -296,7 +296,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 				(frame->flags & FLAG_B_FRAME));
 		} else {
 			aux_addr = 0x6ADEAD00;
-			value = 0;
+			value = 0x3f;
 		}
 
 		tegra_vde_setup_iram_entry(vde, num_ref_pics, 0, i, value,
-- 
2.17.0
