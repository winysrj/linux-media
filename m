Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46720 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2CZNSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:18:03 -0400
Received: by wgbdr13 with SMTP id dr13so3877041wgb.1
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:18:01 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	u.kleine-koenig@pengutronix.de, mchehab@infradead.org,
	kernel@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 2/3] i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16.
Date: Mon, 26 Mar 2012 15:17:47 +0200
Message-Id: <1332767868-2531-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1332767868-2531-1-git-send-email-javier.martin@vista-silicon.com>
References: <1332767868-2531-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 3128cfe..4db00c6 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -164,7 +164,7 @@ static struct platform_device visstrim_tvp5150 = {
 
 
 static struct mx2_camera_platform_data visstrim_camera = {
-	.flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_SWAP16 | MX2_CAMERA_PCLK_SAMPLE_RISING,
+	.flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_PCLK_SAMPLE_RISING,
 	.clk = 100000,
 };
 
-- 
1.7.0.4

