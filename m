Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4310 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0DDPln (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Apr 2010 11:41:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: new V4L control framework
Date: Sun, 4 Apr 2010 17:41:51 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004041741.51869.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The support in drivers for the V4L2 control API is currently very chaotic.
Few if any drivers support the API correctly. Especially the support for the
new extended controls is very much hit and miss.

Combine that with the requirements for the upcoming embedded devices that
will want to use controls much more actively and you end up with a big mess.

I've wanted to fix this for a long time and last week I finally had the time.

The new framework works like a charm and massively reduces the complexity in
drivers when it comes to control handling. And just as importantly, any driver
that uses it is fully compliant to the V4L spec. Something that application
writers will appreciate.

I have converted the cx2341x.c module and tested it with ivtv since that is
by far the most complex example of control handling. The new code is much,
much cleaner.

The documentation is available here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/raw-file/9b6708e8293c/linux/Documentation/video4linux/v4l2-controls.txt

The tree with my code is available here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/

What is very nice is that controls are now exposed in sysfs:

$ l /sys/class/video4linux/video0/controls/
audio_crc                    chroma_gain                   spatial_chroma_filter_type  video_bitrate_mode
audio_emphasis               contrast                      spatial_filter              video_encoding
audio_encoding               hue                           spatial_filter_mode         video_gop_closure
audio_layer_ii_bitrate       insert_navigation_packets     spatial_luma_filter_type    video_gop_size
audio_mute                   median_chroma_filter_maximum  stream_type                 video_mute
audio_sampling_frequency     median_chroma_filter_minimum  stream_vbi_format           video_mute_yuv
audio_stereo_mode            median_filter_type            temporal_filter             video_peak_bitrate
audio_stereo_mode_extension  median_luma_filter_maximum    temporal_filter_mode        video_temporal_decimation
balance                      median_luma_filter_minimum    video_aspect                volume
brightness                   mute                          video_b_frames
chroma_agc                   saturation                    video_bitrate

Writing and reading controls from sysfs is fully transparent and requires
no support from the driver.

Other highlights:

- No need to implement VIDIOC_QUERYCTRL, QUERYMENU, S_CTRL, G_CTRL,
  S_EXT_CTRLS, G_EXT_CTRLS or TRY_EXT_CTRLS in either bridge drivers
  or subdevs. New wrapper functions are provided that can just be plugged in.
 
- When subdevices are added their controls can be automatically merged
  with the bridge driver's controls.
 
- Most drivers just need to implement s_ctrl to set the controls.
  The framework handles the locking and tries to be as 'atomic' as possible.
 
- Ready for the subdev device nodes: the same mechanism applies to subdevs
  and their device nodes as well. Sub-device drivers can make controls
  local, preventing them from being merged with bridge drivers.
 
- Takes care of backwards compatibility handling of VIDIOC_S_CTRL and
  VIDIOC_G_CTRL. Handling of V4L2_CID_PRIVATE_BASE is fully transparent.

There is one thing though that needs to be proven first: can uvc use it as
well? The UVC driver is unusual in that it can dynamically add controls.

The framework should be able to handle this, but it would be great if Laurent
can take a good look at it.

BTW, I've also completely overhauled the vivi driver. I've used it to test
the control handling, but I took the opportunity to do a big clean up of that
driver. The combination of vivi + qv4l2 made testing of the more unusual
integer64 and string control types much easier.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
