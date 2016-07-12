Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:56553 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161AbcGLA3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 20:29:47 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-mfc remove void function return statement
Date: Mon, 11 Jul 2016 18:29:43 -0600
Message-Id: <1468283383-3142-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove void function return statement

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c96421f..b6fde20 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -495,7 +495,6 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	s5p_mfc_clock_off();
 	wake_up_dev(dev, reason, err);
-	return;
 }
 
 /* Header parsing interrupt handling */
-- 
2.7.4

