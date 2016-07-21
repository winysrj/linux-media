Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbcGUUS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Subject: [PATCH 06/12] [media] v4l2-subdev.h: Improve documentation
Date: Thu, 21 Jul 2016 17:18:11 -0300
Message-Id: <fadadab43aa7474eb8a3a11f3f45ef8c3cc2af18.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This header were poorly documented, and weren't using the
kernel-doc format. Document everything but the macros using
the right format.

While here, also fix the other comments to match the
Linux CodingStyle.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c |  10 -
 include/media/v4l2-subdev.h           | 586 ++++++++++++++++++++++------------
 2 files changed, 390 insertions(+), 206 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 953eab08e420..34a1e7c8b306 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -621,16 +621,6 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
 
-/**
- * v4l2_subdev_notify_event() - Delivers event notification for subdevice
- * @sd: The subdev for which to deliver the event
- * @ev: The event to deliver
- *
- * Will deliver the specified event to all userspace event listeners which are
- * subscribed to the v42l subdev event queue as well as to the bridge driver
- * using the notify callback. The notification type for the notify callback
- * will be V4L2_DEVICE_NOTIFY_EVENT.
- */
 void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 			      const struct v4l2_event *ev)
 {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 4c880e86a1aa..996e1590cf32 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1,21 +1,17 @@
 /*
-    V4L2 sub-device support header.
-
-    Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  V4L2 sub-device support header.
+ *
+ *  Copyright (C) 2008  Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  */
 
 #ifndef _V4L2_SUBDEV_H
@@ -52,55 +48,64 @@ struct v4l2_subdev_fh;
 struct tuner_setup;
 struct v4l2_mbus_frame_desc;
 
-/* decode_vbi_line */
+/**
+ * struct v4l2_decode_vbi_line - used to decode_vbi_line
+ *
+ * @is_second_field: Set to 0 for the first (odd) field;
+ *	set to 1 for the second (even) field.
+ * @p: Pointer to the sliced VBI data from the decoder. On exit, points to
+ *	the start of the payload.
+ * @line: Line number of the sliced VBI data (1-23)
+ * @type: VBI service type (V4L2_SLICED_*). 0 if no service found
+ */
 struct v4l2_decode_vbi_line {
-	u32 is_second_field;	/* Set to 0 for the first (odd) field,
-				   set to 1 for the second (even) field. */
-	u8 *p; 			/* Pointer to the sliced VBI data from the decoder.
-				   On exit points to the start of the payload. */
-	u32 line;		/* Line number of the sliced VBI data (1-23) */
-	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found */
+	u32 is_second_field;
+	u8 *p;
+	u32 line;
+	u32 type;
 };
 
-/* Sub-devices are devices that are connected somehow to the main bridge
-   device. These devices are usually audio/video muxers/encoders/decoders or
-   sensors and webcam controllers.
-
-   Usually these devices are controlled through an i2c bus, but other busses
-   may also be used.
-
-   The v4l2_subdev struct provides a way of accessing these devices in a
-   generic manner. Most operations that these sub-devices support fall in
-   a few categories: core ops, audio ops, video ops and tuner ops.
-
-   More categories can be added if needed, although this should remain a
-   limited set (no more than approx. 8 categories).
-
-   Each category has its own set of ops that subdev drivers can implement.
-
-   A subdev driver can leave the pointer to the category ops NULL if
-   it does not implement them (e.g. an audio subdev will generally not
-   implement the video category ops). The exception is the core category:
-   this must always be present.
-
-   These ops are all used internally so it is no problem to change, remove
-   or add ops or move ops from one to another category. Currently these
-   ops are based on the original ioctls, but since ops are not limited to
-   one argument there is room for improvement here once all i2c subdev
-   drivers are converted to use these ops.
+/*
+ * Sub-devices are devices that are connected somehow to the main bridge
+ * device. These devices are usually audio/video muxers/encoders/decoders or
+ * sensors and webcam controllers.
+ *
+ * Usually these devices are controlled through an i2c bus, but other busses
+ * may also be used.
+ *
+ * The v4l2_subdev struct provides a way of accessing these devices in a
+ * generic manner. Most operations that these sub-devices support fall in
+ * a few categories: core ops, audio ops, video ops and tuner ops.
+ *
+ * More categories can be added if needed, although this should remain a
+ * limited set (no more than approx. 8 categories).
+ *
+ * Each category has its own set of ops that subdev drivers can implement.
+ *
+ * A subdev driver can leave the pointer to the category ops NULL if
+ * it does not implement them (e.g. an audio subdev will generally not
+ * implement the video category ops). The exception is the core category:
+ * this must always be present.
+ *
+ * These ops are all used internally so it is no problem to change, remove
+ * or add ops or move ops from one to another category. Currently these
+ * ops are based on the original ioctls, but since ops are not limited to
+ * one argument there is room for improvement here once all i2c subdev
+ * drivers are converted to use these ops.
  */
 
-/* Core ops: it is highly recommended to implement at least these ops:
-
-   log_status
-   g_register
-   s_register
-
-   This provides basic debugging support.
-
-   The ioctl ops is meant for generic ioctl-like commands. Depending on
-   the use-case it might be better to use subdev-specific ops (currently
-   not yet implemented) since ops provide proper type-checking.
+/*
+ * Core ops: it is highly recommended to implement at least these ops:
+ *
+ * log_status
+ * g_register
+ * s_register
+ *
+ * This provides basic debugging support.
+ *
+ * The ioctl ops is meant for generic ioctl-like commands. Depending on
+ * the use-case it might be better to use subdev-specific ops (currently
+ * not yet implemented) since ops provide proper type-checking.
  */
 
 /* Subdevice external IO pin configuration */
@@ -110,18 +115,32 @@ struct v4l2_decode_vbi_line {
 #define V4L2_SUBDEV_IO_PIN_SET_VALUE	(1 << 3) /* Set output value */
 #define V4L2_SUBDEV_IO_PIN_ACTIVE_LOW	(1 << 4) /* ACTIVE HIGH assumed */
 
+/**
+ * struct v4l2_subdev_io_pin_config - Subdevice external IO pin configuration
+ *
+ * @flags: bitmask with flags for this pin's config:
+ *	   %V4L2_SUBDEV_IO_PIN_DISABLE - disables a pin config,
+ *	   %V4L2_SUBDEV_IO_PIN_OUTPUT - if pin is an output,
+ *	   %V4L2_SUBDEV_IO_PIN_INPUT - if pin is an input,
+ *	   %V4L2_SUBDEV_IO_PIN_SET_VALUE - to set the output value via @value
+ *	   and %V4L2_SUBDEV_IO_PIN_ACTIVE_LOW - if active is 0.
+ * @pin: Chip external IO pin to configure
+ * @function: Internal signal pad/function to route to IO pin
+ * @value: Initial value for pin - e.g. GPIO output value
+ * @strength: Pin drive strength
+ */
 struct v4l2_subdev_io_pin_config {
-	u32 flags;	/* V4L2_SUBDEV_IO_PIN_* flags for this pin's config */
-	u8 pin;		/* Chip external IO pin to configure */
-	u8 function;	/* Internal signal pad/function to route to IO pin */
-	u8 value;	/* Initial value for pin - e.g. GPIO output value */
-	u8 strength;	/* Pin drive strength */
+	u32 flags;
+	u8 pin;
+	u8 function;
+	u8 value;
+	u8 strength;
 };
 
 /**
  * struct v4l2_subdev_core_ops - Define core ops callbacks for subdevs
  *
- * @log_status: callback for VIDIOC_LOG_STATUS ioctl handler code.
+ * @log_status: callback for %VIDIOC_LOG_STATUS ioctl handler code.
  *
  * @s_io_pin_config: configure one or more chip I/O pins for chips that
  *	multiplex different internal signal pads out to IO pins.  This function
@@ -143,19 +162,19 @@ struct v4l2_subdev_io_pin_config {
  * @s_gpio: set GPIO pins. Very simple right now, might need to be extended with
  *	a direction argument if needed.
  *
- * @queryctrl: callback for VIDIOC_QUERYCTL ioctl handler code.
+ * @queryctrl: callback for %VIDIOC_QUERYCTL ioctl handler code.
  *
- * @g_ctrl: callback for VIDIOC_G_CTRL ioctl handler code.
+ * @g_ctrl: callback for %VIDIOC_G_CTRL ioctl handler code.
  *
- * @s_ctrl: callback for VIDIOC_S_CTRL ioctl handler code.
+ * @s_ctrl: callback for %VIDIOC_S_CTRL ioctl handler code.
  *
- * @g_ext_ctrls: callback for VIDIOC_G_EXT_CTRLS ioctl handler code.
+ * @g_ext_ctrls: callback for %VIDIOC_G_EXT_CTRLS ioctl handler code.
  *
- * @s_ext_ctrls: callback for VIDIOC_S_EXT_CTRLS ioctl handler code.
+ * @s_ext_ctrls: callback for %VIDIOC_S_EXT_CTRLS ioctl handler code.
  *
- * @try_ext_ctrls: callback for VIDIOC_TRY_EXT_CTRLS ioctl handler code.
+ * @try_ext_ctrls: callback for %VIDIOC_TRY_EXT_CTRLS ioctl handler code.
  *
- * @querymenu: callback for VIDIOC_QUERYMENU ioctl handler code.
+ * @querymenu: callback for %VIDIOC_QUERYMENU ioctl handler code.
  *
  * @ioctl: called at the end of ioctl() syscall handler at the V4L2 core.
  *	   used to provide support for private ioctls used on the driver.
@@ -163,9 +182,9 @@ struct v4l2_subdev_io_pin_config {
  * @compat_ioctl32: called when a 32 bits application uses a 64 bits Kernel,
  *		    in order to fix data passed from/to userspace.
  *
- * @g_register: callback for VIDIOC_G_REGISTER ioctl handler code.
+ * @g_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
  *
- * @s_register: callback for VIDIOC_G_REGISTER ioctl handler code.
+ * @s_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
  *
  * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
  *	mode (on == 1).
@@ -173,7 +192,7 @@ struct v4l2_subdev_io_pin_config {
  * @interrupt_service_routine: Called by the bridge chip's interrupt service
  *	handler, when an interrupt status has be raised due to this subdev,
  *	so that this subdev can handle the details.  It may schedule work to be
- *	performed later.  It must not sleep.  *Called from an IRQ context*.
+ *	performed later.  It must not sleep. **Called from an IRQ context**.
  *
  * @subscribe_event: used by the drivers to request the control framework that
  *		     for it to be warned when the value of a control changes.
@@ -219,25 +238,25 @@ struct v4l2_subdev_core_ops {
 /**
  * struct s_radio - Callbacks used when v4l device was opened in radio mode.
  *
- * @s_radio: callback for VIDIOC_S_RADIO ioctl handler code.
+ * @s_radio: callback for %VIDIOC_S_RADIO ioctl handler code.
  *
- * @s_frequency: callback for VIDIOC_S_FREQUENCY ioctl handler code.
+ * @s_frequency: callback for %VIDIOC_S_FREQUENCY ioctl handler code.
  *
- * @g_frequency: callback for VIDIOC_G_FREQUENCY ioctl handler code.
- *		 freq->type must be filled in. Normally done by video_ioctl2
+ * @g_frequency: callback for %VIDIOC_G_FREQUENCY ioctl handler code.
+ *		 freq->type must be filled in. Normally done by video_ioctl2()
  *		 or the bridge driver.
  *
- * @enum_freq_bands: callback for VIDIOC_ENUM_FREQ_BANDS ioctl handler code.
+ * @enum_freq_bands: callback for %VIDIOC_ENUM_FREQ_BANDS ioctl handler code.
  *
- * @g_tuner: callback for VIDIOC_G_TUNER ioctl handler code.
+ * @g_tuner: callback for %VIDIOC_G_TUNER ioctl handler code.
  *
- * @s_tuner: callback for VIDIOC_S_TUNER ioctl handler code. vt->type must be
+ * @s_tuner: callback for %VIDIOC_S_TUNER ioctl handler code. &vt->type must be
  *	     filled in. Normally done by video_ioctl2 or the
  *	     bridge driver.
  *
- * @g_modulator: callback for VIDIOC_G_MODULATOR ioctl handler code.
+ * @g_modulator: callback for %VIDIOC_G_MODULATOR ioctl handler code.
  *
- * @s_modulator: callback for VIDIOC_S_MODULATOR ioctl handler code.
+ * @s_modulator: callback for %VIDIOC_S_MODULATOR ioctl handler code.
  *
  * @s_type_addr: sets tuner type and its I2C addr.
  *
@@ -268,7 +287,7 @@ struct v4l2_subdev_tuner_ops {
  * @s_i2s_clock_freq: sets I2S speed in bps. This is used to provide a standard
  *	way to select I2S clock used by driving digital audio streams at some
  *	board designs. Usual values for the frequency are 1024000 and 2048000.
- *	If the frequency is not supported, then -EINVAL is returned.
+ *	If the frequency is not supported, then %-EINVAL is returned.
  *
  * @s_routing: used to define the input and/or output pins of an audio chip,
  *	and any additional configuration data.
@@ -300,7 +319,8 @@ struct v4l2_subdev_audio_ops {
 /**
  * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
  *
- * @flags: V4L2_MBUS_FRAME_DESC_FL_* flags
+ * @flags: bitmask flags: %V4L2_MBUS_FRAME_DESC_FL_LEN_MAX and
+ *			  %V4L2_MBUS_FRAME_DESC_FL_BLOB.
  * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
  * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB
  *	    is set
@@ -325,7 +345,7 @@ struct v4l2_mbus_frame_desc {
 
 /**
  * struct v4l2_subdev_video_ops - Callbacks used when v4l device was opened
- * 				  in video mode.
+ *				  in video mode.
  *
  * @s_routing: see s_routing in audio_ops, except this version is for video
  *	devices.
@@ -335,9 +355,9 @@ struct v4l2_mbus_frame_desc {
  *	regarding clock frequency dividers, etc. If not used, then set flags
  *	to 0. If the frequency is not supported, then -EINVAL is returned.
  *
- * @g_std: callback for VIDIOC_G_STD ioctl handler code.
+ * @g_std: callback for %VIDIOC_G_STD ioctl handler code.
  *
- * @s_std: callback for VIDIOC_S_STD ioctl handler code.
+ * @s_std: callback for %VIDIOC_S_STD ioctl handler code.
  *
  * @s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
  *	video input devices.
@@ -345,33 +365,33 @@ struct v4l2_mbus_frame_desc {
  * @g_std_output: get current standard for video OUTPUT devices. This is ignored
  *	by video input devices.
  *
- * @querystd: callback for VIDIOC_QUERYSTD ioctl handler code.
+ * @querystd: callback for %VIDIOC_QUERYSTD ioctl handler code.
  *
- * @g_tvnorms: get v4l2_std_id with all standards supported by the video
+ * @g_tvnorms: get &v4l2_std_id with all standards supported by the video
  *	CAPTURE device. This is ignored by video output devices.
  *
  * @g_tvnorms_output: get v4l2_std_id with all standards supported by the video
  *	OUTPUT device. This is ignored by video capture devices.
  *
- * @g_input_status: get input status. Same as the status field in the v4l2_input
- *	struct.
+ * @g_input_status: get input status. Same as the status field in the
+ *	&struct &v4l2_input
  *
  * @s_stream: used to notify the driver that a video stream will start or has
  *	stopped.
  *
- * @cropcap: callback for VIDIOC_CROPCAP ioctl handler code.
+ * @cropcap: callback for %VIDIOC_CROPCAP ioctl handler code.
  *
- * @g_crop: callback for VIDIOC_G_CROP ioctl handler code.
+ * @g_crop: callback for %VIDIOC_G_CROP ioctl handler code.
  *
- * @s_crop: callback for VIDIOC_S_CROP ioctl handler code.
+ * @s_crop: callback for %VIDIOC_S_CROP ioctl handler code.
  *
- * @g_parm: callback for VIDIOC_G_PARM ioctl handler code.
+ * @g_parm: callback for %VIDIOC_G_PARM ioctl handler code.
  *
- * @s_parm: callback for VIDIOC_S_PARM ioctl handler code.
+ * @s_parm: callback for %VIDIOC_S_PARM ioctl handler code.
  *
- * @g_frame_interval: callback for VIDIOC_G_FRAMEINTERVAL ioctl handler code.
+ * @g_frame_interval: callback for %VIDIOC_G_FRAMEINTERVAL ioctl handler code.
  *
- * @s_frame_interval: callback for VIDIOC_S_FRAMEINTERVAL ioctl handler code.
+ * @s_frame_interval: callback for %VIDIOC_S_FRAMEINTERVAL ioctl handler code.
  *
  * @s_dv_timings: Set custom dv timings in the sub device. This is used
  *	when sub device is capable of setting detailed timing information
@@ -379,7 +399,7 @@ struct v4l2_mbus_frame_desc {
  *
  * @g_dv_timings: Get custom dv timings in the sub device.
  *
- * @query_dv_timings: callback for VIDIOC_QUERY_DV_TIMINGS ioctl handler code.
+ * @query_dv_timings: callback for %VIDIOC_QUERY_DV_TIMINGS ioctl handler code.
  *
  * @g_mbus_config: get supported mediabus configurations
  *
@@ -428,31 +448,31 @@ struct v4l2_subdev_video_ops {
 
 /**
  * struct v4l2_subdev_vbi_ops - Callbacks used when v4l device was opened
- * 				  in video mode via the vbi device node.
+ *				  in video mode via the vbi device node.
  *
  *  @decode_vbi_line: video decoders that support sliced VBI need to implement
- *	this ioctl. Field p of the v4l2_sliced_vbi_line struct is set to the
+ *	this ioctl. Field p of the &struct v4l2_sliced_vbi_line is set to the
  *	start of the VBI data that was generated by the decoder. The driver
  *	then parses the sliced VBI data and sets the other fields in the
  *	struct accordingly. The pointer p is updated to point to the start of
  *	the payload which can be copied verbatim into the data field of the
- *	v4l2_sliced_vbi_data struct. If no valid VBI data was found, then the
+ *	&struct v4l2_sliced_vbi_data. If no valid VBI data was found, then the
  *	type field is set to 0 on return.
  *
  * @s_vbi_data: used to generate VBI signals on a video signal.
- *	v4l2_sliced_vbi_data is filled with the data packets that should be
- *	output. Note that if you set the line field to 0, then that VBI signal
- *	is disabled. If no valid VBI data was found, then the type field is
- *	set to 0 on return.
+ *	&struct v4l2_sliced_vbi_data is filled with the data packets that
+ *	should be output. Note that if you set the line field to 0, then that
+ *	VBI signal is disabled. If no valid VBI data was found, then the type
+ *	field is set to 0 on return.
  *
  * @g_vbi_data: used to obtain the sliced VBI packet from a readback register.
  *	Not all video decoders support this. If no data is available because
- *	the readback register contains invalid or erroneous data -EIO is
+ *	the readback register contains invalid or erroneous data %-EIO is
  *	returned. Note that you must fill in the 'id' member and the 'field'
  *	member (to determine whether CC data from the first or second field
  *	should be obtained).
  *
- * @g_sliced_vbi_cap: callback for VIDIOC_SLICED_VBI_CAP ioctl handler code.
+ * @g_sliced_vbi_cap: callback for %VIDIOC_SLICED_VBI_CAP ioctl handler code.
  *
  * @s_raw_fmt: setup the video encoder/decoder for raw VBI.
  *
@@ -485,58 +505,99 @@ struct v4l2_subdev_sensor_ops {
 	int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);
 };
 
-/*
-   [rt]x_g_parameters: Get the current operating parameters and state of the
-	the IR receiver or transmitter.
-
-   [rt]x_s_parameters: Set the current operating parameters and state of the
-	the IR receiver or transmitter.  It is recommended to call
-	[rt]x_g_parameters first to fill out the current state, and only change
-	the fields that need to be changed.  Upon return, the actual device
-	operating parameters and state will be returned.  Note that hardware
-	limitations may prevent the actual settings from matching the requested
-	settings - e.g. an actual carrier setting of 35,904 Hz when 36,000 Hz
-	was requested.  An exception is when the shutdown parameter is true.
-	The last used operational parameters will be returned, but the actual
-	state of the hardware be different to minimize power consumption and
-	processing when shutdown is true.
-
-   rx_read: Reads received codes or pulse width data.
-	The semantics are similar to a non-blocking read() call.
-
-   tx_write: Writes codes or pulse width data for transmission.
-	The semantics are similar to a non-blocking write() call.
+/**
+ * enum v4l2_subdev_ir_mode- describes the type of IR supported
+ *
+ * @V4L2_SUBDEV_IR_MODE_PULSE_WIDTH: IR uses struct ir_raw_event records
  */
-
 enum v4l2_subdev_ir_mode {
-	V4L2_SUBDEV_IR_MODE_PULSE_WIDTH, /* uses struct ir_raw_event records */
+	V4L2_SUBDEV_IR_MODE_PULSE_WIDTH,
 };
 
+/**
+ * struct v4l2_subdev_ir_parameters - Parameters for IR TX or TX
+ *
+ * @bytes_per_data_element: bytes per data element of data in read or
+ *	write call.
+ * @mode: IR mode as defined by &enum v4l2_subdev_ir_mode.
+ * @enable: device is active if true
+ * @interrupt_enable: IR interrupts are enabled if true
+ * @shutdown: if true: set hardware to low/no power, false: normal mode
+ *
+ * @modulation: if true, it uses carrier, if false: baseband
+ * @max_pulse_width:  maximum pulse width in ns, valid only for baseband signal
+ * @carrier_freq: carrier frequency in Hz, valid only for modulated signal
+ * @duty_cycle: duty cycle percentage, valid only for modulated signal
+ * @invert_level: invert signal level
+ *
+ * @invert_carrier_sense: Send 0/space as a carrier burst. used only in TX.
+ *
+ * @noise_filter_min_width: min time of a valid pulse, in ns. Used only for RX.
+ * @carrier_range_lower: Lower carrier range, in Hz, valid only for modulated
+ *	signal. Used only for RX.
+ * @carrier_range_upper: Upper carrier range, in Hz, valid only for modulated
+ *	signal. Used only for RX.
+ * @resolution: The receive resolution, in ns . Used only for RX.
+ */
 struct v4l2_subdev_ir_parameters {
-	/* Either Rx or Tx */
-	unsigned int bytes_per_data_element; /* of data in read or write call */
+	unsigned int bytes_per_data_element;
 	enum v4l2_subdev_ir_mode mode;
 
 	bool enable;
 	bool interrupt_enable;
-	bool shutdown; /* true: set hardware to low/no power, false: normal */
+	bool shutdown;
 
-	bool modulation;           /* true: uses carrier, false: baseband */
-	u32 max_pulse_width;       /* ns,      valid only for baseband signal */
-	unsigned int carrier_freq; /* Hz,      valid only for modulated signal*/
-	unsigned int duty_cycle;   /* percent, valid only for modulated signal*/
-	bool invert_level;	   /* invert signal level */
+	bool modulation;
+	u32 max_pulse_width;
+	unsigned int carrier_freq;
+	unsigned int duty_cycle;
+	bool invert_level;
 
 	/* Tx only */
-	bool invert_carrier_sense; /* Send 0/space as a carrier burst */
+	bool invert_carrier_sense;
 
 	/* Rx only */
-	u32 noise_filter_min_width;       /* ns, min time of a valid pulse */
-	unsigned int carrier_range_lower; /* Hz, valid only for modulated sig */
-	unsigned int carrier_range_upper; /* Hz, valid only for modulated sig */
-	u32 resolution;                   /* ns */
+	u32 noise_filter_min_width;
+	unsigned int carrier_range_lower;
+	unsigned int carrier_range_upper;
+	u32 resolution;
 };
 
+/**
+ * struct v4l2_subdev_ir_ops - operations for IR subdevices
+ *
+ * @rx_read: Reads received codes or pulse width data.
+ *	The semantics are similar to a non-blocking read() call.
+ * @rx_g_parameters: Get the current operating parameters and state of the
+ *	the IR receiver.
+ * @rx_s_parameters: Set the current operating parameters and state of the
+ *	the IR receiver.  It is recommended to call
+ *	[rt]x_g_parameters first to fill out the current state, and only change
+ *	the fields that need to be changed.  Upon return, the actual device
+ *	operating parameters and state will be returned.  Note that hardware
+ *	limitations may prevent the actual settings from matching the requested
+ *	settings - e.g. an actual carrier setting of 35,904 Hz when 36,000 Hz
+ *	was requested.  An exception is when the shutdown parameter is true.
+ *	The last used operational parameters will be returned, but the actual
+ *	state of the hardware be different to minimize power consumption and
+ *	processing when shutdown is true.
+ *
+ * @tx_write: Writes codes or pulse width data for transmission.
+ *	The semantics are similar to a non-blocking write() call.
+ * @tx_g_parameters: Get the current operating parameters and state of the
+ *	the IR transmitter.
+ * @tx_s_parameters: Set the current operating parameters and state of the
+ *	the IR transmitter.  It is recommended to call
+ *	[rt]x_g_parameters first to fill out the current state, and only change
+ *	the fields that need to be changed.  Upon return, the actual device
+ *	operating parameters and state will be returned.  Note that hardware
+ *	limitations may prevent the actual settings from matching the requested
+ *	settings - e.g. an actual carrier setting of 35,904 Hz when 36,000 Hz
+ *	was requested.  An exception is when the shutdown parameter is true.
+ *	The last used operational parameters will be returned, but the actual
+ *	state of the hardware be different to minimize power consumption and
+ *	processing when shutdown is true.
+ */
 struct v4l2_subdev_ir_ops {
 	/* Receiver */
 	int (*rx_read)(struct v4l2_subdev *sd, u8 *buf, size_t count,
@@ -557,11 +618,16 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
-/*
- * Used for storing subdev pad information. This structure only needs
- * to be passed to the pad op if the 'which' field of the main argument
- * is set to V4L2_SUBDEV_FORMAT_TRY. For V4L2_SUBDEV_FORMAT_ACTIVE it is
- * safe to pass NULL.
+/**
+ * struct v4l2_subdev_pad_config - Used for storing subdev pad information.
+ *
+ * @try_fmt: pointer to &struct v4l2_mbus_framefmt
+ * @try_crop: pointer to &struct v4l2_rect to be used for crop
+ * @try_compose: pointer to &struct v4l2_rect to be used for compose
+ *
+ * This structure only needs to be passed to the pad op if the 'which' field
+ * of the main argument is set to %V4L2_SUBDEV_FORMAT_TRY. For
+ * %V4L2_SUBDEV_FORMAT_ACTIVE it is safe to pass %NULL.
  */
 struct v4l2_subdev_pad_config {
 	struct v4l2_mbus_framefmt try_fmt;
@@ -573,30 +639,30 @@ struct v4l2_subdev_pad_config {
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
  *
  * @init_cfg: initialize the pad config to default values
- * @enum_mbus_code: callback for VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
+ * @enum_mbus_code: callback for %VIDIOC_SUBDEV_ENUM_MBUS_CODE ioctl handler
  *		    code.
- * @enum_frame_size: callback for VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
+ * @enum_frame_size: callback for %VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl handler
  *		     code.
  *
- * @enum_frame_interval: callback for VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL ioctl
+ * @enum_frame_interval: callback for %VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL ioctl
  *			 handler code.
  *
- * @get_fmt: callback for VIDIOC_SUBDEV_G_FMT ioctl handler code.
+ * @get_fmt: callback for %VIDIOC_SUBDEV_G_FMT ioctl handler code.
  *
- * @set_fmt: callback for VIDIOC_SUBDEV_S_FMT ioctl handler code.
+ * @set_fmt: callback for %VIDIOC_SUBDEV_S_FMT ioctl handler code.
  *
- * @get_selection: callback for VIDIOC_SUBDEV_G_SELECTION ioctl handler code.
+ * @get_selection: callback for %VIDIOC_SUBDEV_G_SELECTION ioctl handler code.
  *
- * @set_selection: callback for VIDIOC_SUBDEV_S_SELECTION ioctl handler code.
+ * @set_selection: callback for %VIDIOC_SUBDEV_S_SELECTION ioctl handler code.
  *
- * @get_edid: callback for VIDIOC_SUBDEV_G_EDID ioctl handler code.
+ * @get_edid: callback for %VIDIOC_SUBDEV_G_EDID ioctl handler code.
  *
- * @set_edid: callback for VIDIOC_SUBDEV_S_EDID ioctl handler code.
+ * @set_edid: callback for %VIDIOC_SUBDEV_S_EDID ioctl handler code.
  *
- * @dv_timings_cap: callback for VIDIOC_SUBDEV_DV_TIMINGS_CAP ioctl handler
+ * @dv_timings_cap: callback for %VIDIOC_SUBDEV_DV_TIMINGS_CAP ioctl handler
  *		    code.
  *
- * @enum_dv_timings: callback for VIDIOC_SUBDEV_ENUM_DV_TIMINGS ioctl handler
+ * @enum_dv_timings: callback for %VIDIOC_SUBDEV_ENUM_DV_TIMINGS ioctl handler
  *		     code.
  *
  * @link_validate: used by the media controller code to check if the links
@@ -648,6 +714,18 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 };
 
+/**
+ * struct v4l2_subdev_ops - Subdev operations
+ *
+ * @core: pointer to &struct v4l2_subdev_core_ops. Can be %NULL
+ * @tuner: pointer to &struct v4l2_subdev_tuner_ops. Can be %NULL
+ * @audio: pointer to &struct v4l2_subdev_audio_ops. Can be %NULL
+ * @video: pointer to &struct v4l2_subdev_video_ops. Can be %NULL
+ * @vbi: pointer to &struct v4l2_subdev_vbi_ops. Can be %NULL
+ * @ir: pointer to &struct v4l2_subdev_ir_ops. Can be %NULL
+ * @sensor: pointer to &struct v4l2_subdev_sensor_ops. Can be %NULL
+ * @pad: pointer to &struct v4l2_subdev_pad_ops. Can be %NULL
+ */
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -659,19 +737,22 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_pad_ops	*pad;
 };
 
-/*
- * Internal ops. Never call this from drivers, only the v4l2 framework can call
- * these ops.
+/**
+ * struct v4l2_subdev_internal_ops - V4L2 subdev internal ops
  *
- * registered: called when this subdev is registered. When called the v4l2_dev
+ * @registered: called when this subdev is registered. When called the v4l2_dev
  *	field is set to the correct v4l2_device.
  *
- * unregistered: called when this subdev is unregistered. When called the
+ * @unregistered: called when this subdev is unregistered. When called the
  *	v4l2_dev field is still set to the correct v4l2_device.
  *
- * open: called when the subdev device node is opened by an application.
+ * @open: called when the subdev device node is opened by an application.
  *
- * close: called when the subdev device node is closed.
+ * @close: called when the subdev device node is closed.
+ *
+ * .. note::
+ *	Never call this from drivers, only the v4l2 framework can call
+ *	these ops.
  */
 struct v4l2_subdev_internal_ops {
 	int (*registered)(struct v4l2_subdev *sd);
@@ -693,17 +774,60 @@ struct v4l2_subdev_internal_ops {
 
 struct regulator_bulk_data;
 
+/**
+ * struct v4l2_subdev_platform_data - regulators config struct
+ *
+ * @regulators: Optional regulators used to power on/off the subdevice
+ * @num_regulators: Number of regululators
+ * @host_priv: Per-subdevice data, specific for a certain video host device
+ */
 struct v4l2_subdev_platform_data {
-	/* Optional regulators uset to power on/off the subdevice */
 	struct regulator_bulk_data *regulators;
 	int num_regulators;
 
-	/* Per-subdevice data, specific for a certain video host device */
 	void *host_priv;
 };
 
-/* Each instance of a subdev driver should create this struct, either
-   stand-alone or embedded in a larger struct.
+/**
+ * struct v4l2_subdev - describes a V4L2 sub-device
+ *
+ * @entity: pointer to &struct media_entity
+ * @list: List of sub-devices
+ * @owner: The owner is the same as the driver's &struct device owner.
+ * @owner_v4l2_dev: true if the &sd->owner matches the owner of &v4l2_dev->dev
+ *	ownner. Initialized by v4l2_device_register_subdev().
+ * @flags: subdev flags. Can be:
+ *   %V4L2_SUBDEV_FL_IS_I2C - Set this flag if this subdev is a i2c device;
+ *   %V4L2_SUBDEV_FL_IS_SPI - Set this flag if this subdev is a spi device;
+ *   %V4L2_SUBDEV_FL_HAS_DEVNODE - Set this flag if this subdev needs a
+ *   device node;
+ *   %V4L2_SUBDEV_FL_HAS_EVENTS -  Set this flag if this subdev generates
+ *   events.
+ *
+ * @v4l2_dev: pointer to &struct v4l2_device
+ * @ops: pointer to &struct v4l2_subdev_ops
+ * @internal_ops: pointer to &struct v4l2_subdev_internal_ops.
+ *	Never call these internal ops from within a driver!
+ * @ctrl_handler: The control handler of this subdev. May be NULL.
+ * @name: Name of the sub-device. Please notice that the name must be unique.
+ * @grp_id: can be used to group similar subdevs. Value is driver-specific
+ * @dev_priv: pointer to private data
+ * @host_priv: pointer to private data used by the device where the subdev
+ *	is attached.
+ * @devnode: subdev device node
+ * @dev: pointer to the physical device, if any
+ * @of_node: The device_node of the subdev, usually the same as dev->of_node.
+ * @async_list: Links this subdev to a global subdev_list or @notifier->done
+ *	list.
+ * @asd: Pointer to respective &struct v4l2_async_subdev.
+ * @notifier: Pointer to the managing notifier.
+ * @pdata: common part of subdevice platform data
+ *
+ * Each instance of a subdev driver should create this struct, either
+ * stand-alone or embedded in a larger struct.
+ *
+ * This structure should be initialized by v4l2_subdev_init() or one of
+ * its variants: v4l2_spi_subdev_init(), v4l2_i2c_subdev_init().
  */
 struct v4l2_subdev {
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -715,30 +839,18 @@ struct v4l2_subdev {
 	u32 flags;
 	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
-	/* Never call these internal ops from within a driver! */
 	const struct v4l2_subdev_internal_ops *internal_ops;
-	/* The control handler of this subdev. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
-	/* name must be unique */
 	char name[V4L2_SUBDEV_NAME_SIZE];
-	/* can be used to group similar subdevs, value is driver-specific */
 	u32 grp_id;
-	/* pointer to private data */
 	void *dev_priv;
 	void *host_priv;
-	/* subdev device node */
 	struct video_device *devnode;
-	/* pointer to the physical device, if any */
 	struct device *dev;
-	/* The device_node of the subdev, usually the same as dev->of_node. */
 	struct device_node *of_node;
-	/* Links this subdev to a global subdev_list or @notifier->done list. */
 	struct list_head async_list;
-	/* Pointer to respective struct v4l2_async_subdev. */
 	struct v4l2_async_subdev *asd;
-	/* Pointer to the managing notifier. */
 	struct v4l2_async_notifier *notifier;
-	/* common part of subdevice platform data */
 	struct v4l2_subdev_platform_data *pdata;
 };
 
@@ -747,8 +859,11 @@ struct v4l2_subdev {
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
-/*
- * Used for storing subdev information per file handle
+/**
+ * struct v4l2_subdev_fh - Used for storing subdev information per file handle
+ *
+ * @vfh: pointer to struct v4l2_fh
+ * @pad: pointer to v4l2_subdev_pad_config
  */
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
@@ -778,53 +893,132 @@ __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
+/**
+ * v4l2_set_subdevdata - Sets V4L2 dev private device data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @p: pointer to the private device data to be stored.
+ */
 static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
 {
 	sd->dev_priv = p;
 }
 
+/**
+ * v4l2_get_subdevdata - Gets V4L2 dev private device data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ *
+ * Returns the pointer to the private device data to be stored.
+ */
 static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
 {
 	return sd->dev_priv;
 }
 
+/**
+ * v4l2_set_subdevdata - Sets V4L2 dev private host data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @p: pointer to the private data to be stored.
+ */
 static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
 {
 	sd->host_priv = p;
 }
 
+/**
+ * v4l2_get_subdevdata - Gets V4L2 dev private data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ *
+ * Returns the pointer to the private host data to be stored.
+ */
 static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
 {
 	return sd->host_priv;
 }
 
 #ifdef CONFIG_MEDIA_CONTROLLER
+
+/**
+ * v4l2_subdev_link_validate_default - validates a media link
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @link: pointer to &struct media_link
+ * @source_fmt: pointer to &struct v4l2_subdev_format
+ * @sink_fmt: pointer to &struct v4l2_subdev_format
+ *
+ * This function ensures that width, height and the media bus pixel
+ * code are equal on both source and sink of the link.
+ */
 int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct media_link *link,
 				      struct v4l2_subdev_format *source_fmt,
 				      struct v4l2_subdev_format *sink_fmt);
+
+/**
+ * v4l2_subdev_link_validate - validates a media link
+ *
+ * @link: pointer to &struct media_link
+ *
+ * This function calls the subdev's link_validate ops to validate
+ * if a media link is valid for streaming. It also internally
+ * calls v4l2_subdev_link_validate_default() to ensure that
+ * width, height and the media bus pixel code are equal on both
+ * source and sink of the link.
+ */
 int v4l2_subdev_link_validate(struct media_link *link);
 
-struct v4l2_subdev_pad_config *
-v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
+/**
+ * v4l2_subdev_alloc_pad_config - Allocates memory for pad config
+ *
+ * @sd: pointer to struct v4l2_subdev
+ */
+struct
+v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd);
+
+/**
+ * v4l2_subdev_free_pad_config - Frees memory allocated by
+ *	v4l2_subdev_alloc_pad_config().
+ *
+ * @cfg: pointer to &struct v4l2_subdev_pad_config
+ */
 void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg);
 #endif /* CONFIG_MEDIA_CONTROLLER */
 
+/**
+ * v4l2_subdev_init - initializes the sub-device struct
+ *
+ * @sd: pointer to the &struct v4l2_subdev to be initialized
+ * @ops: pointer to &struct v4l2_subdev_ops.
+ */
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
-/* Call an ops of a v4l2_subdev, doing the right checks against
-   NULL pointers.
-
-   Example: err = v4l2_subdev_call(sd, video, s_std, norm);
+/*
+ * Call an ops of a v4l2_subdev, doing the right checks against
+ * NULL pointers.
+ *
+ * Example: err = v4l2_subdev_call(sd, video, s_std, norm);
  */
 #define v4l2_subdev_call(sd, o, f, args...)				\
 	(!(sd) ? -ENODEV : (((sd)->ops->o && (sd)->ops->o->f) ?	\
-		(sd)->ops->o->f((sd) , ##args) : -ENOIOCTLCMD))
+		(sd)->ops->o->f((sd), ##args) : -ENOIOCTLCMD))
 
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
 
+/**
+ * v4l2_subdev_notify_event() - Delivers event notification for subdevice
+ * @sd: The subdev for which to deliver the event
+ * @ev: The event to deliver
+ *
+ * Will deliver the specified event to all userspace event listeners which are
+ * subscribed to the v42l subdev event queue as well as to the bridge driver
+ * using the notify callback. The notification type for the notify callback
+ * will be %V4L2_DEVICE_NOTIFY_EVENT.
+ */
 void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 			      const struct v4l2_event *ev);
 
-- 
2.7.4

