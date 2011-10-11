Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56291 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1JKJjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 05:39:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Report the ISP revision through the media controller API
Date: Tue, 11 Oct 2011 11:39:04 +0200
Message-Id: <1318325944-11666-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the media_device::hw_revision field to the ISP revision number.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 7b5ab42..192c448 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1697,6 +1697,7 @@ static int isp_register_entities(struct isp_device *isp)
 	isp->media_dev.dev = isp->dev;
 	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
 		sizeof(isp->media_dev.model));
+	isp->media_dev.hw_revision = isp->revision;
 	isp->media_dev.link_notify = isp_pipeline_link_notify;
 	ret = media_device_register(&isp->media_dev);
 	if (ret < 0) {
-- 
1.7.3.4

