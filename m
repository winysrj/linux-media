Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34710 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcFNWvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:16 -0400
Received: by mail-pf0-f193.google.com with SMTP id 66so306131pfy.1
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:16 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 16/38] gpu: ipu-v3: rename CSI client device
Date: Tue, 14 Jun 2016 15:49:12 -0700
Message-Id: <1465944574-15745-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
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

