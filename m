Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25427 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbeJaBAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:00:51 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: video-i2c: hwmon: constify vb2_ops structure
Date: Tue, 30 Oct 2018 16:31:22 +0100
Message-Id: <1540913482-22130-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1540913482-22130-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1540913482-22130-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_ops structure can be const as it is only stored in the ops
field of a vb2_queue structure and this field is const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/i2c/video-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 4d49af86c15e..cb89cda6553d 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -336,7 +336,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	video_i2c_del_list(vq, VB2_BUF_STATE_ERROR);
 }
 
-static struct vb2_ops video_i2c_video_qops = {
+static const struct vb2_ops video_i2c_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
