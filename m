Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:9891 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932117AbcEKIWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 04:22:04 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	PoChun Lin <pochun.lin@mediatek.com>
Subject: [PATCH] [media] vcodec: mediatek: fix sparse warning
Date: Wed, 11 May 2016 16:21:45 +0800
Message-ID: <1462954905-33600-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix sparse warning when running with parameters:
C=2 CF="-D__CHECK_ENDIAN__"

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: PoChun Lin <pochun.lin@mediatek.com>
---
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
index 431ae70..5b4ef0f 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -252,13 +252,18 @@ static int vp8_enc_compose_one_frame(struct venc_vp8_inst *inst,
 	u32 bs_hdr_len;
 	unsigned int ac_tag_size;
 	u8 ac_tag[MAX_AC_TAG_SIZE];
+	u32 tag;
 
 	bs_frm_size = vp8_enc_read_reg(inst, VENC_BITSTREAM_FRAME_SIZE);
 	bs_hdr_len = vp8_enc_read_reg(inst, VENC_BITSTREAM_HEADER_LEN);
 
 	/* if a frame is key frame, not_key is 0 */
 	not_key = !inst->vpu_inst.is_key_frm;
-	*(u32 *)ac_tag = __cpu_to_le32((bs_hdr_len << 5) | 0x10 | not_key);
+	tag = (bs_hdr_len << 5) | 0x10 | not_key;
+	ac_tag[0] = tag & 0xff;
+	ac_tag[1] = (tag >> 8) & 0xff;
+	ac_tag[2] = (tag >> 16) & 0xff;
+
 	/* key frame */
 	if (not_key == 0) {
 		ac_tag_size = MAX_AC_TAG_SIZE;
-- 
1.7.9.5

