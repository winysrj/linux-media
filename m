Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37729 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdHIUbl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id t138so739974wmt.4
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:40 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 08/12] [media] ddbridge: remove unreachable code
Date: Wed,  9 Aug 2017 22:31:24 +0200
Message-Id: <20170809203128.31476-9-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

>From smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:3490 snr_store() info: ignoring unreachable code.

In fact, the function immediately returns zero, so remove it and update
ddb_attrs_snr[] to not reference it anymore.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 2a4bb6ddf3a2..ba2a2d987430 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2977,25 +2977,6 @@ static ssize_t snr_show(struct device *device,
 	return sprintf(buf, "%s\n", snr);
 }
 
-
-static ssize_t snr_store(struct device *device, struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	struct ddb *dev = dev_get_drvdata(device);
-	int num = attr->attr.name[3] - 0x30;
-	u8 snr[34] = { 0x01, 0x00 };
-
-	return 0; /* NOE: remove completely? */
-	if (count > 31)
-		return -EINVAL;
-	if (dev->port[num].type >= DDB_TUNER_XO2)
-		return -EINVAL;
-	memcpy(snr + 2, buf, count);
-	i2c_write(&dev->i2c[num].adap, 0x57, snr, 34);
-	i2c_write(&dev->i2c[num].adap, 0x50, snr, 34);
-	return count;
-}
-
 static ssize_t bsnr_show(struct device *device,
 			 struct device_attribute *attr, char *buf)
 {
@@ -3135,10 +3116,10 @@ static struct device_attribute ddb_attrs_fan[] = {
 };
 
 static struct device_attribute ddb_attrs_snr[] = {
-	__ATTR(snr0, 0664, snr_show, snr_store),
-	__ATTR(snr1, 0664, snr_show, snr_store),
-	__ATTR(snr2, 0664, snr_show, snr_store),
-	__ATTR(snr3, 0664, snr_show, snr_store),
+	__ATTR_MRO(snr0, snr_show),
+	__ATTR_MRO(snr1, snr_show),
+	__ATTR_MRO(snr2, snr_show),
+	__ATTR_MRO(snr3, snr_show),
 };
 
 static struct device_attribute ddb_attrs_ctemp[] = {
-- 
2.13.0
