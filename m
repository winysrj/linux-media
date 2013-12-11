Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54864 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKGJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 01:09:25 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so9251151pbc.40
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 22:09:24 -0800 (PST)
Date: Tue, 10 Dec 2013 22:09:22 -0800
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: prabhakar.csengg@gmail.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v3] staging: media: davinci_vpfe: Rewrite return statement in
 vpfe_video.c
Message-ID: <20131211060921.GA4772@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rewrite the return statement in vpfe_video.c. This will prevent
the checkpatch.pl script from generating a warning saying
to remove () from this particular return statement.

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
Changes since v3:
- Removed () from return statement per Laurent Pinchart's suggestion

 drivers/staging/media/davinci_vpfe/vpfe_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 24d98a6..3b036be 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -346,7 +346,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	}
 	mutex_unlock(&mdev->graph_mutex);
 
-	return (ret == 0) ? ret : -ETIMEDOUT ;
+	return ret ? -ETIMEDOUT : 0;
 }
 
 /*
-- 
1.7.9.5

