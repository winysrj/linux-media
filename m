Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:55487 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755170AbcJLO7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:59:24 -0400
Subject: [PATCH 14/34] [media] DaVinci-VPFE-Capture: Delete three error
 messages for a failed memory allocation
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <cce4ef26-53b4-02d7-e46c-9438d5953cb9@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:52:35 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:22:47 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Possible unnecessary 'out of memory' message

Thus remove such a logging statement in two functions.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 5c1b8cf..23142f0 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -512,11 +512,9 @@ static int vpfe_open(struct file *file)
 
 	/* Allocate memory for the file handle object */
 	fh = kmalloc(sizeof(struct vpfe_fh), GFP_KERNEL);
-	if (NULL == fh) {
-		v4l2_err(&vpfe_dev->v4l2_dev,
-			"unable to allocate memory for file handle object\n");
+	if (!fh)
 		return -ENOMEM;
-	}
+
 	/* store pointer to fh in private_data member of file */
 	file->private_data = fh;
 	fh->vpfe_dev = vpfe_dev;
@@ -1853,11 +1851,8 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	/* Allocate memory for ccdc configuration */
 	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
-	if (NULL == ccdc_cfg) {
-		v4l2_err(pdev->dev.driver,
-			 "Memory allocation failed for ccdc_cfg\n");
+	if (!ccdc_cfg)
 		goto probe_free_dev_mem;
-	}
 
 	mutex_lock(&ccdc_lock);
 
@@ -1944,8 +1939,6 @@ static int vpfe_probe(struct platform_device *pdev)
 				     sizeof(*vpfe_dev->sd),
 				     GFP_KERNEL);
 	if (NULL == vpfe_dev->sd) {
-		v4l2_err(&vpfe_dev->v4l2_dev,
-			"unable to allocate memory for subdevice pointers\n");
 		ret = -ENOMEM;
 		goto probe_out_video_unregister;
 	}
-- 
2.10.1

