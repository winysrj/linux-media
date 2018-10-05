Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728081AbeJESIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 14:08:16 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kees Cook <keescook@chromium.org>,
        Colin Ian King <colin.king@canonical.com>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] [media] media: drop pointless static qualifier in vpfe_resizer_init()
Date: Fri, 5 Oct 2018 11:21:06 +0000
Message-ID: <1538738466-129133-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to have the 'resource_size_t res_len' variable static
since new value always be assigned before use it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index aac6dbf..b2b23a7 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1884,7 +1884,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	struct v4l2_subdev *sd = &vpfe_rsz->crop_resizer.subdev;
 	struct media_pad *pads = &vpfe_rsz->crop_resizer.pads[0];
 	struct media_entity *me = &sd->entity;
-	static resource_size_t  res_len;
+	resource_size_t  res_len;
 	struct resource *res;
 	int ret;
