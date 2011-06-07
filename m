Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40467 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1FGOsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:48:00 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57ElxtS029912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:59 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep34.itg.ti.com (8.13.7/8.13.8) with ESMTP id p57ElxCr024079
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:59 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>, Amber Jain <amber@ti.com>
Subject: [PATCH 5/6] V4L2: OMAP: VOUT: Changes for NV12 format support for OMAP4
Date: Tue, 7 Jun 2011 20:17:37 +0530
Message-ID: <1307458058-29030-6-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

V4l2 side changes to add NV12 format supportted by OMAP4.

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap/omap_vout.c    |  113 ++++++++++++++++++++++++++-----
 drivers/media/video/omap/omap_voutdef.h |    3 +
 2 files changed, 99 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index f0946ea..25025a1 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -138,6 +138,10 @@ const static struct v4l2_fmtdesc omap_formats[] = {
 		.description = "UYVY, packed",
 		.pixelformat = V4L2_PIX_FMT_UYVY,
 	},
+	{
+		.description = "NV12 - YUV420 format",
+		.pixelformat = V4L2_PIX_FMT_NV12,
+	},
 };
 
 #define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
@@ -185,12 +189,23 @@ static int omap_vout_try_format(struct v4l2_pix_format_mplane *pix_mp)
 		pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
 		bpp = RGB32_BPP;
 		break;
+	case V4L2_PIX_FMT_NV12:
+		pix_mp->colorspace = V4L2_COLORSPACE_JPEG;
+		bpp = 1;
+		break;
 	}
 
 	for (i = 0; i < pix_mp->num_planes; ++i) {
 		int bpl = pix_mp->width * bpp;
-		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].bytesperline = (bpl + PAGE_SIZE - 1) &
+					~(PAGE_SIZE - 1);
+		bpl = pix_mp->plane_fmt[i].bytesperline;
+
 		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		/* :NOTE: NV12 has width bytes per line in both Y and UV sections */
+		if (V4L2_PIX_FMT_NV12 == pix_mp->pixelformat)
+			pix_mp->plane_fmt[i].sizeimage += pix_mp->plane_fmt[i].sizeimage >> 1;
 	}
 
 	return bpp;
@@ -292,6 +307,7 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 	struct v4l2_pix_format_mplane *pix_mp = &vout->pix_mp;
 	int *cropped_offset = &vout->cropped_offset;
 	int ps = 2, line_length = 0;
+	u32 *cropped_uv_offset = &vout->cropped_uv_offset;
 
 	ovid = &vout->vid_info;
 
@@ -307,11 +323,17 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 			ps = 4;
 		else if (V4L2_PIX_FMT_RGB24 == pix_mp->pixelformat)
 			ps = 3;
+		else if (V4L2_PIX_FMT_NV12 == pix_mp->pixelformat)
+			ps = 1;
 
 		vout->ps = ps;
 
 		*cropped_offset = (line_length * ps) *
 			crop->top + crop->left * ps;
+
+		if (V4L2_PIX_FMT_NV12 == pix_mp->pixelformat)
+			*cropped_uv_offset = (line_length * ps) *
+				(crop->top >> 1) + (crop->left & ~1) * ps;
 	}
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "%s Offset:%x\n",
@@ -355,6 +377,9 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 	case V4L2_PIX_FMT_BGR32:
 		mode = OMAP_DSS_COLOR_RGBX32;
 		break;
+	case V4L2_PIX_FMT_NV12:
+		mode = OMAP_DSS_COLOR_NV12;
+		break;
 	default:
 		mode = -EINVAL;
 	}
@@ -366,7 +391,7 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
  */
 int omapvid_setup_overlay(struct omap_vout_device *vout,
 		struct omap_overlay *ovl, int posx, int posy, int outw,
-		int outh, u32 addr)
+		int outh, u32 addr, u32 uv_addr)
 {
 	int ret = 0;
 	struct omap_overlay_info info;
@@ -400,7 +425,15 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 	}
 
 	ovl->get_overlay_info(ovl, &info);
-	info.paddr = addr;
+
+	if (addr)
+		info.paddr = addr;
+
+	if (OMAP_DSS_COLOR_NV12 == vout->dss_mode)
+		info.p_uv_addr = uv_addr;
+	else
+		info.p_uv_addr = (u32) NULL;
+
 	info.vaddr = NULL;
 	info.width = cropwidth;
 	info.height = cropheight;
@@ -430,6 +463,9 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 		info.pos_y, info.out_width, info.out_height, info.rotation_type,
 		info.screen_width);
 
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "info.puvaddr=%x\n",
+		info.p_uv_addr);
+
 	ret = ovl->set_overlay_info(ovl, &info);
 	if (ret)
 		goto setup_ovl_err;
@@ -444,7 +480,7 @@ setup_ovl_err:
 /*
  * Initialize the overlay structure
  */
-int omapvid_init(struct omap_vout_device *vout, u32 addr)
+int omapvid_init(struct omap_vout_device *vout, u32 addr, u32 uv_addr)
 {
 	int ret = 0, i;
 	struct v4l2_window *win;
@@ -495,7 +531,7 @@ int omapvid_init(struct omap_vout_device *vout, u32 addr)
 		}
 
 		ret = omapvid_setup_overlay(vout, ovl, posx, posy,
-				outw, outh, addr);
+				outw, outh, addr, uv_addr);
 		if (ret)
 			goto omapvid_init_err;
 	}
@@ -529,6 +565,7 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
 {
 	int ret;
 	u32 addr, fid;
+	u32 uv_addr;
 	struct omap_overlay *ovl;
 	struct timeval timevalue;
 	struct omapvideo_info *ovid;
@@ -581,8 +618,11 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
 		addr = (unsigned long) vout->queued_buf_addr[vout->next_frm->i]
 			+ vout->cropped_offset;
 
+		uv_addr = (unsigned long)vout->queued_buf_uv_addr[vout->next_frm->i]
+			+ vout->cropped_uv_offset;
+
 		/* First save the configuration in ovelray structure */
-		ret = omapvid_init(vout, addr);
+		ret = omapvid_init(vout, addr, uv_addr);
 		if (ret)
 			printk(KERN_ERR VOUT_NAME
 				"failed to set overlay info\n");
@@ -631,8 +671,12 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
 			addr = (unsigned long)
 				vout->queued_buf_addr[vout->next_frm->i] +
 				vout->cropped_offset;
+
+			uv_addr = (unsigned long)vout->queued_buf_uv_addr[vout->next_frm->i]
+				+ vout->cropped_uv_offset;
+
 			/* First save the configuration in ovelray structure */
-			ret = omapvid_init(vout, addr);
+			ret = omapvid_init(vout, addr, uv_addr);
 			if (ret)
 				printk(KERN_ERR VOUT_NAME
 						"failed to set overlay info\n");
@@ -686,7 +730,11 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		return 0;
 
 	/* Now allocated the V4L2 buffers */
-	*size = PAGE_ALIGN(vout->pix_mp.width * vout->pix_mp.height * vout->bpp);
+	if (V4L2_PIX_FMT_NV12 == vout->pix_mp.pixelformat)
+		*size = PAGE_ALIGN(vout->pix_mp.width * vout->pix_mp.height * vout->bpp * 3/2);
+	else
+		*size = PAGE_ALIGN(vout->pix_mp.width * vout->pix_mp.height * vout->bpp);
+
 	startindex = (vout->vid == OMAP_VIDEO1) ?
 		video1_numbuffers : video2_numbuffers;
 
@@ -771,19 +819,34 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		/* Physical address */
 		vout->queued_buf_addr[vb->i] = (u8 *)
 			omap_vout_uservirt_to_phys(vb->baddr);
+		vout->queued_buf_uv_addr[vb->i] = (u8 *)
+			omap_vout_uservirt_to_phys(vb->baddr + vb->size);
 	} else {
-		int addr, dma_addr;
-		unsigned long size;
+		int addr, uv_addr, dma_addr, dma_uv_addr;
+		unsigned long size, size_uv;
 
 		addr = (unsigned long) vout->buf_virt_addr[vb->i];
 		size = (unsigned long) vb->size;
 
+		uv_addr = (unsigned long) (vout->buf_virt_addr[vb->i]
+			+ vb->size);
+
 		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
 				(unsigned) size, DMA_TO_DEVICE);
 		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
 			printk(KERN_ERR "dma_map_single failed\n");
 
-		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
+		if (vout->dss_mode == OMAP_DSS_COLOR_NV12) {
+			size_uv = (unsigned long) (vb->size)/2;
+			dma_uv_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) uv_addr,
+							(unsigned) size_uv, DMA_TO_DEVICE);
+			if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_uv_addr))
+				printk(KERN_ERR "dma_map_single failed\n");
+		}
+
+		vout->queued_buf_addr[vb->i] = (u8 *) vout->buf_phy_addr[vb->i];
+		vout->queued_buf_uv_addr[vb->i] = (u8 *) (vout->buf_phy_addr[vb->i]
+						+ vb->size);
 	}
 
 	if (ovid->rotation_type == VOUT_ROT_VRFB)
@@ -1121,9 +1184,13 @@ static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 
 	bpp = omap_vout_try_format(&f->fmt.pix_mp);
 
-	for (i = 0; i < f->fmt.pix_mp.num_planes; ++i)
+	for (i = 0; i < f->fmt.pix_mp.num_planes; ++i) {
 		f->fmt.pix_mp.plane_fmt[i].sizeimage = f->fmt.pix_mp.width *
 						f->fmt.pix_mp.height * bpp;
+		if (V4L2_PIX_FMT_NV12 == f->fmt.pix_mp.pixelformat)
+			f->fmt.pix_mp.plane_fmt[i].sizeimage +=
+				f->fmt.pix_mp.plane_fmt[i].sizeimage >> 1;
+	}
 	/* try & set the new output format */
 	vout->bpp = bpp;
 	vout->pix_mp = f->fmt.pix_mp;
@@ -1138,7 +1205,7 @@ static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 	omap_vout_new_format(&vout->pix_mp, &vout->fbuf, &vout->crop, &vout->win);
 
 	/* Save the changes in the overlay strcuture */
-	ret = omapvid_init(vout, 0);
+	ret = omapvid_init(vout, 0, 0);
 	if (ret) {
 		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
 		goto s_fmt_vid_out_exit;
@@ -1567,8 +1634,8 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 
-	unsigned long size;
-	u32 addr;
+	unsigned long size, size_uv;
+	u32 addr, uv_addr;
 	struct videobuf_buffer *vb;
 	int ret;
 
@@ -1588,6 +1655,13 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	size = (unsigned long) vb->size;
 	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
 				(unsigned) size, DMA_TO_DEVICE);
+	if (vout->dss_mode == OMAP_DSS_COLOR_NV12) {
+		uv_addr = (unsigned long) (vout->buf_phy_addr[vb->i]
+			+ vb->size);
+		size_uv = (unsigned long) (vb->size)/2;
+		dma_unmap_single(vout->vid_dev->v4l2_dev.dev, uv_addr,
+					(unsigned) size_uv, DMA_TO_DEVICE);
+	}
 	return ret;
 }
 
@@ -1595,6 +1669,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 {
 	int ret = 0, j;
 	u32 addr = 0, mask = 0;
+	u32 uv_addr = 0;
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 	struct omapvideo_info *ovid = &vout->vid_info;
@@ -1637,6 +1712,9 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
 		+ vout->cropped_offset;
 
+	uv_addr = (unsigned long) vout->queued_buf_uv_addr[vout->cur_frm->i]
+		+ vout->cropped_uv_offset;
+
 	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
 		| DISPC_IRQ_VSYNC2;
 
@@ -1650,6 +1728,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 			ovl->get_overlay_info(ovl, &info);
 			info.enabled = 1;
 			info.paddr = addr;
+			info.p_uv_addr = uv_addr;
 			if (ovl->set_overlay_info(ovl, &info)) {
 				ret = -EINVAL;
 				goto streamon_err1;
@@ -1658,7 +1737,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	}
 
 	/* First save the configuration in ovelray structure */
-	ret = omapvid_init(vout, addr);
+	ret = omapvid_init(vout, addr, uv_addr);
 	if (ret)
 		v4l2_err(&vout->vid_dev->v4l2_dev,
 				"failed to set overlay info\n");
@@ -2045,7 +2124,7 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		video_set_drvdata(vfd, vout);
 
 		/* Configure the overlay structure */
-		ret = omapvid_init(vid_dev->vouts[k], 0);
+		ret = omapvid_init(vid_dev->vouts[k], 0, 0);
 		if (!ret)
 			goto success;
 
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 6f94ea1..a2ae56a 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -128,6 +128,8 @@ struct omap_vout_device {
 	/* keep buffer info across opens */
 	unsigned long buf_virt_addr[VIDEO_MAX_FRAME];
 	unsigned long buf_phy_addr[VIDEO_MAX_FRAME];
+	u8 *queued_buf_uv_addr[VIDEO_MAX_FRAME];
+
 	enum omap_color_mode dss_mode;
 
 	/* we don't allow to request new buffer when old buffers are
@@ -174,6 +176,7 @@ struct omap_vout_device {
 	struct list_head dma_queue;
 	u8 *queued_buf_addr[VIDEO_MAX_FRAME];
 	u32 cropped_offset;
+	u32 cropped_uv_offset;
 	s32 tv_field1_offset;
 	void *isr_handle;
 
-- 
1.7.1

