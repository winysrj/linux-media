Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52985 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2FNGqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 02:46:08 -0400
Received: by qcro28 with SMTP id o28so814795qcr.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 23:46:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 14:46:07 +0800
Message-ID: <CAN6EUtu2N2hR2CLG1BWqR3mp9t0vbzfKeQXnhdB+FgeMw5Uf8g@mail.gmail.com>
Subject: DVB streaming failed after running tzap
From: Bruce Ying <bruce.ying@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm new to this mailing list, so excuse me if I'm posting to the wrong place.
I'm using a DiBcom USB module on an Ubuntu 11.04 host. The v4l-dvb
drivers were downloaded via git and built on June 13, 2012.
Basically, I can watch DVB-T by running mplayer (version
SVN-r35003-4.5.2); however, if I ran tzap before launching mplayer,
then I would get a series of "dvb_streaming_read, attempt N. 6 failed
with errno 0 when reading 2048 bytes" failure messages. Then I must
unplug the DiBcom USB tuner and plug it in again so that I could
relaunch mplayer to tune to a DVB-T channel. The console output of
running mplayer as well as tzap is as attached below.
Has anyone experienced the same problem?

==========================================================================

hying@hying-VT3410-8595CMB:~$ gmplayer dvb://CTS
MPlayer SVN-r35003-4.5.2 (C) 2000-2012 MPlayer Team

Playing dvb://CTS.
dvb_tune Freq: 593000000
TS file format detected.
VIDEO MPEG2(pid=5011) AUDIO MPA(pid=5012) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  704x480  (aspect 2)  29.970 fps  15000.0 kbps (1875.0 kbyte/s)
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
libavcodec version 54.25.100 (internal)
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [mpg123] MPEG 1.0/2.0/2.5 layers I, II, III
AUDIO: 48000 Hz, 2 ch, s16le, 128.0 kbit/8.33% (ratio: 16000->192000)
Selected audio codec: [mpg123] afm: mpg123 (MPEG 1.0/2.0/2.5 layers I, II, III)
==========================================================================
[AO OSS] audio_setup: Can't open audio device /dev/dsp: No such file
or directory
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
[AO_ALSA] Unable to find simple control 'PCM',0.
Starting playback...
[VD_FFMPEG] Trying pixfmt=0.
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
The selected video_out device is incompatible with this codec.
Try appending the scale filter to your filter list,
e.g. -vf spp,scale instead of -vf spp.
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [vdpau] 704x480 => 704x528 Planar YV12
A:42279.3 V:42279.6 A-V: -0.336 ct:  0.000   4/  4 ??% ??% ??,?% 0 0
[AO_ALSA] Unable to find simple control 'PCM',0.

[snip]

hying@hying-VT3410-8595CMB:~$ tzap -r -c .tzap/channels.conf CTS
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '.tzap/channels.conf'
tuning to 593000000 Hz
video pid 0x1393, audio pid 0x1394
status 0f | signal 6322 | snr 008a | ber 001fffff | unc 00000000 |
status 1f | signal 614f | snr 0098 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5f5d | snr 0099 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5fbf | snr 00a1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 5f9e | snr 009d | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 6027 | snr 009e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 608d | snr 00a1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 625e | snr 00a1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 6127 | snr 009f | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 60ad | snr 00a2 | ber 00000030 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 614f | snr 009e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 6323 | snr 00a3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 604d | snr 00a4 | ber 00000030 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 6294 | snr 009f | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 60a9 | snr 009d | ber 00000000 | unc 00000000 | FE_HAS_LOCK
^C
hying@hying-VT3410-8595CMB:~$ gmplayer dvb://CTS
MPlayer SVN-r35003-4.5.2 (C) 2000-2012 MPlayer Team

Playing dvb://CTS.
dvb_tune Freq: 593000000
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes
