Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42110 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752877AbaLTMpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:44 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 6/8] [media] em28xx-audio: fix missing newlines
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPh-0006Ui-Cw@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:41 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspection shows that newlines are missing from several kernel messages
in em28xx-audio.  Fix these.

Cc: <stable@vger.kernel.org>
Fixes: 6d746f91f230 ("[media] em28xx-audio: implement em28xx_ops: suspend/resume hooks")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 82d58eb3d32a..49a5f9532bd8 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -1005,7 +1005,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	em28xx_info("Suspending audio extension");
+	em28xx_info("Suspending audio extension\n");
 	em28xx_deinit_isoc_audio(dev);
 	atomic_set(&dev->adev.stream_started, 0);
 	return 0;
@@ -1019,7 +1019,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
-	em28xx_info("Resuming audio extension");
+	em28xx_info("Resuming audio extension\n");
 	/* Nothing to do other than schedule_work() ?? */
 	schedule_work(&dev->adev.wq_trigger);
 	return 0;
-- 
1.8.3.1

