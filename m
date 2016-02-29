Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33300 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbcB2NOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:14:06 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 2/4] media: soc_camera: rcar_vin: Add get_selection callback function
Date: Mon, 29 Feb 2016 22:12:41 +0900
Message-Id: <1456751563-21246-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Add get_selection callback function because it is required for
clipping processing.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index a22141b..9225992 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1906,6 +1906,13 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 	return vb2_queue_init(vq);
 }
 
+static int rcar_vin_get_selection(struct soc_camera_device *icd,
+				  struct v4l2_selection *sel)
+{
+	/* TODO */
+	return 0;
+}
+
 static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= rcar_vin_add_device,
@@ -1920,6 +1927,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 	.querycap	= rcar_vin_querycap,
 	.set_bus_param	= rcar_vin_set_bus_param,
 	.init_videobuf2	= rcar_vin_init_videobuf2,
+	.get_selection	= rcar_vin_get_selection,
 };
 
 #ifdef CONFIG_OF
-- 
1.9.1

