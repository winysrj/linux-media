Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:64144 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZFUAje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 20:39:34 -0400
Received: by an-out-0708.google.com with SMTP id d40so4576802and.1
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 17:39:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W5242CD3E26117EB289B48488380@phx.gbl>
References: <COL103-W5242CD3E26117EB289B48488380@phx.gbl>
Date: Sat, 20 Jun 2009 20:39:35 -0400
Message-ID: <829197380906201739h6f655751hd510281fafca31ba@mail.gmail.com>
Subject: =?windows-1256?Q?Re=3A_=5Blinux=2Ddvb=5D_Can=27t_use_my_Pinnacle_PCTV_HD_Pro_st?=
	=?windows-1256?Q?ick_=2D_what_am_I_doing_wrong=3F=FE?=
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/6/20 George Adams <g_adams27@hotmail.com>:
>
> Hello.  I'm having problems getting my (USB) PCTV HD Pro Stick (800e,
>
> the "old" style) to work under V4L.  Could anyone spot the problem in
>
> what I'm doing?
>
>
>
> I'm running Ubuntu 8.04.2 LTS (the 2.6.24-24-server kernel), and am
>
> following this procedure (based on
>
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers).
>
> I intend to use this to tune to USA NTSC channel 3 (to capture a
>
> close-captioned feed inside our building)
>
>
>
> 1) Extract and copy the firmware file I need
>
>   (xc3028-v27.fw) to /lib/firmware
>
>
>
> 2) cd /usr/local/src
>
>
>
> 3) hg clone http://linuxtv.org/hg/v4l-dvb
>
>
>
> 4) cd v4l-dvb
>
>
>
> 5) make rminstall; make distclean; make; make install
>
>
>
> These seems to do what it's supposed to - installs the drivers into
>
> /lib/modules/2.6.24-24-server .  My PCTV HD Pro Stick uses the em28xx
>
> drivers.
>
>
>
>> find /lib/modules/ -type f -name "em28*" -mtime -1
>
>    /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko
>
>    /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
>
>
>
> 6) Reboot with the USB capture device plugged in
>
>
>
> 7) Examine "dmesg" for details related to the capture device
>
>
>
> - em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
>
> - em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
>
> - em28xx #0: chip ID is em2882/em2883
>
> - - -> GSI 22 (level, low) -> IRQ 22
>
> - PCI: Setting latency timer of device 0000:00:1b.0 to 64
>
> - em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
>
> - em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
>
> - em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
>
> - em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
>
> - em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
>
> - em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
>
> - em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
>
> - em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
>
> - em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> - em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
>
> - em28xx #0: EEPROM info:
>
> - em28xx #0:       AC97 audio (5 sample rates)
>
> - em28xx #0:       500mA max power
>
> - em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
>
> - hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
>
> - input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6
>
> - - -> GSI 20 (level, low) -> IRQ 23
>
> - Vortex: init.... em28xx #0: Config register raw data: 0xd0
>
> - em28xx #0: AC97 vendor ID = 0xffffffff
>
> - em28xx #0: AC97 features = 0x6a90
>
> - em28xx #0: Empia 202 AC97 audio processor detected
>
> - em28xx #0: v4l2 driver version 0.1.2
>
> - em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>
> - usbcore: registered new interface driver em28xx
>
> - em28xx driver loaded
>
> - xc2028 0-0061: creating new instance
>
> - xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
>
> - em28xx #0/2: xc3028 attached
>
> - DVB: registering new adapter (em28xx #0)
>
> - DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
>
> - Successfully loaded em28xx-dvb
>
> - Em28xx: Initialized (Em28xx dvb Extension) extension
>
> - done.
>
>
>
> Everything looks good - the drivers are getting called and the card is
>
> recognized.  However, all my attempts to get something "out of it"
>
> aren't working.  I tried firing up "tvtime", but it just launches a
>
> blank, black screen and hanges.  The menu won't come up, the channel
>
> won't change, right-clicking isn't responsive, it won't close, and I
>
> have to kill it.
>
>
>
> I also tried mencoder, but I get this:
>
>
>
>> mencoder -nosound -tv driver=v4l2:width=640:height=480 tv://3 -o /tmp/tv.avi -ovc raw -endpos 5
>
>
>
> MEncoder 2:1.0~rc2-0ubuntu13.1+medibuntu1 (C) 2000-2007 MPlayer Team
>
> CPU: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz
>
>  (Family: 6, Model: 23, Stepping: 10)
>
> CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
>
> Compiled with runtime CPU detection.
>
> success: format: 9  data: 0x0 - 0x0
>
> TV file format detected.
>
> Selected driver: v4l2
>
>  name: Video 4 Linux 2 input
>
>  author: Martin Olschewski
>
>  comment: first try, more to come ;-)
>
> Selected device: Pinnacle PCTV HD Pro Stick
>
>  Tuner cap:
>
>  Tuner rxs:
>
>  Capabilites:  video capture  tuner  audio  read/write  streaming
>
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4
>
>   = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
>
>   10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
>
>   SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20
>
>   = SECAM-Lc;
>
>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>
>  Current input: 0
>
>  Current format: YUYV
>
> v4l2: ioctl set format failed: Invalid argument
>
> v4l2: ioctl set format failed: Invalid argument
>
> v4l2: ioctl set format failed: Invalid argument
>
> v4l2: ioctl query control failed: Invalid argument
>
> v4l2: ioctl query control failed: Invalid argument
>
> v4l2: ioctl query control failed: Invalid argument
>
> v4l2: ioctl query control failed: Invalid argument
>
> [V] filefmt:9  fourcc:0x32595559  size:640x480  fps:25.00  ftime:=0.0400
>
> Opening video filter: [expand osd=1]
>
> Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
>
> ==========================================================================
>
> Opening video decoder: [raw] RAW Uncompressed Video
>
> VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
>
> VDec: using Packed YUY2 as output csp (no 0)
>
> Movie-Aspect is undefined - no prescaling applied.
>
> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
>
> ==========================================================================
>
> Forcing audio preload to 0, max pts correction to 0.
>
> v4l2: select timeout
>
>
>
> Skipping frame!
>
> Pos:   0.0s      1f ( 0%)  0.96fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
> Skipping frame!
>
> v4l2: select timeout( 0%)  1.28fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
>
>
> Skipping frame!
>
> Pos:   0.0s      3f ( 0%)  1.44fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
> Skipping frame!
>
> v4l2: select timeout( 0%)  1.54fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
>
>
> Skipping frame!
>
> Pos:   0.0s      5f ( 0%)  1.60fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
> Skipping frame!
>
> v4l2: select timeout( 0%)  1.65fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
>
>
> Skipping frame!
>
> Pos:   0.0s      7f ( 0%)  1.68fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
> Skipping frame!
>
> Pos:   0.0s      8f ( 0%)  1.71fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
>
>
>
>
> The resulting file (/tmp/tv.avi) is only 4K and not a valid AVI file.
>
>
>
>
>
>
>
> One thing I noticed that differs from what I was expecting is that
>
> nowhere in the "dmesg" output does it say anything about the firmware
>
> file.  I was expecting to see this in "dmesg":
>
>
>
> - firmware: requesting xc3028-v27.fw
>
> - xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
>
> -   type: xc2028 firmware, ver 2.7
>
>
>
> but nothing approximating those lines appears at all.  I tried deleting
>
> /lib/firmware/xc3028-v27.fw entirely to see if it would complain, but
>
> it loaded up exactly the same way after I rebooted...  and still didn't
>
> work.
>
>
>
> So my questions are:
>
>
>
> 1) Why is the firmware file not being read?  Has something happened to
>
> the em28xx drivers recently that causes this file not to be needed
>
> anymore?  Or is something else going wrong?
>
>
>
> 2) Is that the reason for the problem, or have you spotted something
>
> else I've done wrong?
>
>
>
> Thanks greatly to anyone who can help!
>
> _________________________________________________________________
> Insert movie times and more without leaving Hotmail®.
> http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=TXT_TAGLM_WL_HM_Tutorial_QuickAdd_062009
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hello George,

I did the original support for the PCTV 800e.  I just checked out the
v4l-dvb latest code and tried it out, and everything looks ok from
here (confirming there was no regression).

>From the dmesg output you sent, it looks like the tvp5150 video
decoder was not detected.  Could you please unplug/replug the device
again send the dmesg again.

Also, have you tried it under Windows to confirm the hardware is not defective?

Please send future email to the linux-media mailing list, since
linux-dvb is deprecated.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
