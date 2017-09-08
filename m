Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:60796 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757094AbdIHTm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 15:42:27 -0400
Subject: [PATCH 1/3] [media] fsl-viu: Delete an error message for a failed
 memory allocation in viu_of_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Message-ID: <c5314800-1b8b-b9cd-17e5-a1ffe633bb53@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:42:17 +0200
MIME-Version: 1.0
In-Reply-To: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:03:22 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/fsl-viu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index fb43025df573..526f80649864 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1433,5 +1433,4 @@ static int viu_of_probe(struct platform_device *op)
 	if (!viu_dev) {
-		dev_err(&op->dev, "Can't allocate private structure\n");
 		ret = -ENOMEM;
 		goto err;
 	}
-- 
2.14.1
