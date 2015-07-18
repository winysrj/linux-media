Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34136 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbGRE5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2015 00:57:36 -0400
Received: by wibud3 with SMTP id ud3so51975930wib.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 21:57:34 -0700 (PDT)
Date: Sat, 18 Jul 2015 07:57:44 +0300
From: Adi Ratiu <adi@adirat.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: lirc: sasem: fix whitespace style issue
Message-ID: <20150718075744.5a4d5603@adipc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Adi Ratiu <adi@adirat.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c
b/drivers/staging/media/lirc/lirc_sasem.c index 8ebee96..c14ca7e 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -185,7 +185,7 @@ static void deregister_from_lirc(struct sasem_context
*context) __func__, retval);
 	else
 		dev_info(&context->dev->dev,
-		         "Deregistered Sasem driver (minor:%d)\n", minor);
+			 "Deregistered Sasem driver (minor:%d)\n", minor);
 
 }
 
-- 
2.4.6
