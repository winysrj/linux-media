Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:58488 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1GGMV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2011 08:21:59 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p67CLxBf025555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:59 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep34.itg.ti.com (8.13.7/8.13.8) with ESMTP id p67CLw7r001224
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:58 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p67CLwHF008058
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:58 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, Amber Jain <amber@ti.com>
Subject: [PATCH] V4L2: OMAP: VOUT: Changes to support NV12-color format on OMAP4 
Date: Thu, 7 Jul 2011 17:51:55 +0530
Message-ID: <1310041315-8849-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

V4L2 side changes to add NV12-color format support to OMAP4.

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap/omap_vout.c    |  107 ++++++++++++++++++++++++++----
 drivers/media/video/omap/omap_voutdef.h |    3 +
 2 files changed, 95 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 548f4cd..e80b842 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -140,6 +140,10 @@ const static struct v4l2_fmtdesc omap_formats[] = {
 		.description = "UYVY, packed",
 		.pixelformat = V4L2_PIX_FMT_UYVY,
 	},
+	{
+		.description = "NV12 - YUV420 format",
+		.pixelformat = V4L2_PIX_FMT_NV12,
+	},
 };
 
 #define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
@@ -188,10 +192,20 @@ static int omap_vout_try_format(struct v4l2_pix_format *pix)
 		pix->colorspace = V4L2_COLORSPACE_SRGB;
 		bpp = RGB32_BPP;
 		break;
+	case V4L2_PIX_FMT_NV12:
+		pix->colorspace = V4L2_COLORSPACE_JPEG;
+		bpp = 1;
+		break;
 	}
 	pix->bytesperline = pix->width * bpp;
+	pix->bytesperline = (pix->bytesperline + PAGE_SIZE - 1) &
+				~(PAGE_SIZE - 1);
+
 	pix->sizeimage = pix->bytesperline * pix->height;
 
+	/* :NOTE: NV12 has width bytes per line in both Y and UV sections */
+		if (V4L2_PIX_FMT_NV12 == pix->pixelformat)
+			pix->sizeimage += pix->sizeimage >> 1;
 	return bpp;
 }
 
@@ -291,6 +305,7 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 	struct v4l2_pix_format *pix = &vout->pix;
 	int *cropped_offset = &vout->cropped_offset;
 	int ps = 2, line_length = 0;
+	u32 *cropped_uv_offset = &vout->cropped_uv_offset;
 
 	ovid = &vout->vid_info;
 
@@ -306,11 +321,17 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 			ps = 4;
 		else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat)
 			ps = 3;
+		else if (V4L2_PIX_FMT_NV12 == pix->pixelformat)
+			ps = 1;
 
 		vout->ps = ps;
 
 		*cropped_offset = (line_length * ps) *
 			crop->top + crop->left * ps;
+
+		if (V4L2_PIX_FMT_NV12 == pix->pixelformat)
+			*cropped_uv_offset = (line_length * ps) *
+				(crop->top >> 1) + (crop->left & ~1) * ps;
 	}
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "%s Offset:%x\n",
@@ -354,6 +375,9 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 	case V4L2_PIX_FMT_BGR32:
 		mode = OMAP_DSS_COLOR_RGBX32;
 		break;
+	case V4L2_PIX_FMT_NV12:
+		mode = OMAP_DSS_COLOR_NV12;
+		break;
 	default:
 		mode = -EINVAL;
 	}
@@ -365,7 +389,7 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
  */
 static int omapvid_setup_overlay(struct omap_vout_device *vout,
 		struct omap_overlay *ovl, int posx, int posy, int outw,
-		int outh, u32 addr)
+		int outh, u32 addr, u32 uv_addr)
 {
 	int ret = 0;
 	struct omap_overlay_info info;
@@ -399,7 +423,15 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
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
@@ -429,6 +461,9 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 		info.pos_y, info.out_width, info.out_height, info.rotation_type,
 		info.screen_width);
 
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "info.puvaddr=%x\n",
+		info.p_uv_addr);
+
 	ret = ovl->set_overlay_info(ovl, &info);
 	if (ret)
 		goto setup_ovl_err;
@@ -443,7 +478,7 @@ setup_ovl_err:
 /*
  * Initialize the overlay structure
  */
-static int omapvid_init(struct omap_vout_device *vout, u32 addr)
+static int omapvid_init(struct omap_vout_device *vout, u32 addr, u32 uv_addr)
 {
 	int ret = 0, i;
 	struct v4l2_window *win;
@@ -494,7 +529,7 @@ static int omapvid_init(struct omap_vout_device *vout, u32 addr)
 		}
 
 		ret = omapvid_setup_overlay(vout, ovl, posx, posy,
-				outw, outh, addr);
+				outw, outh, addr, uv_addr);
 		if (ret)
 			goto omapvid_init_err;
 	}
@@ -528,6 +563,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 {
 	int ret;
 	u32 addr, fid;
+	u32 uv_addr;
 	struct omap_overlay *ovl;
 	struct timeval timevalue;
 	struct omapvideo_info *ovid;
@@ -580,8 +616,11 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
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
@@ -630,8 +669,12 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
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
@@ -685,7 +728,11 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		return 0;
 
 	/* Now allocated the V4L2 buffers */
-	*size = PAGE_ALIGN(vout->pix.width * vout->pix.height * vout->bpp);
+	if (V4L2_PIX_FMT_NV12 == vout->pix.pixelformat)
+		*size = PAGE_ALIGN(vout->pix.width * vout->pix.height * vout->bpp * 3/2);
+	else
+		*size = PAGE_ALIGN(vout->pix.width * vout->pix.height * vout->bpp);
+
 	startindex = (vout->vid == OMAP_VIDEO1) ?
 		video1_numbuffers : video2_numbuffers;
 
@@ -778,19 +825,34 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		/* Physical address */
 		vout->queued_buf_addr[vb->i] = (u8 *)
 			omap_vout_uservirt_to_phys(vb->baddr);
+		vout->queued_buf_uv_addr[vb->i] = (u8 *)
+			omap_vout_uservirt_to_phys(vb->baddr + vb->size);
 	} else {
-		u32 addr, dma_addr;
-		unsigned long size;
+		u32 addr, uv_addr, dma_addr, dma_uv_addr;
+		unsigned long size, size_uv;
 
 		addr = (unsigned long) vout->buf_virt_addr[vb->i];
 		size = (unsigned long) vb->size;
 
+		uv_addr = (unsigned long) (vout->buf_virt_addr[vb->i]
+			+ vb->size);
+
 		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
 				size, DMA_TO_DEVICE);
 		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
 			v4l2_err(&vout->vid_dev->v4l2_dev, "dma_map_single failed\n");
 
-		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
+		if (vout->dss_mode == OMAP_DSS_COLOR_NV12) {
+			size_uv = (unsigned long) (vb->size)/2;
+			dma_uv_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) uv_addr,
+							(unsigned) size_uv, DMA_TO_DEVICE);
+			if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_uv_addr))
+				v4l2_err(&vout->vid_dev->v4l2_dev, "dma_map_single failed\n");
+		}
+
+		vout->queued_buf_addr[vb->i] = (u8 *) vout->buf_phy_addr[vb->i];
+		vout->queued_buf_uv_addr[vb->i] = (u8 *) (vout->buf_phy_addr[vb->i]
+						+ vb->size);
 	}
 
 	if (ovid->rotation_type == VOUT_ROT_VRFB)
@@ -1132,6 +1194,9 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 
 	bpp = omap_vout_try_format(&f->fmt.pix);
 	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height * bpp;
+		if (V4L2_PIX_FMT_NV12 == f->fmt.pix.pixelformat)
+			f->fmt.pix.sizeimage +=
+				f->fmt.pix.sizeimage >> 1;
 
 	/* try & set the new output format */
 	vout->bpp = bpp;
@@ -1147,7 +1212,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 	omap_vout_new_format(&vout->pix, &vout->fbuf, &vout->crop, &vout->win);
 
 	/* Save the changes in the overlay strcuture */
-	ret = omapvid_init(vout, 0);
+	ret = omapvid_init(vout, 0, 0);
 	if (ret) {
 		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
 		goto s_fmt_vid_out_exit;
@@ -1574,8 +1639,8 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	struct videobuf_queue *q = &vout->vbq;
 
 	int ret;
-	u32 addr;
-	unsigned long size;
+	u32 addr, uv_addr;
+	unsigned long size, size_uv;
 	struct videobuf_buffer *vb;
 
 	vb = q->bufs[b->index];
@@ -1594,6 +1659,13 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	size = (unsigned long) vb->size;
 	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
 				size, DMA_TO_DEVICE);
+	if (vout->dss_mode == OMAP_DSS_COLOR_NV12) {
+		uv_addr = (unsigned long) (vout->buf_phy_addr[vb->i]
+			+ vb->size);
+		size_uv = (unsigned long) (vb->size)/2;
+		dma_unmap_single(vout->vid_dev->v4l2_dev.dev, uv_addr,
+					(unsigned) size_uv, DMA_TO_DEVICE);
+	}
 	return ret;
 }
 
@@ -1601,6 +1673,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 {
 	int ret = 0, j;
 	u32 addr = 0, mask = 0;
+	u32 uv_addr = 0;
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 	struct omapvideo_info *ovid = &vout->vid_info;
@@ -1643,6 +1716,9 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
 		+ vout->cropped_offset;
 
+	uv_addr = (unsigned long) vout->queued_buf_uv_addr[vout->cur_frm->i]
+		+ vout->cropped_uv_offset;
+
 	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
 		| DISPC_IRQ_VSYNC2;
 
@@ -1656,6 +1732,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 			ovl->get_overlay_info(ovl, &info);
 			info.enabled = 1;
 			info.paddr = addr;
+			info.p_uv_addr = uv_addr;
 			if (ovl->set_overlay_info(ovl, &info)) {
 				ret = -EINVAL;
 				goto streamon_err1;
@@ -1664,7 +1741,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	}
 
 	/* First save the configuration in ovelray structure */
-	ret = omapvid_init(vout, addr);
+	ret = omapvid_init(vout, addr, uv_addr);
 	if (ret)
 		v4l2_err(&vout->vid_dev->v4l2_dev,
 				"failed to set overlay info\n");
@@ -2050,7 +2127,7 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		video_set_drvdata(vfd, vout);
 
 		/* Configure the overlay structure */
-		ret = omapvid_init(vid_dev->vouts[k], 0);
+		ret = omapvid_init(vid_dev->vouts[k], 0, 0);
 		if (!ret)
 			goto success;
 
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index d793501..666c4b5 100644
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
@@ -173,6 +175,7 @@ struct omap_vout_device {
 	struct list_head dma_queue;
 	u8 *queued_buf_addr[VIDEO_MAX_FRAME];
 	u32 cropped_offset;
+	u32 cropped_uv_offset;
 	s32 tv_field1_offset;
 	void *isr_handle;
 
-- 
1.7.1

