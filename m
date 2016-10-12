Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:57884 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933602AbcJLOao (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:30:44 -0400
Subject: [PATCH 02/34] [media] DaVinci-VPBE: Delete two error messages for a
 failed memory allocation
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <664f2619-1c7c-22de-775e-3af16e4203f8@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:30:28 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 11 Oct 2016 09:56:13 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Possible unnecessary 'out of memory' message

Thus remove such a logging statement in two functions.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 8c062ff..b479747 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -680,8 +680,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					   sizeof(*vpbe_dev->encoders),
 					   GFP_KERNEL);
 	if (NULL == vpbe_dev->encoders) {
-		v4l2_err(&vpbe_dev->v4l2_dev,
-			"unable to allocate memory for encoders sub devices");
 		ret = -ENOMEM;
 		goto fail_dev_unregister;
 	}
@@ -841,11 +839,9 @@ static int vpbe_probe(struct platform_device *pdev)
 	}
 
 	vpbe_dev = kzalloc(sizeof(*vpbe_dev), GFP_KERNEL);
-	if (vpbe_dev == NULL) {
-		v4l2_err(pdev->dev.driver, "Unable to allocate memory"
-			 " for vpbe_device\n");
+	if (!vpbe_dev)
 		return -ENOMEM;
-	}
+
 	vpbe_dev->cfg = cfg;
 	vpbe_dev->ops = vpbe_dev_ops;
 	vpbe_dev->pdev = &pdev->dev;
-- 
2.10.1

