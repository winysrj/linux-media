Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36328 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbCIGjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 02:39:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 1/4] soc-camera: Unregister v4l2 clock in the OF bind error path
Date: Mon,  9 Mar 2015 08:39:33 +0200
Message-Id: <1425883176-29859-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2 clock registered in soc_of_bind() must be unregistered if an
error occurs and makes the function fail.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index cee7b56..4376172 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1659,6 +1659,8 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
 	if (!ret)
 		return 0;
+
+	v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
 	platform_device_del(sasc->pdev);
-- 
2.0.5

