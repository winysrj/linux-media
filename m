Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.5]:40603 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbeIDBML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 21:12:11 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id BD25F2E6A1
        for <linux-media@vger.kernel.org>; Mon,  3 Sep 2018 15:26:39 -0500 (CDT)
Date: Mon, 3 Sep 2018 15:26:13 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] drxj: fix spelling mistake in fall-through annotations
Message-ID: <20180903202613.GA28844@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace "falltrough" with a proper "fall through" annotation.

This fix is part of the ongoing efforts to enabling
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 9628d40..551b7d6 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -3555,8 +3555,8 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 		if (!ext_attr->has_smatx)
 			return -EIO;
 		switch (uio_cfg->mode) {
-		case DRX_UIO_MODE_FIRMWARE_SMA:	/* falltrough */
-		case DRX_UIO_MODE_FIRMWARE_SAW:	/* falltrough */
+		case DRX_UIO_MODE_FIRMWARE_SMA:	/* fall through */
+		case DRX_UIO_MODE_FIRMWARE_SAW:	/* fall through */
 		case DRX_UIO_MODE_READWRITE:
 			ext_attr->uio_sma_tx_mode = uio_cfg->mode;
 			break;
@@ -3579,7 +3579,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 		if (!ext_attr->has_smarx)
 			return -EIO;
 		switch (uio_cfg->mode) {
-		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
+		case DRX_UIO_MODE_FIRMWARE0:	/* fall through */
 		case DRX_UIO_MODE_READWRITE:
 			ext_attr->uio_sma_rx_mode = uio_cfg->mode;
 			break;
@@ -3603,7 +3603,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 		if (!ext_attr->has_gpio)
 			return -EIO;
 		switch (uio_cfg->mode) {
-		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
+		case DRX_UIO_MODE_FIRMWARE0:	/* fall through */
 		case DRX_UIO_MODE_READWRITE:
 			ext_attr->uio_gpio_mode = uio_cfg->mode;
 			break;
@@ -3639,7 +3639,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 			}
 			ext_attr->uio_irqn_mode = uio_cfg->mode;
 			break;
-		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
+		case DRX_UIO_MODE_FIRMWARE0:	/* fall through */
 		default:
 			return -EINVAL;
 			break;
-- 
2.7.4
