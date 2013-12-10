Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40421 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3LJQFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 11:05:46 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so7663747pdj.1
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 08:05:45 -0800 (PST)
Date: Tue, 10 Dec 2013 08:05:42 -0800
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: prabhakar.csengg@gmail.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v2] staging: media: davinci_vpfe: Rewrite return statement in
 vpfe_video.c
Message-ID: <20131210160541.GA15282@ubuntu>
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
Changes since v2:
- Aligned -ETIMEDOUT return statement with if condition

 drivers/staging/media/davinci_vpfe/vpfe_video.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 24d98a6..22e31d2 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -346,7 +346,10 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	}
 	mutex_unlock(&mdev->graph_mutex);
 
-	return (ret == 0) ? ret : -ETIMEDOUT ;
+	if (ret == 0)
+		return ret;
+
+	return -ETIMEDOUT;
 }
 
 /*
-- 
1.7.9.5

