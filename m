Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47164 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3HWJlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:41:51 -0400
Date: Fri, 23 Aug 2013 12:41:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] s3c-camif: forever loop in
 camif_hw_set_source_format()
Message-ID: <20130823094147.GM31293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Because "i" is unsigned then "i-- >= 0" is always true.  If we don't
find what we are looking for then we loop forever.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Why do we count backwards anyway?  Counting upwards is easier.

diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index a9e3b16..ebf5b18 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -106,15 +106,15 @@ static const u32 src_pixfmt_map[8][2] = {
 void camif_hw_set_source_format(struct camif_dev *camif)
 {
 	struct v4l2_mbus_framefmt *mf = &camif->mbus_fmt;
-	unsigned int i = ARRAY_SIZE(src_pixfmt_map);
+	int i;
 	u32 cfg;
 
-	while (i-- >= 0) {
+	for (i = ARRAY_SIZE(src_pixfmt_map) - 1; i >= 0; i--) {
 		if (src_pixfmt_map[i][0] == mf->code)
 			break;
 	}
-
-	if (i == 0 && src_pixfmt_map[i][0] != mf->code) {
+	if (i < 0) {
+		i = 0;
 		dev_err(camif->dev,
 			"Unsupported pixel code, falling back to %#08x\n",
 			src_pixfmt_map[i][0]);
