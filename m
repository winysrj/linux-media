Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0ESDFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:05:48 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:04:25 +0800
Subject: [PATCH v3 01/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D83@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From ad34a173194d8ec49a18f335e9f2d5f5d883f2eb Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:34:14 +0800
Subject: [PATCH 01/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which control the ISP data path setting.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/mrstisp_dp.h |  257 +++++
 drivers/media/video/mrstisp/mrstisp_dp.c         | 1222 ++++++++++++++++++++++
 2 files changed, 1479 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_dp.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_dp.c

diff --git a/drivers/media/video/mrstisp/include/mrstisp_dp.h b/drivers/media/video/mrstisp/include/mrstisp_dp.h
new file mode 100644
index 0000000..9978b05
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_dp.h
@@ -0,0 +1,257 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+
+#ifndef _MRV_SLS_H
+#define _MRV_SLS_H
+
+/* data path descriptor */
+struct ci_isp_datapath_desc {
+       u16 out_w;
+       u16 out_h;
+       u32 flags;
+};
+
+#define CI_ISP_DPD_DISABLE         0x00000000
+#define CI_ISP_DPD_ENABLE          0x00000001
+#define CI_ISP_DPD_NORESIZE        0x00000002
+
+/*
+ * The input picture from ISP is being cropped to match the
+ * aspect ratio of the desired output. If this flag is not
+ * set, different scaling factors for X and Y axis
+ * may be used.
+ */
+#define CI_ISP_DPD_KEEPRATIO       0x00000004
+#define CI_ISP_DPD_MIRROR          0x00000008
+#define CI_ISP_DPD_MODE_MASK          0x00000070
+#define CI_ISP_DPD_MODE_ISPRAW_16B     0x00000000
+#define CI_ISP_DPD_MODE_ISPYC          0x00000010
+#define CI_ISP_DPD_MODE_ISPRAW         0x00000020
+#define CI_ISP_DPD_MODE_ISPJPEG        0x00000030
+/*
+ * YCbCr data from system memory directly routed to the main/self
+ * path (DMA-read, only applicable for self path)
+ */
+#define CI_ISP_DPD_MODE_DMAYC_DIRECT   0x00000040
+
+/*
+ * YCbCr data from system memory routed through the main processing
+ * chain substituting ISP data (DMA-read)
+ */
+#define CI_ISP_DPD_MODE_DMAYC_ISP      0x00000050
+
+/*
+ * YCbCr data from system memory directly routed to the jpeg encoder
+ * (DMA-read, R2B-bufferless encoding, only applicable for main path)
+ */
+#define CI_ISP_DPD_MODE_DMAJPEG_DIRECT 0x00000060
+
+/*
+ * Jpeg encoding with YCbCr data from system memory routed through the
+ * main processing chain substituting ISP data (DMA-read, only applicable
+ * for main path) top blackline support
+ */
+#define CI_ISP_DPD_MODE_DMAJPEG_ISP    0x00000070
+
+#define CI_ISP_DPD_BLACKLINES_TOP  0x00000080
+#define CI_ISP_DPD_CSS_H_MASK      0x00000700
+#define CI_ISP_DPD_CSS_H_OFF       0x00000000
+#define CI_ISP_DPD_CSS_H2          0x00000100
+#define CI_ISP_DPD_CSS_H4          0x00000200
+#define CI_ISP_DPD_CSS_HUP2        0x00000500
+#define CI_ISP_DPD_CSS_HUP4        0x00000600
+#define CI_ISP_DPD_CSS_V_MASK      0x00003800
+#define CI_ISP_DPD_CSS_V_OFF       0x00000000
+#define CI_ISP_DPD_CSS_V2          0x00000800
+#define CI_ISP_DPD_CSS_V4          0x00001000
+#define CI_ISP_DPD_CSS_VUP2        0x00002800
+#define CI_ISP_DPD_CSS_VUP4        0x00003000
+#define CI_ISP_DPD_CSS_HSHIFT      0x00004000
+#define CI_ISP_DPD_CSS_VSHIFT      0x00008000
+
+/*
+ * Hardware RGB conversion (currently, only supported for self path)
+ * output mode mask (3 bits, not all combination used yet)
+ */
+#define CI_ISP_DPD_HWRGB_MASK     0x00070000
+#define CI_ISP_DPD_HWRGB_OFF       0x00000000
+#define CI_ISP_DPD_HWRGB_565       0x00010000
+#define CI_ISP_DPD_HWRGB_666       0x00020000
+#define CI_ISP_DPD_HWRGB_888       0x00030000
+
+#define CI_ISP_DPD_YUV_420     0x00040000
+#define CI_ISP_DPD_YUV_422     0x00050000
+#define CI_ISP_DPD_YUV_NV12    0x00060000
+#define CI_ISP_DPD_YUV_YUYV    0x00070000
+
+#define CI_ISP_DPD_DMA_IN_MASK    0x00180000
+#define CI_ISP_DPD_DMA_IN_422      0x00000000
+#define CI_ISP_DPD_DMA_IN_444      0x00080000
+#define CI_ISP_DPD_DMA_IN_420      0x00100000
+#define CI_ISP_DPD_DMA_IN_411      0x00180000
+
+/*
+ * Upscaling interpolation mode (tells how newly created pixels
+ * will be interpolated from the existing ones)
+ * Upscaling interpolation mode mask (2 bits, not all combinations
+ * used yet)
+ */
+#define CI_ISP_DPD_UPSCALE_MASK       0x00600000
+#define CI_ISP_DPD_UPSCALE_SMOOTH_LIN  0x00000000
+
+/*
+ * sharp edges, no interpolation, just duplicate pixels, creates
+ * the typical 'blocky' effect.
+ */
+#define CI_ISP_DPD_UPSCALE_SHARP       0x00200000
+
+/*
+ * additional luminance phase shift
+ * apply horizontal luminance phase shift by half the sample distance
+ */
+#define CI_ISP_DPD_LUMA_HSHIFT     0x00800000
+/* apply vertical luminance phase shift by half the sample distance */
+#define CI_ISP_DPD_LUMA_VSHIFT     0x01000000
+
+/*
+ * picture flipping and rotation
+ * Note that when combining the flags, the rotation is applied first.
+ * This enables to configure all 8 possible orientations
+ */
+
+/* horizontal flipping - same as mirroring */
+#define CI_ISP_DPD_H_FLIP          CI_ISP_DPD_MIRROR
+/* vertical flipping */
+#define CI_ISP_DPD_V_FLIP          0x02000000
+/* rotation 90 degrees counter-clockwise */
+#define CI_ISP_DPD_90DEG_CCW       0x04000000
+
+/*
+ * switch to differentiate between full range of values for YCbCr (0-255)
+ * and restricted range (16-235 for Y) (16-240 for CbCr)'
+ * if set leads to unrestricted range (0-255) for YCbCr
+ * package length of a system interface transfer
+ */
+#define CI_ISP_DPD_YCBCREXT        0x10000000
+/* burst mask (2 bits) */
+#define CI_ISP_DPD_BURST_MASK      0x60000000
+/* AHB 4 beat burst */
+#define CI_ISP_DPD_BURST_4          0x00000000
+/* AHB 8 beat burst */
+#define CI_ISP_DPD_BURST_8          0x20000000
+/* AHB 16 beat burst */
+#define CI_ISP_DPD_BURST_16         0x40000000
+
+/* configures main and self datapathes and scaler for data coming from the
+ * ISP */
+
+
+int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
+                   const struct ci_sensor_config *isi_config,
+                   const struct ci_isp_datapath_desc *main,
+                   const struct ci_isp_datapath_desc *self, int zoom);
+
+
+/*
+ * Coordinate transformations: The pixel data coming from the sensor passes
+ * through the ISP output formatter where they may be cropped and through
+ * the main path scaler where they may be stretched and/or squeezed. Thus,
+ * the coordinate systems of input and output are different, but somewhat
+ * related. Further, we can do digital zoom, which adds a third coordinate
+ * system: the virtual input (e.g. a cropped sensor frame zoomed in to the
+ * full sensor frame size. Following routines are intended to transform
+ * pixel resp. window positions from one coordinate systen to another.
+ * Folloin coordinate systems exist: Cam  : original frame coming from the
+ * camera VCam : virtual camera; a system in which a cropped original
+ * camera frame is up-scaled to the camera frame size. If no digital zoom
+ * is to be done, Cam and VCam are identical.  Main : output of main path
+ * Self : output of self path
+ */
+/* coordinate transformation from (real) camera coordinate system to main
+ * path output */
+int ci_transform_cam2_main(
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+/* coordinate transformation from (real) camera coordinate system to self
+ * path output */
+int ci_transform_cam2_self(
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+/* coordinate transformation from virtual camera to real camera coordinate
+ * system */
+void ci_transform_vcam2_cam(
+       const struct ci_sensor_config *isi_sensor_config,
+       const struct ci_isp_window *wnd_in,
+       struct ci_isp_window *wnd_out
+);
+
+/*
+ * Still image snapshot support
+ * The routine re-configures the main path for taking the snapshot. On
+ * successful return, the snapshot has been stored in the given memory
+ * location. Note that the settings of MARVIN will not be restored.
+ */
+
+/*
+ * take the desired snapshot. The type of snapshot (YUV, RAW or JPEG) is
+ * determined by the datapath selection bits in ci_isp_datapath_desc::flags.
+ * Note that the MARVIN configuration may be changed but will not be
+ * restored after the snapshot.
+ */
+int ci_do_snapshot(
+       const struct ci_sensor_config *isi_sensor_config,
+       const struct ci_isp_datapath_desc *main,
+       int zoom,
+       u8 jpeg_compression,
+       struct ci_isp_mi_path_conf *isp_mi_path_conf
+);
+
+
+/* Initialization of the Bad Pixel Detection and Correction */
+int ci_bp_init(
+       const struct ci_isp_bp_corr_config *bp_corr_config,
+       const struct ci_isp_bp_det_config *bp_det_config
+);
+/* Bad Pixel Correction */
+int ci_bp_correction(void);
+/* Disable Bad Pixel Correction and dectection */
+int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config);
+
+/* Capture a whole JPEG snapshot */
+u32 ci_jpe_capture(struct mrst_isp_device *intel,
+                  enum ci_isp_conf_update_time update_time);
+int ci_jpe_encode(struct mrst_isp_device *intel,
+                 enum ci_isp_conf_update_time update_time,
+                 enum ci_isp_jpe_enc_mode mrv_jpe_encMode);
+/* Encode motion JPEG */
+int ci_isp_jpe_enc_motion(enum ci_isp_jpe_enc_mode jpe_enc_mode,
+                          u16 frames_num, u32 *byte_count);
+
+void ci_isp_set_yc_mode(void);
+
+#endif
diff --git a/drivers/media/video/mrstisp/mrstisp_dp.c b/drivers/media/video/mrstisp/mrstisp_dp.c
new file mode 100644
index 0000000..ed8847b
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_dp.c
@@ -0,0 +1,1222 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "mrstisp_stdinc.h"
+
+/* mask for all chroma subsampling settings */
+#define CI_ISP_DPD_CSS_MASK  (CI_ISP_DPD_CSS_H_MASK | CI_ISP_DPD_CSS_V_MASK)
+#define SCALER_COFFS_COSITED 0x400
+#define FIXEDPOINT_ONE 0x1000
+
+/* limitations of main and self scaler */
+#define MAIN_SCALER_WIDTH_MAX 2600
+#define SELF_SCALER_WIDTH_MAX 640
+#define SCALER_MIN 16
+
+#define SELF_UPSCALE_FACTOR_MAX 5
+#define MAIN_UPSCALE_FACTOR_MAX 5
+
+/*
+ * upscale lookup table for smooth edges
+ * (linear interpolation between pixels)
+ */
+
+/* smooth edges */
+static const struct ci_isp_rsz_lut isp_rsz_lut_smooth_lin = {
+       {
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+       0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+       0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
+       0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
+       0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
+       0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+       0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
+       }
+};
+
+/*
+ * upscale lookup table for sharp edges
+ * (no interpolation, just duplicate pixels)
+ */
+
+/* sharp edges */
+static const struct ci_isp_rsz_lut isp_rsz_lut_sharp = {
+       {
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F
+       }
+};
+
+/* structure combining virtual ISP windows settings */
+struct ci_isp_virtual_isp_wnds {
+       struct ci_isp_window wnd_blacklines;
+       struct ci_isp_window wnd_zoom_crop;
+};
+
+/* static storage to remember last applied virtual ISP window settings */
+static struct ci_isp_virtual_isp_wnds last_isp_wnds;
+
+/*
+ * Calculates the value to program into the struct ci_isp_scale or
+ * tsMrvSScale structures to scale from in pixels to out pixels.
+ *
+ * The formulas are taken from the MARVIN / MARVIN3PLUS user
+ * manuals (fixed-point calculation using 32 bit during
+ * processing, will overflow at an output size of 1048575 pixels).
+ */
+static u32 ci_get_scale_reg(u16 in, u16 out)
+{
+       if (in > out) {
+               /* downscaling */
+               return (u32) (((((u32) out - 1) * RSZ_SCALER_BYPASS) /
+                                 (u32) (in - 1)) + 1);
+       } else if (in < out) {
+               /* upscaling */
+               return (u32) (((((u32) in - 1) * RSZ_SCALER_BYPASS) /
+                                 (u32) (out - 1)) | (u32) RSZ_UPSCALE_ENABLE);
+       }
+
+       /* no scaling */
+       return RSZ_SCALER_BYPASS;
+}
+
+/*
+ * Calculates the values of the ci_isp_scale structure for the
+ * given input size and data path descriptor.
+ */
+static u32 ci_calc_scale_factors(const struct ci_isp_datapath_desc *source,
+                                const struct ci_isp_datapath_desc *path,
+                                struct ci_isp_scale *scale, int implementation)
+{
+       u32 scaler_output_format;
+       u32 cssflags;
+       u32 scaler_input_format;
+
+       u16 chroma_in_w;
+       u16 chroma_in_h;
+       u16 chroma_out_wcr;
+       u16 chroma_out_wcb;
+       u16 chroma_out_h;
+
+       memset(scale, 0, sizeof(struct ci_isp_scale));
+       dprintk(1, "srcw %d, srch %d;", source->out_w, source->out_h);
+       dprintk(1, "dstw %d, dsth %d", path->out_w, path->out_h);
+
+       /* calculate Y scale factors */
+       scale->scale_hy = ci_get_scale_reg(source->out_w, path->out_w);
+       scale->scale_vy = ci_get_scale_reg(source->out_h, path->out_h);
+
+       /* figure out the color input format of the scaler */
+       switch (path->flags & CI_ISP_DPD_MODE_MASK) {
+       case CI_ISP_DPD_MODE_DMAYC_DIRECT:
+       case CI_ISP_DPD_MODE_DMAYC_ISP:
+       case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
+       case CI_ISP_DPD_MODE_DMAJPEG_ISP:
+               scaler_input_format = path->flags & CI_ISP_DPD_DMA_IN_MASK;
+               break;
+       default:
+               scaler_input_format = CI_ISP_DPD_DMA_IN_422;
+               break;
+       }
+
+       dprintk(1, "scaler_input_format is 0x%x", scaler_input_format);
+
+       switch (scaler_input_format) {
+       case CI_ISP_DPD_DMA_IN_422:
+               chroma_in_w = source->out_w / 2;
+               chroma_in_h = source->out_h;
+               chroma_out_wcr = path->out_w / 2;
+               chroma_out_wcb = (path->out_w + 1) / 2;
+               chroma_out_h = path->out_h;
+               break;
+       case CI_ISP_DPD_DMA_IN_420:
+               chroma_in_w = source->out_w / 2;
+               chroma_in_h = source->out_h / 2;
+               chroma_out_wcr = path->out_w / 2;
+               chroma_out_wcb = (path->out_w + 1) / 2;
+               chroma_out_h = path->out_h / 2;
+               break;
+       case CI_ISP_DPD_DMA_IN_411:
+               chroma_in_w = source->out_w / 4;
+               chroma_in_h = source->out_h;
+               chroma_out_wcr = path->out_w / 4;
+               chroma_out_wcb = (path->out_w + 2) / 4;
+               chroma_out_h = path->out_h;
+               break;
+       case CI_ISP_DPD_DMA_IN_444:
+       default:
+               chroma_in_w = source->out_w;
+               chroma_in_h = source->out_h;
+               chroma_out_wcb = chroma_out_wcr = path->out_w;
+               chroma_out_h = path->out_h;
+               break;
+       }
+
+       /* calculate chrominance scale factors */
+       switch (path->flags & CI_ISP_DPD_CSS_H_MASK) {
+       case CI_ISP_DPD_CSS_H2:
+               chroma_out_wcb /= 2;
+               chroma_out_wcr /= 2;
+               break;
+       case CI_ISP_DPD_CSS_H4:
+               chroma_out_wcb /= 4;
+               chroma_out_wcr /= 4;
+               break;
+       case CI_ISP_DPD_CSS_HUP2:
+               chroma_out_wcb *= 2;
+               chroma_out_wcr *= 2;
+               break;
+       case CI_ISP_DPD_CSS_HUP4:
+               chroma_out_wcb *= 4;
+               chroma_out_wcr *= 4;
+               break;
+       default:
+               break;
+       }
+
+       scale->scale_hcr = ci_get_scale_reg(chroma_in_w, chroma_out_wcr);
+       scale->scale_hcb = ci_get_scale_reg(chroma_in_w, chroma_out_wcb);
+       scale->scale_hcb = scale->scale_hcr;
+
+       switch (path->flags & CI_ISP_DPD_CSS_V_MASK) {
+       case CI_ISP_DPD_CSS_V2:
+               chroma_out_h /= 2;
+               break;
+       case CI_ISP_DPD_CSS_V4:
+               chroma_out_h /= 4;
+               break;
+       case CI_ISP_DPD_CSS_VUP2:
+               chroma_out_h *= 2;
+               break;
+       case CI_ISP_DPD_CSS_VUP4:
+               chroma_out_h *= 4;
+               break;
+       default:
+               break;
+       }
+
+       scale->scale_vc = ci_get_scale_reg(chroma_in_h, chroma_out_h);
+
+       /* additional chrominance phase shifts */
+       if (path->flags & CI_ISP_DPD_CSS_HSHIFT)
+               scale->phase_hc = SCALER_COFFS_COSITED;
+       if (path->flags & CI_ISP_DPD_CSS_VSHIFT)
+               scale->phase_vc = SCALER_COFFS_COSITED;
+
+       /* additional luminance phase shifts */
+       if (path->flags & CI_ISP_DPD_LUMA_HSHIFT)
+               scale->phase_hy = SCALER_COFFS_COSITED;
+       if (path->flags & CI_ISP_DPD_LUMA_VSHIFT)
+               scale->phase_vy = SCALER_COFFS_COSITED;
+
+       /* try to figure out the outcoming YCbCr format */
+       cssflags = path->flags & CI_ISP_DPD_CSS_MASK;
+       if (cssflags == (CI_ISP_DPD_CSS_H_OFF | CI_ISP_DPD_CSS_V_OFF)) {
+               /* trivial case: the output format is not changed */
+               scaler_output_format = scaler_input_format;
+       } else {
+               /* output format gets changed by the scaler setting */
+               /* assume invalid format by default */
+               scaler_output_format = (u32) (-1);
+               switch (scaler_input_format) {
+               case CI_ISP_DPD_DMA_IN_444:
+                       if (cssflags == (CI_ISP_DPD_CSS_H2
+                                        | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 444 -> 422 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H4
+                                               | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 444 -> 411 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
+                                               | CI_ISP_DPD_CSS_V2)) {
+                               /* conversion 444 -> 420 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_422:
+                       if (cssflags == (CI_ISP_DPD_CSS_HUP2
+                                        | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 422 -> 444 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
+                                               | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 422 -> 411 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H_OFF
+                                               | CI_ISP_DPD_CSS_V2)) {
+                               /* conversion 422 -> 420 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_420:
+                       if (cssflags == (CI_ISP_DPD_CSS_HUP2
+                                        | CI_ISP_DPD_CSS_VUP2)) {
+                               /* conversion 420 -> 444 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
+                                               | CI_ISP_DPD_CSS_VUP2)) {
+                               /* conversion 420 -> 411 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_H_OFF
+                                               | CI_ISP_DPD_CSS_VUP2)) {
+                               /* conversion 420 -> 422 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_411:
+                       if (cssflags == (CI_ISP_DPD_CSS_HUP4
+                                        | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 411 -> 444 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_HUP2
+                                               | CI_ISP_DPD_CSS_V_OFF)) {
+                               /* conversion 411 -> 422 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       } else if (cssflags == (CI_ISP_DPD_CSS_HUP2
+                                               | CI_ISP_DPD_CSS_V2)) {
+                               /* conversion 411 -> 420 */
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               default:
+                       break;
+               }
+       }
+
+       return scaler_output_format;
+}
+
+/*
+ * Returns the address of up-scaling lookup table to use for
+ * the given data path flags.
+ */
+static const struct ci_isp_rsz_lut *ci_get_rsz_lut(u32 flags)
+{
+       const struct ci_isp_rsz_lut *ret_val;
+       switch (flags & CI_ISP_DPD_UPSCALE_MASK) {
+       case CI_ISP_DPD_UPSCALE_SHARP:
+               ret_val = &isp_rsz_lut_sharp;
+               break;
+       default:
+               ret_val = &isp_rsz_lut_smooth_lin;
+               break;
+       }
+       return ret_val;
+}
+
+/*
+ * Fills in scale factors and MI configuration for the main path.
+ * Note that only self path related settings will be written into
+ * the MI configuration struct, so this routine can be used for
+ * both ISP and DMA originated data path setups.
+ *
+ * Following fields are being filled in:
+ * scale_main: [all fields]
+ * mrv_mi_ctrl: mrv_mif_mp_pic_form main_path
+ */
+static int ci_calc_main_path_settings(const struct ci_isp_datapath_desc *source,
+                                     const struct ci_isp_datapath_desc  *main,
+                                     struct ci_isp_scale *scale_main,
+                                     struct ci_isp_mi_ctrl *mrv_mi_ctrl)
+{
+       u32 main_flag;
+
+       WARN_ON(!(source != NULL));
+       WARN_ON(!(scale_main != NULL));
+       WARN_ON(!(mrv_mi_ctrl != NULL));
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (main)
+               main_flag = main->flags;
+       else
+               main_flag = 0;
+
+       /* initialize the given parameters */
+       memset(scale_main, 0, sizeof(struct ci_isp_scale));
+       scale_main->scale_hy = RSZ_SCALER_BYPASS;
+       scale_main->scale_hcb = RSZ_SCALER_BYPASS;
+       scale_main->scale_hcr = RSZ_SCALER_BYPASS;
+       scale_main->scale_vy = RSZ_SCALER_BYPASS;
+       scale_main->scale_vc = RSZ_SCALER_BYPASS;
+
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+               case CI_ISP_DPD_MODE_DMAYC_ISP:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_ON;
+                       break;
+               case CI_ISP_DPD_MODE_ISPJPEG:
+               case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
+               case CI_ISP_DPD_MODE_DMAJPEG_ISP:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_JPE;
+                       break;
+               case CI_ISP_DPD_MODE_ISPRAW:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW8;
+                       break;
+               case CI_ISP_DPD_MODE_ISPRAW_16B:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW816;
+                       break;
+               default:
+                       eprintk("unsupported mode for main path");
+                       return CI_STATUS_NOTSUPP;
+               }
+               if (main_flag & (CI_ISP_DPD_H_FLIP | CI_ISP_DPD_V_FLIP |
+                       CI_ISP_DPD_90DEG_CCW)) {
+                       eprintk("not supported for main path");
+                       return CI_STATUS_NOTSUPP;
+               }
+               if (main_flag & CI_ISP_DPD_NORESIZE) {
+                       if (main_flag & CI_ISP_DPD_CSS_MASK) {
+                               eprintk("main path needs resizer");
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (main_flag &
+                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
+                               eprintk("main path needs resizer");
+                               return CI_STATUS_NOTSUPP;
+                       }
+               } else {
+                       if ((mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)
+                           || (mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)) {
+                               eprintk("scaler not in RAW mode");
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       /* changed to avoid LINT warnings (Warning 613) */
+                       if (main != NULL) {
+                               if ((((u32) (source->out_w) *
+                                     MAIN_UPSCALE_FACTOR_MAX) < main->out_w)
+                                   ||
+                                   (((u32) (source->out_h) *
+                                     MAIN_UPSCALE_FACTOR_MAX) <
+                                    main->out_h)) {
+                                       eprintk("main upscaling exceeded");
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                               if ((main->out_w >
+                                    MAIN_SCALER_WIDTH_MAX)
+                                   || (main->out_w < SCALER_MIN)
+                                   || (main->out_h < SCALER_MIN)) {
+                                       eprintk("main scaler ange exceeded");
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               WARN_ON(main == NULL);
+                       }
+
+                       if (source->out_w & 0x01) {
+                               eprintk("input width must be even!");
+                               return CI_STATUS_NOTSUPP;
+                       }
+
+                       /* calculate scale factors. */
+                       ci_calc_scale_factors(source, main, scale_main, 3);
+               }
+       } else {
+               mrv_mi_ctrl->main_path = CI_ISP_PATH_OFF;
+       }
+
+       /* hardcoded MI settings */
+       dprintk(1, "main_flag is 0x%x", main_flag);
+       if (main_flag & CI_ISP_DPD_HWRGB_MASK) {
+               switch (main_flag & CI_ISP_DPD_HWRGB_MASK) {
+               case CI_ISP_DPD_YUV_420:
+               case CI_ISP_DPD_YUV_422:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_YUV_NV12:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
+                       break;
+               case CI_ISP_DPD_YUV_YUYV:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
+                       break;
+               default:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+               }
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Fills in scale factors and MI configuration for the self
+ * path.  Note that only self path related settings will be written into
+ * the MI config struct, so this routine can be used for both ISP and DMA
+ * originated datapath setups.
+ *
+ * Following fields are being filled in:
+ *           scale_flag :
+ *              [all fields]
+ *           mrv_mi_ctrl :
+ *              mrv_mif_sp_out_form
+ *              mrv_mif_sp_in_form
+ *              mrv_mif_sp_pic_form
+ *              mrv_mif_sp_mode
+ *              self_path
+ */
+static int ci_calc_self_path_settings(const struct ci_isp_datapath_desc *source,
+                                     const struct ci_isp_datapath_desc *self,
+                                     struct ci_isp_scale *scale_flag,
+                                     struct ci_isp_mi_ctrl *mrv_mi_ctrl)
+{
+       u32 scaler_out_col_format;
+       u32 self_flag;
+
+       WARN_ON(!(source != NULL));
+       WARN_ON(!(scale_flag != NULL));
+       WARN_ON(!(mrv_mi_ctrl != NULL));
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (self)
+               self_flag = self->flags;
+       else
+               self_flag = 0;
+
+       /* initialize the given parameters */
+       memset(scale_flag, 0, sizeof(struct ci_isp_scale));
+       scale_flag->scale_hy = RSZ_SCALER_BYPASS;
+       scale_flag->scale_hcb = RSZ_SCALER_BYPASS;
+       scale_flag->scale_hcr = RSZ_SCALER_BYPASS;
+       scale_flag->scale_vy = RSZ_SCALER_BYPASS;
+       scale_flag->scale_vc = RSZ_SCALER_BYPASS;
+
+       if (self_flag & CI_ISP_DPD_ENABLE) {
+               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
+                       scaler_out_col_format = CI_ISP_DPD_DMA_IN_422;
+                       break;
+               case CI_ISP_DPD_MODE_DMAYC_ISP:
+               case CI_ISP_DPD_MODE_DMAYC_DIRECT:
+                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
+                       scaler_out_col_format =
+                           self_flag & CI_ISP_DPD_DMA_IN_MASK;
+                       break;
+               default:
+                       eprintk("unsupported mode for self path");
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               if (self_flag & CI_ISP_DPD_NORESIZE) {
+                       if (self_flag & CI_ISP_DPD_CSS_MASK) {
+                               eprintk("in self path needs resizer");
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (self_flag &
+                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
+                               eprintk("n self path needs resizer");
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       /* changed to avoid LINT warnings (Warning 613) */
+                       if (self != NULL) {
+                               if ((source->out_w != self->out_w) ||
+                                   (source->out_h != self->out_h)) {
+                                       eprintk("sizes needs resizer");
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               WARN_ON(self == NULL);
+                       }
+               } else {
+                       /* changed to avoid LINT warnings (Warning 613) */
+                       if (self != NULL) {
+                               /* upscaling only to factor
+                                * SELF_UPSCALE_FACTOR_MAX possible
+                                */
+                               if ((((u32) (source->out_w) *
+                                     SELF_UPSCALE_FACTOR_MAX) <
+                                    self->out_w)
+                                   ||
+                                   (((u32) (source->out_h) *
+                                     SELF_UPSCALE_FACTOR_MAX) <
+                                    self->out_h)) {
+                                       eprintk("apability exceeded");
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                               if ((self->out_w >
+                                    SELF_SCALER_WIDTH_MAX)
+                                   || (self->out_w < SCALER_MIN)
+                                   || (self->out_h < SCALER_MIN)) {
+                                       eprintk("out range exceeded");
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               WARN_ON(self == NULL);
+                       }
+
+                       /*
+                        * Remember that the input picture width should be
+                        * even if the scaler is used otherwise the scaler may
+                        * show unexpected behaviour in some rare cases)
+                        */
+                       if (source->out_w & 0x01) {
+                               eprintk("width must be even!");
+                               return CI_STATUS_NOTSUPP;
+                       }
+
+                       /* calculate scale factors. */
+                       scaler_out_col_format =
+                           ci_calc_scale_factors(source, self, scale_flag, 3);
+               }
+
+               /* figure out the input format setting */
+               switch (scaler_out_col_format) {
+               case CI_ISP_DPD_DMA_IN_444:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_444;
+                       break;
+               case CI_ISP_DPD_DMA_IN_422:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+               case CI_ISP_DPD_DMA_IN_420:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+               case CI_ISP_DPD_DMA_IN_411:
+               default:
+                       eprintk("input color format not supported");
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               /* figure out the output format setting */
+               dprintk(2, "step2, self_flag is 0x%x", self_flag);
+
+               switch (self_flag & CI_ISP_DPD_HWRGB_MASK) {
+               case CI_ISP_DPD_HWRGB_565:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_565;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_HWRGB_666:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_666;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_HWRGB_888:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_888;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_YUV_420:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+               case CI_ISP_DPD_YUV_422:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+               case CI_ISP_DPD_YUV_NV12:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+               case CI_ISP_DPD_YUV_YUYV:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+
+               case CI_ISP_DPD_HWRGB_OFF:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           mrv_mi_ctrl->mrv_mif_sp_in_form;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               default:
+                       eprintk("output color format not supported");
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               /* picture flipping / rotation */
+               dprintk(2, "step3");
+
+               switch (self_flag &
+                       (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
+                        CI_ISP_DPD_H_FLIP)) {
+               case CI_ISP_DPD_H_FLIP:
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_HORIZONTAL_FLIP;
+                       break;
+               case CI_ISP_DPD_V_FLIP:
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_VERTICAL_FLIP;
+                       break;
+               case (CI_ISP_DPD_V_FLIP | CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_180_DEG;
+                       break;
+               case CI_ISP_DPD_90DEG_CCW:
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_090_DEG;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROT_270_V_FLIP;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROT_090_V_FLIP;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
+                       CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_270_DEG;
+                       break;
+               default:
+                       mrv_mi_ctrl->mrv_mif_sp_mode = CI_ISP_MIF_SP_ORIGINAL;
+                       break;
+               }
+
+       } else {
+               mrv_mi_ctrl->self_path = CI_ISP_PATH_OFF;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Translates the given memory interface configuration struct
+ * into appropriate values to program the data path multiplexers.
+ */
+static int ci_calc_dp_mux_settings(const struct ci_isp_mi_ctrl *mi_ctrl,
+                                  enum ci_isp_ycs_chn_mode *ycs_chn_mode,
+                                  enum ci_isp_dp_switch *dp_switch)
+{
+       switch (mi_ctrl->main_path) {
+       case CI_ISP_PATH_RAW8:
+       case CI_ISP_PATH_RAW816:
+               *dp_switch = CI_ISP_DP_RAW;
+               *ycs_chn_mode = CI_ISP_YCS_MVRAW;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF) {
+                       eprintk("combined with RAW mode of main path");
+                       return CI_STATUS_NOTSUPP;
+               }
+               break;
+
+       case CI_ISP_PATH_JPE:
+               *dp_switch = CI_ISP_DP_JPEG;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *ycs_chn_mode = CI_ISP_YCS_MV_SP;
+               else
+                       *ycs_chn_mode = CI_ISP_YCS_MV;
+               break;
+
+       case CI_ISP_PATH_ON:
+               *dp_switch = CI_ISP_DP_MV;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *ycs_chn_mode = CI_ISP_YCS_MV_SP;
+               else
+                       *ycs_chn_mode = CI_ISP_YCS_MV;
+               break;
+
+       case CI_ISP_PATH_OFF:
+               *dp_switch = CI_ISP_DP_MV;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *ycs_chn_mode = CI_ISP_YCS_SP;
+               else
+                       *ycs_chn_mode = CI_ISP_YCS_OFF;
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+#define ISPWND_COMBINE_WNDS    0x00000001
+#define ISPWND_APPLY_OUTFORM   0x00000002
+#define ISPWND_APPLY_ISCONF    0x00000004
+#define ISPWND_NO_CROPPING     0x00000008
+
+/*
+ * Returns information about how to combine black pixel and
+ * zoom/crop windows for programming the ISP output formatter and the image
+ * stabilization unit for the given marvin derivative and ISP path.
+ */
+static u32 ci_get_isp_wnd_style(enum ci_isp_path isp_path)
+{
+       u32 res = 0;
+
+       /* image stabilization in both bayer and YCbCr paths */
+       if ((isp_path == CI_ISP_PATH_BAYER) ||
+           (isp_path == CI_ISP_PATH_YCBCR))
+               res = ISPWND_APPLY_OUTFORM | ISPWND_APPLY_ISCONF;
+       else
+               res = ISPWND_COMBINE_WNDS | ISPWND_APPLY_OUTFORM;
+
+       return res;
+}
+
+/*
+ *  the given windows for cutting away blacklines coming from
+ *  the image sensor and further cropping of the image for other
+ *  purposes like e.g. digital zoom to the output formatter and/or
+ *  image stabilisation modules of Marvins ISP.
+ */
+static int ci_set_isp_windows(const struct ci_sensor_config *isi_sensor_config,
+                             const struct ci_isp_window *wnd_blackline,
+                             const struct ci_isp_window *wnd_zoom_crop)
+{
+       struct ci_isp_window wnd_out_form;
+       struct ci_isp_is_config is_conf;
+       enum ci_isp_path isp_path;
+       u32 wnd_style;
+
+       memset(&wnd_out_form, 0, sizeof(wnd_out_form));
+       memset(&is_conf, 0, sizeof(is_conf));
+
+       /*
+        * figure out the path through the ISP to process the data from the
+        * image sensor
+        */
+       isp_path = ci_isp_select_path(isi_sensor_config, NULL);
+       if (isp_path == CI_ISP_PATH_UNKNOWN) {
+               eprintk("detect marvin ISP path to use");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /*
+        * get the recommended way to configure output formatter and/or
+        * image stabilization
+        */
+       wnd_style = ci_get_isp_wnd_style(isp_path);
+       if (wnd_style & ISPWND_NO_CROPPING) {
+               /*
+                * cropping not possible -> make sure that it is *not*
+                * supposed to be used
+                */
+               u16 isi_x;
+               u16 isi_y;
+               ci_sensor_res2size(isi_sensor_config->res, &isi_x, &isi_y);
+               if ((wnd_zoom_crop->hsize != isi_x)
+                   || (wnd_zoom_crop->vsize != isi_y)
+                   || (wnd_zoom_crop->hoffs != 0)
+                   || (wnd_zoom_crop->voffs != 0)) {
+                       eprintk("in selected ISP data path");
+                       return CI_STATUS_NOTSUPP;
+               }
+               if ((wnd_blackline->hsize != isi_x) ||
+                   (wnd_blackline->vsize != isi_y) ||
+                   (wnd_blackline->hoffs != 0) ||
+                   (wnd_blackline->voffs != 0)) {
+                       eprintk("supported in selected ISP data path");
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       /*
+        * The image stabilization is allowed to move the window in both
+        * directions by the same amount of pixels we have calculated for
+        * the offsets. The initial image stabilization window is equal to
+        * the zoom/crop window
+        */
+       is_conf.max_dx = wnd_zoom_crop->hoffs;
+       is_conf.max_dy = wnd_zoom_crop->voffs;
+       is_conf.mrv_is_window = *wnd_zoom_crop;
+
+       /* combine both blackline and zoom/crop window */
+       if (wnd_style & ISPWND_COMBINE_WNDS) {
+               wnd_out_form = *wnd_zoom_crop;
+               wnd_out_form.voffs += wnd_blackline->voffs;
+               wnd_out_form.hoffs += wnd_blackline->hoffs;
+               is_conf.mrv_is_window = wnd_out_form;
+               if (wnd_style & ISPWND_APPLY_OUTFORM) {
+                       /*
+                        * if the output formatter is to be used, offsets
+                        * are cut away there, so
+                        * we don't need additional ones in the imags
+                        * stabilization unit
+                        */
+                       is_conf.mrv_is_window.hoffs = 0;
+                       is_conf.mrv_is_window.voffs = 0;
+               }
+       } else {
+               /*
+                * do not combine windows --> blacklines done with output
+                * formatter, zoom/cropping done with image stabilization
+                */
+               wnd_out_form = *wnd_blackline;
+               is_conf.mrv_is_window = *wnd_zoom_crop;
+       }
+
+       /* finally, apply the settings to marvin */
+       if (wnd_style & ISPWND_APPLY_OUTFORM) {
+               ci_isp_set_output_formatter(&wnd_out_form,
+                                           CI_ISP_CFG_UPDATE_IMMEDIATE);
+       }
+       if (wnd_style & ISPWND_APPLY_ISCONF) {
+               int res = ci_isp_is_set_config(&is_conf);
+               if (res != CI_STATUS_SUCCESS) {
+                       eprintk("set image stabilization config");
+                       return res;
+               }
+       }
+
+       /* success - remember our virtual settings */
+       last_isp_wnds.wnd_blacklines = *wnd_blackline;
+       last_isp_wnds.wnd_zoom_crop = *wnd_zoom_crop;
+
+       return CI_STATUS_SUCCESS;
+}
+
+/* sets extended YCbCr mode */
+static int ci_ext_ycb_cr_mode(const struct ci_isp_datapath_desc *path)
+{
+       u32 main_flag;
+
+       WARN_ON(!(path != NULL));
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (path)
+               main_flag = path->flags;
+       else
+               main_flag = 0;
+
+       /* if flag CI_ISP_DPD_YCBCREXT is set set extended YCbCr mode */
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               if (main_flag & CI_ISP_DPD_YCBCREXT)
+                       ci_isp_set_ext_ycmode();
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Configures main and self data pathes and scaler for data coming from the ISP.
+ *
+ * Following MARVIN subsystems are programmed:
+ * - ISP output formatter
+ * - Image stabilization module
+ * - YC-Splitter
+ * - Self path DMA-read multiplexer
+ * - Main path multiplexer
+ * - Main & Self path resizer
+ * - Small output unit
+ * - Memory Interface (MI) input source, en/disable and data format
+ *
+ * Following MARVIN subsystems are *NOT* programmed:
+ * - All ISP functionality but the output formatter & image stabilization module
+ * - color Processing block
+ * - JPEG encode subsystem (quantisation tables etc.)
+ * - Memory Interface (MI) output buffer addresses and sizes
+ */
+int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
+                   const struct ci_sensor_config *isi_config,
+                   const struct ci_isp_datapath_desc *main,
+                   const struct ci_isp_datapath_desc *self, int zoom)
+{
+       int res;
+
+       u32 main_flag;
+       u32 self_flag;
+       u16 isi_x;
+       u16 isi_y;
+       struct ci_isp_scale scale_main;
+       struct ci_isp_scale scale_flag;
+       enum ci_isp_ycs_chn_mode chn_mode = 0;
+       enum ci_isp_dp_switch dp_switch = 0;
+       struct ci_isp_mi_ctrl mrv_mi_ctrl;
+       struct ci_isp_datapath_desc source;
+       struct ci_isp_window wnd_blackline;
+       struct ci_isp_window wnd_zoom_crop;
+
+       const struct ci_isp_datapath_desc *target = NULL;
+
+       /* assume datapath deactivation for not provided descriptors */
+       main_flag = 0;
+       self_flag = 0;
+       if (main)
+               main_flag = main->flags;
+
+       if (self)
+               self_flag = self->flags;
+
+       /* initialize variables on the stack */
+       res = CI_STATUS_SUCCESS;
+       ci_sensor_res2size(isi_config->res, &isi_x, &isi_y);
+       memset(&mrv_mi_ctrl, 0, sizeof(struct ci_isp_mi_ctrl));
+       memset(&wnd_blackline, 0, sizeof(wnd_blackline));
+       memset(&wnd_zoom_crop, 0, sizeof(wnd_zoom_crop));
+
+       /* no cropping, no offset */
+       wnd_blackline.hsize = isi_x;
+       wnd_blackline.vsize = isi_y;
+       wnd_zoom_crop = wnd_blackline;
+
+       /* output channel */
+       if ((main_flag & CI_ISP_DPD_ENABLE) &&
+           (main_flag & CI_ISP_DPD_KEEPRATIO)) {
+               target = main;
+       }
+       if ((self_flag & CI_ISP_DPD_ENABLE) &&
+           (self_flag & CI_ISP_DPD_KEEPRATIO)) {
+               if (target) {
+                       eprintk("only allowed for one path");
+                       return CI_STATUS_NOTSUPP;
+               }
+               target = self;
+       }
+
+       /* if so, calculate the cropping */
+       if (target) {
+               u32 aspect_cam = (0x1000 * ((u32) isi_x)) / isi_y;
+               u32 aspect_target = (0x1000 * ((u32) (target->out_w))) /
+                   target->out_h;
+               if (aspect_cam < aspect_target) {
+                       /*
+                        * camera aspect is more 'portrait-like' as
+                        * target aspect. We have to crop the
+                        * camera picture by cutting off a bit of
+                        * the top & bottom changed to avoid LINT
+                        * warnings (Info 734)
+                        */
+                       wnd_zoom_crop.vsize = (u16) (((u32) isi_x *
+                                      (u32) (target->out_h)) / target->out_w);
+               } else  {
+                       /* camera aspect is more 'landscape-like'
+                        * as target aspect. We have to crop the
+                        * camera picture by cutting off a bit of
+                        * the left and right changed to avoid LINT
+                        * warnings (Info 734) */
+                       wnd_zoom_crop.hsize = (u16) (((u32) isi_y *
+                                      (u32) (target->out_w)) / target->out_h);
+               }
+       }
+
+       /*
+        * now, we may also want to do digital zoom. If so, we need
+        * to shrink the ISP window by the desired zoom factor.
+        */
+       if (zoom > 0) {
+               wnd_zoom_crop.vsize = (u16) (((u32) (wnd_zoom_crop.vsize) *
+                              1024) / (1024 + (u32) zoom));
+               wnd_zoom_crop.hsize = (u16) (((u32) (wnd_zoom_crop.hsize) *
+                              1024) / (1024 + (u32) zoom));
+       }
+
+       /*
+        * Remember that the output formatter h_size should be
+        * even if the scaler is used
+        * (otherwise the scaler may show unexpected behaviour in
+        * some rare cases)
+        */
+       wnd_zoom_crop.hsize &= ~0x01;
+
+       /*
+        * At last, we care about the offset of the ISP window. We
+        * want it centered on the image data delivered by the
+        * sensor (not counting possible black lines)
+        */
+       wnd_zoom_crop.hoffs = (isi_x - wnd_zoom_crop.hsize) / 2;
+       wnd_zoom_crop.voffs = (isi_y - wnd_zoom_crop.vsize) / 2;
+
+       /*
+        * If the image sensor delivers blacklines, we cut them
+        * away with moving wnd_blackline window by the given
+        * amount of lines
+        */
+       switch (isi_config->bls) {
+       case SENSOR_BLS_OFF:
+               break;
+       case SENSOR_BLS_TWO_LINES:
+               wnd_blackline.voffs += 2;
+               break;
+       case SENSOR_BLS_FOUR_LINES:
+               wnd_blackline.voffs += 2;
+               break;
+       default:
+               eprintk("config");
+               return CI_STATUS_NOTSUPP;
+       }
+       /*
+        * if we are instructed to show the blacklines and the
+        * sensor generates them,
+        * we have to move the ISP windows to the upper border of
+        * the whole sensor, and deny the image stabilization to
+        * move around the window in vertical direction.
+        */
+       if (isi_config->bls != SENSOR_BLS_OFF) {
+               if (((main_flag & CI_ISP_DPD_ENABLE)
+                    && (main_flag & CI_ISP_DPD_BLACKLINES_TOP))
+                   || ((self_flag & CI_ISP_DPD_ENABLE)
+                       && (self_flag & CI_ISP_DPD_BLACKLINES_TOP))) {
+                       if ((main_flag & CI_ISP_DPD_ENABLE)
+                           && (self_flag & CI_ISP_DPD_ENABLE)
+                           && ((main_flag & CI_ISP_DPD_BLACKLINES_TOP)
+                               != (self_flag & CI_ISP_DPD_BLACKLINES_TOP))) {
+                               eprintk("and self path");
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       wnd_blackline.voffs = 0;
+                       wnd_zoom_crop.voffs = 0;
+               }
+       }
+
+       source.out_w = wnd_zoom_crop.hsize;
+       source.out_h = wnd_zoom_crop.vsize;
+       source.flags = CI_ISP_DPD_DMA_IN_422;
+
+       /*to use crop set crop_flag first*/
+       if (crop_flag) {
+               wnd_zoom_crop.hsize = main->out_w;
+               wnd_zoom_crop.vsize = main->out_h;
+       }
+
+       dprintk(1, "source.out_w %d, source.out_h %d",
+               source.out_w, source.out_h);
+       if (main)
+               dprintk(1, "main.out_w %d, main.out_h %d",
+                       main->out_w, main->out_h);
+       if (self)
+               dprintk(1, "self.out_w %d, self.out_h %d",
+                       self->out_w, self->out_h);
+
+       res = ci_calc_main_path_settings(&source, main, &scale_main,
+                                        &mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       /* additional settings specific for main path fed from ISP */
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+               case CI_ISP_DPD_MODE_ISPRAW:
+               case CI_ISP_DPD_MODE_ISPRAW_16B:
+               case CI_ISP_DPD_MODE_ISPJPEG:
+                       break;
+               default:
+                       eprintk("data coming from the ISP");
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       /* basic selfpath settings */
+       res = ci_calc_self_path_settings(&source, self, &scale_flag,
+                                        &mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       if (sys_conf->isp_cfg.flags.ycbcr_non_cosited)
+               mrv_mi_ctrl.mrv_mif_sp_in_phase = mrv_mif_col_phase_non_cosited;
+       else
+               mrv_mi_ctrl.mrv_mif_sp_in_phase = mrv_mif_col_phase_cosited;
+       if (sys_conf->isp_cfg.flags.ycbcr_full_range)
+               mrv_mi_ctrl.mrv_mif_sp_in_range = mrv_mif_col_range_full;
+       else
+               mrv_mi_ctrl.mrv_mif_sp_in_range = mrv_mif_col_range_std;
+       if (self_flag & CI_ISP_DPD_ENABLE) {
+               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+                       break;
+               default:
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       /* Datapath multiplexers */
+       res = ci_calc_dp_mux_settings(&mrv_mi_ctrl, &chn_mode, &dp_switch);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       /* hardcoded global settings of the memory interface */
+       mrv_mi_ctrl.byte_swap_enable = false;
+
+       mrv_mi_ctrl.init_vals = CI_ISP_MIF_INIT_OFFSAndBase;
+
+       /*to use crop set crop_flag first*/
+       if (crop_flag) {
+               wnd_blackline.hsize = main->out_w;
+               wnd_blackline.vsize = main->out_h;
+       }
+
+       res = ci_set_isp_windows(isi_config, &wnd_blackline,
+                                &wnd_zoom_crop);
+       if (res != CI_STATUS_SUCCESS) {
+               eprintk("failed to set ISP window configuration");
+               return res;
+       }
+       res = ci_isp_set_data_path(chn_mode, dp_switch);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       res = ci_isp_set_mipi_smia(isi_config->mode);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       if (mrv_mi_ctrl.self_path != CI_ISP_PATH_OFF)
+               ci_isp_res_set_self_resize(&scale_flag,
+                                          CI_ISP_CFG_UPDATE_IMMEDIATE,
+                                          ci_get_rsz_lut(self_flag));
+
+       if (mrv_mi_ctrl.main_path != CI_ISP_PATH_OFF)
+               ci_isp_res_set_main_resize(&scale_main,
+                                          CI_ISP_CFG_UPDATE_IMMEDIATE,
+                                          ci_get_rsz_lut(main_flag));
+
+       res = ci_isp_mif_set_path_and_orientation(&mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS) {
+               eprintk("failed to set MI path and orientation");
+               return res;
+       }
+
+       /* here the extended YCbCr mode is configured */
+       if (sys_conf->isp_cfg.flags.ycbcr_full_range)
+               res = ci_ext_ycb_cr_mode(main);
+       else
+               ci_isp_set_yc_mode();
+
+       if (res != CI_STATUS_SUCCESS) {
+               eprintk("failed to set ISP YCbCr extended mode");
+               return res;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
--
1.6.3.2

