Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33709 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdLFR7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 12:59:21 -0500
Received: by mail-wr0-f193.google.com with SMTP id v22so4842829wrb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 09:59:20 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 2/2] [media] ddbridge: don't break on single/last port attach failure
Date: Wed,  6 Dec 2017 18:59:15 +0100
Message-Id: <20171206175915.20669-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171206175915.20669-1-d.scheller.oss@gmail.com>
References: <20171206175915.20669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As all error handling improved quite a bit, don't stop attaching frontends
if one of them failed, since - if other tuner modules are connected to
the PCIe bridge - other hardware may just work, so lets not break on a
single port failure, but rather initialise as much as possible. Ie. if
there are issues with a C2T2-equipped PCIe bridge card which has
additional DuoFlex modules connected and the bridge generally works,
the DuoFlex tuners can still work fine. Also, this only had an effect
anyway if the failed device/port was the last one being enumerated.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 11c5cae92408..b43c40e0bf73 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1962,7 +1962,7 @@ int ddb_ports_attach(struct ddb *dev)
 	}
 	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
-		ret = ddb_port_attach(port);
+		ddb_port_attach(port);
 	}
 	return ret;
 }
-- 
2.13.6
