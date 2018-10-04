Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:33522 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbeJDWyk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 18:54:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id A528311CF
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 16:00:45 +0000 (UTC)
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ytCTDQjPHvN8 for <linux-media@vger.kernel.org>;
        Thu,  4 Oct 2018 11:00:45 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 7224211DE
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 11:00:45 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id t22-v6so7840113ioc.20
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 09:00:45 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: davinci_vpfe: fix a NULL pointer dereference bug
Date: Thu,  4 Oct 2018 11:00:31 -0500
Message-Id: <1538668833-18372-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In vpfe_isif_init(), there is a while loop to get the ISIF base address and
linearization table0 and table1 address. In the loop body, the function
platform_get_resource() is called to get the resource. If
platform_get_resource() returns NULL, the loop is terminated and the
execution goes to 'fail_nobase_res'. Suppose the loop is terminated at the
first iteration because platform_get_resource() returns NULL and the
execution goes to 'fail_nobase_res'. Given that there is another while loop
at 'fail_nobase_res' and i equals to 0, one iteration of the second while
loop will be executed. However, the second while loop does not check the
return value of platform_get_resource(). This can cause a NULL pointer
dereference bug if the return value is a NULL pointer.

This patch avoids the above issue by adding a check in the second while
loop after the call to platform_get_resource().

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/staging/media/davinci_vpfe/dm365_isif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 745e33f..b0425a6 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -2080,7 +2080,8 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 
 	while (i >= 0) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		release_mem_region(res->start, res_len);
+		if (res)
+			release_mem_region(res->start, res_len);
 		i--;
 	}
 	return status;
-- 
2.7.4
