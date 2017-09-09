Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:50595 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdIITNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 15:13:50 -0400
Subject: [PATCH 1/2] [media] xc4000: Delete two error messages for a failed
 memory allocation in xc4000_fwupload()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <61016489-eb01-2977-b094-343aa70686b0@users.sourceforge.net>
Message-ID: <0ad4caf5-a0fd-2852-5d01-9c9e45a9e480@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:13:40 +0200
MIME-Version: 1.0
In-Reply-To: <61016489-eb01-2977-b094-343aa70686b0@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Sep 2017 20:46:35 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/xc4000.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index e30948e4ff87..bbf386127fc4 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -779,4 +779,3 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
-		printk(KERN_ERR "Not enough memory to load firmware file.\n");
 		rc = -ENOMEM;
 		goto done;
 	}
@@ -826,4 +825,3 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
-			printk(KERN_ERR "Not enough memory to load firmware file.\n");
 			rc = -ENOMEM;
 			goto done;
 		}
-- 
2.14.1
