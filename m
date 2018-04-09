Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:39093 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753306AbeDIQsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:07 -0400
Received: by mail-wr0-f195.google.com with SMTP id c24so10249624wrc.6
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 12/19] [media] ddbridge: set devid entry for link 0
Date: Mon,  9 Apr 2018 18:47:45 +0200
Message-Id: <20180409164752.641-13-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
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
