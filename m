Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42101 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753084AbaLTMp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:29 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/8] [media] em28xx-input: fix missing newlines
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPS-0006UV-2e@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:26 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspection shows that newlines are missing from several kernel messages
in em28xx-input.  Fix these.

Cc: <stable@vger.kernel.org>
Fixes: 5025076aadfe ("[media] em28xx-input: implement em28xx_ops: suspend/resume hooks")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index aea22deadc0a..4007356d991d 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -861,7 +861,7 @@ static int em28xx_ir_suspend(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	em28xx_info("Suspending input extension");
+	em28xx_info("Suspending input extension\n");
 	if (ir)
 		cancel_delayed_work_sync(&ir->work);
 	cancel_delayed_work_sync(&dev->buttons_query_work);
@@ -878,7 +878,7 @@ static int em28xx_ir_resume(struct em28xx *dev)
 	if (dev->is_audio_only)
 		return 0;
 
-	em28xx_info("Resuming input extension");
+	em28xx_info("Resuming input extension\n");
 	/* if suspend calls ir_raw_event_unregister(), the should call
 	   ir_raw_event_register() */
 	if (ir)
-- 
1.8.3.1

