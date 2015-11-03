Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:43109 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbbKCFkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 00:40:24 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/5] media: atmel-isi: setup YCC_SWAP correctly when using preview path
Date: Tue, 3 Nov 2015 13:45:11 +0800
Message-ID: <1446529512-19109-5-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
References: <1446529512-19109-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The preview path only can convert UYVY format to RGB data.

To make preview path work correctly, we need to set up YCC_SWAP
according to sensor output and convert them to UYVY.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v2:
- remove cfg2_yuv_swap for rgb format
- correct the comment style

 drivers/media/platform/soc_camera/atmel-isi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ae82068..826d04e 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -117,6 +117,20 @@ static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
 		case MEDIA_BUS_FMT_YVYU8_2X8:
 			return ISI_CFG2_YCC_SWAP_MODE_1;
 		}
+	} else if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_RGB565) {
+		/*
+		 * Preview path is enabled, it will convert UYVY to RGB format.
+		 * But if sensor output format is not UYVY, we need to set
+		 * YCC_SWAP_MODE to convert it as UYVY.
+		 */
+		switch (xlate->code) {
+		case MEDIA_BUS_FMT_VYUY8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_1;
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_2;
+		case MEDIA_BUS_FMT_YVYU8_2X8:
+			return ISI_CFG2_YCC_SWAP_MODE_3;
+		}
 	}
 
 	/*
-- 
1.9.1

