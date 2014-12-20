Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42112 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752877AbaLTMpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:49 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 7/8] [media] em28xx-dvb: fix missing newlines
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPm-0006Um-GT@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:46 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspection shows that newlines are missing from several kernel messages
in em28xx-dvb.  Fix these.

Cc: <stable@vger.kernel.org>
Fixes: ca2b46dacbf5 ("[media] em28xx-dvb: implement em28xx_ops: suspend/resume hooks")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 80c384c390e2..aee70d483264 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1775,17 +1775,17 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	em28xx_info("Suspending DVB extension");
+	em28xx_info("Suspending DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_suspend(dvb->fe[0]);
-			em28xx_info("fe0 suspend %d", ret);
+			em28xx_info("fe0 suspend %d\n", ret);
 		}
 		if (dvb->fe[1]) {
 			dvb_frontend_suspend(dvb->fe[1]);
-			em28xx_info("fe1 suspend %d", ret);
+			em28xx_info("fe1 suspend %d\n", ret);
 		}
 	}
 
@@ -1802,18 +1802,18 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	if (!dev->board.has_dvb)
 		return 0;
 
-	em28xx_info("Resuming DVB extension");
+	em28xx_info("Resuming DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_resume(dvb->fe[0]);
-			em28xx_info("fe0 resume %d", ret);
+			em28xx_info("fe0 resume %d\n", ret);
 		}
 
 		if (dvb->fe[1]) {
 			ret = dvb_frontend_resume(dvb->fe[1]);
-			em28xx_info("fe1 resume %d", ret);
+			em28xx_info("fe1 resume %d\n", ret);
 		}
 	}
 
-- 
1.8.3.1

