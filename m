Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.ewetel.de ([212.6.122.11]:45649 "EHLO mail0.ewetel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZCJPeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 11:34:50 -0400
Received: from [192.168.1.5] (host-091-097-096-202.ewe-ip-backbone.de [91.97.96.202])
	by mail0.ewetel.de (8.12.1/8.12.9) with ESMTP id n2AFYjfe002771
	for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 16:34:46 +0100 (CET)
Message-ID: <49B68895.2000709@ewetel.net>
Date: Tue, 10 Mar 2009 16:34:45 +0100
From: Hartmut <spieluhr@ewetel.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Not able to view HD-TV via Technisat Skystar HD 2
References: <49B67832.2060201@ewetel.net> <E1Lh34N-0003Un-00.goga777-bk-ru@f139.mail.ru>
In-Reply-To: <E1Lh34N-0003Un-00.goga777-bk-ru@f139.mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Goga777 schrieb:
>  > since 3 days I have a Technisat Skystar HD 2 in my Computer (PCI-card) 
>   
>> was my mail some days ago. My fault: I installed the multiproto-driver,
>> cause I read this:
>>
>>     
>>>  Mantis/S2API driver
>>>
>>> This is the preferred driver. DVB-S2 support in the Linux kernel is provided by API version 5.0, also known as S2API (and not multiproto). This API was released in kernel version 2.6.28
>>>       
> please try http://mercurial.intuxication.org/hg/s2-liplianin s2api drivers 
>   
please read the below part, that was, what I did ...
>> So I thought, I can only use this driver, if I use a kernel 2.6.28 which
>> I do not and so I installed the multiproto-driver with part-success. But
>> I read further and further and found out, that I was wrong. So yesterday
>> I installed the S2API-driver with some more success. Channel-switching
>> is very fast now and scan-s2 finds the hd-channels. I can even zap to a
>> hd-channel, but viewing is the problem:
>>
>> szap-output to a "normal" channel:
>>
>> szap-s2 -a 0 -H -r -S 0 -n 373
>> zapping to 373 'NDR FS NDS;ARD':
>> delivery DVB-S, modulation QPSK
>> sat 0, frequency 12109 MHz H, symbolrate 27500000, coderate 3/4, rolloff
>> 0.35
>> vpid 0x0a29, apid 0x0a2a, sid 0x0a2c
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
>> status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
>> (and so on)
>>
>> mplayer-output for this channel:
>>     
>
> please try to use another demuxer with mplayer from svn 
>
> mplayer  -demuxer lavf 
>   
The output of mplayer with this option:

Playing /dev/dvb/adapter0/dvr0.
libavformat file format detected.
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]non-existing PPS referenced
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]non-existing PPS referenced
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]non-existing PPS referenced
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]B picture before any references, skipping
[h264 @ 0x13d2370]decode_slice_header error
[h264 @ 0x13d2370]no frame!
[h264 @ 0x13d2370]number of reference frames exceeds max (probably
corrupt input), discarding one
[lavf] Audio stream found, -aid 0
[lavf] Video stream found, -vid 1
VIDEO:  [H264]  1280x720  0bpp  50.000 fps    0.0 kbps ( 0.0 kbyte/s)
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffh264] vfm: ffmpeg (FFmpeg H.264)
==========================================================================
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 256.0 kbit/16.67% (ratio: 32000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
[h264 @ 0xc5df60]B picture before any references, skipping
[h264 @ 0xc5df60]decode_slice_header error
[h264 @ 0xc5df60]no frame!
Error while decoding frame!
[h264 @ 0xc5df60]B picture before any references, skipping
[h264 @ 0xc5df60]decode_slice_header error
[h264 @ 0xc5df60]no frame!
Error while decoding frame!
[h264 @ 0xc5df60]warning: first frame is no keyframe
[h264 @ 0xc5df60]Missing reference picture
VDec: vo config request - 1280 x 720 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
VO: [xv] 1280x720 => 1280x720 Planar YV12
[h264 @ 0xc5df60]error while decoding MB 10 9, bytestream (-18)% 39 0
[h264 @ 0xc5df60]concealing 2919 DC, 2919 AC, 2919 MV errors
A:15563.2 V:15564.4 A-V: -1.191 ct: -0.306   0/  0 86% 20%  0.4% 39 0

Exiting... (End of file)

