Return-path: <mchehab@pedra>
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:48521 "EHLO
	mail1.asahi-net.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1EAFyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 01:54:09 -0400
From: HIRANO Takahito <hiranotaka@zng.info>
To: linux-media@vger.kernel.org
Cc: HIRANO Takahito <hiranotaka@zng.info>
Subject: [PATCH] Fix panic on loading earth-pt1.
Date: Sun,  1 May 2011 14:29:40 +0900
Message-Id: <1304227780-4344-1-git-send-email-hiranotaka@zng.info>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>
---
 drivers/media/dvb/pt1/pt1.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index 0486919..b81df5f 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -1090,6 +1090,7 @@ pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	i2c_adap->algo = &pt1_i2c_algo;
 	i2c_adap->algo_data = NULL;
 	i2c_adap->dev.parent = &pdev->dev;
+	strcpy(i2c_adap->name, DRIVER_NAME);
 	i2c_set_adapdata(i2c_adap, pt1);
 	ret = i2c_add_adapter(i2c_adap);
 	if (ret < 0)
@@ -1156,10 +1157,10 @@ err_pt1_disable_ram:
 	pt1->power = 0;
 	pt1->reset = 1;
 	pt1_update_power(pt1);
-err_pt1_cleanup_adapters:
-	pt1_cleanup_adapters(pt1);
 err_i2c_del_adapter:
 	i2c_del_adapter(i2c_adap);
+err_pt1_cleanup_adapters:
+	pt1_cleanup_adapters(pt1);
 err_kfree:
 	pci_set_drvdata(pdev, NULL);
 	kfree(pt1);
-- 
1.7.4.4

