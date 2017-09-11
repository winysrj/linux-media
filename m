Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:60670 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752025AbdIKQyQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 12:54:16 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org, hans.verkuil@cisco.com, Julia.Lawall@lip6.fr
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] media: v4l2-pci-skeleton: Fix error handling path in 'skeleton_probe()'
Date: Mon, 11 Sep 2017 18:53:07 +0200
Message-Id: <20170911165307.17139-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If this memory allocation fails, we must release some resources, as
already done in the code below and above.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: linux-media@vger.kernel.org added in cc
---
 samples/v4l/v4l2-pci-skeleton.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index 483e9bca9444..f520e3aef9c6 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -772,8 +772,10 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate a new instance */
 	skel = devm_kzalloc(&pdev->dev, sizeof(struct skeleton), GFP_KERNEL);
-	if (!skel)
-		return -ENOMEM;
+	if (!skel) {
+		ret = -ENOMEM;
+		goto disable_pci;
+	}
 
 	/* Allocate the interrupt */
 	ret = devm_request_irq(&pdev->dev, pdev->irq,
-- 
2.11.0
