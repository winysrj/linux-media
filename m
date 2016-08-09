Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:9942 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171AbcHIQVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 12:21:22 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] mtk-vcodec: constify venc_common_if structures
Date: Tue,  9 Aug 2016 18:03:55 +0200
Message-Id: <1470758635-13193-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The venc_common_if structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h    |    2 +-
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c |    6 +++---
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c  |    6 +++---
 drivers/media/platform/mtk-vcodec/venc_drv_if.c       |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
index 94f0a42..b0cb3ed 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -240,7 +240,7 @@ struct mtk_vcodec_ctx {
 	enum mtk_encode_param param_change;
 	struct mtk_enc_params enc_params;
 
-	struct venc_common_if *enc_if;
+	const struct venc_common_if *enc_if;
 	unsigned long drv_handle;
 
 	int int_cond;
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
index 9a60052..532cd36 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
@@ -664,16 +664,16 @@ static int h264_enc_deinit(unsigned long handle)
 	return ret;
 }
 
-static struct venc_common_if venc_h264_if = {
+static const struct venc_common_if venc_h264_if = {
 	h264_enc_init,
 	h264_enc_encode,
 	h264_enc_set_param,
 	h264_enc_deinit,
 };
 
-struct venc_common_if *get_h264_enc_comm_if(void);
+const struct venc_common_if *get_h264_enc_comm_if(void);
 
-struct venc_common_if *get_h264_enc_comm_if(void)
+const struct venc_common_if *get_h264_enc_comm_if(void)
 {
 	return &venc_h264_if;
 }
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
index 60bbcd2..bdf6780 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -471,16 +471,16 @@ static int vp8_enc_deinit(unsigned long handle)
 	return ret;
 }
 
-static struct venc_common_if venc_vp8_if = {
+static const struct venc_common_if venc_vp8_if = {
 	vp8_enc_init,
 	vp8_enc_encode,
 	vp8_enc_set_param,
 	vp8_enc_deinit,
 };
 
-struct venc_common_if *get_vp8_enc_comm_if(void);
+const struct venc_common_if *get_vp8_enc_comm_if(void);
 
-struct venc_common_if *get_vp8_enc_comm_if(void)
+const struct venc_common_if *get_vp8_enc_comm_if(void)
 {
 	return &venc_vp8_if;
 }
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
index c4c83e7..d02d5f1 100644
--- a/drivers/media/platform/mtk-vcodec/venc_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
@@ -26,8 +26,8 @@
 #include "mtk_vcodec_enc_pm.h"
 #include "mtk_vpu.h"
 
-struct venc_common_if *get_h264_enc_comm_if(void);
-struct venc_common_if *get_vp8_enc_comm_if(void);
+const struct venc_common_if *get_h264_enc_comm_if(void);
+const struct venc_common_if *get_vp8_enc_comm_if(void);
 
 int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 {

