Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:21784 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdIUX1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 19:27:30 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org, arvind.yadav.cs@gmail.com,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] media: bt8xx: Fix err 'bt878_probe()'
Date: Fri, 22 Sep 2017 01:23:56 +0200
Message-Id: <20170921232356.10433-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is odd to call 'pci_disable_device()' in an error path before a
coresponding successful 'pci_enable_device()'.

Return directly instead.

Fixes: 77e0be12100a ("V4L/DVB (4176): Bug-fix: Fix memory overflow")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/pci/bt8xx/bt878.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index a5f52137d306..d4bc78b4fcb5 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -422,8 +422,7 @@ static int bt878_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	       bt878_num);
 	if (bt878_num >= BT878_MAX) {
 		printk(KERN_ERR "bt878: Too many devices inserted\n");
-		result = -ENOMEM;
-		goto fail0;
+		return -ENOMEM;
 	}
 	if (pci_enable_device(dev))
 		return -EIO;
-- 
2.11.0
