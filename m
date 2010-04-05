Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4842 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0DEWMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 18:12:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
Date: Tue, 6 Apr 2010 00:12:48 +0200
Cc: Mike Isely <isely@isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl>
In-Reply-To: <201004052347.10845.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004060012.48261.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 April 2010 23:47:10 Hans Verkuil wrote:
> Hi all,
> 
> The new control framework makes it very easy to expose controls in sysfs.
> The way it is implemented now in the framework is that each device node
> will get a 'controls' subdirectory in sysfs. Below which are all the controls
> associated with that device node.
> 
> So different device nodes can have different controls if so desired.
> 
> The name of each sysfs file is derived from the control name, basically making
> it lowercase, replacing ' ', '-' and '_' with '_' and skipping any other non-
> alphanumerical characters. Seems to work well.
> 
> For numerical controls you can write numbers in decimal, octal or hexadecimal.
> 
> When you write to a button control it will ignore what you wrote, but still
> execute the action.
> 
> It looks like this for ivtv:
> 
> $ ls /sys/class/video4linux/video1
> controls  dev  device  index  name  power  subsystem  uevent
> 
> $ ls /sys/class/video4linux/video1/controls
> audio_crc                    chroma_gain                   spatial_chroma_filter_type  video_bitrate_mode
> audio_emphasis               contrast                      spatial_filter              video_encoding
> audio_encoding               hue                           spatial_filter_mode         video_gop_closure
> audio_layer_ii_bitrate       insert_navigation_packets     spatial_luma_filter_type    video_gop_size
> audio_mute                   median_chroma_filter_maximum  stream_type                 video_mute
> audio_sampling_frequency     median_chroma_filter_minimum  stream_vbi_format           video_mute_yuv
> audio_stereo_mode            median_filter_type            temporal_filter             video_peak_bitrate
> audio_stereo_mode_extension  median_luma_filter_maximum    temporal_filter_mode        video_temporal_decimation
> balance                      median_luma_filter_minimum    video_aspect                volume
> brightness                   mute                          video_b_frames
> chroma_agc                   saturation                    video_bitrate
> 
> 
> The question is, is this sufficient?

One thing that might be useful is to prefix the name with the control class
name. E.g. hue becomes user_hue and audio_crc becomes mpeg_audio_crc. It would
groups them better. Or one could make a controls/user and controls/mpeg
directory. That might not be such a bad idea actually.

> One of the few drivers that exposes controls in sysfs is pvrusb2. As far as
> I can tell from the source it will create subdirectories under the device
> node for each control. Those subdirs have the name ctl_<control-name> (e.g.
> ctl_volume), and below that are files exposing all the attributes of that
> control: name, type, min_val, max_val, def_val, cur_val, custom_val, enum_val
> and bit_val. Most are clear, but some are a bit more obscure. enum_val is
> basically a QUERYMENU and returns all menu options. bit_val seems to be used
> for some non-control values like the TV standard that pvrusb2 also exposes
> and where bit_val is a bit mask of all the valid bits that can be used.
> 
> Mike, if you have any additional information, just let us know. My pvrusb2
> is in another country at the moment so I can't do any testing.
> 
> Personally I think that it is overkill to basically expose the whole
> QUERYCTRL information to sysfs. I see it as an easy and quick way to read and
> modify controls via a command line.

An in between solution would be to add _type files. So you would have 'hue' and
'hue_type'. 'cat hue_type' would give something like:

int 0 255 1 128 0x0000 Hue

In other words 'type min max step flags name'.

And for menu controls like stream_type (hmm, that would become stream_type_type...)
you would get:

menu 0 5 1 0 Stream Type
MPEG-2 Program Stream

MPEG-1 System Stream
MPEG-2 DVD-compatible Stream
MPEG-1 VCD-compatible Stream
MPEG-2 SVCD-compatible Stream

Note the empty line to denote the unsupported menu item (transport stream).

This would give the same information with just a single extra file. Still not
sure whether it is worth it though.

Regards,

	Hans

> 
> Mike, do you know of anyone actively using that additional information?
> 
> And which non-control values do you at the moment expose in pvrusb2 through
> sysfs? Can you perhaps give an ls -R of all the files you create in sysfs
> for pvrusb2?
> 
> I am wondering whether some of those should get a place in the framework as
> well. While I don't think e.g. cropping parameters are useful, things like the
> current input or tuner frequency can be handy. However, for those to be useful
> they would have to be wired up internally through the framework. For example,
> VIDIOC_S_FREQUENCY would have to be hooked up internally to a control. That
> would ensure that however you access it (ioctl or sysfs) it will both end up
> in the same s_ctrl function.
> 
> It will be nice to hear from you what your experience is.
> 
> Comments? Ideas? Once we commit to something it is there for a long time to
> come since sysfs is after all a public API (although it seems to be more
> changable than ioctls).
> 
> Regards,
> 
> 	Hans
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
