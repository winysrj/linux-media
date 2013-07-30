Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:34563 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3G3XKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 19:10:04 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] redrat3: ensure whole packet is read
Date: Wed, 31 Jul 2013 00:00:00 +0100
Message-Id: <1375225204-5082-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The length in the header excludes the header itself, so we're getting
spurious readings.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 0042367..ccd267f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -663,7 +663,8 @@ static int redrat3_get_ir_data(struct redrat3_dev *rr3, unsigned len)
 		goto out;
 	}
 
-	if (rr3->bytes_read < be16_to_cpu(rr3->irdata.header.length))
+	if (rr3->bytes_read < be16_to_cpu(rr3->irdata.header.length) +
+						sizeof(struct redrat3_header))
 		/* we're still accumulating data */
 		return 0;
 
-- 
1.8.3.1

