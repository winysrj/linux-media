Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34250 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbcGFXHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:33 -0400
Received: by mail-pa0-f65.google.com with SMTP id us13so97766pab.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:33 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 11/28] gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
Date: Wed,  6 Jul 2016 16:06:41 -0700
Message-Id: <1467846418-12913-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI data format was being programmed incorrectly for the
1x16 media bus formats. The CSI data format for 16-bit must
be bayer/generic (CSI_SENS_CONF_DATA_FMT_BAYER).

Suggested-by: Carsten Resch <Carsten.Resch@de.bosch.com>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 07c7091..0eac28c 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -258,12 +258,8 @@ static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code)
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
 	case MEDIA_BUS_FMT_UYVY8_1X16:
-		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
-		cfg->mipi_dt = MIPI_DT_YUV422;
-		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
-		break;
 	case MEDIA_BUS_FMT_YUYV8_1X16:
-		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
+		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
 		break;
-- 
1.9.1

