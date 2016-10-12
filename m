Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60100 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933302AbcJLO3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:29:23 -0400
Subject: [PATCH 01/34] [media] DaVinci-VPBE: Use kmalloc_array() in
 vpbe_initialize()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ca927405-77a0-b6c2-d626-fa27e584664a@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:29:01 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 11 Oct 2016 09:40:41 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 9a6c2cc..8c062ff 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -676,9 +676,9 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	 * store venc sd index.
 	 */
 	num_encoders = vpbe_dev->cfg->num_ext_encoders + 1;
-	vpbe_dev->encoders = kmalloc(
-				sizeof(struct v4l2_subdev *)*num_encoders,
-				GFP_KERNEL);
+	vpbe_dev->encoders = kmalloc_array(num_encoders,
+					   sizeof(*vpbe_dev->encoders),
+					   GFP_KERNEL);
 	if (NULL == vpbe_dev->encoders) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
 			"unable to allocate memory for encoders sub devices");
-- 
2.10.1

