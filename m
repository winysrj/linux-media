Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24244 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdLSVAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:00:18 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 10/10] staging: atomisp: Fix DMI matching entry for MRD7
Date: Tue, 19 Dec 2017 22:59:57 +0200
Message-Id: <20171219205957.10933-10-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MRD7 board has in particular

	Base Board Information
		Manufacturer: Intel Corp.
		Product Name: TABLET
		Version: MRD 7

Fix the DMI matching entry for it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c   | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 8408a58ed764..d8b7183db252 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -286,7 +286,8 @@ static const struct dmi_system_id gmin_vars[] = {
 	{
 		.ident = "MRD7",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "MRD7"),
+			DMI_MATCH(DMI_BOARD_NAME, "TABLET"),
+			DMI_MATCH(DMI_BOARD_VERSION, "MRD 7"),
 		},
 		.driver_data = mrd7_vars,
 	},
-- 
2.15.1
