Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35962 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbcCHHRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 02:17:49 -0500
From: Manuel Rodriguez <manuel2982@gmail.com>
To: mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Manuel Rodriguez <manuel2982@gmail.com>
Subject: [PATCH] Staging: media: davinci_vpfe: Fix spelling error on a comment
Date: Tue,  8 Mar 2016 01:16:06 -0600
Message-Id: <1457421366-4146-1-git-send-email-manuel2982@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix spelling error on a comment, change 'wether' to 'whether'

Signed-off-by: Manuel Rodriguez <manuel2982@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 0a65405..e4b953a 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -195,7 +195,7 @@ static int vpfe_update_pipe_state(struct vpfe_video_device *video)
 	return 0;
 }
 
-/* checks wether pipeline is ready for enabling */
+/* checks whether pipeline is ready for enabling */
 int vpfe_video_is_pipe_ready(struct vpfe_pipeline *pipe)
 {
 	int i;
-- 
1.9.1

