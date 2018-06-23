Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37085 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbeFWPgY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id k6-v6so9412927wrp.4
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:23 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 05/19] [media] ddbridge: report I2C bus errors
Date: Sat, 23 Jun 2018 17:36:01 +0200
Message-Id: <20180623153615.27630-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The I2C_COMMAND response reports an error in the I2C bus communication
using bit 17. Evaluate the response more thoroughly and log an error
if an I2C problem was detected.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 667340c86ea7..5a28d7611713 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -73,7 +73,10 @@ static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 		}
 		return -EIO;
 	}
-	if (val & 0x70000)
+	val &= 0x70000;
+	if (val == 0x20000)
+		dev_err(dev->dev, "I2C bus error\n");
+	if (val)
 		return -EIO;
 	return 0;
 }
-- 
2.16.4
