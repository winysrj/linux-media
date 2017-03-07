Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55156 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932624AbdCGOtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:49:23 -0500
From: Colin King <colin.king@canonical.com>
To: Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] atmel-isc: fix off-by-one comparison and out of bounds read issue
Date: Tue,  7 Mar 2017 14:30:47 +0000
Message-Id: <20170307143047.30082-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The are only HIST_ENTRIES worth of entries in  hist_entry however the
for-loop is iterating one too many times leasing to a read access off
the end off the array ctrls->hist_entry.  Fix this by iterating by
the correct number of times.

Detected by CoverityScan, CID#1415279 ("Out-of-bounds read")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index b380a7d..7dacf8c 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1298,7 +1298,7 @@ static void isc_hist_count(struct isc_device *isc)
 	regmap_bulk_read(regmap, ISC_HIS_ENTRY, hist_entry, HIST_ENTRIES);
 
 	*hist_count = 0;
-	for (i = 0; i <= HIST_ENTRIES; i++)
+	for (i = 0; i < HIST_ENTRIES; i++)
 		*hist_count += i * (*hist_entry++);
 }
 
-- 
2.10.2
