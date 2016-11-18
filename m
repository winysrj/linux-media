Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53474 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcKRQQd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 11:16:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [media] v4l: rcar_fdp1: mark PM functions as __maybe_unused
Date: Fri, 18 Nov 2016 17:16:04 +0100
Message-Id: <20161118161621.798004-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new driver produces a warning when CONFIG_PM is disabled:

platform/rcar_fdp1.c:2408:12: error: 'fdp1_pm_runtime_resume' defined but not used [-Werror=unused-function]
platform/rcar_fdp1.c:2399:12: error: 'fdp1_pm_runtime_suspend' defined but not used [-Werror=unused-function]

This marks the two functions as __maybe_unused.

Fixes: 4710b752e029 ("[media] v4l: Add Renesas R-Car FDP1 Driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/rcar_fdp1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index dd1a6ea17f22..674cc1309b43 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2396,7 +2396,7 @@ static int fdp1_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int fdp1_pm_runtime_suspend(struct device *dev)
+static int __maybe_unused fdp1_pm_runtime_suspend(struct device *dev)
 {
 	struct fdp1_dev *fdp1 = dev_get_drvdata(dev);
 
@@ -2405,7 +2405,7 @@ static int fdp1_pm_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int fdp1_pm_runtime_resume(struct device *dev)
+static int __maybe_unused fdp1_pm_runtime_resume(struct device *dev)
 {
 	struct fdp1_dev *fdp1 = dev_get_drvdata(dev);
 
-- 
2.9.0

