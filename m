Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:53604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1BVJ5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 04:57:50 -0500
Date: Tue, 22 Feb 2011 10:57:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 2/3] sh: switch ap325rxa to dynamically manage the platform
 camera
In-Reply-To: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102221056430.1380@axis700.grange>
References: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use soc_camera_platform helper functions to dynamically manage the
camera device.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/sh/boards/mach-ap325rxa/setup.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 3e5fc3b..33bfebc 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -343,37 +343,31 @@ static struct soc_camera_link camera_link = {
 	.priv		= &camera_info,
 };
 
-static void dummy_release(struct device *dev)
+static struct platform_device *camera_device;
+
+static void ap325rxa_camera_release(struct device *dev)
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
 static int ap325rxa_camera_add(struct soc_camera_link *icl,
 			       struct device *dev)
 {
-	if (icl != &camera_link || camera_probe() <= 0)
-		return -ENODEV;
+	int ret = soc_camera_platform_add(icl, dev, &camera_device, &camera_link,
+					  ap325rxa_camera_release, 0);
+	if (ret < 0)
+		return ret;
 
-	camera_info.dev = dev;
+	ret = camera_probe();
+	if (ret < 0)
+		soc_camera_platform_del(icl, camera_device, &camera_link);
 
-	return platform_device_register(&camera_device);
+	return ret;
 }
 
 static void ap325rxa_camera_del(struct soc_camera_link *icl)
 {
-	if (icl != &camera_link)
-		return;
-
-	platform_device_unregister(&camera_device);
-	memset(&camera_device.dev.kobj, 0,
-	       sizeof(camera_device.dev.kobj));
+	soc_camera_platform_del(icl, camera_device, &camera_link);
 }
 #endif /* CONFIG_I2C */
 
-- 
1.7.2.3

