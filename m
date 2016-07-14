Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:55658 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbcGNOk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 10:40:26 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: s5p-mfc remove unnecessary error messages
Date: Thu, 14 Jul 2016 08:40:22 -0600
Message-Id: <1468507222-5314-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed unnecessary error message as appropriate error code is returned.
Changed error message into a debug.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
- Changed EBUSY error message to a debug message.

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b6fde20..eeb1db2 100644
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
@@ -776,7 +775,7 @@ static int s5p_mfc_open(struct file *file)
 	while (dev->ctx[ctx->num]) {
 		ctx->num++;
 		if (ctx->num >= MFC_NUM_CONTEXTS) {
-			mfc_err("Too many open contexts\n");
+			mfc_debug(2, "Too many open contexts\n");
 			ret = -EBUSY;
 			goto err_no_ctx;
 		}
-- 
2.7.4

