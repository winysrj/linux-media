Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37487 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdI0IF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 04:05:58 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] cx231xx: make cx231xx_vbi_qops const
Date: Wed, 27 Sep 2017 13:35:43 +0530
Message-Id: <1506499543-11139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only passed to the const argument of the
function videobuf_queue_vmalloc_init in the file referencing it.
Also, make the declaration in the header const.

Structure found using Coccienlle and changes done by hand.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-vbi.c | 2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 76e9019..330b86e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -285,7 +285,7 @@ static void vbi_buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }
 
-struct videobuf_queue_ops cx231xx_vbi_qops = {
+const struct videobuf_queue_ops cx231xx_vbi_qops = {
 	.buf_setup   = vbi_buffer_setup,
 	.buf_prepare = vbi_buffer_prepare,
 	.buf_queue   = vbi_buffer_queue,
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.h b/drivers/media/usb/cx231xx/cx231xx-vbi.h
index 16c7d20..b33d2bd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.h
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.h
@@ -22,7 +22,7 @@
 #ifndef _CX231XX_VBI_H
 #define _CX231XX_VBI_H
 
-extern struct videobuf_queue_ops cx231xx_vbi_qops;
+extern const struct videobuf_queue_ops cx231xx_vbi_qops;
 
 #define   NTSC_VBI_START_LINE 10	/* line 10 - 21 */
 #define   NTSC_VBI_END_LINE   21
-- 
1.9.1
