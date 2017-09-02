Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49987 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdIBSmS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 14:42:18 -0400
Subject: [PATCH 2/3] [media] cx18: Improve a size determination in
 cx18_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Message-ID: <bd9956e3-041a-2efc-702e-07db3e8077a3@users.sourceforge.net>
Date: Sat, 2 Sep 2017 20:42:04 +0200
MIME-Version: 1.0
In-Reply-To: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 19:42:12 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx18/cx18-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index b267590e0877..49fc9b72ada5 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -909,5 +909,5 @@ static int cx18_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	}
 
-	cx = kzalloc(sizeof(struct cx18), GFP_ATOMIC);
+	cx = kzalloc(sizeof(*cx), GFP_ATOMIC);
 	if (!cx)
-- 
2.14.1
