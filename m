Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:38853 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbbDUNui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:50:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/4] v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
Date: Tue, 21 Apr 2015 15:49:58 +0200
Message-Id: <1429624201-44743-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
References: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The descriptions used in drivers for the formats returned with ENUM_FMT
are all over the place.

So instead allow the core to fill them in if the driver didn't. This
allows drivers to drop the description and flags.

Based on an earlier patch from Philipp Zabel:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/81411

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 199 +++++++++++++++++++++++++++++++++--
 1 file changed, 192 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa407cb..24dc45f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1103,6 +1103,182 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_enum_output(file, fh, p);
 }
 
+static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
+{
+	const unsigned sz = sizeof(fmt->description);
+	const char *descr = NULL;
+	u32 flags = 0;
+
+	/*
+	 * We depart from the normal coding style here since the descriptions
+	 * should be aligned so it is easy to see which descriptions will be
+	 * longer than 31 characters (the max length for a description).
+	 * And frankly, this is easier to read anyway.
+	 *
+	 * Note that gcc will use O(log N) comparisons to find the right case.
+	 */
+	switch (fmt->pixelformat) {
+	/* Max description length mask:	descr = "0123456789012345678901234567890" */
+	case V4L2_PIX_FMT_RGB332:	descr = "8-bit RGB 3-3-2"; break;
+	case V4L2_PIX_FMT_RGB444:	descr = "16-bit A/XRGB 4-4-4-4"; break;
+	case V4L2_PIX_FMT_ARGB444:	descr = "16-bit ARGB 4-4-4-4"; break;
+	case V4L2_PIX_FMT_XRGB444:	descr = "16-bit XRGB 4-4-4-4"; break;
+	case V4L2_PIX_FMT_RGB555:	descr = "16-bit A/XRGB 1-5-5-5"; break;
+	case V4L2_PIX_FMT_ARGB555:	descr = "16-bit ARGB 1-5-5-5"; break;
+	case V4L2_PIX_FMT_XRGB555:	descr = "16-bit XRGB 1-5-5-5"; break;
+	case V4L2_PIX_FMT_RGB565:	descr = "16-bit RGB 5-6-5"; break;
+	case V4L2_PIX_FMT_RGB555X:	descr = "16-bit A/XRGB 1-5-5-5 BE"; break;
+	case V4L2_PIX_FMT_ARGB555X:	descr = "16-bit ARGB 1-5-5-5 BE"; break;
+	case V4L2_PIX_FMT_XRGB555X:	descr = "16-bit XRGB 1-5-5-5 BE"; break;
+	case V4L2_PIX_FMT_RGB565X:	descr = "16-bit RGB 5-6-5 BE"; break;
+	case V4L2_PIX_FMT_BGR666:	descr = "18-bit BGRX 6-6-6-14"; break;
+	case V4L2_PIX_FMT_BGR24:	descr = "24-bit BGR 8-8-8"; break;
+	case V4L2_PIX_FMT_RGB24:	descr = "24-bit RGB 8-8-8"; break;
+	case V4L2_PIX_FMT_BGR32:	descr = "32-bit BGRA/X 8-8-8-8"; break;
+	case V4L2_PIX_FMT_ABGR32:	descr = "32-bit BGRA 8-8-8-8"; break;
+	case V4L2_PIX_FMT_XBGR32:	descr = "32-bit BGRX 8-8-8-8"; break;
+	case V4L2_PIX_FMT_RGB32:	descr = "32-bit A/XRGB 8-8-8-8"; break;
+	case V4L2_PIX_FMT_ARGB32:	descr = "32-bit ARGB 8-8-8-8"; break;
+	case V4L2_PIX_FMT_XRGB32:	descr = "32-bit XRGB 8-8-8-8"; break;
+	case V4L2_PIX_FMT_GREY:		descr = "8-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y4:		descr = "4-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y6:		descr = "6-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y10:		descr = "10-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y12:		descr = "12-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y16:		descr = "16-bit Greyscale"; break;
+	case V4L2_PIX_FMT_Y10BPACK:	descr = "10-bit Greyscale (Packed)"; break;
+	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
+	case V4L2_PIX_FMT_UV8:		descr = "8-bit Chrominance UV 4-4"; break;
+	case V4L2_PIX_FMT_YVU410:	descr = "Planar YVU 4:1:0"; break;
+	case V4L2_PIX_FMT_YVU420:	descr = "Planar YVU 4:2:0"; break;
+	case V4L2_PIX_FMT_YUYV:		descr = "YUYV 4:2:2"; break;
+	case V4L2_PIX_FMT_YYUV:		descr = "YYUV 4:2:2"; break;
+	case V4L2_PIX_FMT_YVYU:		descr = "YVYU 4:2:2"; break;
+	case V4L2_PIX_FMT_UYVY:		descr = "UYVY 4:2:2"; break;
+	case V4L2_PIX_FMT_VYUY:		descr = "VYUY 4:2:2"; break;
+	case V4L2_PIX_FMT_YUV422P:	descr = "Planar YVU 4:2:2"; break;
+	case V4L2_PIX_FMT_YUV411P:	descr = "Planar YUV 4:1:1"; break;
+	case V4L2_PIX_FMT_Y41P:		descr = "YUV 4:1:1 (Packed)"; break;
+	case V4L2_PIX_FMT_YUV444:	descr = "16-bit A/XYUV 4-4-4-4"; break;
+	case V4L2_PIX_FMT_YUV555:	descr = "16-bit A/XYUV 1-5-5-5"; break;
+	case V4L2_PIX_FMT_YUV565:	descr = "16-bit YUV 5-6-5"; break;
+	case V4L2_PIX_FMT_YUV32:	descr = "32-bit A/XYUV 8-8-8-8"; break;
+	case V4L2_PIX_FMT_YUV410:	descr = "Planar YUV 4:1:0"; break;
+	case V4L2_PIX_FMT_YUV420:	descr = "Planar YUV 4:2:0"; break;
+	case V4L2_PIX_FMT_HI240:	descr = "8-bit Dithered RGB (BTTV)"; break;
+	case V4L2_PIX_FMT_HM12:		descr = "YUV 4:2:0 (16x16 Macroblocks)"; break;
+	case V4L2_PIX_FMT_M420:		descr = "YUV 4:2:0 (M420)"; break;
+	case V4L2_PIX_FMT_NV12:		descr = "Y/CbCr 4:2:0"; break;
+	case V4L2_PIX_FMT_NV21:		descr = "Y/CrCb 4:2:0"; break;
+	case V4L2_PIX_FMT_NV16:		descr = "Y/CbCr 4:2:2"; break;
+	case V4L2_PIX_FMT_NV61:		descr = "Y/CrCb 4:2:2"; break;
+	case V4L2_PIX_FMT_NV24:		descr = "Y/CbCr 4:4:4"; break;
+	case V4L2_PIX_FMT_NV42:		descr = "Y/CrCb 4:4:4"; break;
+	case V4L2_PIX_FMT_NV12M:	descr = "Y/CbCr 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV21M:	descr = "Y/CrCb 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_NV16M:	descr = "Y/CbCr 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV61M:	descr = "Y/CrCb 4:2:2 (N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT:	descr = "Y/CbCr 4:2:0 (64x32 MB, N-C)"; break;
+	case V4L2_PIX_FMT_NV12MT_16X16:	descr = "Y/CbCr 4:2:0 (16x16 MB, N-C)"; break;
+	case V4L2_PIX_FMT_YUV420M:	descr = "Planar YUV 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_YVU420M:	descr = "Planar YVU 4:2:0 (N-C)"; break;
+	case V4L2_PIX_FMT_SBGGR8:	descr = "8-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG8:	descr = "8-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG8:	descr = "8-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB8:	descr = "8-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SBGGR10:	descr = "10-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG10:	descr = "10-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG10:	descr = "10-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB10:	descr = "10-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SBGGR12:	descr = "12-bit Bayer BGBG/GRGR"; break;
+	case V4L2_PIX_FMT_SGBRG12:	descr = "12-bit Bayer GBGB/RGRG"; break;
+	case V4L2_PIX_FMT_SGRBG12:	descr = "12-bit Bayer GRGR/BGBG"; break;
+	case V4L2_PIX_FMT_SRGGB12:	descr = "12-bit Bayer RGRG/GBGB"; break;
+	case V4L2_PIX_FMT_SBGGR10P:	descr = "10-bit Bayer BGBG/GRGR Packed"; break;
+	case V4L2_PIX_FMT_SGBRG10P:	descr = "10-bit Bayer GBGB/RGRG Packed"; break;
+	case V4L2_PIX_FMT_SGRBG10P:	descr = "10-bit Bayer GRGR/BGBG Packed"; break;
+	case V4L2_PIX_FMT_SRGGB10P:	descr = "10-bit Bayer RGRG/GBGB Packed"; break;
+	case V4L2_PIX_FMT_SBGGR10ALAW8:	descr = "8-bit Bayer BGBG/GRGR (A-law)"; break;
+	case V4L2_PIX_FMT_SGBRG10ALAW8:	descr = "8-bit Bayer GBGB/RGRG (A-law)"; break;
+	case V4L2_PIX_FMT_SGRBG10ALAW8:	descr = "8-bit Bayer GRGR/BGBG (A-law)"; break;
+	case V4L2_PIX_FMT_SRGGB10ALAW8:	descr = "8-bit Bayer RGRG/GBGB (A-law)"; break;
+	case V4L2_PIX_FMT_SBGGR10DPCM8:	descr = "8-bit Bayer BGBG/GRGR (DPCM)"; break;
+	case V4L2_PIX_FMT_SGBRG10DPCM8:	descr = "8-bit Bayer GBGB/RGRG (DPCM)"; break;
+	case V4L2_PIX_FMT_SGRBG10DPCM8:	descr = "8-bit Bayer GRGR/BGBG (DPCM)"; break;
+	case V4L2_PIX_FMT_SRGGB10DPCM8:	descr = "8-bit Bayer RGRG/GBGB (DPCM)"; break;
+	case V4L2_PIX_FMT_SBGGR16:	descr = "16-bit Bayer BGBG/GRGR (Exp.)"; break;
+	case V4L2_PIX_FMT_SN9C20X_I420:	descr = "GSPCA SN9C20X I420";
+	case V4L2_PIX_FMT_SPCA501:	descr = "GSPCA SPCA501"; break;
+	case V4L2_PIX_FMT_SPCA505:	descr = "GSPCA SPCA505"; break;
+	case V4L2_PIX_FMT_SPCA508:	descr = "GSPCA SPCA508"; break;
+	case V4L2_PIX_FMT_STV0680:	descr = "GSPCA STV0680"; break;
+	case V4L2_PIX_FMT_TM6000:	descr = "A/V + VBI Mux Packet"; break;
+	case V4L2_PIX_FMT_CIT_YYVYUY:	descr = "GSPCA CIT YYVYUY"; break;
+	case V4L2_PIX_FMT_KONICA420:	descr = "GSPCA KONICA420"; break;
+	case V4L2_SDR_FMT_CU8:		descr = "Complex U8 (Emulated)"; break;
+	case V4L2_SDR_FMT_CU16LE:	descr = "Complex U16LE (Emulated)"; break;
+	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
+	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
+	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
+
+	default:
+		/* Compressed formats */
+		flags = V4L2_FMT_FLAG_COMPRESSED;
+		switch (fmt->pixelformat) {
+		/* Max description length mask:	descr = "0123456789012345678901234567890" */
+		case V4L2_PIX_FMT_MJPEG:	descr = "Motion-JPEG"; break;
+		case V4L2_PIX_FMT_JPEG:		descr = "JFIF JPEG"; break;
+		case V4L2_PIX_FMT_DV:		descr = "1394"; break;
+		case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
+		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
+		case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
+		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
+		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
+		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
+		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
+		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
+		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
+		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
+		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
+		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
+		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
+		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
+		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
+		case V4L2_PIX_FMT_PWC1:		descr = "Raw Philips Webcam Type (Old)"; break;
+		case V4L2_PIX_FMT_PWC2:		descr = "Raw Philips Webcam Type (New)"; break;
+		case V4L2_PIX_FMT_ET61X251:	descr = "GSPCA ET61X251"; break;
+		case V4L2_PIX_FMT_SPCA561:	descr = "GSPCA SPCA561"; break;
+		case V4L2_PIX_FMT_PAC207:	descr = "GSPCA PAC207"; break;
+		case V4L2_PIX_FMT_MR97310A:	descr = "GSPCA MR97310A"; break;
+		case V4L2_PIX_FMT_JL2005BCD:	descr = "GSPCA JL2005BCD"; break;
+		case V4L2_PIX_FMT_SN9C2028:	descr = "GSPCA SN9C2028"; break;
+		case V4L2_PIX_FMT_SQ905C:	descr = "GSPCA SQ905C"; break;
+		case V4L2_PIX_FMT_PJPG:		descr = "GSPCA PJPG"; break;
+		case V4L2_PIX_FMT_OV511:	descr = "GSPCA OV511"; break;
+		case V4L2_PIX_FMT_OV518:	descr = "GSPCA OV518"; break;
+		case V4L2_PIX_FMT_JPGL:		descr = "JPEG Lite"; break;
+		case V4L2_PIX_FMT_SE401:	descr = "GSPCA SE401"; break;
+		case V4L2_PIX_FMT_S5C_UYVY_JPG:	descr = "S5C73MX interleaved UYVY/JPEG"; break;
+		default:
+			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
+			if (fmt->description[0])
+				return;
+			flags = 0;
+			snprintf(fmt->description, sz, "%c%c%c%c%s",
+					(char)(fmt->pixelformat & 0x7f),
+					(char)((fmt->pixelformat >> 8) & 0x7f),
+					(char)((fmt->pixelformat >> 16) & 0x7f),
+					(char)((fmt->pixelformat >> 24) & 0x7f),
+					(fmt->pixelformat & (1 << 31)) ? "-BE" : "");
+			break;
+		}
+	}
+
+	if (descr)
+		WARN_ON(strlcpy(fmt->description, descr, sz) >= sz);
+	fmt->flags = flags;
+}
+
 static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1112,34 +1288,43 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
+	int ret = -EINVAL;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap))
 			break;
-		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
+		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap_mplane))
 			break;
-		return ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
+		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_overlay))
 			break;
-		return ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
+		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out))
 			break;
-		return ops->vidioc_enum_fmt_vid_out(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_out(file, fh, arg);
+		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
-		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+		break;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_enum_fmt_sdr_cap))
 			break;
-		return ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
+		break;
 	}
-	return -EINVAL;
+	if (ret == 0)
+		v4l_fill_fmtdesc(p);
+	return ret;
 }
 
 static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
-- 
2.1.4

