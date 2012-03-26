Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55236 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932647Ab2CZOmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:42:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] omap3isp: preview: Skip brightness and contrast in configuration ioctl
Date: Mon, 26 Mar 2012 16:42:29 +0200
Message-Id: <1332772951-19108-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brightness and contrast are handled through V4L2 controls. Their
configuration bit in the preview engine update attributes table is set
to -1 to reflect that. However, the VIDIOC_OMAP3ISP_PRV_CFG ioctl
handler doesn't handle -1 correctly as a configuration bit value, and
erroneously considers that the parameter has been selected for update by
the ioctl caller. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 6d0fb2c..cf5014f 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -903,7 +903,7 @@ static int preview_config(struct isp_prev_device *prev,
 		attr = &update_attrs[i];
 		bit = 0;
 
-		if (!(cfg->update & attr->cfg_bit))
+		if (attr->cfg_bit == -1 || !(cfg->update & attr->cfg_bit))
 			continue;
 
 		bit = cfg->flag & attr->cfg_bit;
-- 
1.7.3.4

