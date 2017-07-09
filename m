Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36616 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752579AbdGITmh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:37 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so20375150wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:36 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 11/14] [media] ddbridge: fix impossible condition warning
Date: Sun,  9 Jul 2017 21:42:18 +0200
Message-Id: <20170709194221.10255-12-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Smatch and gcc complained:

  drivers/media/pci/ddbridge/ddbridge-core.c:3491 bpsnr_show() warn: impossible condition '(snr[0] == 255) => ((-128)-127 == 255)'

  drivers/media/pci/ddbridge/ddbridge-core.c: In function ‘bpsnr_show’:
  drivers/media/pci/ddbridge/ddbridge-core.c:3491:13: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Fix this by changing the type of snr to unsigned char.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 3756b9961fcd..6896cd1f3a96 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -3251,7 +3251,7 @@ static ssize_t bpsnr_show(struct device *device,
 			 struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
-	char snr[32];
+	unsigned char snr[32];
 
 	if (!dev->i2c_num)
 		return 0;
-- 
2.13.0
