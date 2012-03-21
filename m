Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57768 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab2CULDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 1/9] mx2_camera: Fix sizeimage computation in try_fmt()
Date: Wed, 21 Mar 2012 12:03:20 +0100
Message-Id: <1332327808-6056-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The try_fmt() handler restricts the image width based on the hardware
limits and updates the bytesperline value, but doesn't update sizeimage.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx2_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 04aab0c..77f8dde 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1142,6 +1142,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 			pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
 							xlate->host_fmt);
 			BUG_ON(pix->bytesperline < 0);
+			pix->sizeimage = pix->height * pix->bytesperline;
 		}
 	}
 
-- 
1.7.3.4

