Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52442 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932826AbcJLOzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:55:49 -0400
Subject: [PATCH 17/34] [media] DaVinci-VPFE-Capture: Improve another size
 determination in vpfe_enum_input()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:55:37 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:33:42 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8314c39..87ee35d 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1091,7 +1091,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 	}
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
-	memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
+	memcpy(inp, &sdinfo->inputs[index], sizeof(*inp));
 	return 0;
 }
 
-- 
2.10.1

