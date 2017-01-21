Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34658 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdAUJhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Jan 2017 04:37:37 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: pci: constify vb2_ops structure
Date: Sat, 21 Jan 2017 15:07:25 +0530
Message-Id: <1484991445-17253-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare vb2_ops structure as const as it is only stored in
the ops field of a vb2_queue structure. This field is of type
const, so vb2_ops structures having same properties can be made
const too.
Done using Coccinelle:

@r1 disable optional_qualifier@
identifier i;
position p;
@@
static struct vb2_ops i@p={...};

@ok1@
identifier r1.i;
position p;
struct sta2x11_vip vip;
struct vb2_queue q;
@@
(
vip.vb_vidq.ops=&i@p
|
q.ops=&i@p
)

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct vb2_ops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
   8448	    440	      0	   8888	   22b8	media/pci/sta2x11/sta2x11_vip.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   8552	    352	      0	   8904	   22c8	media/pci/sta2x11/sta2x11_vip.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index aeb2b4e..6343d24 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -377,7 +377,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_unlock(&vip->lock);
 }
 
-static struct vb2_ops vip_video_qops = {
+static const struct vb2_ops vip_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_init		= buffer_init,
 	.buf_prepare		= buffer_prepare,
-- 
1.9.1

