Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45782 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGYOly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:41:54 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com,
	Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 6/6] media: soc_camera: rcar_vin: Add r8a7794 device support
Date: Fri, 25 Jul 2014 16:40:50 +0200
Message-Id: <1406299250-23975-7-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1406299250-23975-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1406299250-23975-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Cc: linux-media@vger.kernel.org

---
 drivers/media/platform/soc_camera/rcar_vin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index e594230..86d98cd 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1391,6 +1391,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 };
 
 static struct platform_device_id rcar_vin_id_table[] = {
+	{ "r8a7794-vin",  RCAR_GEN2 },
 	{ "r8a7791-vin",  RCAR_GEN2 },
 	{ "r8a7790-vin",  RCAR_GEN2 },
 	{ "r8a7779-vin",  RCAR_H1 },
-- 
1.8.4.5

