Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36628 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdAUJpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Jan 2017 04:45:49 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: dvb-frontends: constify vb2_ops structure
Date: Sat, 21 Jan 2017 15:15:31 +0530
Message-Id: <1484991931-18243-1-git-send-email-bhumirks@gmail.com>
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

File size details of media/dvb-frontends/rtl2832_sdr.o file remains the
same before and after applying the patch.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index e038e88..c6e78d8 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -956,7 +956,7 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&dev->v4l2_lock);
 }
 
-static struct vb2_ops rtl2832_sdr_vb2_ops = {
+static const struct vb2_ops rtl2832_sdr_vb2_ops = {
 	.queue_setup            = rtl2832_sdr_queue_setup,
 	.buf_prepare            = rtl2832_sdr_buf_prepare,
 	.buf_queue              = rtl2832_sdr_buf_queue,
-- 
1.9.1

