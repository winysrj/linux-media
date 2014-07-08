Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45354 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139AbaGHQ77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 12:59:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/8] vivi.txt: add a document describing the features of this driver.
Date: Tue,  8 Jul 2014 18:31:18 +0200
Message-Id: <1404837078-15608-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
References: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vivi driver emulates various types of video capture hardware and is
ideal for testing applications. This document describes in detail all
the features that this driver implements.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivi.txt | 460 +++++++++++++++++++++++++++++++++++++
 1 file changed, 460 insertions(+)
 create mode 100644 Documentation/video4linux/vivi.txt

diff --git a/Documentation/video4linux/vivi.txt b/Documentation/video4linux/vivi.txt
new file mode 100644
index 0000000..7bb61c4
--- /dev/null
+++ b/Documentation/video4linux/vivi.txt
@@ -0,0 +1,460 @@
+vivi: Virtual Video Capture Driver
+==================================
+
+This driver emulates a capture device that supports four inputs by default:
+
+Input 0 emulates a webcam, input 1 emulates a TV capture device, input 2 emulates
+an S-Video capture device and input 3 emulates an HDMI capture device.
+
+These inputs act exactly as a real hardware device would behave. This allows
+you to use this driver as a test input for application development, since you
+can test the various features without requiring special hardware.
+
+This document describes the features implemented by this driver:
+
+- A large list of test patterns and variations thereof
+- Working brightness, contrast, saturation and hue controls
+- Support for the alpha color component
+- Full colorspace support, including limited/full RGB range
+- All possible control types are present
+- Support for various pixel aspect ratios and video aspect ratios
+- Error injection to test what happens if errors occur
+- Supports crop/compose/scale in any combination
+- Can emulate up to 4K resolutions
+- All Field settings are supported for testing interlaced capturing
+- Supports all standard YUV and RGB formats, including two multiplanar YUV formats
+- Overlay support
+
+These features will be described in more detail below.
+
+
+Section 1: Controls
+
+This driver implements User Controls, Image Processing Controls and Digital
+Video Controls.
+
+
+Section 1.1: User Controls
+
+The Brightness, Contrast, Saturation and Hue controls actually work and are
+standard. There is one special feature with the Brightness control: each
+video input has its own brightness value, so changing input will restore
+the brightness for that input. In addition, each video input uses a different
+brightness range (minimum and maximum control values). Switching inputs will
+cause a control event to be sent with the V4L2_EVENT_CTRL_CH_RANGE flag set.
+This allows you to test controls that can change their range.
+
+The 'Gain, Automatic' and Gain controls can be used to test volatile controls:
+if 'Gain, Automatic' is set, then the Gain control is volatile and changes
+constantly. If 'Gain, Automatic' is cleared, then the Gain control is a normal
+control.
+
+The 'Horizontal Flip' and 'Vertical Flip' controls can be used to flip the
+image. These combine with the 'Sensor Flipped Horizontally/Vertically' Image
+Processing controls.
+
+The 'Alpha Component' control can be used to set the alpha component for
+formats containing an alpha channel.
+
+The remaining controls represent all possible control types. The Menu control
+and the Integer Menu control both have 'holes' in their menu list, meaning that
+one or more menu items return EINVAL when VIDIOC_QUERYMENU is called.  Both menu
+controls also have a non-zero minimum control value.  These features allow you
+to check if your application can handle such things correctly.
+
+
+Section 1.2: Image Processing Controls
+
+These controls control the image generation, error injection, etc. All of these
+are specific to the vivi driver.
+
+
+Section 1.2.1: Test Pattern Controls
+
+Test Pattern: selects which test pattern to use. Use the CSC Colorbar for
+	testing colorspace conversions: the colors used in that test pattern
+	map to valid colors in all colorspaces. The colorspace conversion
+	is disabled for the other test patterns.
+
+OSD Text Mode: selects whether the text superimposed on the
+	test pattern should be show, and if so, whether only counters should
+	be displayed or the full text.
+
+Horizontal Movement: selects whether the test pattern should
+	move to the left or right and with what speed.
+
+Vertical Movement: does the same for the vertical direction.
+
+Fill Percentage of Frame: can be used to draw only the top X percent
+	of the image. Since each frame has to be drawn by the driver, this
+	demands a lot of the CPU. For large resolutions this becomes
+	problematic. By drawing only part of the image this CPU load can
+	be reduced.
+
+Show Border: show a two-pixel wide border at the edge of the actual image,
+	excluding letter or pillarboxing.
+
+Show Square: show a square in the middle of the image. If the image is
+	displayed with the correct pixel and image aspect ratio corrections,
+	then the width and height of the square on the monitor should be
+	the same.
+
+Insert SAV Code in Image: adds a SAV (Start of Active Video) code to the image.
+	This can be used to check if such codes in the image are inadvertently
+	interpreted instead of being ignored.
+
+Insert EAV Code in Image: does the same for the EAV (End of Active Video) code.
+
+
+Section 1.2.2: Feature Selection Controls
+
+Sensor Flipped Horizontally: the image is flipped horizontally and the
+	V4L2_IN_ST_HFLIP input status flag is set. This emulates the case where
+	a sensor is for example mounted upside down.
+
+Sensor Flipped Vertically: the image is flipped vertically and the
+	V4L2_IN_ST_VFLIP input status flag is set. This emulates the case where
+        a sensor is for example mounted upside down.
+
+Standard Aspect Ratio: selects if the image aspect ratio as used for the TV or
+	S-Video input should be 4x3, 16x9 or anamorphic widescreen. This may
+	introduce letterboxing.
+
+Timings Aspect Ratio: selects if the image aspect ratio as used for the HDMI
+	input should be the same as the source width and height ratio, or if
+	it should be 4x3 or 16x9. This may introduce letter or pillarboxing.
+
+Timestamp Source: selects when the timestamp for each buffer is taken.
+
+Colorspace: selects which colorspace should be used when generating the image.
+	This only applies if the CSC Colorbar test pattern is selected,
+	otherwise the test pattern will go through unconverted (except for
+	the so-called 'Transfer Function' corrections and the R'G'B' to Y'CbCr
+	conversion). This behavior is also what you want, since a 75% Colorbar
+	should really have 75% signal intensity and should not be affected
+	by colorspace conversions.
+
+	Changing the colorspace will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a detected colorspace change.
+
+Limited RGB Range (16-235): selects if the RGB range of the HDMI source should
+	be limited or full range. This combines with the Digital Video 'Rx RGB
+	Quantization Range' control and can be used to test what happens if
+	a source provides you with the wrong quantization range information.
+	See the description of that control for more details.
+
+Enable Cropping: enables crop support. This control is only present if the
+	ccs_mode module option is set to the default value of -1 and if
+	the no_error_inj module option is set to 0 (the default).
+
+Enable Composing: enables composing support. This control is only present if
+	the ccs_mode module option is set to the default value of -1 and if
+	the no_error_inj module option is set to 0 (the default).
+
+Enable Scaler: enables support for a scaler (maximum 4 times downscaling and
+	upscaling in either direction). This control is only present if the
+	ccs_mode module option is set to the default value of -1 and if
+	the no_error_inj module option is set to 0 (the default).
+
+Maximum EDID Blocks: determines how many EDID blocks the driver supports.
+	Note that the vivi driver does not actually interpret new EDID
+	data, it just stores it. It allows for up to 256 EDID blocks
+	which is the maximum supported by the standard.
+
+
+Section 1.2.3: Error Injection Controls
+
+Standard Signal Mode: selects the behavior of VIDIOC_QUERYSTD: what should
+	it return?
+
+	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a changed input condition (e.g. a cable
+	was plugged in or out).
+
+Standard: selects the standard that VIDIOC_QUERYSTD should return if the
+	previous control is set to "Selected Standard".
+
+	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a changed input standard.
+
+Timings Signal Mode: selects the behavior of VIDIOC_QUERY_DV_TIMINGS: what
+	should it return?
+
+	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a changed input condition (e.g. a cable
+	was plugged in or out).
+
+Timings: selects the timings the VIDIOC_QUERY_DV_TIMINGS should return
+	if the previous control is set to "Selected Timings".
+
+	Changing this control will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates changed input timings.
+
+
+The following controls are only present if the no_error_inj module option
+is set to 0 (the default):
+
+Percentage of Dropped Buffers: sets the percentage of buffers that
+	are never returned by the driver (i.e., they are dropped).
+
+Disconnect: emulates a USB disconnect. The device will act as if it has
+	been disconnected. Only after all open filehandles to the device
+	node have been closed will the device become 'connected' again.
+
+Inject V4L2_BUF_FLAG_ERROR: when pressed, the next frame returned by
+	the driver will have the error flag set (i.e. the frame is marked
+	corrupt).
+
+Inject VIDIOC_REQBUFS Error: when pressed, the next REQBUFS or CREATE_BUFS
+	ioctl call will fail with an error. To be precise: the videobuf2
+	queue_setup() op will return -EINVAL.
+
+Inject VIDIOC_QBUF Error: when pressed, the next VIDIOC_QBUF or
+	VIDIOC_PREPARE_BUFFER ioctl call will fail with an error. To be
+	precise: the videobuf2 buf_prepare() op will return -EINVAL.
+
+Inject VIDIOC_STREAMON Error: when pressed, the next VIDIOC_STREAMON ioctl
+	call will fail with an error. To be precise: the videobuf2
+	start_streaming() op will return -EINVAL.
+
+
+Section 1.3: Digital Video Controls
+
+Rx RGB Quantization Range: sets the RGB quantization detection of the HDMI
+	input. This combines with the Image Processing 'Limited RGB Range (16-235)'
+	control and can be used to test what happens if a source provides
+	you with the wrong quantization range information. This can be tested
+	by selecting an HDMI input, setting this control to Full or Limited
+	range and selecting the opposite in the 'Limited RGB Range (16-235)'
+	control. The effect is easy to see if the 'Gray Ramp' test pattern
+	is selected.
+
+
+Section 2: Cropping, Composing, Scaling
+
+This driver supports cropping, composing and scaling in any combination. Normally
+which features are supported can be selected through the Image Processing controls,
+but it is also possible to hardcode it when the module is loaded through the ccs_mode
+module option. This is a bitmask where bit 0 enables/disables cropping support,
+bit 1 sets composing support and bit 2 sets scaling support.
+
+So ccs_mode=5 will turn on cropping and scaling, but not composing.
+
+This allows you to test your application for all these variations.
+
+Note that the webcam input never supports cropping, composing or scaling. That only
+applies to the TV/S-Video/HDMI inputs. The reason is that webcams, including this
+virtual implementation, normally use VIDIOC_ENUM_FRAMESIZES to list a set of
+discrete framesizes that it supports. And that does not combine with cropping,
+composing or scaling. This is primarily a limitation of the V4L2 API which is
+carefully reproduced here.
+
+The minimum and maximum resolutions that the scaler can achieve are 16x16 and
+(4096 * 4) x (2160 x 4), but it can only scale up or down by a factor of 4 or
+less. So for a source resolution of 1280x720 the minimum the scaler can do is
+320x180 and the maximum is 5120x2880. You can play around with this using the
+qv4l2 test tool and you will see these dependencies.
+
+This driver also supports larger 'bytesperline' settings, something that
+VIDIOC_S_FMT allows but that few drivers implement.
+
+The scaler is a simple scaler that uses the Coarse Bresenham algorithm. It's
+designed for speed and simplicity, not quality.
+
+If the combination of crop, compose and scaling allows it, then it is possible
+to change crop and compose rectangles on the fly.
+
+
+Section 3: Inputs
+
+Each instance of the vivi driver has by default a webcam, TV, S-Video and HDMI
+input. This can be changed, however, by the num_inputs and input_types module
+options.
+
+Like almost all other module options these are arrays, each element maps to a
+vivi video instance.
+
+The num_inputs option allows you to select the number of inputs the vivi instance
+should create. Values from 1-16 are valid.
+
+The input_types option is a bitmask that tells the input type of each input.
+The 32 bits are divided into 16 sets of 2, each encoding the type of an input.
+Bits 0-1 encode for input 0, bits 2-3 for input 1, etc.
+
+A bit value of 00b is a webcam type, 01b is a TV type, 10b is an S-Video type
+and 11b is an HDMI type.
+
+This allows you to customize the input list and can be useful when emulating
+hardware that is not yet available.
+
+In addition, the video_nr option can be used to select which video number the
+driver should use for the video instance (if free).
+
+So 'modprobe vivi n_devs=2 video_nr=2,5 num_inputs=2,1 input_types=0xf,0x01'
+creates a video2 and a video5 node, the first has two HDMI inputs and the second
+has a single TV input.
+
+
+Section 3.1: Webcam Input
+
+The webcam input supports three framesizes: 320x180, 640x360 and 1280x720. It
+supports frames per second settings of 10, 15, 25, 30, 50 and 60 fps. Which ones
+are available depends on the chosen framesize: the larger the framesize, the
+lower the maximum frames per second.
+
+The initially selected colorspace when you switch to the webcam input will be SRGB.
+
+
+Section 3.2: TV and S-Video Inputs
+
+The only difference between the TV and S-Video input is that the TV has a
+tuner. Otherwise they behave identical.
+
+These inputs support audio inputs as well: one TV and one Line-In. They
+both support all TV standards. If the standard is queried, then the Image
+Processing controls 'Standard Signal Mode' and 'Standard' determine what
+the result will be.
+
+These inputs support all combinations of field settings. Special care has
+been taken to faithfully reproduce how fields are handled for the different
+TV standards. This is particularly noticable when generating a horizontally
+moving image so the temporal effect of using interlaced formats become clearly
+visible. For 50 Hz standards the top field is the oldest and the bottom field
+is the newest in time. For 60 Hz standards that is reversed: the bottom field
+is the oldest and the top field is the newest in time.
+
+When you start capturing in V4L2_FIELD_ALTERNATE mode the first buffer will
+contain the top field for 50 Hz standards and the bottom field for 60 Hz
+standards. This is what capture hardware does as well.
+
+Finally, for PAL/SECAM standards the first half of the top line contains noise.
+This simulates the Wide Screen Signal that is commonly placed there.
+
+The initially selected colorspace when you switch to the TV or S-Video input
+will be SMPTE170M.
+
+The pixel aspect ratio will depend on the TV standard. The video aspect ratio
+can be selected through the 'Standard Aspect Ratio' Image Processing control.
+Choices are '4x3', '16x9' which will give letterboxed widescreen video and
+'16x9 Anomorphic' which will give full screen squashed anamorphic widescreen
+video that will need to be scaled accordingly.
+
+The TV 'tuner' supports a frequency range of 44-958 MHz. Channels are available
+every 6 MHz, starting from 49.25 MHz. For each channel the generated image
+will be in color for the +/- 0.25 MHz around it, and in grayscale for
++/- 1 MHz around the channel. Beyond that it is just noise. The VIDIOC_G_TUNER
+ioctl will return 100% signal strength for +/- 0.25 MHz and 50% for +/- 1 MHz.
+It will also return correct afc values to show whether the frequency is too
+low or too high.
+
+The audio subchannels that are returns is MONO for the +/- 1 MHz range. When
+the frequency is within +/- 0.25 MHz of the channel it will return either
+MONO, STEREO, either MONO | SAP (for NTSC) or LANG1 | LANG2 (for others),
+or STEREO | SAP.
+
+Which one is returned cycles for each valid channel so you can test each
+combination by selecting different channels.
+
+Finally, for these inputs the v4l2_timecode struct is filled in in the
+dequeued v4l2_buffer struct.
+
+
+Section 3.3: HDMI Input
+
+The HDMI inputs supports all CEA-861 and DMT timings, both progressive and
+interlaced, for pixelclock frequencies between 25 and 600 MHz. The field
+mode for interlaced formats is always V4L2_FIELD_ALTERNATE. For HDMI the
+field order is always top field first, and when you start capturing an
+interlaced format you will receive the top field first.
+
+The initially selected colorspace when you switch to the HDMI input or
+select an HDMI timing is based on the format resolution: for resolutions
+less than or equal to 720x576 the colorspace is set to SMPTE170M, for
+others it is set to REC709.
+
+The pixel aspect ratio will depend on the HDMI timing: for 720x480 is it
+set as for the NTSC TV standard, for 720x576 it is set as for the PAL TV
+standard, and for all others a 1:1 pixel aspect ratio is returned.
+
+The video aspect ratio can be selected through the 'Timings Aspect Ratio'
+Image Processing control. Choices are 'Source Width x Height' (just use the
+same ratio as the chosen format), '4x3' or '16x9', either of which can
+result in pillarboxed or letterboxed video.
+
+For HDMI inputs it is possible to set the EDID. By default a simple EDID
+is provided. You can only set the EDID for HDMI inputs. Internally, however,
+ the EDID is shared between all HDMI inputs.
+
+No interpretation is done of the EDID data.
+
+
+Section 4: Formats
+
+The driver supports all the regular packed YUYV formats, 16, 24 and 32 RGB
+packed formats and two multiplanar formats (one luma and one chroma plane).
+
+The alpha component can be set through the 'Alpha Component' User control
+for those formats that support it. If the 'Apply Alpha To Red Only' control
+is set, then the alpha component is only used for the color red and set to
+0 otherwise.
+
+The driver has to be configured to support the multiplanar formats. By default
+the first video instance is single-planar, the second is multi-planar, and it
+keeps alternating.
+
+Using the multiplanar module option you can force multiplanar support to off (1)
+or on (2). So 'modprobe vivi n_devs=3,multiplanar=1,1,2' will create three
+video instances, the first two use the single-planar API, the third uses the
+multi-planar API.
+
+For the multiplanar NV16M and NV61M formats the first plane will have a
+data_offset of 128 bytes. It is rare for data_offset to be non-zero, so
+this is a useful feature for testing applications.
+
+VIDIOC_G/S_PARM can be used to set frame intervals. For the webcam input
+the list of frame intervals is a discrete list, for the other inputs frame
+periods from 1/1000s to 1000s are accepted.
+
+
+Section 5: Overlay
+
+This driver has overlay support with bitmap clipping and list clipping (up to
+16 rectangles) capabilities. Overlays are not supported for multiplanar formats.
+It also honors the struct v4l2_window field setting: if it is set to FIELD_TOP
+or FIELD_BOTTOM and the capture setting is FIELD_ALTERNATE, then only the top
+or bottom fields will be copied to the overlay.
+
+The overlay only works if you are also capturing at that same time. This is a
+vivi limitation since it copies from a buffer to the overlay instead of
+filling the overlay directly. And if you are not capturing, then no buffers
+are available to fill.
+
+In addition, the pixelformat of the capture format and that of the framebuffer
+must be the same for the overlay to work. Otherwise VIDIOC_OVERLAY will return
+an error.
+
+
+Section 6: Random Notes
+
+The n_devs module option allow you to select how many vivi instances should be
+created. By default only one video node instance is set up, but with e.g.
+n_devs=4 you will create four instances. At most 64 devices can be instantiated.
+
+The no_error_inj module option will disable all error injecting controls if set.
+The reason is that without this option it is impossible to use the v4l2-compliance
+utility since it will early on activate things like the 'Disconnect' control, and
+nothing will work anymore after that until the last filehandle is closed.
+
+Setting no_error_inj=1 makes it possible to use v4l2-compliance with the vivi
+driver.
+
+
+Section 7: Some Future Improvements
+
+Just as a reminder and in no particular order:
+
+- Add a virtual alsa driver to test audio
+- Add VBI support (raw/sliced)
+- Add radio support, both a tuner and a modulator
+- Add virtual sub-devices and media controller support
+- Some support for testing compressed video
-- 
2.0.0

