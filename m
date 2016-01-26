Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34634 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848AbcAZJEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:04:37 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@osg.samsung.com, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, herman.chen@rock-chips.com,
	alpha.lin@rock-chips.com, zhaojun <jung.zhao@rock-chips.com>,
	Antti Palosaari <crope@iki.fi>, linux-api@vger.kernel.org,
	Benoit Parrot <bparrot@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-kernel@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 1/3] media: v4l: Add VP8 format support in V4L2 framework
Date: Tue, 26 Jan 2016 17:04:04 +0800
Message-Id: <1453799046-307-2-git-send-email-jung.zhao@rock-chips.com>
In-Reply-To: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
References: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: zhaojun <jung.zhao@rock-chips.com>

Signed-off-by: zhaojun <jung.zhao@rock-chips.com>
---

 drivers/media/v4l2-core/v4l2-ctrls.c           | 17 ++++-
 drivers/media/v4l2-core/v4l2-ioctl.c           |  3 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 51 +++++++++-----
 include/media/v4l2-ctrls.h                     |  2 +
 include/media/videobuf2-dma-contig.h           | 11 ++-
 include/uapi/linux/v4l2-controls.h             | 98 ++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                 |  5 ++
 7 files changed, 166 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 890520d..22821e94 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -761,7 +761,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
-
+	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:			return "VP8 Frame Header";
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
@@ -1126,6 +1126,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
+		*type = V4L2_CTRL_TYPE_VP8_FRAME_HDR;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1525,6 +1528,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	/* FIXME:just return 0 for now */
+	case V4L2_CTRL_TYPE_PRIVATE:
+		return 0;
+
+	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2074,6 +2084,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
+		elem_size = sizeof(struct v4l2_ctrl_vp8_frame_hdr);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
@@ -2098,7 +2111,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
-	if (is_array &&
+	if ((is_array || (flags & V4L2_CTRL_FLAG_REQ_KEEP)) &&
 	    (type == V4L2_CTRL_TYPE_BUTTON ||
 	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
 		handler_set_err(hdl, -EINVAL);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7d028d1..8aa5812 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1259,6 +1259,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
+		case V4L2_PIX_FMT_VP8_FRAME:
+			descr = "VP8 FRAME";
+			break;
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index c331272..aebcc7f 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -23,13 +23,16 @@
 
 struct vb2_dc_conf {
 	struct device		*dev;
+	struct dma_attrs	attrs;
 };
 
 struct vb2_dc_buf {
 	struct device			*dev;
 	void				*vaddr;
 	unsigned long			size;
+	void				*cookie;
 	dma_addr_t			dma_addr;
+	struct dma_attrs		attrs;
 	enum dma_data_direction		dma_dir;
 	struct sg_table			*dma_sgt;
 	struct frame_vector		*vec;
@@ -131,7 +134,8 @@ static void vb2_dc_put(void *buf_priv)
 		sg_free_table(buf->sgt_base);
 		kfree(buf->sgt_base);
 	}
-	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
+			&buf->attrs);
 	put_device(buf->dev);
 	kfree(buf);
 }
@@ -143,18 +147,22 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
 	struct device *dev = conf->dev;
 	struct vb2_dc_buf *buf;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
-						GFP_KERNEL | gfp_flags);
-	if (!buf->vaddr) {
+	buf->attrs = conf->attrs;
+	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
+					GFP_KERNEL | gfp_flags, &buf->attrs);
+	if (!buf->cookie) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
+		buf->vaddr = buf->cookie;
+
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
@@ -185,8 +193,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 	 */
 	vma->vm_pgoff = 0;
 
-	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
-		buf->dma_addr, buf->size);
+	ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
+		buf->dma_addr, buf->size, &buf->attrs);
 
 	if (ret) {
 		pr_err("Remapping memory failed, error: %d\n", ret);
@@ -329,7 +337,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 {
 	struct vb2_dc_buf *buf = dbuf->priv;
 
-	return buf->vaddr + pgnum * PAGE_SIZE;
+	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
 }
 
 static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
@@ -368,8 +376,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
 		return NULL;
 	}
 
-	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
-		buf->size);
+	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
+		buf->size, &buf->attrs);
 	if (ret < 0) {
 		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
 		kfree(sgt);
@@ -448,22 +456,26 @@ static void vb2_dc_put_userptr(void *buf_priv)
  */
 
 #ifdef __arch_pfn_to_dma
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
+					   unsigned long pfn)
 {
 	return (dma_addr_t)__arch_pfn_to_dma(dev, pfn);
 }
 #elif defined(__pfn_to_bus)
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
+					   unsigned long pfn)
 {
 	return (dma_addr_t)__pfn_to_bus(pfn);
 }
 #elif defined(__pfn_to_phys)
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
+					   unsigned long pfn)
 {
 	return (dma_addr_t)__pfn_to_phys(pfn);
 }
 #else
-static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
+					   unsigned long pfn)
 {
 	/* really, we cannot do anything better at this point */
 	return (dma_addr_t)(pfn) << PAGE_SHIFT;
@@ -497,7 +509,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		return ERR_PTR(-EINVAL);
 	}
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -721,19 +733,22 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-void *vb2_dma_contig_init_ctx(struct device *dev)
+void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
+				    struct dma_attrs *attrs)
 {
 	struct vb2_dc_conf *conf;
 
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		return ERR_PTR(-ENOMEM);
 
 	conf->dev = dev;
+	if (attrs)
+		conf->attrs = *attrs;
 
 	return conf;
 }
-EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
+EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5f9526f..0424cdc 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -46,6 +46,7 @@ struct poll_table_struct;
  * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_u32:	Pointer to a 32-bit unsigned value.
  * @p_char:	Pointer to a string.
+ * @p_vp8_frame_hdr:	Pointer to a struct v4l2_ctrl_vp8_frame_hdr.
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -55,6 +56,7 @@ union v4l2_ctrl_ptr {
 	u16 *p_u16;
 	u32 *p_u32;
 	char *p_char;
+	struct v4l2_ctrl_vp8_frame_hdr *p_vp8_frame_hdr;
 	void *p;
 };
 
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index c33dfa6..2087c9a 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -16,6 +16,8 @@
 #include <media/videobuf2-v4l2.h>
 #include <linux/dma-mapping.h>
 
+struct dma_attrs;
+
 static inline dma_addr_t
 vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
@@ -24,7 +26,14 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 	return *addr;
 }
 
-void *vb2_dma_contig_init_ctx(struct device *dev);
+void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
+				    struct dma_attrs *attrs);
+
+static inline void *vb2_dma_contig_init_ctx(struct device *dev)
+{
+	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
+}
+
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..63c65d9 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -520,6 +520,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
 };
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
+
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
@@ -578,6 +579,8 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
 
+#define V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR		(V4L2_CID_MPEG_BASE+512)
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -963,4 +966,99 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+
+/* Complex controls */
+
+#define V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED              0x01
+#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP           0x02
+#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_FEATURE_DATA  0x04
+struct v4l2_vp8_sgmnt_hdr {
+	__u8 segment_feature_mode;
+
+	__s8 quant_update[4];
+	__s8 lf_update[4];
+	__u8 segment_probs[3];
+
+	__u8 flags;
+};
+
+#define V4L2_VP8_LF_HDR_ADJ_ENABLE	0x01
+#define V4L2_VP8_LF_HDR_DELTA_UPDATE	0x02
+struct v4l2_vp8_loopfilter_hdr {
+	__u8 type;
+	__u8 level;
+	__u8 sharpness_level;
+	__s8 ref_frm_delta_magnitude[4];
+	__s8 mb_mode_delta_magnitude[4];
+
+	__u8 flags;
+};
+
+struct v4l2_vp8_quantization_hdr {
+	__u8 y_ac_qi;
+	__s8 y_dc_delta;
+	__s8 y2_dc_delta;
+	__s8 y2_ac_delta;
+	__s8 uv_dc_delta;
+	__s8 uv_ac_delta;
+	__u16 dequant_factors[4][3][2];
+};
+
+struct v4l2_vp8_entropy_hdr {
+	__u8 coeff_probs[4][8][3][11];
+	__u8 y_mode_probs[4];
+	__u8 uv_mode_probs[3];
+	__u8 mv_probs[2][19];
+};
+
+#define V4L2_VP8_FRAME_HDR_FLAG_EXPERIMENTAL		0x01
+#define V4L2_VP8_FRAME_HDR_FLAG_SHOW_FRAME		0x02
+#define V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF	0x04
+struct v4l2_ctrl_vp8_frame_hdr {
+	/* 0: keyframe, 1: not a keyframe */
+	__u8 key_frame;
+	__u8 version;
+
+	/* Populated also if not a key frame */
+	__u16 width;
+	__u8 horizontal_scale;
+	__u16 height;
+	__u8 vertical_scale;
+
+	struct v4l2_vp8_sgmnt_hdr sgmnt_hdr;
+	struct v4l2_vp8_loopfilter_hdr lf_hdr;
+	struct v4l2_vp8_quantization_hdr quant_hdr;
+	struct v4l2_vp8_entropy_hdr entropy_hdr;
+
+	__u8 sign_bias_golden;
+	__u8 sign_bias_alternate;
+
+	__u8 prob_skip_false;
+	__u8 prob_intra;
+	__u8 prob_last;
+	__u8 prob_gf;
+
+	__u32 first_part_size;
+	__u32 first_part_offset;
+	/*
+	 * Offset in bits of MB data in first partition,
+	 * i.e. bit offset starting from first_part_offset.
+	 */
+	__u32 macroblock_bit_offset;
+
+	__u8 num_dct_parts;
+	__u32 dct_part_sizes[8];
+
+	__u8 bool_dec_range;
+	__u8 bool_dec_value;
+	__u8 bool_dec_count;
+
+	/* v4l2_buffer indices of reference frames */
+	__u32 last_frame;
+	__u32 golden_frame;
+	__u32 alt_frame;
+
+	__u8 flags;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 29a6b78..191ca19 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -593,6 +593,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
+#define V4L2_PIX_FMT_VP8_FRAME	v4l2_fourcc('V', 'P', '8', 'F') /* VP8 parsed frames */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1473,6 +1474,7 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_vp8_frame_hdr __user *p_vp8_frame_hdr;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1517,6 +1519,9 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_VP8_FRAME_HDR	= 0x108,
+
+	V4L2_CTRL_TYPE_PRIVATE       = 0xffff,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.9.1

