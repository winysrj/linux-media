Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound1-1.us4.outblaze.com ([208.36.123.129])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1MINPx-0006NJ-FA
	for linux-dvb@linuxtv.org; Sun, 21 Jun 2009 15:49:10 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by outbound1-1.us4.outblaze.com (Postfix) with QMQP id 69E8A7A10EF
	for <linux-dvb@linuxtv.org>; Sun, 21 Jun 2009 13:49:01 +0000 (GMT)
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: linux-dvb@linuxtv.org
Date: Sun, 21 Jun 2009 07:49:00 -0600
Message-Id: <20090621134901.0AB9CBE407E@ws1-9.us4.outblaze.com>
Subject: Re: [linux-dvb] Can't use my Pinnacle HDTV USB stick
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2004979742=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============2004979742==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1245592141257600"

This is a multi-part message in MIME format.

--_----------=_1245592141257600
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 George,

I can appreciate your frustration because I went through the same
struggle a while back.=A0 Fortunately, persistence and a lot=A0 of help from
the great people on this forum helped me finally solve the problems I was
having.=A0 I have had enough time to study your message line by line and
compare it with my own but will offer a few words on what I did.

I am using the same stick to capture cable channel three from my cable
set-top box.=A0 I had a lot of struggles in the process of getting it to
work beginning with Ubuntu 8.04 but it has worked flawlessly through all
the upgrades to Ubuntu 9.04.=A0 I do know there were and maybe still are
two different sets of firmware for the 800e and I had both or parts of
both installed at the same time and that was causing a problem.

Once I got the hardware, firmware, and drivers sorted out,=A0 I think I
tried just about every video/tv software program available for linux and
couldn't get any of the full-featured ones with GUIs to work though I
admit I didn't try very hard with MythTV.=A0=A0 When I tried to scan for a
signal either from the basic cable coming out of the wall or from the
RF-out on the back of my set-top box, I could not get anything with any
of the pre-built frequency scanning tables and I never succeeded to find
a channel configuration file for my cable company's (Brighthouse
Networks, panhandle of Florida) signal.

I finally found a reference somewhere to using mplayer from the command
line and feeding it several specific arguments.=A0 Once I got it to work, I
put the following in a launcher for easy activation:

mplayer -vo xv tv:// -tv
driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.1,0:norm=3Dntsc:chanlist=
=3Dus-cable:channel=3D3

Admittedly, all this does is put whatever is selected on my cable box in
a window with sound on my desktop.=A0 The only thing I can do is resize the
window or turn it off but I can control the volume or change the channel
with the cable box remote so it does the basics I need.=A0 I haven't tried
the fancy programs since upgrading to 9.04 nor have I tried mencoder but
I would like to eventually be able to record the signal for delayed
viewing (i.e. use my computer as a PVR).

Hope this helps.

Paul in NW Florida



  ----- Original Message -----
  From: linux-dvb-request@linuxtv.org
  To: linux-dvb@linuxtv.org
  Subject: linux-dvb Digest, Vol 53, Issue 16
  Date: Sun, 21 Jun 2009 12:00:01 +0200


  Send linux-dvb mailing list submissions to
  linux-dvb@linuxtv.org

  To subscribe or unsubscribe via the World Wide Web, visit
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
  or, via email, send a message with subject or body 'help' to
  linux-dvb-request@linuxtv.org

  You can reach the person managing the list at
  linux-dvb-owner@linuxtv.org

  When replying, please edit your Subject line so it is more specific
  than "Re: Contents of linux-dvb digest..."


  Today's Topics:

  1. Can't use my Pinnacle PCTV HD Pro stick - what am I doing
  wrong?? (George Adams)


  ----------------------------------------------------------------------

  Message: 1
  Date: Sat, 20 Jun 2009 20:05:45 -0400
  From: George Adams
  Subject: [linux-dvb] Can't use my Pinnacle PCTV HD Pro stick - what
  am
  I doing wrong??
  To:
  Message-ID:
  Content-Type: text/plain; charset=3D"windows-1256"


  Hello. I'm having problems getting my (USB) PCTV HD Pro Stick (800e,

  the "old" style) to work under V4L. Could anyone spot the problem in

  what I'm doing?



  I'm running Ubuntu 8.04.2 LTS (the 2.6.24-24-server kernel), and am

  following this procedure (based on

  http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4=
L-DVB_Device_Drivers).

  I intend to use this to tune to USA NTSC channel 3 (to capture a

  close-captioned feed inside our building)



  1) Extract and copy the firmware file I need

  (xc3028-v27.fw) to /lib/firmware



  2) cd /usr/local/src



  3) hg clone http://linuxtv.org/hg/v4l-dvb



  4) cd v4l-dvb



  5) make rminstall; make distclean; make; make install



  These seems to do what it's supposed to - installs the drivers into

  /lib/modules/2.6.24-24-server . My PCTV HD Pro Stick uses the em28xx

  drivers.



  > find /lib/modules/ -type f -name "em28*" -mtime -1

  /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx.ko


  /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dv=
b.ko



  6) Reboot with the USB capture device plugged in



  7) Examine "dmesg" for details related to the capture device



  - em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps
  (2304:0227, interface 0, class 0)

  - em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=3D17)

  - em28xx #0: chip ID is em2882/em2883

  - - -> GSI 22 (level, low) -> IRQ 22

  - PCI: Setting latency timer of device 0000:00:1b.0 to 64

  - em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16
  a4 1c

  - em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c
  00 00

  - em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00
  69 00

  - em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00
  53 00

  - em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00
  16 03

  - em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00
  30 00

  - em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00
  30 00

  - em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00
  00 00

  - em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00 00

  - em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0x2de5abbf

  - em28xx #0: EEPROM info:

  - em28xx #0: AC97 audio (5 sample rates)

  - em28xx #0: 500mA max power

  - em28xx #0: Table at 0x27, strings=3D0x168e, 0x1ca4, 0x246a

  - hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...

  - input: em28xx IR (em28xx #0) as
  /devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6

  - - -> GSI 20 (level, low) -> IRQ 23

  - Vortex: init.... em28xx #0: Config register raw data: 0xd0

  - em28xx #0: AC97 vendor ID =3D 0xffffffff

  - em28xx #0: AC97 features =3D 0x6a90

  - em28xx #0: Empia 202 AC97 audio processor detected

  - em28xx #0: v4l2 driver version 0.1.2

  - em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0

  - usbcore: registered new interface driver em28xx

  - em28xx driver loaded

  - xc2028 0-0061: creating new instance

  - xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner

  - em28xx #0/2: xc3028 attached

  - DVB: registering new adapter (em28xx #0)

  - DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303
  VSB/QAM Frontend)...

  - Successfully loaded em28xx-dvb

  - Em28xx: Initialized (Em28xx dvb Extension) extension

  - done.



  Everything looks good - the drivers are getting called and the card
  is

  recognized. However, all my attempts to get something "out of it"

  aren't working. I tried firing up "tvtime", but it just launches a

  blank, black screen and hanges. The menu won't come up, the channel

  won't change, right-clicking isn't responsive, it won't close, and I

  have to kill it.



  I also tried mencoder, but I get this:



  > mencoder -nosound -tv driver=3Dv4l2:width=3D640:height=3D480 tv://3 -o
  > /tmp/tv.avi -ovc raw -endpos 5



  MEncoder 2:1.0~rc2-0ubuntu13.1+medibuntu1 (C) 2000-2007 MPlayer Team

  CPU: Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz

  (Family: 6, Model: 23, Stepping: 10)

  CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1

  Compiled with runtime CPU detection.

  success: format: 9 data: 0x0 - 0x0

  TV file format detected.

  Selected driver: v4l2

  name: Video 4 Linux 2 input

  author: Martin Olschewski

  comment: first try, more to come ;-)

  Selected device: Pinnacle PCTV HD Pro Stick

  Tuner cap:

  Tuner rxs:

  Capabilites: video capture tuner audio read/write streaming

  supported norms: 0 =3D NTSC; 1 =3D NTSC-M; 2 =3D NTSC-M-JP; 3 =3D NTSC-M-=
KR;
  4

  =3D NTSC-443; 5 =3D PAL; 6 =3D PAL-BG; 7 =3D PAL-H; 8 =3D PAL-I; 9 =3D PA=
L-DK;

  10 =3D PAL-M; 11 =3D PAL-N; 12 =3D PAL-Nc; 13 =3D PAL-60; 14 =3D SECAM; 1=
5 =3D

  SECAM-B; 16 =3D SECAM-G; 17 =3D SECAM-H; 18 =3D SECAM-DK; 19 =3D SECAM-L;=
 20

  =3D SECAM-Lc;

  inputs: 0 =3D Television; 1 =3D Composite1; 2 =3D S-Video;

  Current input: 0

  Current format: YUYV

  v4l2: ioctl set format failed: Invalid argument

  v4l2: ioctl set format failed: Invalid argument

  v4l2: ioctl set format failed: Invalid argument

  v4l2: ioctl query control failed: Invalid argument

  v4l2: ioctl query control failed: Invalid argument

  v4l2: ioctl query control failed: Invalid argument

  v4l2: ioctl query control failed: Invalid argument

  [V] filefmt:9 fourcc:0x32595559 size:640x480 fps:25.00 ftime:=3D0.0400

  Opening video filter: [expand osd=3D1]

  Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1

  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  Opening video decoder: [raw] RAW Uncompressed Video

  VDec: vo config request - 640 x 480 (preferred colorspace: Packed
  YUY2)

  VDec: using Packed YUY2 as output csp (no 0)

  Movie-Aspect is undefined - no prescaling applied.

  Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)

  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  Forcing audio preload to 0, max pts correction to 0.

  v4l2: select timeout



  Skipping frame!

  Pos: 0.0s 1f ( 0%) 0.96fps Trem: 0min 0mb A-V:0.000 [0:0]

  Skipping frame!

  v4l2: select timeout( 0%) 1.28fps Trem: 0min 0mb A-V:0.000 [0:0]



  Skipping frame!

  Pos: 0.0s 3f ( 0%) 1.44fps Trem: 0min 0mb A-V:0.000 [0:0]

  Skipping frame!

  v4l2: select timeout( 0%) 1.54fps Trem: 0min 0mb A-V:0.000 [0:0]



  Skipping frame!

  Pos: 0.0s 5f ( 0%) 1.60fps Trem: 0min 0mb A-V:0.000 [0:0]

  Skipping frame!

  v4l2: select timeout( 0%) 1.65fps Trem: 0min 0mb A-V:0.000 [0:0]



  Skipping frame!

  Pos: 0.0s 7f ( 0%) 1.68fps Trem: 0min 0mb A-V:0.000 [0:0]

  Skipping frame!

  Pos: 0.0s 8f ( 0%) 1.71fps Trem: 0min 0mb A-V:0.000 [0:0]





  The resulting file (/tmp/tv.avi) is only 4K and not a valid AVI file.







  One thing I noticed that differs from what I was expecting is that

  nowhere in the "dmesg" output does it say anything about the firmware

  file. I was expecting to see this in "dmesg":



  - firmware: requesting xc3028-v27.fw

  - xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,

  - type: xc2028 firmware, ver 2.7



  but nothing approximating those lines appears at all. I tried
  deleting

  /lib/firmware/xc3028-v27.fw entirely to see if it would complain, but

  it loaded up exactly the same way after I rebooted... and still
  didn't

  work.



  So my questions are:



  1) Why is the firmware file not being read? Has something happened to

  the em28xx drivers recently that causes this file not to be needed

  anymore? Or is something else going wrong?



  2) Is that the reason for the problem, or have you spotted something

  else I've done wrong?



  Thanks greatly to anyone who can help!

  _________________________________________________________________
  Insert movie times and more without leaving Hotmail?.
  http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=3DTXT_TAGLM_WL_HM_T=
utorial_QuickAdd_062009



  ------------------------------

  _______________________________________________
  linux-dvb mailing list
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

  End of linux-dvb Digest, Vol 53, Issue 16
  *****************************************

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1245592141257600
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
George,<br><br>I can appreciate your frustration because I went through the=
 same struggle a while back.&nbsp; Fortunately, persistence and a lot&nbsp;=
 of help from the great people on this forum helped me finally solve the pr=
oblems I was having.&nbsp; I have had enough time to study your message lin=
e by line and compare it with my own but will offer a few words on what I d=
id.<br><br>I am using the same stick to capture cable channel three from my=
 cable set-top box.&nbsp; I had a lot of struggles in the process of gettin=
g it to work beginning with Ubuntu 8.04 but it has worked flawlessly throug=
h all the upgrades to Ubuntu 9.04.&nbsp; I do know there were and maybe sti=
ll are two different sets of firmware for the 800e and I had both or parts =
of both installed at the same time and that was causing a problem.<br><br>O=
nce I got the hardware, firmware, and drivers sorted out,&nbsp; I think I t=
ried just about every video/tv software program available for linux and cou=
ldn't get any of the full-featured ones with GUIs to work though I admit I =
didn't try very hard with MythTV.&nbsp;&nbsp; When I tried to scan for a si=
gnal either from the basic cable coming out of the wall or from the RF-out =
on the back of my set-top box, I could not get anything with any of the pre=
-built frequency scanning tables and I never succeeded to find a channel co=
nfiguration file for my cable company's (Brighthouse Networks, panhandle of=
 Florida) signal.<br><br>I finally found a reference somewhere to using mpl=
ayer from the command line and feeding it several specific arguments.&nbsp;=
 Once I got it to work, I put the following in a launcher for easy activati=
on:<br><br>mplayer -vo xv tv:// -tv driver=3Dv4l2:alsa:immediatemode=3D0:ad=
evice=3Dhw.1,0:norm=3Dntsc:chanlist=3Dus-cable:channel=3D3<br><br>Admittedl=
y, all this does is put whatever is selected on my cable box in a window wi=
th sound on my desktop.&nbsp; The only thing I can do is resize the window =
or turn it off but I can control the volume or change the channel with the =
cable box remote so it does the basics I need.&nbsp; I haven't tried the fa=
ncy programs since upgrading to 9.04 nor have I tried mencoder but I would =
like to eventually be able to record the signal for delayed viewing (i.e. u=
se my computer as a PVR).<br><br>Hope this helps.<br><br>Paul in NW Florida=
<br><br><br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: linux-dvb-request@linuxtv.org<br>
To: linux-dvb@linuxtv.org<br>
Subject: linux-dvb Digest, Vol 53, Issue 16<br>
Date: Sun, 21 Jun 2009 12:00:01 +0200<br>
<br>

<br>
Send linux-dvb mailing list submissions to<br>
	linux-dvb@linuxtv.org<br>
<br>
To subscribe or unsubscribe via the World Wide Web, visit<br>
	http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br>
or, via email, send a message with subject or body 'help' to<br>
	linux-dvb-request@linuxtv.org<br>
<br>
You can reach the person managing the list at<br>
	linux-dvb-owner@linuxtv.org<br>
<br>
When replying, please edit your Subject line so it is more specific<br>
than "Re: Contents of linux-dvb digest..."<br>
<br>
<br>
Today's Topics:<br>
<br>
    1. Can't use my Pinnacle PCTV HD Pro stick - what am I doing<br>
       wrong?? (George Adams)<br>
<br>
<br>
----------------------------------------------------------------------<br>
<br>
Message: 1<br>
Date: Sat, 20 Jun 2009 20:05:45 -0400<br>
From: George Adams <g_adams27@hotmail.com><br>
Subject: [linux-dvb] Can't use my Pinnacle PCTV HD Pro stick - what am<br>
	I doing wrong??<br>
To: <linux-dvb@linuxtv.org><br>
Message-ID: <col103-w5242cd3e26117eb289b48488380@phx.gbl><br>
Content-Type: text/plain; charset=3D"windows-1256"<br>
<br>
<br>
Hello.  I'm having problems getting my (USB) PCTV HD Pro Stick (800e,<br>
<br>
the "old" style) to work under V4L.  Could anyone spot the problem in<br>
<br>
what I'm doing?<br>
<br>
<br>
<br>
I'm running Ubuntu 8.04.2 LTS (the 2.6.24-24-server kernel), and am<br>
<br>
following this procedure (based on<br>
<br>
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-=
DVB_Device_Drivers).<br>
<br>
I intend to use this to tune to USA NTSC channel 3 (to capture a<br>
<br>
close-captioned feed inside our building)<br>
<br>
<br>
<br>
1) Extract and copy the firmware file I need<br>
<br>
    (xc3028-v27.fw) to /lib/firmware<br>
<br>
<br>
<br>
2) cd /usr/local/src<br>
<br>
<br>
<br>
3) hg clone http://linuxtv.org/hg/v4l-dvb<br>
<br>
<br>
<br>
4) cd v4l-dvb<br>
<br>
<br>
<br>
5) make rminstall; make distclean; make; make install<br>
<br>
<br>
<br>
These seems to do what it's supposed to - installs the drivers into<br>
<br>
/lib/modules/2.6.24-24-server .  My PCTV HD Pro Stick uses the em28xx<br>
<br>
drivers.<br>
<br>
<br>
<br>
&gt; find /lib/modules/ -type f -name "em28*" -mtime -1<br>
<br>
     /lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx=
.ko<br>
<br>
     <br>
/lib/modules/2.6.24-24-server/kernel/drivers/media/video/em28xx/em28xx-dvb.=
ko<br>
<br>
<br>
<br>
6) Reboot with the USB capture device plugged in<br>
<br>
<br>
<br>
7) Examine "dmesg" for details related to the capture device<br>
<br>
<br>
<br>
- em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps <br>
(2304:0227, interface 0, class 0)<br>
<br>
- em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=3D17)<br>
<br>
- em28xx #0: chip ID is em2882/em2883<br>
<br>
- - -&gt; GSI 22 (level, low) -&gt; IRQ 22<br>
<br>
- PCI: Setting latency timer of device 0000:00:1b.0 to 64<br>
<br>
- em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c=
<br>
<br>
- em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00=
<br>
<br>
- em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00=
<br>
<br>
- em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00=
<br>
<br>
- em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03=
<br>
<br>
- em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00=
<br>
<br>
- em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00=
<br>
<br>
- em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
<br>
<br>
- em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0x2de5abbf<br>
<br>
- em28xx #0: EEPROM info:<br>
<br>
- em28xx #0:       AC97 audio (5 sample rates)<br>
<br>
- em28xx #0:       500mA max power<br>
<br>
- em28xx #0:       Table at 0x27, strings=3D0x168e, 0x1ca4, 0x246a<br>
<br>
- hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...<br>
<br>
- input: em28xx IR (em28xx #0) as <br>
/devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6<br>
<br>
- - -&gt; GSI 20 (level, low) -&gt; IRQ 23<br>
<br>
- Vortex: init.... em28xx #0: Config register raw data: 0xd0<br>
<br>
- em28xx #0: AC97 vendor ID =3D 0xffffffff<br>
<br>
- em28xx #0: AC97 features =3D 0x6a90<br>
<br>
- em28xx #0: Empia 202 AC97 audio processor detected<br>
<br>
- em28xx #0: v4l2 driver version 0.1.2<br>
<br>
- em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0<br>
<br>
- usbcore: registered new interface driver em28xx<br>
<br>
- em28xx driver loaded<br>
<br>
- xc2028 0-0061: creating new instance<br>
<br>
- xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner<br>
<br>
- em28xx #0/2: xc3028 attached<br>
<br>
- DVB: registering new adapter (em28xx #0)<br>
<br>
- DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 <br>
VSB/QAM Frontend)...<br>
<br>
- Successfully loaded em28xx-dvb<br>
<br>
- Em28xx: Initialized (Em28xx dvb Extension) extension<br>
<br>
- done.<br>
<br>
<br>
<br>
Everything looks good - the drivers are getting called and the card is<br>
<br>
recognized.  However, all my attempts to get something "out of it"<br>
<br>
aren't working.  I tried firing up "tvtime", but it just launches a<br>
<br>
blank, black screen and hanges.  The menu won't come up, the channel<br>
<br>
won't change, right-clicking isn't responsive, it won't close, and I<br>
<br>
have to kill it.<br>
<br>
<br>
<br>
I also tried mencoder, but I get this:<br>
<br>
<br>
<br>
&gt; mencoder -nosound -tv driver=3Dv4l2:width=3D640:height=3D480 tv://3 -o=
 <br>
&gt; /tmp/tv.avi -ovc raw -endpos 5<br>
<br>
<br>
<br>
MEncoder 2:1.0~rc2-0ubuntu13.1+medibuntu1 (C) 2000-2007 MPlayer Team<br>
<br>
CPU: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz<br>
<br>
   (Family: 6, Model: 23, Stepping: 10)<br>
<br>
CPUflags: Type: 6 MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1<br>
<br>
Compiled with runtime CPU detection.<br>
<br>
success: format: 9  data: 0x0 - 0x0<br>
<br>
TV file format detected.<br>
<br>
Selected driver: v4l2<br>
<br>
  name: Video 4 Linux 2 input<br>
<br>
  author: Martin Olschewski<br>
<br>
  comment: first try, more to come ;-)<br>
<br>
Selected device: Pinnacle PCTV HD Pro Stick<br>
<br>
  Tuner cap:<br>
<br>
  Tuner rxs:<br>
<br>
  Capabilites:  video capture  tuner  audio  read/write  streaming<br>
<br>
  supported norms: 0 =3D NTSC; 1 =3D NTSC-M; 2 =3D NTSC-M-JP; 3 =3D NTSC-M-=
KR; 4<br>
<br>
    =3D NTSC-443; 5 =3D PAL; 6 =3D PAL-BG; 7 =3D PAL-H; 8 =3D PAL-I; 9 =3D =
PAL-DK;<br>
<br>
    10 =3D PAL-M; 11 =3D PAL-N; 12 =3D PAL-Nc; 13 =3D PAL-60; 14 =3D SECAM;=
 15 =3D<br>
<br>
    SECAM-B; 16 =3D SECAM-G; 17 =3D SECAM-H; 18 =3D SECAM-DK; 19 =3D SECAM-=
L; 20<br>
<br>
    =3D SECAM-Lc;<br>
<br>
  inputs: 0 =3D Television; 1 =3D Composite1; 2 =3D S-Video;<br>
<br>
  Current input: 0<br>
<br>
  Current format: YUYV<br>
<br>
v4l2: ioctl set format failed: Invalid argument<br>
<br>
v4l2: ioctl set format failed: Invalid argument<br>
<br>
v4l2: ioctl set format failed: Invalid argument<br>
<br>
v4l2: ioctl query control failed: Invalid argument<br>
<br>
v4l2: ioctl query control failed: Invalid argument<br>
<br>
v4l2: ioctl query control failed: Invalid argument<br>
<br>
v4l2: ioctl query control failed: Invalid argument<br>
<br>
[V] filefmt:9  fourcc:0x32595559  size:640x480  fps:25.00  ftime:=3D0.0400<=
br>
<br>
Opening video filter: [expand osd=3D1]<br>
<br>
Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
Opening video decoder: [raw] RAW Uncompressed Video<br>
<br>
VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)<br>
<br>
VDec: using Packed YUY2 as output csp (no 0)<br>
<br>
Movie-Aspect is undefined - no prescaling applied.<br>
<br>
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
Forcing audio preload to 0, max pts correction to 0.<br>
<br>
v4l2: select timeout<br>
<br>
<br>
<br>
Skipping frame!<br>
<br>
Pos:   0.0s      1f ( 0%)  0.96fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
Skipping frame!<br>
<br>
v4l2: select timeout( 0%)  1.28fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
<br>
<br>
Skipping frame!<br>
<br>
Pos:   0.0s      3f ( 0%)  1.44fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
Skipping frame!<br>
<br>
v4l2: select timeout( 0%)  1.54fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
<br>
<br>
Skipping frame!<br>
<br>
Pos:   0.0s      5f ( 0%)  1.60fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
Skipping frame!<br>
<br>
v4l2: select timeout( 0%)  1.65fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
<br>
<br>
Skipping frame!<br>
<br>
Pos:   0.0s      7f ( 0%)  1.68fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
Skipping frame!<br>
<br>
Pos:   0.0s      8f ( 0%)  1.71fps Trem:   0min   0mb  A-V:0.000 [0:0]<br>
<br>
<br>
<br>
<br>
<br>
The resulting file (/tmp/tv.avi) is only 4K and not a valid AVI file.<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
One thing I noticed that differs from what I was expecting is that<br>
<br>
nowhere in the "dmesg" output does it say anything about the firmware<br>
<br>
file.  I was expecting to see this in "dmesg":<br>
<br>
<br>
<br>
- firmware: requesting xc3028-v27.fw<br>
<br>
- xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,<br>
<br>
-   type: xc2028 firmware, ver 2.7<br>
<br>
<br>
<br>
but nothing approximating those lines appears at all.  I tried deleting<br>
<br>
/lib/firmware/xc3028-v27.fw entirely to see if it would complain, but<br>
<br>
it loaded up exactly the same way after I rebooted...  and still didn't<br>
<br>
work.<br>
<br>
<br>
<br>
So my questions are:<br>
<br>
<br>
<br>
1) Why is the firmware file not being read?  Has something happened to<br>
<br>
the em28xx drivers recently that causes this file not to be needed<br>
<br>
anymore?  Or is something else going wrong?<br>
<br>
<br>
<br>
2) Is that the reason for the problem, or have you spotted something<br>
<br>
else I've done wrong?<br>
<br>
<br>
<br>
Thanks greatly to anyone who can help!<br>
<br>
_________________________________________________________________<br>
Insert movie times and more without leaving Hotmail?.<br>
http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=3DTXT_TAGLM_WL_HM_Tut=
orial_QuickAdd_062009<br>
<br>
<br>
<br>
------------------------------<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
linux-dvb@linuxtv.org<br>
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br>
<br>
End of linux-dvb Digest, Vol 53, Issue 16<br>
*****************************************<br>
</col103-w5242cd3e26117eb289b48488380@phx.gbl></linux-dvb@linuxtv.org></g_a=
dams27@hotmail.com></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1245592141257600--



--===============2004979742==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2004979742==--
