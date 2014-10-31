Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62830 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaJaJJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 05:09:53 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH] media: soc_camera: rcar_vin: Fix interrupt enable in progressive
Date: Fri, 31 Oct 2014 18:09:25 +0900
Message-Id: <1414746565-23142-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

The progressive input is captured by the field interrupt.
Therefore the end of frame interrupt is unnecessary.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index d55e2c5..d3d2f7d 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -692,7 +692,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 		vnmc ^= VNMC_BPS;
 
 	/* progressive or interlaced mode */
-	interrupts = progressive ? VNIE_FIE | VNIE_EFE : VNIE_EFE;
+	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
 
 	/* ack interrupts */
 	iowrite32(interrupts, priv->base + VNINTS_REG);
-- 
1.9.1

