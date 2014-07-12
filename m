Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:46129 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaGLQog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jul 2014 12:44:36 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com, olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: em28xx-dvb update fe exit flag to indicate device disconnect
Date: Sat, 12 Jul 2014 10:44:13 -0600
Message-Id: <f787934645180d1c3a30f6424541d424dc1a3052.1405179280.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change em28xx_dvb_fini() to set fe exit flag to DVB_FE_DEVICE_REMOVED
when device is disconnected. em28xx maintains device disconnect status
in em28xx device. fe drivers will be able to now check the fe exit
status to avoid accessing the device, from their release interfaces
when called from disconnect path. This change depends on dvb-core
change that exports fe exit flag by moving it from fepriv to fe.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 8d5cb62..5663d62 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1668,10 +1668,14 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (dev->disconnected) {
 		/* We cannot tell the device to sleep
 		 * once it has been unplugged. */
-		if (dvb->fe[0])
+		if (dvb->fe[0]) {
 			prevent_sleep(&dvb->fe[0]->ops);
-		if (dvb->fe[1])
+			dvb->fe[0]->exit = DVB_FE_DEVICE_REMOVED;
+		}
+		if (dvb->fe[1]) {
 			prevent_sleep(&dvb->fe[1]->ops);
+			dvb->fe[1]->exit = DVB_FE_DEVICE_REMOVED;
+		}
 	}
 
 	em28xx_unregister_dvb(dvb);
-- 
1.7.10.4

