Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38211 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2E0V1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 17:27:07 -0400
Received: by wgbdr13 with SMTP id dr13so2386507wgb.1
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 14:27:06 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] [media] em28xx: Show a warning if the board does not support remote controls.
Date: Sun, 27 May 2012 23:26:53 +0200
Message-Id: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1338154013-5124-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simply shows a little warning if the board does not have remote
control support. This should make it easier for users to see if they
have misconfigured their system or if the driver simply does not have
rc-support for their card (yet).
---
 drivers/media/video/em28xx/em28xx-input.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index fce5f76..d94b434 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -527,6 +527,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	if (dev->board.ir_codes == NULL) {
 		/* No remote control support */
+		printk("No remote control support for em28xx "
+			"card %s (model %d) available.\n",
+			dev->name, dev->model);
 		return 0;
 	}
 
-- 
1.7.10.2

