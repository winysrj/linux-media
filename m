Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58902 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754985AbcJLOye (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:54:34 -0400
Subject: [PATCH 16/34] [media] DaVinci-VPFE-Capture: Delete an unnecessary
 variable initialisation in vpfe_probe()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <e2e1411e-711d-97b3-8280-5caafbead30b@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:54:17 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:30:28 +0200

* Return an error code as a constant after a failed call of
  the function "vpfe_initialize".

* The local variable "ret" will be set then to an appropriate value
  a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 4db3212..8314c39 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1819,7 +1819,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	struct vpfe_device *vpfe_dev;
 	struct i2c_adapter *i2c_adap;
 	struct video_device *vfd;
-	int ret = -ENOMEM, i, j;
+	int ret, i, j;
 	int num_subdevs = 0;
 
 	/* Get the pointer to the device object */
@@ -1828,7 +1828,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	if (!vpfe_dev) {
 		v4l2_err(pdev->dev.driver,
 			"Failed to allocate memory for vpfe_dev\n");
-		return ret;
+		return -ENOMEM;
 	}
 
 	vpfe_dev->pdev = &pdev->dev;
-- 
2.10.1

