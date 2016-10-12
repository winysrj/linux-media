Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63797 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755425AbcJLPMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:12:38 -0400
Subject: [PATCH 31/34] [media] DaVinci-VPIF-Display: Delete an error message
 for a failed memory allocation
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <73ab1e30-a0cc-cbf6-eed0-cb992fca8789@users.sourceforge.net>
Date: Wed, 12 Oct 2016 17:12:18 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 15:38:41 +0200

Omit an extra message for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpif_display.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 80121e8..3347fa14 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1281,7 +1281,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 	subdevdata = vpif_obj.config->subdevinfo;
 	vpif_obj.sd = kcalloc(subdev_count, sizeof(*vpif_obj.sd), GFP_KERNEL);
 	if (vpif_obj.sd == NULL) {
-		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
 		goto vpif_unregister;
 	}
-- 
2.10.1

