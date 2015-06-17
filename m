Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34218 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbbFQMbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 08:31:43 -0400
From: Sunil Shahu <shshahu@gmail.com>
To: mchehab@osg.samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org,
	hamohammed.sa@gmail.com, tapaswenipathak@gmail.com, arnd@arndb.de,
	gulsah.1004@gmail.com, aybuke.147@gmail.com,
	dan.carpenter@oracle.com, mahfouz.saif.elyazal@gmail.com,
	amber.rose.thrall@gmail.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: fix coding style error
Date: Wed, 17 Jun 2015 18:01:32 +0530
Message-Id: <1434544292-32742-1-git-send-email-shshahu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix code indentation error by replacing tab in place of spaces.

Signed-off-by: Sunil Shahu <shshahu@gmail.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 8ebee96..12aae72 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -185,7 +185,7 @@ static void deregister_from_lirc(struct sasem_context *context)
 		       __func__, retval);
 	else
 		dev_info(&context->dev->dev,
-		         "Deregistered Sasem driver (minor:%d)\n", minor);
+			"Deregistered Sasem driver (minor:%d)\n", minor);
 
 }
 
-- 
1.9.1

