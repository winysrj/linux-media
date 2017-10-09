Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59614 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbdJIKTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 11/24] media: v4l2-subdev: create cross-references for ioctls
Date: Mon,  9 Oct 2017 07:19:17 -0300
Message-Id: <70bc13a95be8ef7e5f8178eb9c859cf06c72e1b2.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When generating Sphinx output, create cross-references for the
callbacks for each ioctl.

While here, fix a few wrong names for ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 65 ++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6286c69a12ba..b299cf63972b 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -141,7 +141,7 @@ struct v4l2_subdev_io_pin_config {
 /**
  * struct v4l2_subdev_core_ops - Define core ops callbacks for subdevs
  *
- * @log_status: callback for %VIDIOC_LOG_STATUS ioctl handler code.
+ * @log_status: callback for VIDIOC_LOG_STATUS() ioctl handler code.
  *
  * @s_io_pin_config: configure one or more chip I/O pins for chips that
  *	multiplex different internal signal pads out to IO pins.  This function
@@ -169,9 +169,9 @@ struct v4l2_subdev_io_pin_config {
  * @compat_ioctl32: called when a 32 bits application uses a 64 bits Kernel,
  *		    in order to fix data passed from/to userspace.
  *
- * @g_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
+ * @g_register: callback for VIDIOC_DBG_G_REGISTER() ioctl handler code.
  *
- * @s_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
+ * @s_register: callback for VIDIOC_DBG_S_REGISTER() ioctl handler code.
  *
  * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
  *	mode (on == 1).
@@ -216,25 +216,25 @@ struct v4l2_subdev_core_ops {
  * struct v4l2_subdev_tuner_ops - Callbacks used when v4l device was opened
  *	in radio mode.
  *
- * @s_radio: callback for %VIDIOC_S_RADIO ioctl handler code.
+ * @s_radio: callback for VIDIOC_S_RADIO() ioctl handler code.
  *
- * @s_frequency: callback for %VIDIOC_S_FREQUENCY ioctl handler code.
+ * @s_frequency: callback for VIDIOC_S_FREQUENCY() ioctl handler code.
  *
- * @g_frequency: callback for %VIDIOC_G_FREQUENCY ioctl handler code.
+ * @g_frequency: callback for VIDIOC_G_FREQUENCY() ioctl handler code.
  *		 freq->type must be filled in. Normally done by video_ioctl2()
  *		 or the bridge driver.
  *
- * @enum_freq_bands: callback for %VIDIOC_ENUM_FREQ_BANDS ioctl handler code.
+ * @enum_freq_bands: callback for VIDIOC_ENUM_FREQ_BANDS() ioctl handler code.
  *
- * @g_tuner: callback for %VIDIOC_G_TUNER ioctl handler code.
+ * @g_tuner: callback for VIDIOC_G_TUNER() ioctl handler code.
  *
- * @s_tuner: callback for %VIDIOC_S_TUNER ioctl handler code. @vt->type must be
+ * @s_tuner: callback for VIDIOC_S_TUNER() ioctl handler code. @vt->type must be
  *	     filled in. Normally done by video_ioctl2 or the
  *	     bridge driver.
  *
- * @g_modulator: callback for %VIDIOC_G_MODULATOR ioctl handler code.
+ * @g_modulator: callback for VIDIOC_G_MODULATOR() ioctl handler code.
  *
- * @s_modulator: callback for %VIDIOC_S_MODULATOR ioctl handler code.
+ * @s_modulator: callback for VIDIOC_S_MODULATOR() ioctl handler code.
  *
  * @s_type_addr: sets tuner type and its I2C addr.
  *
@@ -333,9 +333,9 @@ struct v4l2_mbus_frame_desc {
  *	regarding clock frequency dividers, etc. If not used, then set flags
  *	to 0. If the frequency is not supported, then -EINVAL is returned.
  *
- * @g_std: callback for %VIDIOC_G_STD ioctl handler code.
+ * @g_std: callback for VIDIOC_G_STD() ioctl handler code.
  *
- * @s_std: callback for %VIDIOC_S_STD ioctl handler code.
+ * @s_std: callback for VIDIOC_S_STD() ioctl handler code.
  *
  * @s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
  *	video input devices.
@@ -343,7 +343,7 @@ struct v4l2_mbus_frame_desc {
  * @g_std_output: get current standard for video OUTPUT devices. This is ignored
  *	by video input devices.
  *
- * @querystd: callback for %VIDIOC_QUERYSTD ioctl handler code.
+ * @querystd: callback for VIDIOC_QUERYSTD() ioctl handler code.
  *
  * @g_tvnorms: get &v4l2_std_id with all standards supported by the video
  *	CAPTURE device. This is ignored by video output devices.
@@ -359,13 +359,15 @@ struct v4l2_mbus_frame_desc {
  *
  * @g_pixelaspect: callback to return the pixelaspect ratio.
  *
- * @g_parm: callback for %VIDIOC_G_PARM ioctl handler code.
+ * @g_parm: callback for VIDIOC_G_PARM() ioctl handler code.
  *
- * @s_parm: callback for %VIDIOC_S_PARM ioctl handler code.
+ * @s_parm: callback for VIDIOC_S_PARM() ioctl handler code.
  *
- * @g_frame_interval: callback for %VIDIOC_G_FRAMEINTERVAL ioctl handler code.
+ * @g_frame_interval: callback for VIDIOC_SUBDEV_G_FRAME_INTERVAL()
+ *		      ioctl handler code.
  *
- * @s_frame_interval: callback for %VIDIOC_S_FRAMEINTERVAL ioctl handler code.
+ * @s_frame_interval: callback for VIDIOC_SUBDEV_S_FRAME_INTERVAL()
+ *		      ioctl handler code.
  *
  * @s_dv_timings: Set custom dv timings in the sub device. This is used
  *	when sub device is capable of setting detailed timing information
@@ -373,7 +375,7 @@ struct v4l2_mbus_frame_desc {
  *
  * @g_dv_timings: Get custom dv timings in the sub device.
  *
- * @query_dv_timings: callback for %VIDIOC_QUERY_DV_TIMINGS ioctl handler code.
+ * @query_dv_timings: callback for VIDIOC_QUERY_DV_TIMINGS() ioctl handler code.
  *
  * @g_mbus_config: get supported mediabus configurations
  *
@@ -444,7 +446,8 @@ struct v4l2_subdev_video_ops {
  *	member (to determine whether CC data from the first or second field
  *	should be obtained).
  *
- * @g_sliced_vbi_cap: callback for %VIDIOC_SLICED_VBI_CAP ioctl handler code.
+ * @g_sliced_vbi_cap: callback for VIDIOC_G_SLICED_VBI_CAP() ioctl handler
+ *		      code.
  *
  * @s_raw_fmt: setup the video encoder/decoder for raw VBI.
  *
@@ -611,30 +614,30 @@ struct v4l2_subdev_pad_config {
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
  *
  * @init_cfg: initialize the pad config to default values
- * @enum_mbus_code: callback for %VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
+ * @enum_mbus_code: callback for VIDIOC_SUBDEV_ENUM_MBUS_CODE() ioctl handler
  *		    code.
- * @enum_frame_size: callback for %VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
+ * @enum_frame_size: callback for VIDIOC_SUBDEV_ENUM_FRAME_SIZE() ioctl handler
  *		     code.
  *
- * @enum_frame_interval: callback for %VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL ioctl
+ * @enum_frame_interval: callback for VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL() ioctl
  *			 handler code.
  *
- * @get_fmt: callback for %VIDIOC_SUBDEV_G_FMT ioctl handler code.
+ * @get_fmt: callback for VIDIOC_SUBDEV_G_FMT() ioctl handler code.
  *
- * @set_fmt: callback for %VIDIOC_SUBDEV_S_FMT ioctl handler code.
+ * @set_fmt: callback for VIDIOC_SUBDEV_S_FMT() ioctl handler code.
  *
- * @get_selection: callback for %VIDIOC_SUBDEV_G_SELECTION ioctl handler code.
+ * @get_selection: callback for VIDIOC_SUBDEV_G_SELECTION() ioctl handler code.
  *
- * @set_selection: callback for %VIDIOC_SUBDEV_S_SELECTION ioctl handler code.
+ * @set_selection: callback for VIDIOC_SUBDEV_S_SELECTION() ioctl handler code.
  *
- * @get_edid: callback for %VIDIOC_SUBDEV_G_EDID ioctl handler code.
+ * @get_edid: callback for VIDIOC_SUBDEV_G_EDID() ioctl handler code.
  *
- * @set_edid: callback for %VIDIOC_SUBDEV_S_EDID ioctl handler code.
+ * @set_edid: callback for VIDIOC_SUBDEV_S_EDID() ioctl handler code.
  *
- * @dv_timings_cap: callback for %VIDIOC_SUBDEV_DV_TIMINGS_CAP ioctl handler
+ * @dv_timings_cap: callback for VIDIOC_SUBDEV_DV_TIMINGS_CAP() ioctl handler
  *		    code.
  *
- * @enum_dv_timings: callback for %VIDIOC_SUBDEV_ENUM_DV_TIMINGS ioctl handler
+ * @enum_dv_timings: callback for VIDIOC_SUBDEV_ENUM_DV_TIMINGS() ioctl handler
  *		     code.
  *
  * @link_validate: used by the media controller code to check if the links
-- 
2.13.6
