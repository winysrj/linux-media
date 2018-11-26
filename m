Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13150 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbeKZSbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 13:31:55 -0500
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        mchehab+samsung@kernel.org, hverkuil@xs4all.nl
Subject: [PATCH 1/2] media: imx319: fix wrong order in test pattern menus
Date: Mon, 26 Nov 2018 15:43:33 +0800
Message-Id: <1543218214-10767-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

current imx319 test pattern order in ctrl menu
is not correct, this patch fixes it.

Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
 drivers/media/i2c/imx319.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index 0d3e27812b93..acd988d2d7f1 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -1648,8 +1648,8 @@ struct imx319 {
 
 static const char * const imx319_test_pattern_menu[] = {
 	"Disabled",
-	"100% color bars",
 	"Solid color",
+	"100% color bars",
 	"Fade to gray color bars",
 	"PN9"
 };
-- 
1.9.1
