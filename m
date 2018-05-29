Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38612 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967570AbeE2Wlb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 18:41:31 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] media: staging: tegra-vde: Reset VDE regardless of memory client resetting failure
Date: Wed, 30 May 2018 01:41:06 +0300
Message-Id: <20180529224106.31565-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A failed memory client reset doesn't prevent VDE from resetting, hence
reset VDE regardless of preceding memory client resetting failure.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 6dd3bf4481be..6f06061a40d9 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -901,15 +901,12 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	 * the whole system.
 	 */
 	err = reset_control_assert(vde->rst_mc);
-	if (!err) {
-		err = reset_control_assert(vde->rst);
-		if (err)
-			dev_err(dev,
-				"DEC end: Failed to assert HW reset: %d\n",
-				err);
-	} else {
+	if (err)
 		dev_err(dev, "DEC end: Failed to assert MC reset: %d\n", err);
-	}
+
+	err = reset_control_assert(vde->rst);
+	if (err)
+		dev_err(dev, "DEC end: Failed to assert HW reset: %d\n", err);
 
 put_runtime_pm:
 	pm_runtime_mark_last_busy(dev);
-- 
2.17.0
