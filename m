Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42245 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3J1VXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 17:23:09 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so7485494pdj.9
        for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 14:23:08 -0700 (PDT)
Date: Mon, 28 Oct 2013 14:23:06 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] staging: media: davinci_vpfe: Rewrite return statement
 in vpfe_video.c
Message-ID: <c171c58417eb45b816caa1fd8cb0d74ae813dbbf.1382995303.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rewrite the return statement in vpfe_video.c to eliminate the
use of a ternary operator. This will prevent the checkpatch.pl
script from generating a warning saying to remove () from
this particular return statement.

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 24d98a6..49aafe4 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -346,7 +346,10 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	}
 	mutex_unlock(&mdev->graph_mutex);
 
-	return (ret == 0) ? ret : -ETIMEDOUT ;
+	if (ret == 0)
+		return ret;
+	else
+		return -ETIMEDOUT;
 }
 
 /*
-- 
1.8.1.2

