Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35248 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753082AbdI0N7w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 09:59:52 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] bt8xx: make bttv_vbi_qops const
Date: Wed, 27 Sep 2017 19:29:42 +0530
Message-Id: <1506520782-17305-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only passed to the const argument of the
function videobuf_queue_sg_init in the file referencing it.
Also, make the declaration in the header const.

Structure found using Coccienlle and changes done by hand.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-vbi.c | 2 +-
 drivers/media/pci/bt8xx/bttvp.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-vbi.c b/drivers/media/pci/bt8xx/bttv-vbi.c
index e77129c..67c6583 100644
--- a/drivers/media/pci/bt8xx/bttv-vbi.c
+++ b/drivers/media/pci/bt8xx/bttv-vbi.c
@@ -233,7 +233,7 @@ static void vbi_buffer_release(struct videobuf_queue *q, struct videobuf_buffer
 	bttv_dma_free(q,fh->btv,buf);
 }
 
-struct videobuf_queue_ops bttv_vbi_qops = {
+const struct videobuf_queue_ops bttv_vbi_qops = {
 	.buf_setup    = vbi_buffer_setup,
 	.buf_prepare  = vbi_buffer_prepare,
 	.buf_queue    = vbi_buffer_queue,
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 9efc455..853cbb2 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -281,7 +281,7 @@ int bttv_overlay_risc(struct bttv *btv, struct bttv_overlay *ov,
 int bttv_g_fmt_vbi_cap(struct file *file, void *fh, struct v4l2_format *f);
 int bttv_s_fmt_vbi_cap(struct file *file, void *fh, struct v4l2_format *f);
 
-extern struct videobuf_queue_ops bttv_vbi_qops;
+extern const struct videobuf_queue_ops bttv_vbi_qops;
 
 /* ---------------------------------------------------------- */
 /* bttv-gpio.c */
-- 
1.9.1
