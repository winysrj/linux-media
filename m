Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaEZTuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 02/11] omap3isp: Don't ignore subdev streamoff failures
Date: Mon, 26 May 2014 21:50:03 +0200
Message-Id: <1401133812-8745-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Record the value returned by subdevs from s_stream(0) and handle stop
failures when an error occurs.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 2c7aa67..7b10c46 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -999,16 +999,14 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 					 video, s_stream, 0);
 		}
 
-		v4l2_subdev_call(subdev, video, s_stream, 0);
+		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
 
 		if (subdev == &isp->isp_res.subdev)
-			ret = isp_pipeline_wait(isp, isp_pipeline_wait_resizer);
+			ret |= isp_pipeline_wait(isp, isp_pipeline_wait_resizer);
 		else if (subdev == &isp->isp_prev.subdev)
-			ret = isp_pipeline_wait(isp, isp_pipeline_wait_preview);
+			ret |= isp_pipeline_wait(isp, isp_pipeline_wait_preview);
 		else if (subdev == &isp->isp_ccdc.subdev)
-			ret = isp_pipeline_wait(isp, isp_pipeline_wait_ccdc);
-		else
-			ret = 0;
+			ret |= isp_pipeline_wait(isp, isp_pipeline_wait_ccdc);
 
 		/* Handle stop failures. An entity that fails to stop can
 		 * usually just be restarted. Flag the stop failure nonetheless
-- 
1.8.5.5

