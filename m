Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2J0Ul4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:56 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKft9a019766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 66/68] [media] fmdrv: Don't check if unsigned are below zero
Date: Sat, 27 Oct 2012 18:41:24 -0200
Message-Id: <1351370486-29040-67-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/wl128x/fmdrv_common.c:745:3: warning: comparison is always false due to limited range of data type [-Wtype-limits]
drivers/media/radio/wl128x/fmdrv_rx.c:308:2: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
 drivers/media/radio/wl128x/fmdrv_rx.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index bf867a6..602ef7a 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -742,7 +742,7 @@ static void fm_irq_handle_rdsdata_getcmd_resp(struct fmdev *fmdev)
 		if ((meta_data & FM_RDS_STATUS_ERR_MASK) != 0)
 			break;
 
-		if (blk_idx < FM_RDS_BLK_IDX_A || blk_idx > FM_RDS_BLK_IDX_D) {
+		if (blk_idx > FM_RDS_BLK_IDX_D) {
 			fmdbg("Block sequence mismatch\n");
 			rds->last_blk_idx = -1;
 			break;
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index 3dd9fc0..ebf09a3 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -305,7 +305,7 @@ int fm_rx_set_volume(struct fmdev *fmdev, u16 vol_to_set)
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
 
-	if (vol_to_set < FM_RX_VOLUME_MIN || vol_to_set > FM_RX_VOLUME_MAX) {
+	if (vol_to_set > FM_RX_VOLUME_MAX) {
 		fmerr("Volume is not within(%d-%d) range\n",
 			   FM_RX_VOLUME_MIN, FM_RX_VOLUME_MAX);
 		return -EINVAL;
-- 
1.7.11.7

