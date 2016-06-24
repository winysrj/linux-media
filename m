Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbcFXSAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 14:00:40 -0400
From: Colin King <colin.king@canonical.com>
To: Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] netup_unidvb: trivial fix of spelling mistake "initizalize" -> "initialize"
Date: Fri, 24 Jun 2016 19:00:24 +0100
Message-Id: <1466791224-18641-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index d278d4e..c2ec4e2 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -975,7 +975,7 @@ wq_create_err:
 	kfree(ndev);
 dev_alloc_err:
 	dev_err(&pci_dev->dev,
-		"%s(): failed to initizalize device\n", __func__);
+		"%s(): failed to initialize device\n", __func__);
 	return -EIO;
 }
 
-- 
2.8.1

