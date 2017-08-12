Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35810 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdHLL45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 07:56:57 -0400
Received: by mail-wr0-f196.google.com with SMTP id c22so506881wrb.2
        for <linux-media@vger.kernel.org>; Sat, 12 Aug 2017 04:56:56 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v4 08/11] [media] ddbridge: fix impossible condition warning
Date: Sat, 12 Aug 2017 13:55:59 +0200
Message-Id: <20170812115602.18124-9-d.scheller.oss@gmail.com>
In-Reply-To: <20170812115602.18124-1-d.scheller.oss@gmail.com>
References: <20170812115602.18124-1-d.scheller.oss@gmail.com>
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
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 747f3b317fb9..66b520d131a0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -3107,7 +3107,7 @@ static ssize_t bpsnr_show(struct device *device,
 			 struct device_attribute *attr, char *buf)
 {
 	struct ddb *dev = dev_get_drvdata(device);
-	char snr[32];
+	unsigned char snr[32];
 
 	if (!dev->i2c_num)
 		return 0;
-- 
2.13.0
