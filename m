Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:63977
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728608AbeJ0Vcw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 17:32:52 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: vicodec: constify v4l2_ctrl_ops structure
Date: Sat, 27 Oct 2018 14:16:39 +0200
Message-Id: <1540642600-25840-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1540642600-25840-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1540642600-25840-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_ctrl_ops structure is only stored in the ops field of a
v4l2_ctrl_config structure, and this field is const, or passed as the
second argument of v4l2_ctrl_new_std, and the corresponding parameter
is declared as const.  Accordingly, the structure can also be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/vicodec/vicodec-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1108,7 +1108,7 @@ static int vicodec_s_ctrl(struct v4l2_ct
 	return -EINVAL;
 }
 
-static struct v4l2_ctrl_ops vicodec_ctrl_ops = {
+static const struct v4l2_ctrl_ops vicodec_ctrl_ops = {
 	.s_ctrl = vicodec_s_ctrl,
 };
 
