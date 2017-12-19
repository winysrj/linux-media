Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33742 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752377AbdLSVAb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:00:31 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 03/10] staging: atomisp: lm3554: Fix control values
Date: Tue, 19 Dec 2017 22:59:50 +0200
Message-Id: <20171219205957.10933-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver fails to initialize due to insane settings in the
control init array.

Fix this by moving to sanity.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 4fd9f538ac95..974b6ff50c7a 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -562,10 +562,10 @@ static const struct v4l2_ctrl_config lm3554_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_FLASH_STATUS,
-	 .type = V4L2_CTRL_TYPE_BOOLEAN,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
 	 .name = "Flash Status",
-	 .min = 0,
-	 .max = 100,
+	 .min = ATOMISP_FLASH_STATUS_OK,
+	 .max = ATOMISP_FLASH_STATUS_TIMEOUT,
 	 .step = 1,
 	 .def = ATOMISP_FLASH_STATUS_OK,
 	 .flags = 0,
@@ -574,10 +574,10 @@ static const struct v4l2_ctrl_config lm3554_controls[] = {
 	{
 	 .ops = &ctrl_ops,
 	 .id = V4L2_CID_FLASH_STATUS_REGISTER,
-	 .type = V4L2_CTRL_TYPE_BOOLEAN,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
 	 .name = "Flash Status Register",
 	 .min = 0,
-	 .max = 100,
+	 .max = 255,
 	 .step = 1,
 	 .def = 0,
 	 .flags = 0,
-- 
2.15.1
