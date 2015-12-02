Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19239 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbLBIXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:40 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ00BC61ZFAV00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:39 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 3/6] s5p-mfc: remove unnecessary callbacks
Date: Wed, 02 Dec 2015 09:22:30 +0100
Message-id: <1449044553-27115-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
References: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many version specific functions are not called by common code, so there
is no need to use callbacks. Additionally some of them are not used at all,
so they can be safely removed.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 17 ---------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 38 --------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 47 -------------------------
 3 files changed, 102 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index b89df89..33dae96 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -281,26 +281,14 @@ struct s5p_mfc_hw_ops {
 	void (*release_dev_context_buffer)(struct s5p_mfc_dev *dev);
 	void (*dec_calc_dpb_size)(struct s5p_mfc_ctx *ctx);
 	void (*enc_calc_src_size)(struct s5p_mfc_ctx *ctx);
-	int (*set_dec_stream_buffer)(struct s5p_mfc_ctx *ctx,
-			int buf_addr, unsigned int start_num_byte,
-			unsigned int buf_size);
-	int (*set_dec_frame_buffer)(struct s5p_mfc_ctx *ctx);
 	int (*set_enc_stream_buffer)(struct s5p_mfc_ctx *ctx,
 			unsigned long addr, unsigned int size);
 	void (*set_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
 			unsigned long y_addr, unsigned long c_addr);
 	void (*get_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
 			unsigned long *y_addr, unsigned long *c_addr);
-	int (*set_enc_ref_buffer)(struct s5p_mfc_ctx *ctx);
-	int (*init_decode)(struct s5p_mfc_ctx *ctx);
-	int (*init_encode)(struct s5p_mfc_ctx *ctx);
-	int (*encode_one_frame)(struct s5p_mfc_ctx *ctx);
 	void (*try_run)(struct s5p_mfc_dev *dev);
 	void (*clear_int_flags)(struct s5p_mfc_dev *dev);
-	void (*write_info)(struct s5p_mfc_ctx *ctx, unsigned int data,
-			unsigned int ofs);
-	unsigned int (*read_info)(struct s5p_mfc_ctx *ctx,
-			unsigned long ofs);
 	int (*get_dspl_y_adr)(struct s5p_mfc_dev *dev);
 	int (*get_dec_y_adr)(struct s5p_mfc_dev *dev);
 	int (*get_dspl_status)(struct s5p_mfc_dev *dev);
@@ -311,7 +299,6 @@ struct s5p_mfc_hw_ops {
 	int (*get_int_reason)(struct s5p_mfc_dev *dev);
 	int (*get_int_err)(struct s5p_mfc_dev *dev);
 	int (*err_dec)(unsigned int err);
-	int (*err_dspl)(unsigned int err);
 	int (*get_img_width)(struct s5p_mfc_dev *dev);
 	int (*get_img_height)(struct s5p_mfc_dev *dev);
 	int (*get_dpb_count)(struct s5p_mfc_dev *dev);
@@ -320,10 +307,6 @@ struct s5p_mfc_hw_ops {
 	int (*get_enc_strm_size)(struct s5p_mfc_dev *dev);
 	int (*get_enc_slice_type)(struct s5p_mfc_dev *dev);
 	int (*get_enc_dpb_count)(struct s5p_mfc_dev *dev);
-	int (*get_enc_pic_count)(struct s5p_mfc_dev *dev);
-	int (*get_sei_avail_status)(struct s5p_mfc_ctx *ctx);
-	int (*get_mvc_num_views)(struct s5p_mfc_dev *dev);
-	int (*get_mvc_view_id)(struct s5p_mfc_dev *dev);
 	unsigned int (*get_pic_type_top)(struct s5p_mfc_ctx *ctx);
 	unsigned int (*get_pic_type_bot)(struct s5p_mfc_ctx *ctx);
 	unsigned int (*get_crop_info_h)(struct s5p_mfc_ctx *ctx);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index ae4c950..8754b7e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1554,11 +1554,6 @@ static int s5p_mfc_err_dec_v5(unsigned int err)
 	return (err & S5P_FIMV_ERR_DEC_MASK) >> S5P_FIMV_ERR_DEC_SHIFT;
 }
 
-static int s5p_mfc_err_dspl_v5(unsigned int err)
-{
-	return (err & S5P_FIMV_ERR_DSPL_MASK) >> S5P_FIMV_ERR_DSPL_SHIFT;
-}
-
 static int s5p_mfc_get_img_width_v5(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_SI_HRESOL);
@@ -1600,26 +1595,6 @@ static int s5p_mfc_get_enc_dpb_count_v5(struct s5p_mfc_dev *dev)
 	return -1;
 }
 
-static int s5p_mfc_get_enc_pic_count_v5(struct s5p_mfc_dev *dev)
-{
-	return mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT);
-}
-
-static int s5p_mfc_get_sei_avail_status_v5(struct s5p_mfc_ctx *ctx)
-{
-	return s5p_mfc_read_info_v5(ctx, FRAME_PACK_SEI_AVAIL);
-}
-
-static int s5p_mfc_get_mvc_num_views_v5(struct s5p_mfc_dev *dev)
-{
-	return -1;
-}
-
-static int s5p_mfc_get_mvc_view_id_v5(struct s5p_mfc_dev *dev)
-{
-	return -1;
-}
-
 static unsigned int s5p_mfc_get_pic_type_top_v5(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v5(ctx, PIC_TIME_TOP);
@@ -1652,19 +1627,11 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
 	.release_dev_context_buffer = s5p_mfc_release_dev_context_buffer_v5,
 	.dec_calc_dpb_size = s5p_mfc_dec_calc_dpb_size_v5,
 	.enc_calc_src_size = s5p_mfc_enc_calc_src_size_v5,
-	.set_dec_stream_buffer = s5p_mfc_set_dec_stream_buffer_v5,
-	.set_dec_frame_buffer = s5p_mfc_set_dec_frame_buffer_v5,
 	.set_enc_stream_buffer = s5p_mfc_set_enc_stream_buffer_v5,
 	.set_enc_frame_buffer = s5p_mfc_set_enc_frame_buffer_v5,
 	.get_enc_frame_buffer = s5p_mfc_get_enc_frame_buffer_v5,
-	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v5,
-	.init_decode = s5p_mfc_init_decode_v5,
-	.init_encode = s5p_mfc_init_encode_v5,
-	.encode_one_frame = s5p_mfc_encode_one_frame_v5,
 	.try_run = s5p_mfc_try_run_v5,
 	.clear_int_flags = s5p_mfc_clear_int_flags_v5,
-	.write_info = s5p_mfc_write_info_v5,
-	.read_info = s5p_mfc_read_info_v5,
 	.get_dspl_y_adr = s5p_mfc_get_dspl_y_adr_v5,
 	.get_dec_y_adr = s5p_mfc_get_dec_y_adr_v5,
 	.get_dspl_status = s5p_mfc_get_dspl_status_v5,
@@ -1675,7 +1642,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
 	.get_int_reason = s5p_mfc_get_int_reason_v5,
 	.get_int_err = s5p_mfc_get_int_err_v5,
 	.err_dec = s5p_mfc_err_dec_v5,
-	.err_dspl = s5p_mfc_err_dspl_v5,
 	.get_img_width = s5p_mfc_get_img_width_v5,
 	.get_img_height = s5p_mfc_get_img_height_v5,
 	.get_dpb_count = s5p_mfc_get_dpb_count_v5,
@@ -1684,10 +1650,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
 	.get_enc_strm_size = s5p_mfc_get_enc_strm_size_v5,
 	.get_enc_slice_type = s5p_mfc_get_enc_slice_type_v5,
 	.get_enc_dpb_count = s5p_mfc_get_enc_dpb_count_v5,
-	.get_enc_pic_count = s5p_mfc_get_enc_pic_count_v5,
-	.get_sei_avail_status = s5p_mfc_get_sei_avail_status_v5,
-	.get_mvc_num_views = s5p_mfc_get_mvc_num_views_v5,
-	.get_mvc_view_id = s5p_mfc_get_mvc_view_id_v5,
 	.get_pic_type_top = s5p_mfc_get_pic_type_top_v5,
 	.get_pic_type_bot = s5p_mfc_get_pic_type_bot_v5,
 	.get_crop_info_h = s5p_mfc_get_crop_info_h_v5,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index fbff09a..764a675 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1829,14 +1829,6 @@ static void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
 	writel(0, mfc_regs->risc2host_int);
 }
 
-static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
-		unsigned int ofs)
-{
-	s5p_mfc_clock_on();
-	writel(data, (void __iomem *)((unsigned long)ofs));
-	s5p_mfc_clock_off();
-}
-
 static unsigned int
 s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned long ofs)
 {
@@ -1903,11 +1895,6 @@ static int s5p_mfc_err_dec_v6(unsigned int err)
 	return (err & S5P_FIMV_ERR_DEC_MASK_V6) >> S5P_FIMV_ERR_DEC_SHIFT_V6;
 }
 
-static int s5p_mfc_err_dspl_v6(unsigned int err)
-{
-	return (err & S5P_FIMV_ERR_DSPL_MASK_V6) >> S5P_FIMV_ERR_DSPL_SHIFT_V6;
-}
-
 static int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
 {
 	return readl(dev->mfc_regs->d_display_frame_width);
@@ -1948,27 +1935,6 @@ static int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
 	return readl(dev->mfc_regs->e_slice_type);
 }
 
-static int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
-{
-	return readl(dev->mfc_regs->e_picture_count);
-}
-
-static int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
-{
-	struct s5p_mfc_dev *dev = ctx->dev;
-	return readl(dev->mfc_regs->d_frame_pack_sei_avail);
-}
-
-static int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
-{
-	return readl(dev->mfc_regs->d_mvc_num_views);
-}
-
-static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
-{
-	return readl(dev->mfc_regs->d_mvc_view_id);
-}
-
 static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
@@ -2243,19 +2209,11 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
 		s5p_mfc_release_dev_context_buffer_v6,
 	.dec_calc_dpb_size = s5p_mfc_dec_calc_dpb_size_v6,
 	.enc_calc_src_size = s5p_mfc_enc_calc_src_size_v6,
-	.set_dec_stream_buffer = s5p_mfc_set_dec_stream_buffer_v6,
-	.set_dec_frame_buffer = s5p_mfc_set_dec_frame_buffer_v6,
 	.set_enc_stream_buffer = s5p_mfc_set_enc_stream_buffer_v6,
 	.set_enc_frame_buffer = s5p_mfc_set_enc_frame_buffer_v6,
 	.get_enc_frame_buffer = s5p_mfc_get_enc_frame_buffer_v6,
-	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v6,
-	.init_decode = s5p_mfc_init_decode_v6,
-	.init_encode = s5p_mfc_init_encode_v6,
-	.encode_one_frame = s5p_mfc_encode_one_frame_v6,
 	.try_run = s5p_mfc_try_run_v6,
 	.clear_int_flags = s5p_mfc_clear_int_flags_v6,
-	.write_info = s5p_mfc_write_info_v6,
-	.read_info = s5p_mfc_read_info_v6,
 	.get_dspl_y_adr = s5p_mfc_get_dspl_y_adr_v6,
 	.get_dec_y_adr = s5p_mfc_get_dec_y_adr_v6,
 	.get_dspl_status = s5p_mfc_get_dspl_status_v6,
@@ -2266,7 +2224,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
 	.get_int_reason = s5p_mfc_get_int_reason_v6,
 	.get_int_err = s5p_mfc_get_int_err_v6,
 	.err_dec = s5p_mfc_err_dec_v6,
-	.err_dspl = s5p_mfc_err_dspl_v6,
 	.get_img_width = s5p_mfc_get_img_width_v6,
 	.get_img_height = s5p_mfc_get_img_height_v6,
 	.get_dpb_count = s5p_mfc_get_dpb_count_v6,
@@ -2275,10 +2232,6 @@ static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
 	.get_enc_strm_size = s5p_mfc_get_enc_strm_size_v6,
 	.get_enc_slice_type = s5p_mfc_get_enc_slice_type_v6,
 	.get_enc_dpb_count = s5p_mfc_get_enc_dpb_count_v6,
-	.get_enc_pic_count = s5p_mfc_get_enc_pic_count_v6,
-	.get_sei_avail_status = s5p_mfc_get_sei_avail_status_v6,
-	.get_mvc_num_views = s5p_mfc_get_mvc_num_views_v6,
-	.get_mvc_view_id = s5p_mfc_get_mvc_view_id_v6,
 	.get_pic_type_top = s5p_mfc_get_pic_type_top_v6,
 	.get_pic_type_bot = s5p_mfc_get_pic_type_bot_v6,
 	.get_crop_info_h = s5p_mfc_get_crop_info_h_v6,
-- 
1.9.1

