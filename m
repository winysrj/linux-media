Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:37430 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2DVIGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 04:06:30 -0400
Date: Sun, 22 Apr 2012 11:06:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] fintek-cir: change || to &&
Message-ID: <20120422080617.GA1252@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F90798B.5000709@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current condition is always true, so everything uses
LOGICAL_DEV_CIR_REV2 (8).  It should be that Fintek products
0x0408(F71809) and 0x0804(F71855) use logical device
LOGICAL_DEV_CIR_REV1 (5) and other chip ids use logical device 8.

In other words, this fixes hardware detection for 0x0408 and 0x0804.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 392d4be..fba611e 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -197,7 +197,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 	/*
 	 * Newer reviews of this chipset uses port 8 instead of 5
 	 */
-	if ((chip != 0x0408) || (chip != 0x0804))
+	if ((chip != 0x0408) && (chip != 0x0804))
 		fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV2;
 	else
 		fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV1;
