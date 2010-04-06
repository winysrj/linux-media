Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFOdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 10:33:32 -0400
Message-ID: <4BBB4617.7040102@redhat.com>
Date: Tue, 06 Apr 2010 11:32:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>
Subject: Re: RFC: exposing controls in sysfs
References: <201004052347.10845.hverkuil@xs4all.nl>    <201004060012.48261.hverkuil@xs4all.nl>    <201004060837.24770.hverkuil@xs4all.nl> <4BBB341D.2010300@redhat.com> <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
In-Reply-To: <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Hans Verkuil wrote:
>>> $ ls /sys/class/video4linux/video1/controls
>>> balance                           mpeg_insert_navigation_packets
>>> mpeg_video_aspect
>>> brightness                        mpeg_median_chroma_filter_maximum
>>> mpeg_video_b_frames
>>> chroma_agc                        mpeg_median_chroma_filter_minimum
>>> mpeg_video_bitrate
>>> chroma_gain                       mpeg_median_filter_type
>>> mpeg_video_bitrate_mode
>>> contrast                          mpeg_median_luma_filter_maximum
>>> mpeg_video_encoding
>>> hue                               mpeg_median_luma_filter_minimum
>>> mpeg_video_gop_closure
>>> mpeg_audio_crc                    mpeg_spatial_chroma_filter_type
>>> mpeg_video_gop_size
>>> mpeg_audio_emphasis               mpeg_spatial_filter
>>> mpeg_video_mute
>>> mpeg_audio_encoding               mpeg_spatial_filter_mode
>>> mpeg_video_mute_yuv
>>> mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type
>>> mpeg_video_peak_bitrate
>>> mpeg_audio_mute                   mpeg_stream_type
>>> mpeg_video_temporal_decimation
>>> mpeg_audio_sampling_frequency     mpeg_stream_vbi_format
>>> mute
>>> mpeg_audio_stereo_mode            mpeg_temporal_filter
>>> saturation
>>> mpeg_audio_stereo_mode_extension  mpeg_temporal_filter_mode
>>> volume
>>
>> It would be more intuitive if you group the classes with a few subdirs:
>>
>> /video/balance
>> /video/brightness
>> ...
>> /mpeg_audio/crc
>> /mpeg_audio/mute
>> ...
>> /audio/volume
>> /audio/bass
>> /audio/treble
> 
> 1) We don't have that information.
> 2) It would make a simple scheme suddenly a lot more complicated (see
> Andy's comments)
> 3) The main interface is always the application's GUI through ioctls, not
> sysfs.
> 4) Remember that ivtv has an unusually large number of controls. Most
> drivers will just have the usual audio and video controls, perhaps 10 at
> most.

Ok.

> I think we should just ditch this for the first implementation of the
> control framework. It can always be added later, but once added it is
> *much* harder to remove again. It's a nice proof-of-concept, though :-)

I like the concept, especially if we can get rid of other similar sysfs interfaces
that got added on a few drivers (pvrusb2 and some non-gspca drivers have
it, for sure). I think I saw some of the gspca patches also touching on sysfs.
Having this unified into a common interface is a bonus.

-- 

Cheers,
Mauro
