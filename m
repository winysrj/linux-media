Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46907 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755055AbcHXQaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 12:30:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/2] [media] tw5864: remove two unused vars
Date: Wed, 24 Aug 2016 13:30:40 -0300
Message-Id: <06dccc17cd84bae893a347be3191a5d43ec019d1.1472056235.git.mchehab@s-opensource.com>
In-Reply-To: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
References: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
In-Reply-To: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
References: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove those two vars that aren't used, as reported by smatch:

drivers/media/pci/tw5864/tw5864-video.c: In function 'tw5864_prepare_frame_headers':
drivers/media/pci/tw5864/tw5864-video.c:1219:16: warning: variable 'space_before_sl_hdr' set but not used [-Wunused-but-set-variable]
  unsigned long space_before_sl_hdr;
                ^~~~~~~~~~~~~~~~~~~
drivers/media/pci/tw5864/tw5864-video.c:1218:6: warning: variable 'sl_hdr' set but not used [-Wunused-but-set-variable]
  u8 *sl_hdr;
      ^~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/tw5864/tw5864-video.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 3461ba9162e7..6c1685aeaea9 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -1215,8 +1215,6 @@ void tw5864_prepare_frame_headers(struct tw5864_input *input)
 	u8 *dst;
 	size_t dst_space;
 	unsigned long flags;
-	u8 *sl_hdr;
-	unsigned long space_before_sl_hdr;
 
 	if (!vb) {
 		spin_lock_irqsave(&input->slock, flags);
@@ -1253,8 +1251,6 @@ void tw5864_prepare_frame_headers(struct tw5864_input *input)
 					      input->width, input->height);
 
 	/* Put slice header */
-	sl_hdr = dst;
-	space_before_sl_hdr = dst_space;
 	tw5864_h264_put_slice_header(&dst, &dst_space, input->h264_idr_pic_id,
 				     input->frame_gop_seqno,
 				     &input->tail_nb_bits, &input->tail);
-- 
2.7.4

