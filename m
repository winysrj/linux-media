Return-path: <linux-media-owner@vger.kernel.org>
Received: from bran.ispras.ru ([83.149.199.196]:23119 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbeGRO7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 10:59:31 -0400
From: Anton Vasilyev <vasilyev@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Anton Vasilyev <vasilyev@ispras.ru>, Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] media: dm1105: Limit number of cards to avoid buffer over read
Date: Wed, 18 Jul 2018 17:13:56 +0300
Message-Id: <20180718141356.2515-1-vasilyev@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dm1105_probe() counts number of cards at dm1105_devcount,
but missed bounds check before dereference a card array.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
 drivers/media/pci/dm1105/dm1105.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index c9db108751a7..1ddb0576fb7b 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -986,6 +986,9 @@ static int dm1105_probe(struct pci_dev *pdev,
 	int ret = -ENOMEM;
 	int i;
 
+	if (dm1105_devcount >= ARRAY_SIZE(card))
+		return -ENODEV;
+
 	dev = kzalloc(sizeof(struct dm1105_dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-- 
2.18.0
