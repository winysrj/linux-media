Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7347 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965830AbbFJQc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:56 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] wl128x: use swap() in fm_rdsparse_swapbytes()
Date: Wed, 10 Jun 2015 18:32:39 +0200
Message-Id: <1433953959-24221-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 704397f..ebc73b0 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -689,7 +689,6 @@ static void fm_rx_update_af_cache(struct fmdev *fmdev, u8 af)
 static void fm_rdsparse_swapbytes(struct fmdev *fmdev,
 		struct fm_rdsdata_format *rds_format)
 {
-	u8 byte1;
 	u8 index = 0;
 	u8 *rds_buff;
 
@@ -701,9 +700,7 @@ static void fm_rdsparse_swapbytes(struct fmdev *fmdev,
 	if (fmdev->asci_id != 0x6350) {
 		rds_buff = &rds_format->data.groupdatabuff.buff[0];
 		while (index + 1 < FM_RX_RDS_INFO_FIELD_MAX) {
-			byte1 = rds_buff[index];
-			rds_buff[index] = rds_buff[index + 1];
-			rds_buff[index + 1] = byte1;
+			swap(rds_buff[index], rds_buff[index + 1]);
 			index += 2;
 		}
 	}
-- 
2.4.2

