Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.ewetel.de ([212.6.122.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <spieluhr@ewetel.net>) id 1Lh2tb-0000w8-Ew
	for linux-dvb@linuxtv.org; Tue, 10 Mar 2009 15:25:28 +0100
Received: from [192.168.1.5] (host-091-097-096-202.ewe-ip-backbone.de
	[91.97.96.202])
	by mail1.ewetel.de (8.12.1/8.12.9) with ESMTP id n2AEOoIx015096
	for <linux-dvb@linuxtv.org>; Tue, 10 Mar 2009 15:24:51 +0100 (CET)
Message-ID: <49B67832.2060201@ewetel.net>
Date: Tue, 10 Mar 2009 15:24:50 +0100
From: Hartmut <spieluhr@ewetel.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Not able to view HD-TV via Technisat Skystar HD 2
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

> since 3 days I have a Technisat Skystar HD 2 in my Computer (PCI-card) 

was my mail some days ago. My fault: I installed the multiproto-driver,
cause I read this:

>  Mantis/S2API driver
> 
> This is the preferred driver. DVB-S2 support in the Linux kernel is provided by API version 5.0, also known as S2API (and not multiproto). This API was released in kernel version 2.6.28

So I thought, I can only use this driver, if I use a kernel 2.6.28 which
I do not and so I installed the multiproto-driver with part-success. But
I read further and further and found out, that I was wrong. So yesterday
I installed the S2API-driver with some more success. Channel-switching
is very fast now and scan-s2 finds the hd-channels. I can even zap to a
hd-channel, but viewing is the problem:

szap-output to a "normal" channel:

szap-s2 -a 0 -H -r -S 0 -n 373
zapping to 373 'NDR FS NDS;ARD':
delivery DVB-S, modulation QPSK
sat 0, frequency 12109 MHz H, symbolrate 27500000, coderate 3/4, rolloff
0.35
vpid 0x0a29, apid 0x0a2a, sid 0x0a2c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
status 1f | signal   0% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
(and so on)

mplayer-output for this channel:

VDecoder init failed :(
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
VDec: vo config request - 720 x 576 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [xv] 720x576 => 768x576 Planar YV12
A:91464.4 V:91464.4 A-V:  0.000 ct: -0.518 303/303  9%  2%  0.4% 0 0

OK so far, though the signal-strenght is shown 0%, the picture is Ok.

output of szap if I zap to a HD-channel - in this case arteHD

szap-s2 -a 0 -H -r -S 1 -n 385
reading channels from file '/home/hartmut/.szap/channels.conf'
zapping to 385 'arte HD;ZDFvision':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 11361 MHz H, symbolrate 22000000, coderate 2/3, rolloff
0.35
vpid 0x1842, apid 0x184d, sid 0x1856
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal   0% | snr  49% | ber 0 | unc -2 |
status 1b | signal   2% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 2666666 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 6666666 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 1333333 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
status 1b | signal   2% | snr   0% | ber 0 | unc -2 | FE_HAS_LOCK
(and so on)

output of mplayer
Playing /dev/dvb/adapter0/dvr0.
TS file format detected.
VIDEO MPEG2(pid=6210) AUDIO MPA(pid=6221) NO SUBS (yet)!  PROGRAM N. 0

(I have to wait 2 minutes)

Too many audio packets in the buffer: (1366 in 8392704 bytes).
Maybe you are playing a non-interleaved stream/file or the codec failed?
For AVI files, try to force non-interleaved mode with the -ni option.
MPEG: FATAL: EOF while searching for sequence header.
Video: Cannot read properties.
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 256.0 kbit/16.67% (ratio: 32000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
Video: no video
Starting playback...
A:10567.0 ( 2:56:07.0) of -1.1 (unknown)  0.2%
A:10567.1 ( 2:56:07.0) of -1.1 (unknown)  0.2%
So no video, but only audio

If I start mplayer with mplayer -vc +ffh264 I get the same output

Only ffplay can play the channel:
3 seconds fluently,
2 seconds staggering and
after another 5 seconds my free memory (about 500M) is full and I have
to kill ffplay

output of ffplay:

  built on Jan 16 2009 22:23:29, gcc: 4.3.1 20080507 (prerelease)
[gcc-4_3-branch revision 135036]
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]non-existing PPS referenced
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]non-existing PPS referenced
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]non-existing PPS referenced
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]B picture before any references, skipping
[h264 @ 0x68ac80]decode_slice_header error
[h264 @ 0x68ac80]no frame!
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one
[h264 @ 0x68ac80]number of reference frames exceeds max (probably
corrupt input), discarding one

I have several HD-TV.ts-files which are played very well with all
applications, so in  my opinion the videooutput is not ok.

Any advices?

Regards,

Hartmut

PS: Opensuse 11.0 on AMD64, everything updated to the newest ...

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
