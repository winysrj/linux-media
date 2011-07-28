Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50862 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1G1V7c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 17:59:32 -0400
Received: from dyn3-82-128-185-212.psoas.suomi.net ([82.128.185.212] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <crope@iki.fi>)
	id 1QmYc6-0008Gl-Nm
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 00:59:30 +0300
Message-ID: <4E31DBC2.4060708@iki.fi>
Date: Fri, 29 Jul 2011 00:59:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: use MFE lock for PCTV nanoStick T2 290e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index ab8a740..b9cfe93 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -604,7 +604,7 @@ static void unregister_dvb(struct em28xx_dvb *dvb)
 
 static int dvb_init(struct em28xx *dev)
 {
-	int result = 0;
+	int result = 0, mfe_shared = 0;
 	struct em28xx_dvb *dvb;
 
 	if (!dev->board.has_dvb) {
@@ -767,6 +767,8 @@ static int dvb_init(struct em28xx *dev)
 				dvb_frontend_detach(dvb->fe[1]);
 				/* leave FE 0 still active */
 			}
+
+			mfe_shared = 1;
 		}
 		break;
 	case EM2884_BOARD_TERRATEC_H5:
@@ -823,6 +825,9 @@ static int dvb_init(struct em28xx *dev)
 	if (result < 0)
 		goto out_free;
 
+	/* MFE lock */
+	dvb->adapter.mfe_shared = mfe_shared;
+
 	em28xx_info("Successfully loaded em28xx-dvb\n");
 ret:
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-- 
1.7.6
