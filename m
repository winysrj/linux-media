Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37313 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbeAWOoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 09:44:16 -0500
Received: by mail-wm0-f68.google.com with SMTP id v71so2398299wmv.2
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 06:44:16 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: gregkh@linuxfoundation.org, mchehab@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858 kconfig
Date: Tue, 23 Jan 2018 14:37:26 +0000
Message-Id: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nothing in kernel use VIDEO_ATOMISP_OV8858 since commit 3a81c7660f80 ("media: staging: atomisp: Remove IMX sensor support")
Lets remove this kconfig option.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/staging/media/atomisp/i2c/Kconfig | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index db054d3c7ed6..f7f7177b9b37 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -28,18 +28,6 @@ config VIDEO_ATOMISP_GC2235
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_ATOMISP_OV8858
-       tristate "Omnivision ov8858 sensor support"
-	depends on ACPI
-       depends on I2C && VIDEO_V4L2 && VIDEO_ATOMISP
-       ---help---
-	 This is a Video4Linux2 sensor-level driver for the Omnivision
-	 ov8858 RAW sensor.
-
-	 OV8858 is a 8M raw sensor.
-
-	 It currently only works with the atomisp driver.
-
 config VIDEO_ATOMISP_MSRLIST_HELPER
        tristate "Helper library to load, parse and apply large register lists."
        depends on I2C
-- 
2.13.6
