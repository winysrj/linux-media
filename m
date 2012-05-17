Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28063 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762202Ab2EQQai (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:38 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUa7B010087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:36 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 55AFD1F4D24
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:36 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3ax-00087C-Ir
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:31 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/10] smiapp: Add support for 8-bit uncompressed formats
Date: Thu, 17 May 2012 19:30:08 +0300
Message-Id: <1337272209-31061-9-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for uncompressed 8-bit raw bayer formats.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 47d6901..ffc6eb7 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -367,6 +367,10 @@ static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
 	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_RGGB, },
 	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_BGGR, },
 	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ V4L2_MBUS_FMT_SGRBG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ V4L2_MBUS_FMT_SRGGB8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ V4L2_MBUS_FMT_SBGGR8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ V4L2_MBUS_FMT_SGBRG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GBRG, },
 };
 
 const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
-- 
1.7.2.5

