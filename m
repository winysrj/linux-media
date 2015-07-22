Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35237 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbbGVFGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 01:06:23 -0400
Received: by wibxm9 with SMTP id xm9so146047538wib.0
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 22:06:22 -0700 (PDT)
From: Ioan-Adrian Ratiu <adi@adirat.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	gregkh@linuxfoundation.org, Adi Ratiu <adi@adirat.com>
Subject: [PATCH v2] staging: lirc: sasem: fix whitespace style issue
Date: Wed, 22 Jul 2015 08:06:34 +0300
Message-Id: <1437541594-4220-1-git-send-email-adi@adirat.com>
In-Reply-To: <20150718075744.5a4d5603@adipc>
References: <20150718075744.5a4d5603@adipc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Adi Ratiu <adi@adirat.com>

checkpatch.pl gives an error on line 188 because it uses more than
8 spaces indentation. This patch converts the 8 spaces to a tab.

Signed-off-by: Adi Ratiu <adi@adirat.com>
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
2.4.6

