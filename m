Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2J0UmN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:13 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antoine Jacquet <royale@zerezo.com>
Subject: [PATCH 61/68] [media] zr364xx: urb actual_length is unsigned
Date: Sat, 27 Oct 2012 18:41:19 -0200
Message-Id: <1351370486-29040-62-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/zr364xx/zr364xx.c:1010:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Cc: Antoine Jacquet <royale@zerezo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/zr364xx/zr364xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 9afab35..39edd44 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1007,8 +1007,7 @@ static void read_pipe_completion(struct urb *purb)
 		return;
 	}
 
-	if (purb->actual_length < 0 ||
-	    purb->actual_length > pipe_info->transfer_size) {
+	if (purb->actual_length > pipe_info->transfer_size) {
 		dev_err(&cam->udev->dev, "wrong number of bytes\n");
 		return;
 	}
-- 
1.7.11.7

