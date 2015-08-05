Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34603 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbHEFP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2015 01:15:28 -0400
Received: by oip136 with SMTP id 136so14595891oip.1
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2015 22:15:28 -0700 (PDT)
From: Pradheep Shrinivasan <pradheep.sh@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Pradheep Shrinivasan <pradheep.sh@gmail.com>
Subject: [PATCH 2/2] staging: media: lirc This fix changes the spaces to tab in lirc_sasem.c
Date: Wed,  5 Aug 2015 00:14:56 -0500
Message-Id: <1438751698-8254-2-git-send-email-pradheep.sh@gmail.com>
In-Reply-To: <1438751698-8254-1-git-send-email-pradheep.sh@gmail.com>
References: <1438751698-8254-1-git-send-email-pradheep.sh@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fix changes the space in the code to tab to fix the ERROR
"ERROR: code indent should use tabs where possible"

Signed-off-by: Pradheep Shrinivasan <pradheep.sh@gmail.com>
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

