Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:34987 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZFWBad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 21:30:33 -0400
Message-ID: <20090623013034.1MY1D.184083.root@cdptpa-web14-z02>
Date: Mon, 22 Jun 2009 21:30:34 -0400
From: <petehiggins@roadrunner.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can't use my Pinnacle HDTV USB stick
Cc: Paul Guzowski <guzowskip@linuxmail.org>
In-Reply-To: <20090621134901.0AB9CBE407E@ws1-9.us4.outblaze.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Paul,

I have a Happauge HVR-1800 with a CX-23885 chip that I would like to get working the same way you described in your email to George. It does work correctly with MythTV, but like you I've not been able to get it to work with Totem Movie Player, MeTV or any of the other players I've tried.

When I paste your “mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3” into terminal and hit enter I get a green screen with static (snow) and sound appears to work. Did you do enough research to point me at a solution? I am guessing that I need to change the driver=v4l2 to a driver for the CX-23885 chip or something similar but don't know what that would be. Any help you could provide would be appreciated.

Sincerely,

Pete Higgins
petehiggins@roadrunner.com

root@pete-desktop:~# mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3

MPlayer 1.0rc2-4.3.3 (C) 2000-2007 MPlayer Team

CPU: Intel(R) Core(TM)2 CPU          4300  @ 1.80GHz (Family: 6, Model: 15, Stepping: 2)

CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1

Compiled with runtime CPU detection.

Creating config file: /root/.mplayer/config

mplayer: could not connect to socket

mplayer: No such file or directory

Failed to open LIRC support. You will not be able to use your remote control.



Playing tv://.

TV file format detected.

Selected driver: v4l2

 name: Video 4 Linux 2 input

 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>

 comment: first try, more to come ;-)

Selected device: Hauppauge WinTV-HVR1800

 Tuner cap:

 Tuner rxs:

 Capabilites:  video capture  VBI capture device  tuner  read/write  streaming

 supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = NTSC-443; 3 = PAL-BG; 4 = PAL-I; 5 = PAL-DK; 6 = PAL-M; 7 = PAL-N; 8 = PAL-Nc; 9 = PAL-60; 10 = SECAM-DK; 11 = SECAM-L;

 inputs: 0 = Television; 1 = Composite1; 2 = S-Video;

 Current input: 0

 Current format: BGR24

v4l2: current audio mode is : MONO

v4l2: ioctl set format failed: Invalid argument

v4l2: ioctl set format failed: Invalid argument

tv.c: norm_from_string(ntsc): Bogus norm parameter, setting default.

Selected channel: 3 (freq: 61.250)

xscreensaver_disable: Could not find XScreenSaver window.

GNOME screensaver disabled

==========================================================================

Opening video decoder: [raw] RAW Uncompressed Video

VDec: vo config request - 640 x 480 (preferred colorspace: Packed UYVY)

VDec: using Packed UYVY as output csp (no 0)

Movie-Aspect is undefined - no prescaling applied.

VO: [xv] 640x480 => 640x480 Packed UYVY 

Selected video codec: [rawuyvy] vfm: raw (RAW UYVY)

==========================================================================

==========================================================================

Forced audio codec: mad

Opening audio decoder: [pcm] Uncompressed PCM audio decoder

AUDIO: 44100 Hz, 1 ch, s16le, 705.6 kbit/100.00% (ratio: 88200->88200)

Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)

==========================================================================

AO: [pulse] 44100Hz 1ch s16le (2 bytes per sample)

Starting playback...



---- Paul Guzowski <guzowskip@linuxmail.org> wrote: 
>  George,
> 
> I can appreciate your frustration because I went through the same
> struggle a while back.  Fortunately, persistence and a lot  of help from
> the great people on this forum helped me finally solve the problems I was
> having.  I have had enough time to study your message line by line and
> compare it with my own but will offer a few words on what I did.
> 
> I am using the same stick to capture cable channel three from my cable
> set-top box.  I had a lot of struggles in the process of getting it to
> work beginning with Ubuntu 8.04 but it has worked flawlessly through all
> the upgrades to Ubuntu 9.04.  I do know there were and maybe still are
> two different sets of firmware for the 800e and I had both or parts of
> both installed at the same time and that was causing a problem.
> 
> Once I got the hardware, firmware, and drivers sorted out,  I think I
> tried just about every video/tv software program available for linux and
> couldn't get any of the full-featured ones with GUIs to work though I
> admit I didn't try very hard with MythTV.   When I tried to scan for a
> signal either from the basic cable coming out of the wall or from the
> RF-out on the back of my set-top box, I could not get anything with any
> of the pre-built frequency scanning tables and I never succeeded to find
> a channel configuration file for my cable company's (Brighthouse
> Networks, panhandle of Florida) signal.
> 
> I finally found a reference somewhere to using mplayer from the command
> line and feeding it several specific arguments.  Once I got it to work, I
> put the following in a launcher for easy activation:
> 
> mplayer -vo xv tv:// -tv
> driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
> 
> Admittedly, all this does is put whatever is selected on my cable box in
> a window with sound on my desktop.  The only thing I can do is resize the
> window or turn it off but I can control the volume or change the channel
> with the cable box remote so it does the basics I need.  I haven't tried
> the fancy programs since upgrading to 9.04 nor have I tried mencoder but
> I would like to eventually be able to record the signal for delayed
> viewing (i.e. use my computer as a PVR).
> 
> Hope this helps.
> 
> Paul in NW Florida
> 
> 
> 
>   ----- Original Message -----
>   From: linux-dvb-request@linuxtv.org
>   To: linux-dvb@linuxtv.org
>   Subject: linux-dvb Digest, Vol 53, Issue 16
>   Date: Sun, 21 Jun 2009 12:00:01 +0200
> 
> 
>   Send linux-dvb mailing list submissions to
>   linux-dvb@linuxtv.org
> 
>   To subscribe or unsubscribe via the World Wide Web, visit
>   http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   or, via email, send a message with subject or body 'help' to
>   linux-dvb-request@linuxtv.org
> 
>   You can reach the person managing the list at
>   linux-dvb-owner@linuxtv.org
> 
>   When replying, please edit your Subject line so it is more specific
>   than "Re: Contents of linux-dvb digest..."
> 
> 
>   Today's Topics:
> 
>   1. Can't use my Pinnacle PCTV HD Pro stick - what am I doing
>   wrong?? (George Adams)
> 
> 
>   ----------------------------------------------------------------------
> 
>   Message: 1
>   Date: Sat, 20 Jun 2009 20:05:45 -0400
>   From: George Adams
>   Subject: [linux-dvb] Can't use my Pinnacle PCTV HD Pro stick - what
>   am
>   I doing wrong??
>   To:
>   Message-ID:
>   Content-Type: text/plain; charset="windows-1256"
> 
> 
>   Hello. I'm having problems getting my (USB) PCTV HD Pro Stick (800e,
> 
>   the "old" style) to work under V4L. Could anyone spot the problem in
> 
>   what I'm doing?
> 
> 
> 
>   I'm running Ubuntu 8.04.2 LTS (the 2.6.24-24-server kernel), and am
> 
>   following this procedure (based on
> 
>   http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers).
> 
>   I intend to use this to tune to USA NTSC channel 3 (to capture a
> 
>   close-captioned feed inside our building)
> 
> 
> 
>   1) Extract and copy the firmware file I need
> 
>   (xc3028-v27.fw) to /lib/firmware
> 
> 
> 
>   2) cd /usr/local/src
> 
> 
> 
>   3) hg clone http://linuxtv.org/hg/v4l-dvb
> 
> 
> 
>   4) cd v4l-dvb
> 
> 
> 
>   5) make rminstall; make distclean; make; make install
> 
> 
> 
>   These seems to do what it's supposed to - installs the drivers into
> 
>   /lib/modules/2.6.24-24-server . My PCTV HD Pro Stick uses the em28xx
> 
>   drivers.
> 
> 
> 
>   > find /lib/modules/ -type f -name "em28*" -mtime -1
> 
>   /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko
> 
> 
>   /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> 
> 
> 
>   6) Reboot with the USB capture device plugged in
> 
> 
> 
>   7) Examine "dmesg" for details related to the capture device
> 
> 
> 
>   - em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps
>   (2304:0227, interface 0, class 0)
> 
>   - em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
> 
>   - em28xx #0: chip ID is em2882/em2883
> 
>   - - -> GSI 22 (level, low) -> IRQ 22
> 
>   - PCI: Setting latency timer of device 0000:00:1b.0 to 64
> 
>   - em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16
>   a4 1c
> 
>   - em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c
>   00 00
> 
>   - em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00
>   69 00
> 
>   - em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00
>   53 00
> 
>   - em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00
>   16 03
> 
>   - em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00
>   30 00
> 
>   - em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00
>   30 00
> 
>   - em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00
>   00 00
> 
>   - em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   00 00
> 
>   - em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
> 
>   - em28xx #0: EEPROM info:
> 
>   - em28xx #0: AC97 audio (5 sample rates)
> 
>   - em28xx #0: 500mA max power
> 
>   - em28xx #0: Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
> 
>   - hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
> 
>   - input: em28xx IR (em28xx #0) as
>   /devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6
> 
>   - - -> GSI 20 (level, low) -> IRQ 23
> 
>   - Vortex: init.... em28xx #0: Config register raw data: 0xd0
> 
>   - em28xx #0: AC97 vendor ID = 0xffffffff
> 
>   - em28xx #0: AC97 features = 0x6a90
> 
>   - em28xx #0: Empia 202 AC97 audio processor detected
> 
>   - em28xx #0: v4l2 driver version 0.1.2
> 
>   - em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> 
>   - usbcore: registered new interface driver em28xx
> 
>   - em28xx driver loaded
> 
>   - xc2028 0-0061: creating new instance
> 
>   - xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
> 
>   - em28xx #0/2: xc3028 attached
> 
>   - DVB: registering new adapter (em28xx #0)
> 
>   - DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303
>   VSB/QAM Frontend)...
> 
>   - Successfully loaded em28xx-dvb
> 
>   - Em28xx: Initialized (Em28xx dvb Extension) extension
> 
>   - done.
> 
> 
> 
>   Everything looks good - the drivers are getting called and the card
>   is
> 
>   recognized. However, all my attempts to get something "out of it"
> 
>   aren't working. I tried firing up "tvtime", but it just launches a
> 
>   blank, black screen and hanges. The menu won't come up, the channel
> 
>   won't change, right-clicking isn't responsive, it won't close, and I
> 
>   have to kill it.
> 
> 
> 
>   I also tried mencoder, but I get this:
> 
> 
> 
>   > mencoder -nosound -tv driver=v4l2:width=640:height=480 tv://3 -o
>   > /tmp/tv.avi -ovc raw -endpos 5
> 
> 
> 
>   MEncoder 2:1.0~rc2-0ubuntu13.1+medibuntu1 (C) 2000-2007 MPlayer Team
> 
>   CPU: Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz
> 
>   (Family: 6, Model: 23, Stepping: 10)
> 
>   CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
> 
>   Compiled with runtime CPU detection.
> 
>   success: format: 9 data: 0x0 - 0x0
> 
>   TV file format detected.
> 
>   Selected driver: v4l2
> 
>   name: Video 4 Linux 2 input
> 
>   author: Martin Olschewski
> 
>   comment: first try, more to come ;-)
> 
>   Selected device: Pinnacle PCTV HD Pro Stick
> 
>   Tuner cap:
> 
>   Tuner rxs:
> 
>   Capabilites: video capture tuner audio read/write streaming
> 
>   supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
>   4
> 
>   = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
> 
>   10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
> 
>   SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20
> 
>   = SECAM-Lc;
> 
>   inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
> 
>   Current input: 0
> 
>   Current format: YUYV
> 
>   v4l2: ioctl set format failed: Invalid argument
> 
>   v4l2: ioctl set format failed: Invalid argument
> 
>   v4l2: ioctl set format failed: Invalid argument
> 
>   v4l2: ioctl query control failed: Invalid argument
> 
>   v4l2: ioctl query control failed: Invalid argument
> 
>   v4l2: ioctl query control failed: Invalid argument
> 
>   v4l2: ioctl query control failed: Invalid argument
> 
>   [V] filefmt:9 fourcc:0x32595559 size:640x480 fps:25.00 ftime:=0.0400
> 
>   Opening video filter: [expand osd=1]
> 
>   Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
> 
>   ==========================================================================
> 
>   Opening video decoder: [raw] RAW Uncompressed Video
> 
>   VDec: vo config request - 640 x 480 (preferred colorspace: Packed
>   YUY2)
> 
>   VDec: using Packed YUY2 as output csp (no 0)
> 
>   Movie-Aspect is undefined - no prescaling applied.
> 
>   Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
> 
>   ==========================================================================
> 
>   Forcing audio preload to 0, max pts correction to 0.
> 
>   v4l2: select timeout
> 
> 
> 
>   Skipping frame!
> 
>   Pos: 0.0s 1f ( 0%) 0.96fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
>   Skipping frame!
> 
>   v4l2: select timeout( 0%) 1.28fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
> 
> 
>   Skipping frame!
> 
>   Pos: 0.0s 3f ( 0%) 1.44fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
>   Skipping frame!
> 
>   v4l2: select timeout( 0%) 1.54fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
> 
> 
>   Skipping frame!
> 
>   Pos: 0.0s 5f ( 0%) 1.60fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
>   Skipping frame!
> 
>   v4l2: select timeout( 0%) 1.65fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
> 
> 
>   Skipping frame!
> 
>   Pos: 0.0s 7f ( 0%) 1.68fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
>   Skipping frame!
> 
>   Pos: 0.0s 8f ( 0%) 1.71fps Trem: 0min 0mb A-V:0.000 [0:0]
> 
> 
> 
> 
> 
>   The resulting file (/tmp/tv.avi) is only 4K and not a valid AVI file.
> 
> 
> 
> 
> 
> 
> 
>   One thing I noticed that differs from what I was expecting is that
> 
>   nowhere in the "dmesg" output does it say anything about the firmware
> 
>   file. I was expecting to see this in "dmesg":
> 
> 
> 
>   - firmware: requesting xc3028-v27.fw
> 
>   - xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
> 
>   - type: xc2028 firmware, ver 2.7
> 
> 
> 
>   but nothing approximating those lines appears at all. I tried
>   deleting
> 
>   /lib/firmware/xc3028-v27.fw entirely to see if it would complain, but
> 
>   it loaded up exactly the same way after I rebooted... and still
>   didn't
> 
>   work.
> 
> 
> 
>   So my questions are:
> 
> 
> 
>   1) Why is the firmware file not being read? Has something happened to
> 
>   the em28xx drivers recently that causes this file not to be needed
> 
>   anymore? Or is something else going wrong?
> 
> 
> 
>   2) Is that the reason for the problem, or have you spotted something
> 
>   else I've done wrong?
> 
> 
> 
>   Thanks greatly to anyone who can help!
> 
>   _________________________________________________________________
>   Insert movie times and more without leaving Hotmail?.
>   http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=TXT_TAGLM_WL_HM_Tutorial_QuickAdd_062009
> 
> 
> 
>   ------------------------------
> 
>   _______________________________________________
>   linux-dvb mailing list
>   linux-dvb@linuxtv.org
>   http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
>   End of linux-dvb Digest, Vol 53, Issue 16
>   *****************************************
> 
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
> 

