Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56797 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbeKHUhY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 15:37:24 -0500
From: Colin King <colin.king@canonical.com>
To: Dmitry Osipenko <digetx@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: tegra-vde: print long unsigned using %lu format specifier
Date: Thu,  8 Nov 2018 11:02:24 +0000
Message-Id: <20181108110224.1916-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The frame.flags & FLAG_B_FRAME is promoted to a long unsigned because
of the use of the BIT() macro when defining FLAG_B_FRAME and causing a
build warning. Fix this by using the %lu format specifer.

Cleans up warning:
drivers/staging/media/tegra-vde/tegra-vde.c:267:5: warning: format
specifies type 'int' but the argument has type 'unsigned long' [-Wformat]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 6f06061a40d9..66cf14212c14 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -262,7 +262,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 			value |= frame->frame_num;
 
 			dev_dbg(vde->miscdev.parent,
-				"\tFrame %d: frame_num = %d B_frame = %d\n",
+				"\tFrame %d: frame_num = %d B_frame = %lu\n",
 				i + 1, frame->frame_num,
 				(frame->flags & FLAG_B_FRAME));
 		} else {
-- 
2.19.1
