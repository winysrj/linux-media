Return-path: <linux-media-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:20225 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966000Ab2EOTnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 15:43:37 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org, corbet@lwn.net
Cc: linux-media@vger.kernel.org
Subject: [PATCH] mmp-camera: specify XO-1.75 clock speed
Message-Id: <20120515194331.77C519D401E@zog.reactivated.net>
Date: Tue, 15 May 2012 20:43:31 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the ov7670 camera to return images at the requested frame rate,
it needs to make calculations based on the clock speed, which is
a completely external factor (depends on the wiring of the system).

On the XO-1.75, which is the only known mmp-camera user, the camera
is clocked at 48MHz.

Pass this information to the ov7670 driver, to fix an issue where
a framerate faster than the requested amount was being provided.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/marvell-ccic/mmp-driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

Jon, is it OK to assume that XO-1.75 is the only mmp-camera user?

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index c4c17fe..0ba49c7 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -188,6 +188,13 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
 	spin_lock_init(&mcam->dev_lock);
+
+	/*
+	 * Set the clock speed for the XO-1.75; I don't believe this
+	 * driver has ever run anywhere else.
+	 */
+	mcam->clock_speed = 48;
+
 	/*
 	 * Get our I/O memory.
 	 */
-- 
1.7.10.1

