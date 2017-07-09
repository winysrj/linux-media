Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36608 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbdGITmg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:36 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so20375073wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:35 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 10/14] [media] ddbridge: remove unreachable code
Date: Sun,  9 Jul 2017 21:42:17 +0200
Message-Id: <20170709194221.10255-11-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

>From smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:3490 snr_store() info: ignoring unreachable code.

In fact, the function immediately returns zero, so remove it and update
ddb_attrs_snr[] to not reference it anymore.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 8981795b0819..3756b9961fcd 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -3236,25 +3236,6 @@ static ssize_t snr_show(struct device *device,
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
@@ -3394,10 +3375,10 @@ static struct device_attribute ddb_attrs_fan[] = {
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
