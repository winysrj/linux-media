Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:55520 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbcHILfX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 07:35:23 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org,
	Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/4] media: pci: pt3: don't print error when adding adapter fails
Date: Tue,  9 Aug 2016 13:35:14 +0200
Message-Id: <1470742517-12774-3-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The core will do this for us now.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/pci/pt3/pt3.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index eff5e9f51ace3d..7fb649e523f46e 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -798,10 +798,8 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
 	i2c_set_adapdata(i2c, pt3);
 	ret = i2c_add_adapter(i2c);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add i2c adapter\n");
+	if (ret < 0)
 		goto err_i2cbuf;
-	}
 
 	for (i = 0; i < PT3_NUM_FE; i++) {
 		ret = pt3_alloc_adapter(pt3, i);
-- 
2.8.1

