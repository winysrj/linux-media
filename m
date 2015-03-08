Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46394 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbCHOlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:09 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 05/17] media: blackfin: bfin_capture: improve queue_setup() callback
Date: Sun,  8 Mar 2015 14:40:41 +0000
Message-Id: <1425825653-14768-6-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch does the following:
a: returns -EINVAL in case format image size is less
   then current image size.
b: assigns nbuffers to two in case the total of vq->num_buffers
   and nbuffers is less then the number of buffers required by driver.
c: sets the sizes[0] of plane according to the fmt passed or which is
   being set in the device.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index a588129..bf7e999 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -44,7 +44,6 @@
 #include <media/blackfin/ppi.h>
 
 #define CAPTURE_DRV_NAME        "bfin_capture"
-#define BCAP_MIN_NUM_BUF        2
 
 struct bcap_format {
 	char *desc;
@@ -292,11 +291,14 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
-	if (*nbuffers < BCAP_MIN_NUM_BUF)
-		*nbuffers = BCAP_MIN_NUM_BUF;
+	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
+		return -EINVAL;
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2;
 
 	*nplanes = 1;
-	sizes[0] = bcap_dev->fmt.sizeimage;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
 	alloc_ctxs[0] = bcap_dev->alloc_ctx;
 
 	return 0;
-- 
2.1.0

