Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38841 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdLKUMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 15:12:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id 64so16413285wme.3
        for <linux-media@vger.kernel.org>; Mon, 11 Dec 2017 12:12:53 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH] [media] ddbridge: stv09xx: detach frontends on lnb failure
Date: Mon, 11 Dec 2017 21:12:49 +0100
Message-Id: <20171211201249.10095-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

While the failure handling in dvb_input_attach() has been improved lately
so any tuner failure won't result in demod driver modules with a
usecount > 0 anymore (thus requiring rmmod -f), there's still an issue
with stv090x and stv0910 based tuner modules, in that LNB driver attach
failures leave an attached demod frontend driver behind which have a
usecount of > 0 in this failure case, due to them not being detached/
released. Fix this by detaching the demod frontends if the LNB driver
fails.

Richard tested and verified the changes with STV0910 hardware, thus adding
his Tested-by.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 348cc8b3d1f9..f4d6e43aa0f0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1114,6 +1114,7 @@ static int demod_attach_stv0900(struct ddb_input *input, int type)
 			0, (input->nr & 1) ?
 			(0x09 - type) : (0x0b - type))) {
 		dev_err(dev, "No LNBH24 found!\n");
+		dvb_frontend_detach(dvb->fe);
 		return -ENODEV;
 	}
 	return 0;
@@ -1196,6 +1197,7 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 		lnbcfg.i2c_address = (((input->nr & 1) ? 0x09 : 0x08) << 1);
 		if (!dvb_attach(lnbh25_attach, dvb->fe, &lnbcfg, i2c)) {
 			dev_err(dev, "No LNBH25 found!\n");
+			dvb_frontend_detach(dvb->fe);
 			return -ENODEV;
 		}
 	}
-- 
2.13.6
