Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:41505 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0G0MGt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:06:49 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/4] mx2_camera: fix a race causing NULL dereference
Date: Tue, 27 Jul 2010 15:06:07 +0300
Message-Id: <9f12919acb3673ff10249ea3d151eccaa2818859.1280229966.git.baruch@tkos.co.il>
In-Reply-To: <cover.1280229966.git.baruch@tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mx25_camera_irq irq handler may get called after the camera has been
deactivated (from mx2_camera_deactivate). Detect this situation, and bail out.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/mx2_camera.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 881d5d8..1536bd4 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -384,6 +384,9 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
+	if (*fb_active == NULL)
+		goto out;
+
 	vb = &(*fb_active)->vb;
 	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -408,6 +411,7 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 
 	*fb_active = buf;
 
+out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-- 
1.7.1

