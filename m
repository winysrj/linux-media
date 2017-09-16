Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56472 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdIPIk5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 04:40:57 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] Maxi Radio: Delete an error message for a failed
 memory allocation in maxiradio_probe()
Message-ID: <2c0d1f34-cdb0-f1c0-7243-4e80ad89af6a@users.sourceforge.net>
Date: Sat, 16 Sep 2017 10:40:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 10:15:29 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/radio-maxiradio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 3aa5ad391581..995bdc7ff4e6 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -125,7 +125,5 @@ static int maxiradio_probe(struct pci_dev *pdev,
-	if (dev == NULL) {
-		dev_err(&pdev->dev, "not enough memory\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	v4l2_dev = &dev->v4l2_dev;
 	v4l2_device_set_name(v4l2_dev, "maxiradio", &maxiradio_instance);
-- 
2.14.1
