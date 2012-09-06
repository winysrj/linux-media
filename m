Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33245 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2IFPYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 11:24:20 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/14] drivers/media/platform/soc_camera/soc_camera.c: fix error return code
Date: Thu,  6 Sep 2012 17:24:00 +0200
Message-Id: <1346945041-26676-13-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
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

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/platform/soc_camera/soc_camera.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..a4beb6c 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1184,7 +1184,8 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	sd->grp_id = soc_camera_grp_id(icd);
 	v4l2_set_subdev_hostdata(sd, icd);
 
-	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
+	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler);
+	if (ret)
 		goto ectrl;
 
 	/* At this point client .probe() should have run already */

