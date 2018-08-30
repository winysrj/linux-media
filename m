Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33645 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbeH3OTt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 10:19:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.19] staging/media/mt9t031/Kconfig: remove bogus entry
Message-ID: <179f7844-668a-4d15-eae1-feaf74d9e187@xs4all.nl>
Date: Thu, 30 Aug 2018 12:18:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'config SOC_CAMERA_IMX074' is a copy-and-paste error and should be removed.
This Kconfig is for mt9t031 only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/mt9t031/Kconfig b/drivers/staging/media/mt9t031/Kconfig
index f48e06a03cdb..9a58aaf72edd 100644
--- a/drivers/staging/media/mt9t031/Kconfig
+++ b/drivers/staging/media/mt9t031/Kconfig
@@ -1,9 +1,3 @@
-config SOC_CAMERA_IMX074
-	tristate "imx074 support (DEPRECATED)"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports IMX074 cameras from Sony
-
 config SOC_CAMERA_MT9T031
 	tristate "mt9t031 support (DEPRECATED)"
 	depends on SOC_CAMERA && I2C
