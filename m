Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2F2C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 16:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29D422064A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 16:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfCSQgc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:36:32 -0400
Received: from sauhun.de ([88.99.104.3]:46062 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfCSQgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 12:36:32 -0400
Received: from localhost (p5486CE21.dip0.t-ipconnect.de [84.134.206.33])
        by pokefinder.org (Postfix) with ESMTPSA id A74A02C3F83;
        Tue, 19 Mar 2019 17:36:28 +0100 (CET)
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/1] staging: media: imx: imx7-mipi-csis: simplify getting .driver_data
Date:   Tue, 19 Mar 2019 17:36:22 +0100
Message-Id: <20190319163622.30607-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We should get 'driver_data' from 'struct device' directly. Going via
platform_device is an unneeded step back and forth.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Build tested only. buildbot is happy.

 drivers/staging/media/imx/imx7-mipi-csis.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 2ddcc42ab8ff..44569c63e4de 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -1039,8 +1039,7 @@ static int mipi_csis_probe(struct platform_device *pdev)
 
 static int mipi_csis_pm_suspend(struct device *dev, bool runtime)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
+	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
 	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
 	int ret = 0;
 
@@ -1064,8 +1063,7 @@ static int mipi_csis_pm_suspend(struct device *dev, bool runtime)
 
 static int mipi_csis_pm_resume(struct device *dev, bool runtime)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct v4l2_subdev *mipi_sd = platform_get_drvdata(pdev);
+	struct v4l2_subdev *mipi_sd = dev_get_drvdata(dev);
 	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
 	int ret = 0;
 
-- 
2.11.0

