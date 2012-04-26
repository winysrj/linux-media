Return-path: <linux-media-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:39976 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759153Ab2DZUHE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:07:04 -0400
From: Chris Ball <cjb@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] marvell-cam: Build fix: mcam->platform assignment
Date: Thu, 26 Apr 2012 16:07:25 -0400
Message-ID: <87ehra9s02.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that this driver has never been buildable upstream, because it
was merged with this line included:

       mcam->platform = MHP_Armada610;

which causes:

drivers/media/video/marvell-ccic/mmp-driver.c:184:6: error: 'struct mcam_camera' has no member named 'platform'
drivers/media/video/marvell-ccic/mmp-driver.c:184:19: error: 'MHP_Armada610' undeclared (first use in this function)

Since neither the ->platform member nor MHP_Armada610 are defined,
this patch removes the entire line.

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable <stable@vger.kernel.org>
---
Jon, not sure what the intention was here -- any ideas?  Thanks.

 drivers/media/video/marvell-ccic/mmp-driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
