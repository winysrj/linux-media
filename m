Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64666 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaJNHUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:20:52 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 1/2] media: soc_camera: rcar_vin: Add r8a7794 device support
Date: Tue, 14 Oct 2014 16:20:23 +0900
Message-Id: <1413271224-9792-2-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
References: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index bf3588f..224604d0 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1887,6 +1887,7 @@ MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
 #endif
 
 static struct platform_device_id rcar_vin_id_table[] = {
+	{ "r8a7794-vin",  RCAR_GEN2 },
 	{ "r8a7791-vin",  RCAR_GEN2 },
 	{ "r8a7790-vin",  RCAR_GEN2 },
 	{ "r8a7779-vin",  RCAR_H1 },
-- 
1.9.1

