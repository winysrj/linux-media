Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21103
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbbDEMOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2015 08:14:46 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/16] [media] radio: fix error return code
Date: Sun,  5 Apr 2015 14:06:24 +0200
Message-Id: <1428235596-4757-5-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/radio/radio-timb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index e6b55ed..04baafe 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -138,8 +138,10 @@ static int timbradio_probe(struct platform_device *pdev)
 		i2c_get_adapter(pdata->i2c_adapter), pdata->tuner, NULL);
 	tr->sd_dsp = v4l2_i2c_new_subdev_board(&tr->v4l2_dev,
 		i2c_get_adapter(pdata->i2c_adapter), pdata->dsp, NULL);
-	if (tr->sd_tuner == NULL || tr->sd_dsp == NULL)
+	if (tr->sd_tuner == NULL || tr->sd_dsp == NULL) {
+		err = -ENODEV;
 		goto err_video_req;
+	}
 
 	tr->v4l2_dev.ctrl_handler = tr->sd_dsp->ctrl_handler;
 

