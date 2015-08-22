Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/39] [media] v4l2-subdev: convert documentation to the right format
Date: Sat, 22 Aug 2015 14:27:54 -0300
Message-Id: <643a6925a3112d0e7927948f307792da91bf7ba5.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct v4l2_subdev_core_ops has some kernel-doc-nano documentation
using a wrong format, with affects the number of stuff reported at
the DocBook device-drivers.xml.

Properly mark the such comment blocks using the right notation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 370fc38c34f1..7b15eccaceb3 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -118,34 +118,36 @@ struct v4l2_subdev_io_pin_config {
 	u8 strength;	/* Pin drive strength */
 };
 
-/*
-   s_io_pin_config: configure one or more chip I/O pins for chips that
-	multiplex different internal signal pads out to IO pins.  This function
-	takes a pointer to an array of 'n' pin configuration entries, one for
-	each pin being configured.  This function could be called at times
-	other than just subdevice initialization.
-
-   init: initialize the sensor registers to some sort of reasonable default
-	values. Do not use for new drivers and should be removed in existing
-	drivers.
-
-   load_fw: load firmware.
-
-   reset: generic reset command. The argument selects which subsystems to
-	reset. Passing 0 will always reset the whole chip. Do not use for new
-	drivers without discussing this first on the linux-media mailinglist.
-	There should be no reason normally to reset a device.
-
-   s_gpio: set GPIO pins. Very simple right now, might need to be extended with
-	a direction argument if needed.
-
-   s_power: puts subdevice in power saving mode (on == 0) or normal operation
-	mode (on == 1).
-
-   interrupt_service_routine: Called by the bridge chip's interrupt service
-	handler, when an interrupt status has be raised due to this subdev,
-	so that this subdev can handle the details.  It may schedule work to be
-	performed later.  It must not sleep.  *Called from an IRQ context*.
+/**
+ * struct v4l2_subdev_core_ops - Define ops callbacks for subdevs
+ *
+ * @s_io_pin_config: configure one or more chip I/O pins for chips that
+ *	multiplex different internal signal pads out to IO pins.  This function
+ *	takes a pointer to an array of 'n' pin configuration entries, one for
+ *	each pin being configured.  This function could be called at times
+ *	other than just subdevice initialization.
+ *
+ * @init: initialize the sensor registers to some sort of reasonable default
+ *	values. Do not use for new drivers and should be removed in existing
+ *	drivers.
+ *
+ * @load_fw: load firmware.
+ *
+ * @reset: generic reset command. The argument selects which subsystems to
+ *	reset. Passing 0 will always reset the whole chip. Do not use for new
+ *	drivers without discussing this first on the linux-media mailinglist.
+ *	There should be no reason normally to reset a device.
+ *
+ * @s_gpio: set GPIO pins. Very simple right now, might need to be extended with
+ *	a direction argument if needed.
+ *
+ * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
+ *	mode (on == 1).
+ *
+ * @interrupt_service_routine: Called by the bridge chip's interrupt service
+ *	handler, when an interrupt status has be raised due to this subdev,
+ *	so that this subdev can handle the details.  It may schedule work to be
+ *	performed later.  It must not sleep.  *Called from an IRQ context*.
  */
 struct v4l2_subdev_core_ops {
 	int (*log_status)(struct v4l2_subdev *sd);
@@ -180,18 +182,17 @@ struct v4l2_subdev_core_ops {
 				 struct v4l2_event_subscription *sub);
 };
 
-/* s_radio: v4l device was opened in radio mode.
-
-   g_frequency: freq->type must be filled in. Normally done by video_ioctl2
-	or the bridge driver.
-
-   g_tuner:
-   s_tuner: vt->type must be filled in. Normally done by video_ioctl2 or the
-	bridge driver.
-
-   s_type_addr: sets tuner type and its I2C addr.
-
-   s_config: sets tda9887 specific stuff, like port1, port2 and qss
+/**
+ * struct s_radio - Callbacks used when v4l device was opened in radio mode.
+ *
+ * @g_frequency: freq->type must be filled in. Normally done by video_ioctl2
+ *	or the bridge driver.
+ * @g_tuner:
+ * @s_tuner: vt->type must be filled in. Normally done by video_ioctl2 or the
+ *	bridge driver.
+ *
+ * @s_type_addr: sets tuner type and its I2C addr.
+ * @s_config: sets tda9887 specific stuff, like port1, port2 and qss
  */
 struct v4l2_subdev_tuner_ops {
 	int (*s_radio)(struct v4l2_subdev *sd);
@@ -206,25 +207,28 @@ struct v4l2_subdev_tuner_ops {
 	int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *config);
 };
 
-/* s_clock_freq: set the frequency (in Hz) of the audio clock output.
-	Used to slave an audio processor to the video decoder, ensuring that
-	audio and video remain synchronized. Usual values for the frequency
-	are 48000, 44100 or 32000 Hz. If the frequency is not supported, then
-	-EINVAL is returned.
-
-   s_i2s_clock_freq: sets I2S speed in bps. This is used to provide a standard
-	way to select I2S clock used by driving digital audio streams at some
-	board designs. Usual values for the frequency are 1024000 and 2048000.
-	If the frequency is not supported, then -EINVAL is returned.
-
-   s_routing: used to define the input and/or output pins of an audio chip,
-	and any additional configuration data.
-	Never attempt to use user-level input IDs (e.g. Composite, S-Video,
-	Tuner) at this level. An i2c device shouldn't know about whether an
-	input pin is connected to a Composite connector, become on another
-	board or platform it might be connected to something else entirely.
-	The calling driver is responsible for mapping a user-level input to
-	the right pins on the i2c device.
+/**
+ * struct v4l2_subdev_audio_ops - Callbacks used for audio-related settings
+ *
+ * @s_clock_freq: set the frequency (in Hz) of the audio clock output.
+ *	Used to slave an audio processor to the video decoder, ensuring that
+ *	audio and video remain synchronized. Usual values for the frequency
+ *	are 48000, 44100 or 32000 Hz. If the frequency is not supported, then
+ *	-EINVAL is returned.
+ *
+ * @s_i2s_clock_freq: sets I2S speed in bps. This is used to provide a standard
+ *	way to select I2S clock used by driving digital audio streams at some
+ *	board designs. Usual values for the frequency are 1024000 and 2048000.
+ *	If the frequency is not supported, then -EINVAL is returned.
+ *
+ * @s_routing: used to define the input and/or output pins of an audio chip,
+ *	and any additional configuration data.
+ *	Never attempt to use user-level input IDs (e.g. Composite, S-Video,
+ *	Tuner) at this level. An i2c device shouldn't know about whether an
+ *	input pin is connected to a Composite connector, become on another
+ *	board or platform it might be connected to something else entirely.
+ *	The calling driver is responsible for mapping a user-level input to
+ *	the right pins on the i2c device.
  */
 struct v4l2_subdev_audio_ops {
 	int (*s_clock_freq)(struct v4l2_subdev *sd, u32 freq);
@@ -243,6 +247,7 @@ struct v4l2_subdev_audio_ops {
 
 /**
  * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
+ *
  * @flags: V4L2_MBUS_FRAME_DESC_FL_* flags
  * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
  * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB
@@ -266,45 +271,46 @@ struct v4l2_mbus_frame_desc {
 	unsigned short num_entries;
 };
 
-/*
-   s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
-	video input devices.
-
-   g_std_output: get current standard for video OUTPUT devices. This is ignored
-	by video input devices.
-
-   g_tvnorms: get v4l2_std_id with all standards supported by the video
-	CAPTURE device. This is ignored by video output devices.
-
-   g_tvnorms_output: get v4l2_std_id with all standards supported by the video
-	OUTPUT device. This is ignored by video capture devices.
-
-   s_crystal_freq: sets the frequency of the crystal used to generate the
-	clocks in Hz. An extra flags field allows device specific configuration
-	regarding clock frequency dividers, etc. If not used, then set flags
-	to 0. If the frequency is not supported, then -EINVAL is returned.
-
-   g_input_status: get input status. Same as the status field in the v4l2_input
-	struct.
-
-   s_routing: see s_routing in audio_ops, except this version is for video
-	devices.
-
-   s_dv_timings(): Set custom dv timings in the sub device. This is used
-	when sub device is capable of setting detailed timing information
-	in the hardware to generate/detect the video signal.
-
-   g_dv_timings(): Get custom dv timings in the sub device.
-
-   g_mbus_config: get supported mediabus configurations
-
-   s_mbus_config: set a certain mediabus configuration. This operation is added
-	for compatibility with soc-camera drivers and should not be used by new
-	software.
-
-   s_rx_buffer: set a host allocated memory buffer for the subdev. The subdev
-	can adjust @size to a lower value and must not write more data to the
-	buffer starting at @data than the original value of @size.
+/**
+ * struct v4l2_subdev_video_ops - Callbacks used when v4l device was opened
+ * 				  in video mode.
+ * @s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
+ *	video input devices.
+ *
+ * @g_std_output: get current standard for video OUTPUT devices. This is ignored
+ *	by video input devices.
+ *
+ * @g_tvnorms: get v4l2_std_id with all standards supported by the video
+ *	CAPTURE device. This is ignored by video output devices.
+ *
+ * @g_tvnorms_output: get v4l2_std_id with all standards supported by the video
+ *	OUTPUT device. This is ignored by video capture devices.
+ *
+ * @s_crystal_freq: sets the frequency of the crystal used to generate the
+ *	clocks in Hz. An extra flags field allows device specific configuration
+ *	regarding clock frequency dividers, etc. If not used, then set flags
+ *	to 0. If the frequency is not supported, then -EINVAL is returned.
+ *
+ * @g_input_status: get input status. Same as the status field in the v4l2_input
+ *	struct.
+ *
+ * @s_routing: see s_routing in audio_ops, except this version is for video
+ *	devices.
+ *
+ * @s_dv_timings(): Set custom dv timings in the sub device. This is used
+ *	when sub device is capable of setting detailed timing information
+ *	in the hardware to generate/detect the video signal.
+ *
+ * @g_dv_timings(): Get custom dv timings in the sub device.
+ * @g_mbus_config: get supported mediabus configurations
+ *
+ * @s_mbus_config: set a certain mediabus configuration. This operation is added
+ *	for compatibility with soc-camera drivers and should not be used by new
+ *	software.
+ *
+ * @s_rx_buffer: set a host allocated memory buffer for the subdev. The subdev
+ *	can adjust @size to a lower value and must not write more data to the
+ *	buffer starting at @data than the original value of @size.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -341,34 +347,37 @@ struct v4l2_subdev_video_ops {
 			   unsigned int *size);
 };
 
-/*
-   decode_vbi_line: video decoders that support sliced VBI need to implement
-	this ioctl. Field p of the v4l2_sliced_vbi_line struct is set to the
-	start of the VBI data that was generated by the decoder. The driver
-	then parses the sliced VBI data and sets the other fields in the
-	struct accordingly. The pointer p is updated to point to the start of
-	the payload which can be copied verbatim into the data field of the
-	v4l2_sliced_vbi_data struct. If no valid VBI data was found, then the
-	type field is set to 0 on return.
-
-   s_vbi_data: used to generate VBI signals on a video signal.
-	v4l2_sliced_vbi_data is filled with the data packets that should be
-	output. Note that if you set the line field to 0, then that VBI signal
-	is disabled. If no valid VBI data was found, then the type field is
-	set to 0 on return.
-
-   g_vbi_data: used to obtain the sliced VBI packet from a readback register.
-	Not all video decoders support this. If no data is available because
-	the readback register contains invalid or erroneous data -EIO is
-	returned. Note that you must fill in the 'id' member and the 'field'
-	member (to determine whether CC data from the first or second field
-	should be obtained).
-
-   s_raw_fmt: setup the video encoder/decoder for raw VBI.
-
-   g_sliced_fmt: retrieve the current sliced VBI settings.
-
-   s_sliced_fmt: setup the sliced VBI settings.
+/**
+ * struct v4l2_subdev_vbi_ops - Callbacks used when v4l device was opened
+ * 				  in video mode via the vbi device node.
+ *
+ *  @decode_vbi_line: video decoders that support sliced VBI need to implement
+ *	this ioctl. Field p of the v4l2_sliced_vbi_line struct is set to the
+ *	start of the VBI data that was generated by the decoder. The driver
+ *	then parses the sliced VBI data and sets the other fields in the
+ *	struct accordingly. The pointer p is updated to point to the start of
+ *	the payload which can be copied verbatim into the data field of the
+ *	v4l2_sliced_vbi_data struct. If no valid VBI data was found, then the
+ *	type field is set to 0 on return.
+ *
+ * @s_vbi_data: used to generate VBI signals on a video signal.
+ *	v4l2_sliced_vbi_data is filled with the data packets that should be
+ *	output. Note that if you set the line field to 0, then that VBI signal
+ *	is disabled. If no valid VBI data was found, then the type field is
+ *	set to 0 on return.
+ *
+ * @g_vbi_data: used to obtain the sliced VBI packet from a readback register.
+ *	Not all video decoders support this. If no data is available because
+ *	the readback register contains invalid or erroneous data -EIO is
+ *	returned. Note that you must fill in the 'id' member and the 'field'
+ *	member (to determine whether CC data from the first or second field
+ *	should be obtained).
+ *
+ * @s_raw_fmt: setup the video encoder/decoder for raw VBI.
+ *
+ * @g_sliced_fmt: retrieve the current sliced VBI settings.
+ *
+ * @s_sliced_fmt: setup the sliced VBI settings.
  */
 struct v4l2_subdev_vbi_ops {
 	int (*decode_vbi_line)(struct v4l2_subdev *sd, struct v4l2_decode_vbi_line *vbi_line);
-- 
2.4.3

