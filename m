Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:55900 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3CKN5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 09:57:23 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf20so1673676bkc.7
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 06:57:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 21:57:22 +0800
Message-ID: <CAPgLHd80DXpcUmY69Vcc72ALGh3LrSGPakm0iBeXNUqLY-+Nxg@mail.gmail.com>
Subject: [PATCH -next] [media] davinci: vpfe: fix return value check in vpfe_enable_clock()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, gregkh@linuxfoundation.org,
	prabhakar.lad@ti.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 7b35171..6a8222c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -243,7 +243,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 
 		vpfe_dev->clks[i] =
 				clk_get(vpfe_dev->pdev, vpfe_cfg->clocks[i]);
-		if (vpfe_dev->clks[i] == NULL) {
+		if (IS_ERR(vpfe_dev->clks[i])) {
 			v4l2_err(vpfe_dev->pdev->driver,
 				"Failed to get clock %s\n",
 				vpfe_cfg->clocks[i]);
@@ -264,7 +264,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 	return 0;
 out:
 	for (i = 0; i < vpfe_cfg->num_clocks; i++)
-		if (vpfe_dev->clks[i]) {
+		if (!IS_ERR(vpfe_dev->clks[i])) {
 			clk_disable_unprepare(vpfe_dev->clks[i]);
 			clk_put(vpfe_dev->clks[i]);
 		}

