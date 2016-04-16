Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50970 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbcDPHE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Apr 2016 03:04:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media/omap1: assign resource before use
Date: Sat, 16 Apr 2016 09:03:47 +0200
Message-Id: <1460790246-3800892-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent cleanup patch accidentally moved the initial assignment
of the register resource after its first use, as shown by this
gcc warning:

drivers/staging/media/omap1/omap1_camera.c: In function 'omap1_cam_probe':
include/linux/ioport.h:191:12: error: 'res' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  return res->end - res->start + 1;
         ~~~^~~~~
drivers/staging/media/omap1/omap1_camera.c:1566:19: note: 'res' was declared here
  struct resource *res;
                   ^~~

This moves the line to immediately before the location that the variable
is used in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 76e543382bd4 ("staging: media: omap1: Switch to devm_ioremap_resource")
---
 drivers/staging/media/omap1/omap1_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
index 54b8dd2d2bba..078049481e8b 100644
--- a/drivers/staging/media/omap1/omap1_camera.c
+++ b/drivers/staging/media/omap1/omap1_camera.c
@@ -1579,6 +1579,7 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev) + resource_size(res),
 			     GFP_KERNEL);
 	if (!pcdev)
@@ -1614,7 +1615,6 @@ static int omap1_cam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
2.7.0

