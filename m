Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42531 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979Ab1LRJUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 04:20:37 -0500
Received: by lagp5 with SMTP id p5so1878012lag.19
        for <linux-media@vger.kernel.org>; Sun, 18 Dec 2011 01:20:35 -0800 (PST)
Message-ID: <4EEDB060.7070708@gmail.com>
Date: Sun, 18 Dec 2011 10:20:32 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mihai Dobrescu <msdobrescu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com> <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com> <4EEAFF47.5040003@gmail.com> <CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com> <4EECB2C2.8050701@gmail.com> <4EECE392.5080000@gmail.com> <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com>
In-Reply-To: <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/11 20:53, Mihai Dobrescu wrote:
>
>
>
> Mihai,
>
> I got some success. I did this,
>
> # cd /usr/src (for example)
>
> # git clone git://linuxtv.org/media_build.git
>
> # emerge dev-util/patchutils
> # emerge Proc-ProcessTable
>
> # cd media_build
> # ./build
> # make install
>
> Which will install the latest driver on your running kernel (just in case
> make sure /usr/src/linux points to your running kernel sources). Then
> reboot.
>
> You should now see that (among other) modules have loaded:
>
> # lsmod
>
> <snip>
>
> em28xx                 93528  1 em28xx_dvb
> v4l2_common             5254  1 em28xx
> videobuf_vmalloc        4167  1 em28xx
> videobuf_core          15151  2 em28xx,videobuf_vmalloc
>
> Then try w_scan and dvbscan etc. I got mythtv to scan too now. There were
> some warnings and timeouts and I'm not sure if this is normal or not.
>
> You can also do a dmesg -c while scanning to monitor the changes en the
> kernel log.
>
> Regards,
>
> /Fredrik
>
>
> In my case I have:
>
> lsmod |grep em2
> em28xx_dvb             12608  0
> dvb_core               76187  1 em28xx_dvb
> em28xx                 82436  1 em28xx_dvb
> v4l2_common             5087  1 em28xx
> videodev               70123  2 em28xx,v4l2_common
> videobuf_vmalloc        3783  1 em28xx
> videobuf_core          12991  2 em28xx,videobuf_vmalloc
> rc_core                11695  11
> rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder
> tveeprom               12441  1 em28xx
> i2c_core               14232  9
> xc5000,drxk,em28xx_dvb,em28xx,v4l2_common,videodev,tveeprom,nvidia,i2c_i801
>
> yet, w_scan founds nothing.

I was able to scan using the "media_build" install method described 
above but when trying to watch a free channel the image and sound was 
stuttering severly. I have tried both MythTV and mplayer with similar 
results.

I created the channel list for mplayer with:

lintv ~ # dvbscan -x0 -fc /usr/share/dvb/dvb-c/no-Oslo-Get -o zap > 
.mplayer/channels.conf

And, for example,  I get this output from mplayer plus a very (blocky) 
stuttering image and sound:

lin-tv ~ # mplayer dvb://1@"TV8 Oslo" -ao jack

MPlayer SVN-r33094-4.5.3 (C) 2000-2011 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing dvb://1@TV8 Oslo.
dvb_tune Freq: 306000000
TS file format detected.
VIDEO MPEG2(pid=1585) AUDIO MPA(pid=1586) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  720x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 
kbyte/s)
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [jack] 48000Hz 2ch floatle (4 bytes per sample)
Starting playback...
Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
VO: [xv] 720x576 => 1024x576 Planar YV12
[VO_XV] Shared memory not supported
Reverting to normal Xv.
[VO_XV] Shared memory not supported
Reverting to normal Xv.
[mpeg2video @ 0xac0bc0]ac-tex damaged at 10 0
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 16 1
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 26 3
[mpeg2video @ 0xac0bc0]ac-tex damaged at 26 6
[mpeg2video @ 0xac0bc0]ac-tex damaged at 12 10
[mpeg2video @ 0xac0bc0]invalid mb type in I Frame at 22 12
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 44 13
[mpeg2video @ 0xac0bc0]ac-tex damaged at 28 16
[mpeg2video @ 0xac0bc0]ac-tex damaged at 4 17
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 16 19
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 14 20
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 5 22
[mpeg2video @ 0xac0bc0]invalid mb type in I Frame at 6 23
[mpeg2video @ 0xac0bc0]ac-tex damaged at 16 24
[mpeg2video @ 0xac0bc0]ac-tex damaged at 5 25
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 21 27
[mpeg2video @ 0xac0bc0]skipped MB in I frame at 42 28
[mpeg2video @ 0xac0bc0]ac-tex damaged at 24 31
[mpeg2video @ 0xac0bc0]invalid mb type in I Frame at 7 34
[mpeg2video @ 0xac0bc0]ac-tex damaged at 43 35
[mpeg2video @ 0xac0bc0]Warning MVs not available
[mpeg2video @ 0xac0bc0]concealing 1296 DC, 1296 AC, 1296 MV errors
[mpeg2video @ 0xac0bc0]concealing 1320 DC, 1320 AC, 1320 MV errors
[mpeg2video @ 0xac0bc0]concealing 1320 DC, 1320 AC, 1320 MV errors
[mpeg2video @ 0xac0bc0]concealing 1320 DC, 1320 AC, 1320 MV errors
[mpeg2video @ 0xac0bc0]concealing 1320 DC, 1320 AC, 1320 MV errors
[mpeg2video @ 0xac0bc0]ac-tex damaged at 44 7
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 11 13
[mpeg2video @ 0xac0bc0]ac-tex damaged at 20 17
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 32 21
[mpeg2video @ 0xac0bc0]ac-tex damaged at 31 22
[mpeg2video @ 0xac0bc0]ac-tex damaged at 5 30
[mpeg2video @ 0xac0bc0]ac-tex damaged at 20 31
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 43 32
[mpeg2video @ 0xac0bc0]invalid cbp at 12 2
[mpeg2video @ 0xac0bc0]ac-tex damaged at 7 3
[mpeg2video @ 0xac0bc0]invalid cbp at 31 4
[mpeg2video @ 0xac0bc0]ac-tex damaged at 8 5
[mpeg2video @ 0xac0bc0]ac-tex damaged at 7 9
[mpeg2video @ 0xac0bc0]ac-tex damaged at 16 10
[mpeg2video @ 0xac0bc0]ac-tex damaged at 7 12
[mpeg2video @ 0xac0bc0]ac-tex damaged at 22 12
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]ac-tex damaged at 6 17
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]mb incr damaged
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]ac-tex damaged at 29 22
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 5 22
[mpeg2video @ 0xac0bc0]ac-tex damaged at 11 23
[mpeg2video @ 0xac0bc0]ac-tex damaged at 29 25
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 7 26
[mpeg2video @ 0xac0bc0]ac-tex damaged at 12 27
[mpeg2video @ 0xac0bc0]ac-tex damaged at 1 31
[mpeg2video @ 0xac0bc0]ac-tex damaged at 28 32
[mpeg2video @ 0xac0bc0]mb incr damaged
[mpeg2video @ 0xac0bc0]Warning MVs not available
[mpeg2video @ 0xac0bc0]concealing 1312 DC, 1312 AC, 1312 MV errors
A:91547.6 V:91546.8 A-V:  0.787 ct:  0.000   6/  6 ??% ??% ??,?% 2 0
[mpeg2video @ 0xac0bc0]invalid cbp at 34 6
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]ac-tex damaged at 5 13
[mpeg2video @ 0xac0bc0]ac-tex damaged at 42 15
[mpeg2video @ 0xac0bc0]invalid cbp at 13 17
[mpeg2video @ 0xac0bc0]invalid cbp at 5 23
[mpeg2video @ 0xac0bc0]Warning MVs not available
[mpeg2video @ 0xac0bc0]concealing 631 DC, 631 AC, 631 MV errors
A:91548.6 V:91546.9 A-V:  1.699 ct:  0.004   7/  7 ??% ??% ??,?% 3 0
[mpeg2video @ 0xac0bc0]invalid cbp at 29 8
[mpeg2video @ 0xac0bc0]invalid cbp at 26 9
[mpeg2video @ 0xac0bc0]ac-tex damaged at 0 10
[mpeg2video @ 0xac0bc0]mb incr damaged
[mpeg2video @ 0xac0bc0]ac-tex damaged at 18 17
[mpeg2video @ 0xac0bc0]ac-tex damaged at 20 18
[mpeg2video @ 0xac0bc0]ac-tex damaged at 2 20
[mpeg2video @ 0xac0bc0]ac-tex damaged at 4 22
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 26 23
[mpeg2video @ 0xac0bc0]ac-tex damaged at 29 25
[mpeg2video @ 0xac0bc0]ac-tex damaged at 15 27
[mpeg2video @ 0xac0bc0]invalid mb type in P Frame at 8 28
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]ac-tex damaged at 16 32
[mpeg2video @ 0xac0bc0]concealing 980 DC, 980 AC, 980 MV errors
A:91549.3 V:91546.9 A-V:  2.444 ct:  0.008   8/  8 ??% ??% ??,?% 4 0
[mpeg2video @ 0xac0bc0]ac-tex damaged at 28 2
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]ac-tex damaged at 29 20
[mpeg2video @ 0xac0bc0]ac-tex damaged at 35 24
[mpeg2video @ 0xac0bc0]slice mismatch
[mpeg2video @ 0xac0bc0]mb incr damaged
[mpeg2video @ 0xac0bc0]


