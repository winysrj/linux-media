Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56250 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab2CZLUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 07:20:24 -0400
Received: by wibhj6 with SMTP id hj6so4208468wib.1
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 04:20:23 -0700 (PDT)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	u.kleine-koenig@pengutronix.de, mchehab@infradead.org,
	kernel@pengutronix.de, linux@arm.linux.org.uk,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/3] i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16.
Date: Mon, 26 Mar 2012 13:20:04 +0200
Message-Id: <1332760804-22743-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1332760804-22743-1-git-send-email-javier.martin@vista-silicon.com>
References: <1332760804-22743-1-git-send-email-javier.martin@vista-silicon.com>
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

