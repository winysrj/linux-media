Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:13597 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbeJESJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 14:09:06 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] [media] media: drop pointless static qualifier in vpfe_ipipeif_init()
Date: Fri, 5 Oct 2018 11:22:06 +0000
Message-ID: <1538738526-131410-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to have the 'resource_size_t res_len' variable static
since new value always be assigned before use it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index a53231b..e191829 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -998,7 +998,7 @@ int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
 	struct v4l2_subdev *sd = &ipipeif->subdev;
 	struct media_pad *pads = &ipipeif->pads[0];
 	struct media_entity *me = &sd->entity;
-	static resource_size_t  res_len;
+	resource_size_t  res_len;
 	struct resource *res;
 	int ret;
