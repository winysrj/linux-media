Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40324 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZFVVsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 17:48:55 -0400
Received: by ewy6 with SMTP id 6so5066228ewy.37
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 14:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W308B321250A646D788B25188390@phx.gbl>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
	 <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
	 <COL103-W308B321250A646D788B25188390@phx.gbl>
Date: Mon, 22 Jun 2009 17:48:55 -0400
Message-ID: <829197380906221448l5739e2f1j19757687ceba31e8@mail.gmail.com>
Subject: Re: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: George Adams <g_adams27@hotmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 22, 2009 at 5:39 PM, George Adams<g_adams27@hotmail.com> wrote:
>
> Hello again.  I have some updates now that I've been able to make some further tests.
>
> 1) My Pinnacle PCTV HD Pro (800e) stick does, in fact, work correctly under Windows.  The scanning detects the one channel we're running over our closed circuit cable (channel 3) and displays it on-screen just fine.  (audio over channel 3 works as well)
>
>
> 2) Devin, my installation process is "hg clone http://linuxtv.org/hg/v4l-dvb; cd v4l-dvb; make rminstall; make distclean; make; make install"  This appears to install everything v4l-related as modules in the appropriate directories.  For instance:
>
>>  uname -r
> 2.6.24-24-server
>
>> find /lib/modules/`uname -r` -type f -name em28xx\* -o -name tvp\*
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/tvp5150.ko
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko
> /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
>
>
> 3) tvtime still hangs when launched.
>
>
> 4) Running zapping gives the error "VBI Initialization failed.  /dev/vbi0 (Pinnacle PCTV HD Pro) is not a raw vbi device)".  Continuing on and trying to choose the "Preferences" menu option segfaults the program (and this is the Ubuntu-distributed "zapping" package)
>
>
> 5) Running Paul's suggested "mplayer" command gives the following:
>
>> mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
>
> MPlayer 1.0rc2-4.2.4 (C) 2000-2007 MPlayer Team
> CPU: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz (Family: 6, Model: 23, Stepping: 10)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> Compiled with runtime CPU detection.
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote control.
>
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski
>  comment: first try, more to come ;-)
> Selected device: Pinnacle PCTV HD Pro Stick
>  Tuner cap:
>  Tuner rxs:
>  Capabilites:  video capture  tuner  audio  read/write  streaming
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM;
>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>  Current input: 0
>  Current format: YUYV
> v4l2: current audio mode is : MONO
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> Selected channel: 3 (freq: 61.250)
> Video buffer shorter than 3 times audio frame duration.
> You will probably experience heavy framedrops.
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> xscreensaver_disable: Could not find XScreenSaver window.
> GNOME screensaver disabled
> ==========================================================================
> Opening video decoder: [raw] RAW Uncompressed Video
> VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
> VDec: using Packed YUY2 as output csp (no 0)
> Movie-Aspect is undefined - no prescaling applied.
> VO: [xv] 640x480 => 640x480 Packed YUY2
> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
> ==========================================================================
> ==========================================================================
> Forced audio codec: mad
> Opening audio decoder: [pcm] Uncompressed PCM audio decoder
> AUDIO: 44100 Hz, 1 ch, s16le, 705.6 kbit/100.00% (ratio: 88200->88200)
> Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
> ==========================================================================
> AO: [pulse] 44100Hz 1ch s16le (2 bytes per sample)
> Starting playback...
> v4l2: select timeout
> A:   0.5 V:   0.0 A-V:  0.472 ct:  0.000   1/  1 ??% ??% ??,?% 1 0 [[JMA:   0.9 V:   0.0 A-V:  0.940 ct:  0.003   2/  2 ??% ??% ??,?% 2 0 [[JMv4l2: select timeout
> A:   1.5 V:   0.0 A-V:  1.479 ct:  0.007   3/  3 ??% ??% ??,?% 3 0 [[JMA:   2.0 V:   0.0 A-V:  1.981 ct:  0.010   4/  4 ??% ??% ??,?% 4 0 [[JMv4l2: select timeout
> A:   2.5 V:   0.0 A-V:  2.485 ct:  0.013   5/  5 ??% ??% ??,?% 5 0 [[JMA:   3.0 V:   0.0 A-V:  2.957 ct:  0.017   6/  6 ??% ??% ??,?% 6 0 [[JMv4l2: select timeout
> A:   3.5 V:   0.0 A-V:  3.460 ct:  0.020   7/  7 ??% ??% ??,?% 7 0 [[JMA:   4.0 V:   0.0 A-V:  3.956 ct:  0.022   8/  8 ??% ??% ??,?% 8 0 [[JMv4l2: select timeout
> A:   4.5 V:   0.0 A-V:  4.460 ct:  0.025   9/  9 ??% ??% ??,?% 9 0 [[JMA:   5.0 V:   0.0 A-V:  4.956 ct:  0.027  10/ 10 ??% ??% ??,?% 10 0 [[JMv4l2: select timeout
>
>
> The Mplayer screen itself remains green the whole time.
>
>
> So the surprise to me is that the Pinnacle device is not actually broken.  By this point, I had been sure it was a hardware problem.  Now I realize that it's something else.  And so I would again appreciate any suggestions you might have.  Thank you once again!
>
> (My installation process, just for reference, distilled down:)
>> cd /usr/local/src
>> hg clone http://linuxtv.org/hg/v4l-dvb
>> cd v4l-dvb
>> make rminstall; make distclean; make; make install
>> cd /tmp
>> wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
>> unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
>> perl /usr/local/src/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>> mv xc3028-v27.fw /lib/firmware/xc3028-v27.fw
>
>
>
>
> _________________________________________________________________
> Hotmail® has ever-growing storage! Don’t worry about storage limits.
> http://windowslive.com/Tutorial/Hotmail/Storage?ocid=TXT_TAGLM_WL_HM_Tutorial_Storage_062009

Ok, here's something to try.  I assume you are rebooting the box,
keeping the stick plugged in.  Please unplug the device, plug it back
in, and then post the full dmesg output.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
