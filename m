Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42099 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753066AbaLTMpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:24 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/8] [media] em28xx: ensure "closing" messages terminate with
 a newline
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPM-0006UR-W1@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:20 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lockdep splat addressed in a previous commit revealed that at
least one message in em28xx-input.c was missing a new line:

em28178 #0: Closing input extensionINFO: trying to register non-static key.

Further inspection shows several other messages also miss a new line.
These will be fixed in a subsequent patch.

Cc: <stable@vger.kernel.org>
Fixes: aa929ad783c0 ("[media] em28xx: print a message at disconnect")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   | 2 +-
 drivers/media/usb/em28xx/em28xx-input.c | 2 +-
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 44ae1e0661e6..52dc9d70da72 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -981,7 +981,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Closing audio extension");
+	em28xx_info("Closing audio extension\n");
 
 	if (dev->adev.sndcard) {
 		snd_card_disconnect(dev->adev.sndcard);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9877b699c6bc..80c384c390e2 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1724,7 +1724,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (!dev->dvb)
 		return 0;
 
-	em28xx_info("Closing DVB extension");
+	em28xx_info("Closing DVB extension\n");
 
 	dvb = dev->dvb;
 	client = dvb->i2c_client_tuner;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ef36c49ef166..aea22deadc0a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -832,7 +832,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	em28xx_info("Closing input extension");
+	em28xx_info("Closing input extension\n");
 
 	em28xx_shutdown_buttons(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index cf7f58b76292..3b8c464bf25a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1958,7 +1958,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (v4l2 == NULL)
 		return 0;
 
-	em28xx_info("Closing video extension");
+	em28xx_info("Closing video extension\n");
 
 	mutex_lock(&dev->lock);
 
-- 
1.8.3.1

