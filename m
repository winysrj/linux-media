Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab0DFNQu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 09:16:50 -0400
Message-ID: <4BBB341D.2010300@redhat.com>
Date: Tue, 06 Apr 2010 10:16:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>
Subject: Re: RFC: exposing controls in sysfs
References: <201004052347.10845.hverkuil@xs4all.nl> <201004060012.48261.hverkuil@xs4all.nl> <201004060837.24770.hverkuil@xs4all.nl>
In-Reply-To: <201004060837.24770.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Tuesday 06 April 2010 00:12:48 Hans Verkuil wrote:
>> On Monday 05 April 2010 23:47:10 Hans Verkuil wrote:
>>> Hi all,
>>>
>>> The new control framework makes it very easy to expose controls in sysfs.
>>> The way it is implemented now in the framework is that each device node
>>> will get a 'controls' subdirectory in sysfs. Below which are all the controls
>>> associated with that device node.
>>>
>>> So different device nodes can have different controls if so desired.
>>>
>>> The name of each sysfs file is derived from the control name, basically making
>>> it lowercase, replacing ' ', '-' and '_' with '_' and skipping any other non-
>>> alphanumerical characters. Seems to work well.
>>>
>>> For numerical controls you can write numbers in decimal, octal or hexadecimal.
>>>
>>> When you write to a button control it will ignore what you wrote, but still
>>> execute the action.
>>>
>>> It looks like this for ivtv:
>>>
>>> $ ls /sys/class/video4linux/video1
>>> controls  dev  device  index  name  power  subsystem  uevent
>>>
>>> $ ls /sys/class/video4linux/video1/controls
>>> audio_crc                    chroma_gain                   spatial_chroma_filter_type  video_bitrate_mode
>>> audio_emphasis               contrast                      spatial_filter              video_encoding
>>> audio_encoding               hue                           spatial_filter_mode         video_gop_closure
>>> audio_layer_ii_bitrate       insert_navigation_packets     spatial_luma_filter_type    video_gop_size
>>> audio_mute                   median_chroma_filter_maximum  stream_type                 video_mute
>>> audio_sampling_frequency     median_chroma_filter_minimum  stream_vbi_format           video_mute_yuv
>>> audio_stereo_mode            median_filter_type            temporal_filter             video_peak_bitrate
>>> audio_stereo_mode_extension  median_luma_filter_maximum    temporal_filter_mode        video_temporal_decimation
>>> balance                      median_luma_filter_minimum    video_aspect                volume
>>> brightness                   mute                          video_b_frames
>>> chroma_agc                   saturation                    video_bitrate
>>>
>>>
>>> The question is, is this sufficient?
>> One thing that might be useful is to prefix the name with the control class
>> name. E.g. hue becomes user_hue and audio_crc becomes mpeg_audio_crc. It would
>> groups them better. Or one could make a controls/user and controls/mpeg
>> directory. That might not be such a bad idea actually.
> 
> Replying to your own mails is probably a bad sign, but I can't help myself :-)
> 
> I've changed the code to add a control class prefix for all but the user controls.
> It looks much better now:
> 
> $ ls /sys/class/video4linux/video1/controls
> balance                           mpeg_insert_navigation_packets     mpeg_video_aspect
> brightness                        mpeg_median_chroma_filter_maximum  mpeg_video_b_frames
> chroma_agc                        mpeg_median_chroma_filter_minimum  mpeg_video_bitrate
> chroma_gain                       mpeg_median_filter_type            mpeg_video_bitrate_mode
> contrast                          mpeg_median_luma_filter_maximum    mpeg_video_encoding
> hue                               mpeg_median_luma_filter_minimum    mpeg_video_gop_closure
> mpeg_audio_crc                    mpeg_spatial_chroma_filter_type    mpeg_video_gop_size
> mpeg_audio_emphasis               mpeg_spatial_filter                mpeg_video_mute
> mpeg_audio_encoding               mpeg_spatial_filter_mode           mpeg_video_mute_yuv
> mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type      mpeg_video_peak_bitrate
> mpeg_audio_mute                   mpeg_stream_type                   mpeg_video_temporal_decimation
> mpeg_audio_sampling_frequency     mpeg_stream_vbi_format             mute
> mpeg_audio_stereo_mode            mpeg_temporal_filter               saturation
> mpeg_audio_stereo_mode_extension  mpeg_temporal_filter_mode          volume


It would be more intuitive if you group the classes with a few subdirs:

/video/balance
/video/brightness
...
/mpeg_audio/crc
/mpeg_audio/mute
...
/audio/volume
/audio/bass
/audio/treble
..

-- 

Cheers,
Mauro
