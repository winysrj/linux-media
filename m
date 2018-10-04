Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37403 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbeJEBtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:49:07 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 07/11] media: imx-csi: Allow skipping odd chroma rows for YVU420
Date: Thu,  4 Oct 2018 11:53:57 -0700
Message-Id: <20181004185401.15751-8-slongerbeam@gmail.com>
In-Reply-To: <20181004185401.15751-1-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Skip writing U/V components to odd rows for YVU420 in addition to
YUV420 and NV12.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4b075bc949de..6dd53a8e35d2 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -452,6 +452,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		passthrough_bits = 16;
 		break;
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
-- 
2.17.1
