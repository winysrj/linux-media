Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61658 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab1LBTlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 14:41:32 -0500
Received: by lagp5 with SMTP id p5so336862lag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Dec 2011 11:41:30 -0800 (PST)
Message-ID: <4ED929E7.2050808@gmail.com>
Date: Fri, 02 Dec 2011 20:41:27 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-930C problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi ,

I noticed that HVR 930C support was added 21-11-2011.

I have build the new driver and installed the firmware but I'm 
struggling to get it working.

I have the firmwares:

dvb-usb-hauppauge-hvr930c-drxk.fw

and

dvb-fe-xc5000-1.6.114.fw

in /lib/firmware (on  a Gentoo x86_64 system)

Since I'm new to tv devices, what tools should I use?

Some tests I've done:

1) Driver loading:

#  modprobe em28xx
# dmesg -c
[90072.073823] em28xx 2-3:1.0: usb_probe_interface
[90072.073827] em28xx 2-3:1.0: usb_probe_interface - got id
[90072.073832] em28xx: New device WinTV HVR-930C @ 480 Mbps (2040:1605, 
interface 0, class 0)
[90072.073834] em28xx: Audio Vendor Class interface 0 found
[90072.077038] em28xx #0: chip ID is em2884
[90072.129073] em28xx #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[90072.129451] Registered IR keymap rc-hauppauge
[90072.129575] input: em28xx IR (em28xx #0) as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc4/input17
[90072.129625] rc4: em28xx IR (em28xx #0) as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc4
[90072.130444] em28xx #0: Config register raw data: 0xcb
[90072.130446] em28xx #0: v4l2 driver version 0.1.3
[90072.135290] em28xx #0: V4L2 video device registered as video1
[90072.140241] usbcore: registered new interface driver em28xx
[90072.140243] em28xx driver loaded
[90073.298578] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[90074.641068] DRXK driver version 0.9.4300
[90074.655586] xc5000 1-0061: creating new instance
[90074.656091] xc5000: Successfully identified at address 0x61
[90074.656094] xc5000: Firmware has not been loaded previously
[90074.656098] DVB: registering new adapter (em28xx #0)
[90074.656101] DVB: registering adapter 0 frontend 0 (DRXK DVB-C)...
[90074.656172] DVB: registering adapter 0 frontend 1 (DRXK DVB-T)...
[90074.656389] em28xx #0: Successfully loaded em28xx-dvb
[90074.656392] Em28xx: Initialized (Em28xx dvb Extension) extension

which looks ok to me.

2) Analog scanning:

# scantv -a -n PAL

vid-open-auto: failed to open an analog TV device at /dev/video1
vid-open: could not find a suitable videodev
no analog TV device available

# dmesg  -c
[90174.629465] ehci_hcd 0000:00:1a.7: reused qh ffff880118578f80 schedule
[90174.629469] usb 1-6: link qh4-0001/ffff880118578f80 start 2 [1/0 us]
[90174.629711] usb 1-6: unlink qh4-0001/ffff880118578f80 start 2 [1/0 us]

3) Mplayer

# mplayer tv:// -tv 
driver=v4l2:norm=PAL:input=0:amode=1:width=384:height=288:outfmt=yv12:device=/dev/video1:chanlist=europe-west:channel=S14

MPlayer SVN-r33094-4.5.3 (C) 2000-2011 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
  name: Video 4 Linux 2 input
  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
  comment: first try, more to come ;-)
Selected device: Hauppauge WinTV HVR 930C
  Capabilities:  video capture  read/write  streaming
  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 
= NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = 
PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 
16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
  inputs:
  Current input: 0
  Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl enum input failed: Invalid argument
Selected input hasn't got a tuner!
v4l2: ioctl queue buffer failed: No space left on device
v4l2: 0 frames successfully processed, 0 frames dropped.


Exiting... (End of file)

# dmesg  -c

[90262.194863] ehci_hcd 0000:00:1d.7: iso resched full ffff8800d7df9000 
(now 5829 max 14021)
[90262.194870] submit of urb 0 failed (error=-28)

4) DVB scanning

# w_scan -c NO -f c

w_scan version 20110702 (compiled for DVB API 5.2)
using settings for NORWAY
DVB cable
DVB-C
frontend_type DVB-C, channellist 7
output format vdr-1.6
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
         /dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": good :-)
         /dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": specified 
was DVB-C -> SEARCH NEXT ONE.
Using DVB-C frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.4
frontend 'DRXK DVB-C' supports
INVERSION_AUTO
QAM_AUTO not supported, trying QAM_64 QAM_256.
FEC_AUTO
FREQ (47.00MHz ... 862.00MHz)
SRATE (0.870MBd ... 11.700MBd)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
searching QAM64...
73000: sr6900 (time: 00:00) sr6875 (time: 00:03)
81000: sr6900 (time: 00:06) sr6875 (time: 00:08)
113000: sr6900 (time: 00:11) sr6875 (time: 00:13)
121000: sr6900 (time: 00:16) sr6875 (time: 00:18)
129000: sr6900 (time: 00:21) sr6875 (time: 00:23)
137000: sr6900 (time: 00:26) sr6875 (time: 00:28)
145000: sr6900 (time: 00:31) sr6875 (time: 00:34)
153000: sr6900 (time: 00:36) sr6875 (time: 00:39)
161000: sr6900 (time: 00:41) sr6875 (time: 00:44)
169000: sr6900 (time: 00:46) sr6875 (time: 00:49)
314000: sr6900 (time: 00:51) sr6875 (time: 00:54)
322000: sr6900 (time: 00:56) sr6875 (time: 00:59)
330000: sr6900 (time: 01:01) sr6875 (time: 01:04)
338000: sr6900 (time: 01:07) sr6875 (time: 01:09)
346000: sr6900 (time: 01:12) sr6875 (time: 01:14)
354000: sr6900 (time: 01:17) sr6875 (time: 01:19)
362000: sr6900 (time: 01:22) sr6875 (time: 01:24)
370000: sr6900 (time: 01:27) sr6875 (time: 01:29)
378000: sr6900 (time: 01:32) sr6875 (time: 01:34)
386000: sr6900 (time: 01:37) sr6875 (time: 01:40)
394000: sr6900 (time: 01:42) sr6875 (time: 01:45)
402000: sr6900 (time: 01:47) sr6875 (time: 01:50)
410000: sr6900 (time: 01:52) sr6875 (time: 01:55)
418000: sr6900 (time: 01:57) sr6875 (time: 02:00)
426000: sr6900 (time: 02:02) sr6875 (time: 02:05)
434000: sr6900 (time: 02:08) sr6875 (time: 02:10)
442000: sr6900 (time: 02:13) sr6875 (time: 02:15)
450000: sr6900 (time: 02:18) sr6875 (time: 02:20)
458000: sr6900 (time: 02:23) sr6875 (time: 02:25)
466000: sr6900 (time: 02:28) sr6875 (time: 02:30)
474000: sr6900 (time: 02:33) sr6875 (time: 02:35)
482000: sr6900 (time: 02:38) sr6875 (time: 02:41)
490000: sr6900 (time: 02:43) sr6875 (time: 02:46)
498000: sr6900 (time: 02:48) sr6875 (time: 02:51)
506000: sr6900 (time: 02:53) sr6875 (time: 02:56)
514000: sr6900 (time: 02:58) sr6875 (time: 03:01)
522000: sr6900 (time: 03:03) sr6875 (time: 03:06)
530000: sr6900 (time: 03:08) sr6875 (time: 03:11)
538000: sr6900 (time: 03:14) sr6875 (time: 03:16)
546000: sr6900 (time: 03:19) sr6875 (time: 03:21)
554000: sr6900 (time: 03:24) sr6875 (time: 03:26)
562000: sr6900 (time: 03:29) sr6875 (time: 03:31)
570000: sr6900 (time: 03:34) sr6875 (time: 03:36)
578000: sr6900 (time: 03:39) sr6875 (time: 03:42)
586000: sr6900 (time: 03:44) sr6875 (time: 03:47)
594000: sr6900 (time: 03:49) sr6875 (time: 03:52)
602000: sr6900 (time: 03:54) sr6875 (time: 03:57)
610000: sr6900 (time: 03:59) sr6875 (time: 04:02)
618000: sr6900 (time: 04:04) sr6875 (time: 04:07)
626000: sr6900 (time: 04:09) sr6875 (time: 04:12)
634000: sr6900 (time: 04:15) sr6875 (time: 04:17)
642000: sr6900 (time: 04:20) sr6875 (time: 04:22)
650000: sr6900 (time: 04:25) sr6875 (time: 04:27)
658000: sr6900 (time: 04:30) sr6875 (time: 04:32)
666000: sr6900 (time: 04:35) sr6875 (time: 04:37)
674000: sr6900 (time: 04:40) sr6875 (time: 04:42)
682000: sr6900 (time: 04:45) sr6875 (time: 04:48)
690000: sr6900 (time: 04:50) sr6875 (time: 04:53)
698000: sr6900 (time: 04:55) sr6875 (time: 04:58)
706000: sr6900 (time: 05:00) sr6875 (time: 05:03)
714000: sr6900 (time: 05:05) sr6875 (time: 05:08)
722000: sr6900 (time: 05:10) sr6875 (time: 05:13)
730000: sr6900 (time: 05:16) sr6875 (time: 05:18)
738000: sr6900 (time: 05:21) sr6875 (time: 05:23)
746000: sr6900 (time: 05:26) sr6875 (time: 05:28)
754000: sr6900 (time: 05:31) sr6875 (time: 05:33)
762000: sr6900 (time: 05:36) sr6875 (time: 05:38)
770000: sr6900 (time: 05:41) sr6875 (time: 05:43)
778000: sr6900 (time: 05:46) sr6875 (time: 05:49)
786000: sr6900 (time: 05:51) sr6875 (time: 05:54)
794000: sr6900 (time: 05:56) sr6875 (time: 05:59)
802000: sr6900 (time: 06:01) sr6875 (time: 06:04)
810000: sr6900 (time: 06:06) sr6875 (time: 06:09)
818000: sr6900 (time: 06:11) sr6875 (time: 06:14)
826000: sr6900 (time: 06:16) sr6875 (time: 06:19)
834000: sr6900 (time: 06:22) sr6875 (time: 06:24)
842000: sr6900 (time: 06:27) sr6875 (time: 06:29)
850000: sr6900 (time: 06:32) sr6875 (time: 06:34)
858000: sr6900 (time: 06:37) sr6875 (time: 06:39)
searching QAM256...
73000: sr6900 (time: 06:42) sr6875 (time: 06:44)
81000: sr6900 (time: 06:47) sr6875 (time: 06:50)
113000: sr6900 (time: 06:52) sr6875 (time: 06:55)
121000: sr6900 (time: 06:57) sr6875 (time: 07:00)
129000: sr6900 (time: 07:02) sr6875 (time: 07:05)
137000: sr6900 (time: 07:07) sr6875 (time: 07:10)
145000: sr6900 (time: 07:12) sr6875 (time: 07:15)
153000: sr6900 (time: 07:17) sr6875 (time: 07:20)
161000: sr6900 (time: 07:23) sr6875 (time: 07:25)
169000: sr6900 (time: 07:28) sr6875 (time: 07:30)
314000: sr6900 (time: 07:33) (time: 07:34)
sr6875 (time: 07:35)
322000: sr6900 (time: 07:37) (time: 07:39)
sr6875 (time: 07:40)
330000: sr6900 (time: 07:42) (time: 07:43)
sr6875 (time: 07:44)
338000: sr6900 (time: 07:47) (time: 07:48)
sr6875 (time: 07:49)
346000: sr6900 (time: 07:52) (time: 07:53)
sr6875 (time: 07:54)
354000: sr6900 (time: 07:56) (time: 07:57)
sr6875 (time: 07:58)
362000: sr6900 (time: 08:01) (time: 08:02)
sr6875 (time: 08:03)
370000: sr6900 (time: 08:06) (time: 08:07)
sr6875 (time: 08:08)
378000: sr6900 (time: 08:10) (time: 08:12)
sr6875 (time: 08:13)
386000: sr6900 (time: 08:15) (time: 08:16)
sr6875 (time: 08:17)
394000: sr6900 (time: 08:20) (time: 08:21)
sr6875 (time: 08:22)
402000: sr6900 (time: 08:25) sr6875 (time: 08:27)
410000: sr6900 (time: 08:30) sr6875 (time: 08:32)
418000: sr6900 (time: 08:35) sr6875 (time: 08:37)
426000: sr6900 (time: 08:40) sr6875 (time: 08:42)
434000: sr6900 (time: 08:45) sr6875 (time: 08:47)
442000: sr6900 (time: 08:50) sr6875 (time: 08:53)
450000: sr6900 (time: 08:55) sr6875 (time: 08:58)
458000: sr6900 (time: 09:00) sr6875 (time: 09:03)
466000: sr6900 (time: 09:05) sr6875 (time: 09:08)
474000: sr6900 (time: 09:10) sr6875 (time: 09:13)
482000: sr6900 (time: 09:15) sr6875 (time: 09:18)
490000: sr6900 (time: 09:20) sr6875 (time: 09:23)
498000: sr6900 (time: 09:26) sr6875 (time: 09:28)
506000: sr6900 (time: 09:31) sr6875 (time: 09:33)
514000: sr6900 (time: 09:36) sr6875 (time: 09:38)
522000: sr6900 (time: 09:41) sr6875 (time: 09:43)
530000: sr6900 (time: 09:46) sr6875 (time: 09:48)
538000: sr6900 (time: 09:51) sr6875 (time: 09:54)
546000: sr6900 (time: 09:56) sr6875 (time: 09:59)
554000: sr6900 (time: 10:01) sr6875 (time: 10:04)
562000: sr6900 (time: 10:06) sr6875 (time: 10:09)
570000: sr6900 (time: 10:11) sr6875 (time: 10:14)
578000: sr6900 (time: 10:16) sr6875 (time: 10:19)
586000: sr6900 (time: 10:21) sr6875 (time: 10:24)
594000: sr6900 (time: 10:27) sr6875 (time: 10:29)
602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
         QAM_256  f = 602000 kHz S6900C999
start_filter:1415: ERROR: ioctl DMX_SET_FILTER failed: 28 No space left 
on device
Info: NIT(actual) filter timeout
610000: sr6900 (time: 10:55) sr6875 (time: 10:58)
618000: sr6900 (time: 11:00) sr6875 (time: 11:03)
626000: sr6900 (time: 11:05) sr6875 (time: 11:08)
634000: sr6900 (time: 11:10) sr6875 (time: 11:13)
642000: sr6900 (time: 11:15) sr6875 (time: 11:18)
650000: sr6900 (time: 11:20) sr6875 (time: 11:23)
658000: sr6900 (time: 11:26) sr6875 (time: 11:28)
666000: sr6900 (time: 11:31) sr6875 (time: 11:33)
674000: sr6900 (time: 11:36) sr6875 (time: 11:38)
682000: sr6900 (time: 11:41) sr6875 (time: 11:43)
690000: sr6900 (time: 11:46) sr6875 (time: 11:48)
698000: sr6900 (time: 11:51) sr6875 (time: 11:53)
706000: sr6900 (time: 11:56) sr6875 (time: 11:59)
714000: sr6900 (time: 12:01) sr6875 (time: 12:04)
722000: sr6900 (time: 12:06) sr6875 (time: 12:09)
730000: sr6900 (time: 12:11) sr6875 (time: 12:14)
738000: sr6900 (time: 12:16) sr6875 (time: 12:19)
746000: sr6900 (time: 12:21) sr6875 (time: 12:24)
754000: sr6900 (time: 12:27) sr6875 (time: 12:29)
762000: sr6900 (time: 12:32) sr6875 (time: 12:34)
770000: sr6900 (time: 12:37) sr6875 (time: 12:39)
778000: sr6900 (time: 12:42) sr6875 (time: 12:44)
786000: sr6900 (time: 12:47) sr6875 (time: 12:49)
794000: sr6900 (time: 12:52) sr6875 (time: 12:54)
802000: sr6900 (time: 12:57) sr6875 (time: 13:00)
810000: sr6900 (time: 13:02) sr6875 (time: 13:05)
818000: sr6900 (time: 13:07) sr6875 (time: 13:10)
826000: sr6900 (time: 13:12) sr6875 (time: 13:15)
834000: sr6900 (time: 13:17) sr6875 (time: 13:20)
842000: sr6900 (time: 13:22) sr6875 (time: 13:25)
850000: sr6900 (time: 13:27) sr6875 (time: 13:30)
858000: sr6900 (time: 13:33) sr6875 (time: 13:35)
tune to: QAM_256  f = 602000 kHz S6900C999
(time: 13:38) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout
dumping lists (0 services)
Done.

# dmesg  -c

[90430.491896] xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
[90430.493120] xc5000: firmware read 12401 bytes.
[90430.493122] xc5000: firmware uploading...
[90430.864026] xc5000: firmware upload complete...
[90431.558408] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[90431.558414] drxk: 02 00 00 00 10 00 05 00 03 02                    
..........
[90433.838274] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[90433.838279] drxk: 02 00 00 00 10 00 05 00 03 02                    
..........
[90436.409398] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:

<snip>

The HVR 930C device has three connectors/inputs:  an antenna input, an 
S-video, and a composite video, respectively,

The provider I have here in Norway (Get) has both analog tv and digital 
(DVB-C) so can I get analog tv using the antenna input or is analog only 
on the S-video/composite inputs? And, how do I select which analog input 
that  is used?

Regards,

/Fredrik
