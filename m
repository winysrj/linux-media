Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:32934 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbbFSIwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 04:52:02 -0400
From: Sunil Shahu <shshahu@gmail.com>
To: mchehab@osg.samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org,
	hamohammed.sa@gmail.com, tapaswenipathak@gmail.com, arnd@arndb.de,
	gulsah.1004@gmail.com, aybuke.147@gmail.com,
	dan.carpenter@oracle.com, mahfouz.saif.elyazal@gmail.com,
	amber.rose.thrall@gmail.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: fix coding style error
Date: Fri, 19 Jun 2015 14:22:02 +0530
Message-Id: <1434703922-1655-1-git-send-email-shshahu@gmail.com>
In-Reply-To: <20150619080232.GN28762@mwanda>
References: <20150619080232.GN28762@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix code indentation error by replacing tab in place of spaces.

Signed-off-by: Sunil Shahu <shshahu@gmail.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 8ebee96..c14ca7e 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -185,7 +185,7 @@ static void deregister_from_lirc(struct sasem_context *context)
 		       __func__, retval);
 	else
 		dev_info(&context->dev->dev,
-		         "Deregistered Sasem driver (minor:%d)\n", minor);
+			 "Deregistered Sasem driver (minor:%d)\n", minor);
 
 }
 
-- 
1.9.1

