Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:40941
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbeJ0Vcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 17:32:53 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: ov5645: constify v4l2_ctrl_ops structure
Date: Sat, 27 Oct 2018 14:16:40 +0200
Message-Id: <1540642600-25840-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1540642600-25840-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1540642600-25840-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_ctrl_ops structure is only passed as the second argument to
functions such as v4l2_ctrl_new_std for which the corresponding
parameter is const, so make the v4l2_ctrl_ops structure const as well.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/i2c/ov5645.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -886,7 +886,7 @@ static int ov5645_s_ctrl(struct v4l2_ctr
 	return ret;
 }
 
-static struct v4l2_ctrl_ops ov5645_ctrl_ops = {
+static const struct v4l2_ctrl_ops ov5645_ctrl_ops = {
 	.s_ctrl = ov5645_s_ctrl,
 };
 
