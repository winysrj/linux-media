Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9126 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbeKCAbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 20:31:05 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jacob chen <jacob2.chen@rock-chips.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: rockchip/rga: constify video_device structure
Date: Fri,  2 Nov 2018 15:48:15 +0100
Message-Id: <1541170095-24104-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video_device structure is only copied into another structure, so
it can be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/rockchip/rga/rga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 9cc9db083870..4d3e08584027 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -700,7 +700,7 @@ static const struct v4l2_ioctl_ops rga_ioctl_ops = {
 	.vidioc_s_selection = vidioc_s_selection,
 };
 
-static struct video_device rga_videodev = {
+static const struct video_device rga_videodev = {
 	.name = "rockchip-rga",
 	.fops = &rga_fops,
 	.ioctl_ops = &rga_ioctl_ops,
