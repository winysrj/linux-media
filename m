Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62466 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758899Ab2AFS3W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 13:29:22 -0500
Received: by obcwo16 with SMTP id wo16so2189773obc.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
References: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com>
From: Mario Ceresa <mrceresa@gmail.com>
Date: Fri, 6 Jan 2012 19:29:01 +0100
Message-ID: <CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com>
Subject: Re: em28xx: no sound on board 1b80:e309 (sveon stv40)
To: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok boys: just to let you know that everything works now.

thinking that the problem was with the audio input, I noticed that
card=64 had an amux while card=19 no.

.amux     = EM28XX_AMUX_LINE_IN,

So I tried this card and modified the mplayer options accordingly:

mplayer -tv device=/dev/video0:input=0:norm=PAL:forceaudio:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
tv://

notice the forceaudio parameter that reads the audio even if no source
is reported from v4l (The same approach with card=19 does not work)

The output was a bit slugglish so I switched off pulse audio control
of the board (https://bbs.archlinux.org/viewtopic.php?id=114228) and
now everything is ok!

I hope this will help some lonenly googlers in the future :)

Regards,

Mario





On 6 January 2012 18:48, Mario Ceresa <mrceresa@gmail.com> wrote:
> Hello again!
>
> I managed to obtain a nice video input from my sveon usb stick using
> last em28xx v4l drivers from git and giving the module the hint
> card=19.
>
> But I have no audio.The card works flawlessy in windows.
>
> The internal chipsets in the card are:
> - USB interface: em2860
> - Audio ADC: emp202
> - Video ADC: saa7118h (philips)
>
> Attached is the relevant dmseg output.
>
> The usb audio card card correctly shows in pulseaudio volume control
> and is recognized as hw.2 by alsa:
> $ arecord -l
> **** List of CAPTURE Hardware Devices ****
> card 0: Intel [HDA Intel], device 0: AD198x Analog [AD198x Analog]
>  Subdevices: 3/3
>  Subdevice #0: subdevice #0
>  Subdevice #1: subdevice #1
>  Subdevice #2: subdevice #2
> card 2: STV40 [USB 2861 Device (SVEON STV40)], device 0: USB Audio [USB Audio]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
>
> However, I'm not able to record any sound from it and mplayer says "no audio":
> $ mplayer -tv device=/dev/video0:input=1:norm=PAL:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
> tv://
> MPlayer SVN-r33996-4.6.1 (C) 2000-2011 MPlayer Team
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote control.
>
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: EM2860/SAA711X Reference Design
>  Capabilities:  video capture  VBI capture device  audio  read/write  streaming
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
> 4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
> 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
> SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 =
> SECAM-Lc;
>  inputs: 0 = S-Video; 1 = Composite1;
>  Current input: 1
>  Current format: YUYV
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> Selected input hasn't got a tuner!
> ==========================================================================
> Opening video decoder: [raw] RAW Uncompressed Video
> Movie-Aspect is undefined - no prescaling applied.
> VO: [vdpau] 640x480 => 640x480 Packed YUY2
> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
> ==========================================================================
> Audio: no sound
> Starting playback...
> V:   2.0  52/ 52  0%  5%  0.0% 0 0
> v4l2: 59 frames successfully processed, 0 frames dropped.
>
> Maybe has something to do with the last line in dmesg:
>
> [  403.359333] ALSA sound/usb/mixer.c:845 2:1: cannot get min/max
> values for control 2 (id 2)
>
> Any ideas?
>
> Mario
