Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:41731 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeG0FEU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 01:04:20 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: pci: ivtv: Replace GFP_ATOMIC with GFP_KERNEL
Date: Fri, 27 Jul 2018 11:44:24 +0800
Message-Id: <20180727034424.4405-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ivtv_probe() and ivtvfb_init_card() are never called in atomic context.
They call kzalloc() with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c | 2 +-
 drivers/media/pci/ivtv/ivtvfb.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 6b2ffdc96961..dd727098daf4 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -999,7 +999,7 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	int vbi_buf_size;
 	struct ivtv *itv;
 
-	itv = kzalloc(sizeof(struct ivtv), GFP_ATOMIC);
+	itv = kzalloc(sizeof(struct ivtv), GFP_KERNEL);
 	if (itv == NULL)
 		return -ENOMEM;
 	itv->pdev = pdev;
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 8e62b8be6529..1d7d10367d55 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -1178,7 +1178,7 @@ static int ivtvfb_init_card(struct ivtv *itv)
 	}
 
 	itv->osd_info = kzalloc(sizeof(struct osd_info),
-					GFP_ATOMIC|__GFP_NOWARN);
+					GFP_KERNEL|__GFP_NOWARN);
 	if (itv->osd_info == NULL) {
 		IVTVFB_ERR("Failed to allocate memory for osd_info\n");
 		return -ENOMEM;
-- 
2.17.0
