Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4292 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0DFNol (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 09:44:41 -0400
Message-ID: <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
In-Reply-To: <4BBB341D.2010300@redhat.com>
References: <201004052347.10845.hverkuil@xs4all.nl>
    <201004060012.48261.hverkuil@xs4all.nl>
    <201004060837.24770.hverkuil@xs4all.nl> <4BBB341D.2010300@redhat.com>
Date: Tue, 6 Apr 2010 15:44:22 +0200
Subject: Re: RFC: exposing controls in sysfs
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, "Mike Isely" <isely@isely.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>> $ ls /sys/class/video4linux/video1/controls
>> balance                           mpeg_insert_navigation_packets
>> mpeg_video_aspect
>> brightness                        mpeg_median_chroma_filter_maximum
>> mpeg_video_b_frames
>> chroma_agc                        mpeg_median_chroma_filter_minimum
>> mpeg_video_bitrate
>> chroma_gain                       mpeg_median_filter_type
>> mpeg_video_bitrate_mode
>> contrast                          mpeg_median_luma_filter_maximum
>> mpeg_video_encoding
>> hue                               mpeg_median_luma_filter_minimum
>> mpeg_video_gop_closure
>> mpeg_audio_crc                    mpeg_spatial_chroma_filter_type
>> mpeg_video_gop_size
>> mpeg_audio_emphasis               mpeg_spatial_filter
>> mpeg_video_mute
>> mpeg_audio_encoding               mpeg_spatial_filter_mode
>> mpeg_video_mute_yuv
>> mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type
>> mpeg_video_peak_bitrate
>> mpeg_audio_mute                   mpeg_stream_type
>> mpeg_video_temporal_decimation
>> mpeg_audio_sampling_frequency     mpeg_stream_vbi_format
>> mute
>> mpeg_audio_stereo_mode            mpeg_temporal_filter
>> saturation
>> mpeg_audio_stereo_mode_extension  mpeg_temporal_filter_mode
>> volume
>
>
> It would be more intuitive if you group the classes with a few subdirs:
>
> /video/balance
> /video/brightness
> ...
> /mpeg_audio/crc
> /mpeg_audio/mute
> ...
> /audio/volume
> /audio/bass
> /audio/treble

1) We don't have that information.
2) It would make a simple scheme suddenly a lot more complicated (see
Andy's comments)
3) The main interface is always the application's GUI through ioctls, not
sysfs.
4) Remember that ivtv has an unusually large number of controls. Most
drivers will just have the usual audio and video controls, perhaps 10 at
most.

Strife for simplicity. I'm not sure whether we want to have this in sysfs
at all. While nice there is a danger that people suddenly see it as the
main API. And Markus' comment regarding permissions was a good one, I
thought.

I think we should just ditch this for the first implementation of the
control framework. It can always be added later, but once added it is
*much* harder to remove again. It's a nice proof-of-concept, though :-)

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

