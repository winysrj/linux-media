Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62012 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFQgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 12:36:18 -0400
Received: by bwz1 with SMTP id 1so72496bwz.21
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 09:36:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BBB5C0E.8000906@cam.ac.uk>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <201004060012.48261.hverkuil@xs4all.nl>
	 <201004060837.24770.hverkuil@xs4all.nl> <4BBB341D.2010300@redhat.com>
	 <59e96807eef191ed2c8913139748b655.squirrel@webmail.xs4all.nl>
	 <4BBB4617.7040102@redhat.com> <4BBB5C0E.8000906@cam.ac.uk>
Date: Tue, 6 Apr 2010 18:36:16 +0200
Message-ID: <o2s5f2b61004060936kdfe94615j6735c6362673173f@mail.gmail.com>
Subject: Re: RFC: exposing controls in sysfs
From: =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 April 2010 18:06, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 04/06/10 15:32, Mauro Carvalho Chehab wrote:
>> Hans Verkuil wrote:
>>>> Hans Verkuil wrote:
>>>>> $ ls /sys/class/video4linux/video1/controls
>>>>> balance                           mpeg_insert_navigation_packets
>>>>> mpeg_video_aspect
>>>>> brightness                        mpeg_median_chroma_filter_maximum
>>>>> mpeg_video_b_frames
>>>>> chroma_agc                        mpeg_median_chroma_filter_minimum
>>>>> mpeg_video_bitrate
>>>>> chroma_gain                       mpeg_median_filter_type
>>>>> mpeg_video_bitrate_mode
>>>>> contrast                          mpeg_median_luma_filter_maximum
>>>>> mpeg_video_encoding
>>>>> hue                               mpeg_median_luma_filter_minimum
>>>>> mpeg_video_gop_closure
>>>>> mpeg_audio_crc                    mpeg_spatial_chroma_filter_type
>>>>> mpeg_video_gop_size
>>>>> mpeg_audio_emphasis               mpeg_spatial_filter
>>>>> mpeg_video_mute
>>>>> mpeg_audio_encoding               mpeg_spatial_filter_mode
>>>>> mpeg_video_mute_yuv
>>>>> mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type
>>>>> mpeg_video_peak_bitrate
>>>>> mpeg_audio_mute                   mpeg_stream_type
>>>>> mpeg_video_temporal_decimation
>>>>> mpeg_audio_sampling_frequency     mpeg_stream_vbi_format
>>>>> mute
>>>>> mpeg_audio_stereo_mode            mpeg_temporal_filter
>>>>> saturation
>>>>> mpeg_audio_stereo_mode_extension  mpeg_temporal_filter_mode
>>>>> volume
>>>>
>>>> It would be more intuitive if you group the classes with a few subdirs:
>>>>
>>>> /video/balance
>>>> /video/brightness
>>>> ...
>>>> /mpeg_audio/crc
>>>> /mpeg_audio/mute
>>>> ...
>>>> /audio/volume
>>>> /audio/bass
>>>> /audio/treble
>>>
>>> 1) We don't have that information.
>>> 2) It would make a simple scheme suddenly a lot more complicated (see
>>> Andy's comments)
>>> 3) The main interface is always the application's GUI through ioctls, not
>>> sysfs.
>>> 4) Remember that ivtv has an unusually large number of controls. Most
>>> drivers will just have the usual audio and video controls, perhaps 10 at
>>> most.
>>
>> Ok.
>>
>>> I think we should just ditch this for the first implementation of the
>>> control framework. It can always be added later, but once added it is
>>> *much* harder to remove again. It's a nice proof-of-concept, though :-)
>>
>> I like the concept, especially if we can get rid of other similar sysfs interfaces
>> that got added on a few drivers (pvrusb2 and some non-gspca drivers have
>> it, for sure). I think I saw some of the gspca patches also touching on sysfs.
>> Having this unified into a common interface is a bonus.
>
> Obviously it adds to the review burden, but perhaps we can state that the sysfs
> interface is only an additional option (and personally I think I'd find it pretty
> helpful for debugging if nothing else) and that all functionality there MUST be
> available through the normal routes?  If any functionality only supported via
> sysfs is seen as a bug, then we can point it out in reviews etc.
>
> I agree with Mauro that it would be really handy to unify any interfaces that are
> going to turn up there anyway.
>
> Generally I'm personally in favor with the convenience of sysfs interfaces for quick
> and dirty debugging purposes but perhaps this isn't the time to do it here.

Hi all,

I'm a newbie but I have to ask: how about using debugfs instead of
sysfs? Then everyone will know that the interface is for debugging
only and not production code :-)

Best regards,
Bjørn Forsman
