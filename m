Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:12494
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750965AbdHNGYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 02:24:15 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] pxa_camera: constify v4l2_clk_ops structure
Date: Mon, 14 Aug 2017 07:58:37 +0200
Message-Id: <1502690317-9478-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v4l2_clk_ops structure is only passed as the first argument of
v4l2_clk_register, which is const, so the v4l2_clk_ops structure can
also be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/pxa_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 0d4af6d..4a800a4 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2100,7 +2100,7 @@ static int pxac_fops_camera_release(struct file *filp)
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
-static struct v4l2_clk_ops pxa_camera_mclk_ops = {
+static const struct v4l2_clk_ops pxa_camera_mclk_ops = {
 };
 
 static const struct video_device pxa_camera_videodev_template = {
