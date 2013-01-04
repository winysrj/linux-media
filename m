Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab3ADVQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] em28xx: autoload em28xx-rc if the device has an I2C IR
Date: Fri,  4 Jan 2013 19:15:50 -0200
Message-Id: <1357334152-3811-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the device has an I2C IR, em28xx-rc should be loaded by default,
except if the user explicitly requested to not load, via modprobe
option.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f5cac47..e17be07 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2912,7 +2912,7 @@ static void request_module_async(struct work_struct *work)
 
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
-	if (dev->board.ir_codes && !disable_ir)
+	if ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir)
 		request_module("em28xx-rc");
 #endif /* CONFIG_MODULES */
 }
-- 
1.7.11.7

