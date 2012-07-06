Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab2GFB71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 21:59:27 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q661xRkL016953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jul 2012 21:59:27 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] em28xx: fix em28xx-rc load
Date: Thu,  5 Jul 2012 22:59:22 -0300
Message-Id: <1341539962-22511-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that checks if a device has remote control is wrong.
Due to that, the em28xx RC module is not loaded by default.

Fix the logic, in order to make it work properly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 12bc54a..ca62b99 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2888,7 +2888,7 @@ static void request_module_async(struct work_struct *work)
 
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
-	if (dev->board.has_ir_i2c && !disable_ir)
+	if (dev->board.ir_codes && !disable_ir)
 		request_module("em28xx-rc");
 }
 
-- 
1.7.10.4

