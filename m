Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:40845 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753685AbeDAPAb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2018 11:00:31 -0400
Received: by mail-io0-f195.google.com with SMTP id e79so15557052ioi.7
        for <linux-media@vger.kernel.org>; Sun, 01 Apr 2018 08:00:30 -0700 (PDT)
From: Samuel Williams <sam8641@gmail.com>
Subject: [PATCH] media: bttv: Fixed oops error when capturing at yuv410p
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <c8d39f5d-9daa-2673-9d47-38834c0c6edb@gmail.com>
Date: Sun, 1 Apr 2018 10:00:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When capturing at yuv410p, sg_next was called too many times when chroma is
false, eventually returning NULL. This patch does fix this for my hardware.

Signed-off-by: Samuel Williams <sam8641@gmail.com>
---
  drivers/media/pci/bt8xx/bttv-risc.c | 16 ++++++++--------
  1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
index 3859dde98be2..f87ac667f5fc 100644
--- a/drivers/media/pci/bt8xx/bttv-risc.c
+++ b/drivers/media/pci/bt8xx/bttv-risc.c
@@ -189,20 +189,20 @@ bttv_risc_planar(struct bttv *btv, struct btcx_riscmem *risc,
  				yoffset -= sg_dma_len(ysg);
  				ysg = sg_next(ysg);
  			}
-			while (uoffset && uoffset >= sg_dma_len(usg)) {
-				uoffset -= sg_dma_len(usg);
-				usg = sg_next(usg);
-			}
-			while (voffset && voffset >= sg_dma_len(vsg)) {
-				voffset -= sg_dma_len(vsg);
-				vsg = sg_next(vsg);
-			}
  
  			/* calculate max number of bytes we can write */
  			ylen = todo;
  			if (yoffset + ylen > sg_dma_len(ysg))
  				ylen = sg_dma_len(ysg) - yoffset;
  			if (chroma) {
+				while (uoffset && uoffset >= sg_dma_len(usg)) {
+					uoffset -= sg_dma_len(usg);
+					usg = sg_next(usg);
+				}
+				while (voffset && voffset >= sg_dma_len(vsg)) {
+					voffset -= sg_dma_len(vsg);
+					vsg = sg_next(vsg);
+				}
  				if (uoffset + (ylen>>hshift) > sg_dma_len(usg))
  					ylen = (sg_dma_len(usg) - uoffset) << hshift;
  				if (voffset + (ylen>>hshift) > sg_dma_len(vsg))
-- 
2.16.3
