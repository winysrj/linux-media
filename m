Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36209 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbeDBSYn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:43 -0400
Received: by mail-wm0-f65.google.com with SMTP id x82so29042216wmg.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:42 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 13/20] [media] ddbridge: set devid entry for link 0
Date: Mon,  2 Apr 2018 20:24:20 +0200
Message-Id: <20180402182427.20918-14-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Currently, /sys/class/ddbridgeX/devid always reports 0 due to devid not
being set at all. Set the devid field alongside while storing all other
hardware ID data.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 008be9066814..6356b48b3874 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -198,6 +198,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	dev->link[0].ids.device = id->device;
 	dev->link[0].ids.subvendor = id->subvendor;
 	dev->link[0].ids.subdevice = pdev->subsystem_device;
+	dev->link[0].ids.devid = (id->device << 16) | id->vendor;
 
 	dev->link[0].dev = dev;
 	dev->link[0].info = get_ddb_info(id->vendor, id->device,
-- 
2.16.1
