Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35355 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbcGFXHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:39 -0400
Received: by mail-pf0-f196.google.com with SMTP id t190so96714pfb.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:39 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 16/28] gpu: ipu-v3: rename CSI client device
Date: Wed,  6 Jul 2016 16:06:46 -0700
Message-Id: <1467846418-12913-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the CSI client device in the client_reg[] table to
"imx-ipuv3-csi".

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 374100e..bd6771b 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1153,14 +1153,14 @@ static struct ipu_platform_reg client_reg[] = {
 			.dma[0] = IPUV3_CHANNEL_CSI0,
 			.dma[1] = -EINVAL,
 		},
-		.name = "imx-ipuv3-camera",
+		.name = "imx-ipuv3-csi",
 	}, {
 		.pdata = {
 			.csi = 1,
 			.dma[0] = IPUV3_CHANNEL_CSI1,
 			.dma[1] = -EINVAL,
 		},
-		.name = "imx-ipuv3-camera",
+		.name = "imx-ipuv3-csi",
 	}, {
 		.pdata = {
 			.di = 0,
-- 
1.9.1

