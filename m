Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33932 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752227AbdK2TIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:48 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 10/22] media: vdec: fix some kernel-doc warnings
Date: Wed, 29 Nov 2017 14:08:28 -0500
Message-Id: <0ddb6632dd9afa919656e0bd8f0651af82e98a9d.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:
  drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c:69: warning: No description found for parameter 'reserved'
  drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:175: warning: Excess struct member 'dev' description in 'vdec_vp8_inst'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c | 1 +
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
index b7731b18ecae..aa3ce41898bc 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
@@ -59,6 +59,7 @@ struct h264_fb {
  * @read_idx  : read index
  * @write_idx : write index
  * @count     : buffer count in list
+ * @reserved  : for 8 bytes alignment
  */
 struct h264_ring_fb_list {
 	struct h264_fb fb_list[H264_MAX_FB_NUM];
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
index b9fad6a48879..3e84a761db3a 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
@@ -155,7 +155,6 @@ struct vdec_vp8_vpu_inst {
  * @reg_base		   : HW register base address
  * @frm_cnt		   : decode frame count
  * @ctx			   : V4L2 context
- * @dev			   : platform device
  * @vpu			   : VPU instance for decoder
  * @vsi			   : VPU share information
  */
-- 
2.14.3
