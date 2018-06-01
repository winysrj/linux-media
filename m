Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36617 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbeFAAbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:13 -0400
Received: by mail-pl0-f66.google.com with SMTP id v24-v6so14225305plo.3
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:13 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 07/10] media: imx-csi: Allow skipping odd chroma rows for YVU420
Date: Thu, 31 May 2018 17:30:46 -0700
Message-Id: <1527813049-3231-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Skip writing U/V components to odd rows for YVU420 in addition to
YUV420 and NV12.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6101e2ed..c878a00 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -430,6 +430,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		passthrough_bits = 16;
 		break;
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
-- 
2.7.4
