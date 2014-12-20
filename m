Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42114 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752877AbaLTMpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:54 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 8/8] [media] em28xx-video: fix missing newlines
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPr-0006Uq-Jk@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:51 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspection shows that newlines are missing from several kernel messages
in em28xx-video.  Fix these.

Cc: <stable@vger.kernel.org>
Fixes: a61f68119af3 ("[media] em28xx-video: implement em28xx_ops: suspend/resume hooks")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3b8c464bf25a..f220c1f376e3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2007,7 +2007,7 @@ static int em28xx_v4l2_suspend(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	em28xx_info("Suspending video extension");
+	em28xx_info("Suspending video extension\n");
 	em28xx_stop_urbs(dev);
 	return 0;
 }
@@ -2020,7 +2020,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
 	if (!dev->has_video)
 		return 0;
 
-	em28xx_info("Resuming video extension");
+	em28xx_info("Resuming video extension\n");
 	/* what do we do here */
 	return 0;
 }
-- 
1.8.3.1

