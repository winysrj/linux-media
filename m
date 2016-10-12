Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:61060 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933324AbcJLPEC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:04:02 -0400
Subject: [PATCH 25/34] [media] DaVinci-VPIF-Capture: Use kcalloc() in
 vpif_probe()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <506f65c8-645f-d408-433a-d716da0ab3bc@users.sourceforge.net>
Date: Wed, 12 Oct 2016 17:03:19 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 15:15:34 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpif_capture.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5104cc0..fb9e850 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1464,8 +1464,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	vpif_obj.config = pdev->dev.platform_data;
 
 	subdev_count = vpif_obj.config->subdev_count;
-	vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
-				GFP_KERNEL);
+	vpif_obj.sd = kcalloc(subdev_count, sizeof(*vpif_obj.sd), GFP_KERNEL);
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-- 
2.10.1

