Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:58958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1BVJ5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 04:57:51 -0500
Date: Tue, 22 Feb 2011 10:57:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 3/3] ARM: switch mackerel to dynamically manage the platform
 camera
In-Reply-To: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102221057040.1380@axis700.grange>
References: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use soc_camera_platform helper functions to dynamically manage the
camera device.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/board-mackerel.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 7b15d21..257355e 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -843,37 +843,23 @@ static struct soc_camera_link camera_link = {
 	.priv		= &camera_info,
 };
 
-static void dummy_release(struct device *dev)
+static struct platform_device *camera_device;
+
+static void mackerel_camera_release(struct device *dev)
 {
+	soc_camera_platform_release(&camera_device);
 }
 
-static struct platform_device camera_device = {
-	.name		= "soc_camera_platform",
-	.dev		= {
-		.platform_data	= &camera_info,
-		.release	= dummy_release,
-	},
-};
-
 static int mackerel_camera_add(struct soc_camera_link *icl,
 			       struct device *dev)
 {
-	if (icl != &camera_link)
-		return -ENODEV;
-
-	camera_info.dev = dev;
-
-	return platform_device_register(&camera_device);
+	return soc_camera_platform_add(icl, dev, &camera_device, &camera_link,
+				       mackerel_camera_release, 0);
 }
 
 static void mackerel_camera_del(struct soc_camera_link *icl)
 {
-	if (icl != &camera_link)
-		return;
-
-	platform_device_unregister(&camera_device);
-	memset(&camera_device.dev.kobj, 0,
-	       sizeof(camera_device.dev.kobj));
+	soc_camera_platform_del(icl, camera_device, &camera_link);
 }
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-- 
1.7.2.3

