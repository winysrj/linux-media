Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30007 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbcKRLbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 06:31:01 -0500
Date: Fri, 18 Nov 2016 14:30:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Thaissa Falbo <thaissa.falbo@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Leo Sperling <leosperling97@gmail.com>,
        sayli karnik <karniksayli1995@gmail.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Staging: media: davinci_vpfe: unlock on error in
 vpfe_reqbufs()
Message-ID: <20161118113024.GA3150@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should unlock before returning this error code in vpfe_reqbufs().

Fixes: 622897da67b3 ("[media] davinci: vpfe: add v4l2 video driver support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index c34bf46..353f3a8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1362,7 +1362,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	ret = vb2_queue_init(q);
 	if (ret) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
-		return ret;
+		goto unlock_out;
 	}
 
 	fh->io_allowed = 1;
