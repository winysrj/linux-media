Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39015 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2E3Try (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 15:47:54 -0400
Received: by bkcji2 with SMTP id ji2so181506bkc.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 12:47:53 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] [media] em28xx: Show a warning if the board does not support remote controls
Date: Wed, 30 May 2012 21:47:40 +0200
Message-Id: <1338407260-14367-1-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simply shows a little warning if the board does not have remote
control support. This should make it easier for users to see if they
have misconfigured their system or if the driver simply does not have
rc-support for their card (yet).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/video/em28xx/em28xx-input.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index fce5f76..5e30c4f 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -527,6 +527,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	if (dev->board.ir_codes == NULL) {
 		/* No remote control support */
+		em28xx_warn("Remote control support is not available for "
+				"this card.\n");
 		return 0;
 	}
 
-- 
1.7.10.3

