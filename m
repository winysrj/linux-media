Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:46970 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbcLDFzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Dec 2016 00:55:23 -0500
From: Pan Bian <bianpan201603@163.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] media: pci: meye: set error code on failures
Date: Sun,  4 Dec 2016 13:39:17 +0800
Message-Id: <1480829957-4793-1-git-send-email-bianpan201603@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

The value of return variable ret is 0 on some error paths, for example,
when pci_resource_start() returns a NULL pointer. 0 means no error in
this context, which is contrary to the fact. This patch fixes the bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189011

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/media/pci/meye/meye.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index ba887e8..115e141 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1669,6 +1669,7 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 		goto outenabledev;
 	}
 
+	ret = -EIO;
 	mchip_adr = pci_resource_start(meye.mchip_dev,0);
 	if (!mchip_adr) {
 		v4l2_err(v4l2_dev, "meye: mchip has no device base address\n");
-- 
1.9.1


