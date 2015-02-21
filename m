Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:40354 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbBUSkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:35 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 05/15] media: blackfin: bfin_capture: improve queue_setup() callback
Date: Sat, 21 Feb 2015 18:39:51 +0000
Message-Id: <1424544001-19045-6-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch improves the queue_setup() callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8f62a84..be0d0a2b 100644
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

