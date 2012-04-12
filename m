Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:34623 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759869Ab2DLIhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 04:37:35 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 3/3] Support additional dpcm compressed bayer formats.
Date: Thu, 12 Apr 2012 11:41:35 +0300
Message-Id: <1334220095-1698-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/yavta.c b/yavta.c
index 532fb1f..a89d475 100644
--- a/yavta.c
+++ b/yavta.c
@@ -149,7 +149,10 @@ static struct {
 	{ "SGBRG8", V4L2_PIX_FMT_SGBRG8 },
 	{ "SGRBG8", V4L2_PIX_FMT_SGRBG8 },
 	{ "SRGGB8", V4L2_PIX_FMT_SRGGB8 },
+	{ "SBGGR10_DPCM8", V4L2_PIX_FMT_SBGGR10DPCM8 },
+	{ "SGBRG10_DPCM8", V4L2_PIX_FMT_SGBRG10DPCM8 },
 	{ "SGRBG10_DPCM8", V4L2_PIX_FMT_SGRBG10DPCM8 },
+	{ "SRGGB10_DPCM8", V4L2_PIX_FMT_SRGGB10DPCM8 },
 	{ "SBGGR10", V4L2_PIX_FMT_SBGGR10 },
 	{ "SGBRG10", V4L2_PIX_FMT_SGBRG10 },
 	{ "SGRBG10", V4L2_PIX_FMT_SGRBG10 },
-- 
1.7.2.5

