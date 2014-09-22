Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIVIAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 04:00:37 -0400
Date: Mon, 22 Sep 2014 11:00:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] davinci: remove an unneeded check
Message-ID: <20140922080008.GB12362@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need to check "ret", we know it's zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index c557eb5..3eb6e4b 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -442,11 +442,10 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 		return ret;
 
 	/* Update the values of sizeimage and bytesperline */
-	if (!ret) {
-		pix->bytesperline = ccdc_dev->hw_ops.get_line_length();
-		pix->sizeimage = pix->bytesperline * pix->height;
-	}
-	return ret;
+	pix->bytesperline = ccdc_dev->hw_ops.get_line_length();
+	pix->sizeimage = pix->bytesperline * pix->height;
+
+	return 0;
 }
 
 static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
