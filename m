Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36261 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1GHUwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/6] marvell-cam: power down mmp camera on registration failure
Date: Fri,  8 Jul 2011 14:50:48 -0600
Message-Id: <1310158250-168899-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

If registration does not work, we don't want to leave the sensor powered on.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mmp-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index 8415915..d6b7645 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -267,8 +267,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 
 out_unregister:
 	mccic_shutdown(mcam);
-	mmpcam_power_down(mcam);
 out_gpio2:
+	mmpcam_power_down(mcam);
 	gpio_free(pdata->sensor_reset_gpio);
 out_gpio:
 	gpio_free(pdata->sensor_power_gpio);
-- 
1.7.6

