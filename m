Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60410 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdEEOL0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 10:11:26 -0400
From: Rene Hickersberger <renehickersberger@gmx.net>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rene Hickersberger <renehickersberger@gmx.net>
Subject: [PATCH] Staging: media: s5p-cec: Fixed spelling mistake
Date: Fri,  5 May 2017 16:09:58 +0200
Message-Id: <20170505140958.5981-1-renehickersberger@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed spelling mistake of "successfully"

Signed-off-by: Rene Hickersberger <renehickersberger@gmx.net>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 2a07968..7e9ace8 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -216,7 +216,7 @@ static int s5p_cec_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, cec);
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "successfuly probed\n");
+	dev_dbg(dev, "successfully probed\n");
 	return 0;
 }
 
-- 
2.9.3
