Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:48976 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbcGMAea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 20:34:30 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-mfc remove unnecessary error messages
Date: Tue, 12 Jul 2016 18:33:58 -0600
Message-Id: <1468370038-5364-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing unnecessary error messages as appropriate error code is returned.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b6fde20..906f80c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -759,7 +759,6 @@ static int s5p_mfc_open(struct file *file)
 	/* Allocate memory for context */
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
-		mfc_err("Not enough memory\n");
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
@@ -776,7 +775,6 @@ static int s5p_mfc_open(struct file *file)
 	while (dev->ctx[ctx->num]) {
 		ctx->num++;
 		if (ctx->num >= MFC_NUM_CONTEXTS) {
-			mfc_err("Too many open contexts\n");
 			ret = -EBUSY;
 			goto err_no_ctx;
 		}
-- 
2.7.4

