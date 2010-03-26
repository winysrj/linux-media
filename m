Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:56238 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab0CZAXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Mar 2010 20:23:04 -0400
Subject: Re: Which of my 3 video capture devices will work best with my PC?
From: hermann pitton <hermann-pitton@arcor.de>
To: Serge Pontejos <jeepster.goons@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <dfbf38831003251506w7cefb286ue0d91a4f3af197f4@mail.gmail.com>
References: <dfbf38831003241545s48e717c6i366599fd705c221c@mail.gmail.com>
	 <1269471975.6885.54.camel@pc07.localdom.local>
	 <1269544731.3273.8.camel@pc07.localdom.local>
	 <dfbf38831003251506w7cefb286ue0d91a4f3af197f4@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 01:22:37 +0100
Message-Id: <1269562957.6921.22.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 25.03.2010, 16:06 -0600 schrieb Serge Pontejos:
> 
> 
> On Thu, Mar 25, 2010 at 1:18 PM, hermann pitton
> <hermann-pitton@arcor.de> wrote:
>         Hi Serge,
>         
>         Am Donnerstag, den 25.03.2010, 00:06 +0100 schrieb hermann
>         pitton:
>         
>         
>         please always provide us with the relevant dmesg output also
>         for cards
>         with trouble.
>         
> I figured I would try to determine if there was a specific card that
> might have a better chance of working first, then focus on that card's
> problem.  But I'll just supply the dmesg with the BT878 installed
> here...
> 
> [   33.150658] Bt87x 0000:02:0a.1: PCI INT A -> Link[APC3] -> GSI 18
> (level, low) -> IRQ 18 
> [   33.150914] bt87x0: Using board 1, analog, digital (rate 32000 Hz) 
> [   33.294887] EMU10K1_Audigy 0000:02:07.0: PCI INT A -> Link[APC4] ->
> GSI 19 (level, low) -> IRQ 19 
> [   33.429554] bttv: driver version 0.9.18 loaded 
> [   33.429559] bttv: using 8 buffers with 2080k (520 pages) each for
> capture 
> [   33.429609] bttv: Bt8xx card found (0). 
> [   33.429629] bttv 0000:02:0a.0: PCI INT A -> Link[APC3] -> GSI 18
> (level, low) -> IRQ 18 
> [   33.429639] bttv0: Bt878 (rev 17) at 0000:02:0a.0, irq: 18,
> latency: 32, mmio: 0xe4000000 
> [   33.429672] bttv0: detected: Hauppauge WinTV [card=10], PCI
> subsystem ID is 0070:13eb 
> [   33.429675] bttv0: using: Hauppauge (bt878) [card=10,insmod
> option] 
> [   33.429678] IRQ 18/bttv0: IRQF_DISABLED is not guaranteed on shared
> IRQs 
> [   33.429709] bttv0: gpio: en=00000000, out=00000000 in=00fffffb
> [init] 
> [   33.432194] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5] 
> [   33.432232] bt878 #0 [sw]: Test OK 
> [   33.475356] tveeprom 3-0050: Hauppauge model 38101, rev B410,
> serial# 1974546 
> [   33.475361] tveeprom 3-0050: tuner model is Philips FI1236 MK2 (idx
> 10, type 2) 
> [   33.475365] tveeprom 3-0050: TV standards NTSC(M) (eeprom 0x08) 
> [   33.475368] tveeprom 3-0050: audio processor is None (idx 0) 
> [   33.475371] tveeprom 3-0050: has no radio 
> [   33.475373] bttv0: Hauppauge eeprom indicates model#38101 
> [   33.475376] bttv0: tuner type=2 
> [   33.640466] bttv0: audio absent, no audio device found! 
> [   33.671316] tuner 3-0061: chip found @ 0xc2 (bt878 #0 [sw]) 
> [   33.816641] tuner-simple 3-0061: creating new instance 
> [   33.816648] tuner-simple 3-0061: type set to 2 (Philips NTSC
> (FI1236,FM1236 and compatibles)) 
> [   33.817329] bttv0: registered device video1 
> [   33.817357] bttv0: registered device vbi1 
> [   33.817374] bttv0: PLL: 28636363 => 35468950 .. ok 
> 
> ...which has similar output to your first dmesg example.... Serial#
> appears to be a little earlier than your example.
>  
>         Maybe we can fix them or at least others are informed about
>         the issues
>         too.
>         
>         The bttv WinTV model 38101 might be just a new revision and
>         maybe the
>         tuner is just missing in tveeprom?
>         
>         Old ones.
>         
>         bttv0: Bt878 (rev 17) at 0000:05:04.0, irq: 18, latency: 66,
>         mmio: 0xf8400000
>         bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID
>         is 0070:13eb
>         bttv0: using: Hauppauge (bt878) [card=10,autodetected]
>         bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
>         bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
>         tveeprom 0-0050: Hauppauge model 38101, rev B410, serial#
>         1993042
>         tveeprom 0-0050: tuner model is Philips FI1236 MK2 (idx 10,
>         type 2)
>         tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
>         tveeprom 0-0050: audio processor is None (idx 0)
>         tveeprom 0-0050: has no radio
>         bttv0: Hauppauge eeprom indicates model#38101
>         
>         Cheers,
>         Hermann
> 
> This is the xawtv output:
> 
> serge@Bracken:~$ xawtv -noxv -device /dev/video0
> This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.31-20-generic)
> xinerama 0: 1680x1050+0+0
> WARNING: No DGA direct video mode for this display.
> WARNING: couldn't find framebuffer base address, try manual
>          configuration ("v4l-conf -a <addr>")
> v4l2: WARNING: framebuffer base address mismatch
> v4l2: me=(nil) v4l=(nil)
> Warning: Missing charsets in String to FontSet conversion
> Warning: Cannot convert string
> "-*-lucidatypewriter-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,
> -*-courier-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,
> -gnu-unifont-bold-r-normal--16-*-*-*-c-*-*-*,
> -efont-biwidth-bold-r-normal--16-*-*-*-*-*-*-*,
> -*-*-bold-r-normal-*-16-*-*-*-m-*-*-*,
> -*-*-bold-r-normal-*-16-*-*-*-c-*-*-*,
> -*-*-*-*-*-*-16-*-*-*-*-*-*-*,*" to type FontSet
> Warning: Cannot convert string
> "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
> Warning: Missing charsets in String to FontSet conversion
> Warning: Cannot convert string
> "-*-lucidatypewriter-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,
> -*-courier-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,
> -gnu-unifont-bold-r-normal--16-*-*-*-c-*-*-*,
> -efont-biwidth-bold-r-normal--16-*-*-*-*-*-*-*,
> -*-*-bold-r-normal-*-16-*-*-*-m-*-*-*,
> -*-*-bold-r-normal-*-16-*-*-*-c-*-*-*,
> -*-*-*-*-*-*-16-*-*-*-*-*-*-*, *" to type FontSet
> ioctl: VIDIOC_QBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0
> [];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): Device or resource busy
> libv4l2: error turning on stream: Device or resource busy
> ioctl: VIDIOC_STREAMON(int=1): Device or resource busy
> ioctl: VIDIOC_QBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0
> [];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): Device or resource busy
> libv4l2: error dequeuing buf: Invalid argument
> ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0
> [];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): Invalid argument
> v4l2: read: Device or resource busy
> serge@Bracken:~$ sudo mplayer -tv
> driver=v4l2:noaudio:width=640:height=480:norm=ntsc :device=/dev/video0
> tv://
> Creating config file: /home/serge/.mplayer/config
> MPlayer SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote
> control.
> 
> Playing :device=/dev/video0.
> File not found: ':device=/dev/video0'
> Failed to open :device=/dev/video0.
> 
> 
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: BT878 video (Hauppauge (bt878))
>  Tuner cap:
>  Tuner rxs: MONO
>  Capabilites:  video capture  video overlay  VBI capture device  tuner
> read/write  streaming
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
> 4 = PAL; 5 = PAL-BG; 6 = PAL-H; 7 = PAL-I; 8 = PAL-DK; 9 = PAL-M; 10 =
> PAL-N; 11 = PAL-Nc; 12 = PAL-60; 13 = SECAM; 14 = SECAM-B; 15 =
> SECAM-G; 16 = SECAM-H; 17 = SECAM-DK; 18 = SECAM-L; 19 = SECAM-Lc;
>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video; 3 = Composite3;
>  Current input: 0
>  Current format: BGR32
> v4l2: current audio mode is : MONO
> v4l2: ioctl queue buffer failed: Device or resource busy
> v4l2: 0 frames successfully processed, 0 frames dropped.
> 
> 
> Exiting... (End of file)
> 
> ====
> 
> mucho thanks...
> 
> Serge

Hi Serge,

thanks, now with copy to the ML. You likely are running a binary driver from nvidia or ati
without support for overlay preview.

For xawtv you would use then -nodga -remote -c /dev/video0 to make sure
you are in grabdisplay/mmap mode and it should work.

/usr/local/bin/mplayer -v tv:// -vf pp=lb -tv
driver=v4l2:input=0:noaudio:width=640:height=480:norm=NTSC-M:device=/dev/video0

Something like that should work too, dunno what blocks /dev/video0 now
for you.

You might try "fuser /dev/video0"

We have examples on the wiki, also for mencoder usage.

For further processing of the recorded material "avidemux2" with GUI is
quite fine.

Hm, I remember some bug, at least on Nvidia, after using mplayer, xawtv
does not get the grabdisplay X overlay back until you logged out once.

It is five years back, but might still be around ...

Cheers,
Hermann



