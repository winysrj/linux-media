Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:53075 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdITRBp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:01:45 -0400
Subject: [PATCH 4/5] [media] s2255drv: Use common error handling code in
 read_pipe_completion()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Message-ID: <8e0409dd-0228-c15d-260c-b8d4e18eb07b@users.sourceforge.net>
Date: Wed, 20 Sep 2017 19:01:34 +0200
MIME-Version: 1.0
In-Reply-To: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 17:45:13 +0200

Add a jump target so that a bit of exception handling can be better
reused at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/s2255/s2255drv.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 29bc73ad7d8a..5a5d5ae833ff 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2065,11 +2065,9 @@ static void read_pipe_completion(struct urb *purb)
 	pipe_info = purb->context;
-	if (!pipe_info) {
-		dev_err(&purb->dev->dev, "no context!\n");
-		return;
-	}
+	if (!pipe_info)
+		goto report_failure;
+
 	dev = pipe_info->dev;
-	if (!dev) {
-		dev_err(&purb->dev->dev, "no context!\n");
-		return;
-	}
+	if (!dev)
+		goto report_failure;
+
 	status = purb->status;
@@ -2107,6 +2105,9 @@ static void read_pipe_completion(struct urb *purb)
 		dprintk(dev, 2, "%s :complete state 0\n", __func__);
 	}
 	return;
+
+report_failure:
+	dev_err(&purb->dev->dev, "no context!\n");
 }
 
 static int s2255_start_readpipe(struct s2255_dev *dev)
-- 
2.14.1
