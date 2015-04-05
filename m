Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21103
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbbDEMOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2015 08:14:44 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/16] [media] si4713: fix error return code
Date: Sun,  5 Apr 2015 14:06:22 +0200
Message-Id: <1428235596-4757-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/radio/si4713/si4713.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index c90004d..c4e1d6c 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1615,8 +1615,10 @@ static int si4713_probe(struct i2c_client *client,
 		return 0;
 
 	si4713_pdev = platform_device_alloc("radio-si4713", -1);
-	if (!si4713_pdev)
+	if (!si4713_pdev) {
+		rval = -ENOMEM;
 		goto put_main_pdev;
+	}
 
 	si4713_pdev_pdata.subdev = client;
 	rval = platform_device_add_data(si4713_pdev, &si4713_pdev_pdata,

