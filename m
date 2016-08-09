Return-path: <linux-media-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:59232 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbcHIPgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2016 11:36:48 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success
Date: Tue,  9 Aug 2016 17:36:41 +0200
Message-Id: <1470757001-4333-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When resuming from suspend-to-RAM on r8a7795/salvator-x:

    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
    PM: Device fe940000.fdp1 failed to resume noirq: error 1
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
    PM: Device fe944000.fdp1 failed to resume noirq: error 1
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
    PM: Device fe948000.fdp1 failed to resume noirq: error 1

According to its documentation, rcar_fcp_enable() returns 0 on success
or a negative error code if an error occurs.  Hence
fdp1_pm_runtime_resume() and vsp1_pm_runtime_resume() forward its return
value to their callers.

However, rcar_fcp_enable() forwards the return value of
pm_runtime_get_sync(), which can actually be 1 on success, leading to
the resume failure above.

To fix this, consider only negative values returned by
pm_runtime_get_sync() to be failures.

Fixes: 7b49235e83b2347c ("[media] v4l: Add Renesas R-Car FCP driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/media/platform/rcar-fcp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 0ff6b1edf1dbf677..7e944479205d4059 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -99,10 +99,16 @@ EXPORT_SYMBOL_GPL(rcar_fcp_put);
  */
 int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 {
+	int error;
+
 	if (!fcp)
 		return 0;
 
-	return pm_runtime_get_sync(fcp->dev);
+	error = pm_runtime_get_sync(fcp->dev);
+	if (error < 0)
+		return error;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rcar_fcp_enable);
 
-- 
1.9.1

