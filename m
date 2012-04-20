Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:40609 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2DTQWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 12:22:51 -0400
Date: Fri, 20 Apr 2012 10:22:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] marvell-cam: fix an ARM build error
Message-ID: <20120420102250.1389bca8@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One of the OLPC changes lost a little in its translation to mainline,
leading to build errors on the ARM architecture.  Remove the offending
line, and all will be well.

Reported-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index d235523..c4c17fe 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -181,7 +181,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
-	mcam->platform = MHP_Armada610;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->dev = &pdev->dev;
