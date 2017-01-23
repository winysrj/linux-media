Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:29132 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdAWVRK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 16:17:10 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org,
        javier@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] exynos4-is: Add missing 'of_node_put'
Date: Mon, 23 Jan 2017 22:16:56 +0100
Message-Id: <20170123211656.11185-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is likely that a "of_node_put(ep)" is missing here.
There is one in the previous error handling code, and one a few lines
below in the normal case as well.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e3a8709138fa..da5b76c1df98 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -402,8 +402,10 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		return ret;
 	}
 
-	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
+	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS) {
+		of_node_put(ep);
 		return -EINVAL;
+	}
 
 	pd->mux_id = (endpoint.base.port - 1) & 0x1;
 
-- 
2.9.3

