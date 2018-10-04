Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:59148 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbeJDWiH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 18:38:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id C6268528
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 15:44:16 +0000 (UTC)
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ve1Kw4aVrWhu for <linux-media@vger.kernel.org>;
        Thu,  4 Oct 2018 10:44:16 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 9F61E6EA
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 10:44:16 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id f9-v6so9288452iog.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 08:44:16 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org (open list:TI DAVINCI SERIES MEDIA DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: isif: fix a NULL pointer dereference bug
Date: Thu,  4 Oct 2018 10:44:02 -0500
Message-Id: <1538667843-18091-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In isif_probe(), there is a while loop to get the ISIF base address and
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
 drivers/media/platform/davinci/isif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index f924e76..340f821 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1100,7 +1100,8 @@ static int isif_probe(struct platform_device *pdev)
 
 	while (i >= 0) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		release_mem_region(res->start, resource_size(res));
+		if (res)
+			release_mem_region(res->start, resource_size(res));
 		i--;
 	}
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
-- 
2.7.4
