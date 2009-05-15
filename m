Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46442 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754337AbZEORTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:19:48 -0400
Date: Fri, 15 May 2009 19:20:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 07/10 v2] sh: prepare board-ap325rxa.c for v4l2-subdev
 conversion
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151829100.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We will be registering and unregistering the soc_camera_platform platform
device multiple times, therefore we need a .release() method and have to
nullify the kobj.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Another one for "sh". Again have to synchronise.

 arch/sh/boards/board-ap325rxa.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index f644ad7..9329fe5 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -323,13 +323,19 @@ static struct soc_camera_platform_info camera_info = {
 		.bus_id		= 0,
 		.add_device	= ap325rxa_camera_add,
 		.del_device	= ap325rxa_camera_del,
+		.module_name	= "soc_camera_platform",
 	},
 };
 
+static void dummy_release(struct device *dev)
+{
+}
+
 static struct platform_device camera_device = {
 	.name		= "soc_camera_platform",
 	.dev		= {
 		.platform_data	= &camera_info,
+		.release	= dummy_release,
 	},
 };
 
@@ -346,8 +352,11 @@ static int ap325rxa_camera_add(struct soc_camera_link *icl,
 
 static void ap325rxa_camera_del(struct soc_camera_link *icl)
 {
-	if (icl == &camera_info.link)
-		platform_device_unregister(&camera_device);
+	if (icl != &camera_info.link)
+		return;
+
+	platform_device_unregister(&camera_device);
+	memset(&migor_camera_device.dev.kobj, 0, sizeof(migor_camera_device.dev.kobj));
 }
 #endif /* CONFIG_I2C */
 
-- 
1.6.2.4

