Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33432 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbcB2NOI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:14:08 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 3/4] media: soc_camera: rcar_vin: Add cropcap callback function
Date: Mon, 29 Feb 2016 22:12:42 +0900
Message-Id: <1456751563-21246-4-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Add cropcap callback function because it is required for
clipping processing.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 9225992..96f3c8a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1913,6 +1913,13 @@ static int rcar_vin_get_selection(struct soc_camera_device *icd,
 	return 0;
 }
 
+static int rcar_vin_cropcap(struct soc_camera_device *icd,
+			    struct v4l2_cropcap *crop)
+{
+	/* TODO */
+	return 0;
+}
+
 static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= rcar_vin_add_device,
@@ -1928,6 +1935,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.set_bus_param	= rcar_vin_set_bus_param,
 	.init_videobuf2	= rcar_vin_init_videobuf2,
 	.get_selection	= rcar_vin_get_selection,
+	.cropcap	= rcar_vin_cropcap,
 };
 
 #ifdef CONFIG_OF
-- 
1.9.1

