Return-path: <mchehab@gaivota>
Received: from DSL01.212.114.205.243.ip-pool.NEFkom.net ([212.114.205.243]:46710
	"EHLO enzo.pibbs.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191Ab1AAWZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 17:25:12 -0500
Received: from trixi.localnet (trixi.pibbs.org [192.168.20.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by enzo.pibbs.org (Postfix) with ESMTPS id 65783DCF2E
	for <linux-media@vger.kernel.org>; Sat,  1 Jan 2011 23:18:13 +0100 (CET)
From: Martin Seekatz <martin@pibbs.de>
To: linux-media@vger.kernel.org
Subject: Silver Crest VG2000  "USB 2.0 Video Grabber", USB-Id: eb1a:2863 - does not work
Date: Sat, 1 Jan 2011 23:17:21 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101012317.22087.martin@pibbs.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

in December 2009, I bought an USB Stick as Video-Grabber in order to convert my old VCR video tapes to digital files.

The "Grabber" means that this is only converting analog video and audio signals to digital streams - without any TV or Radio receiver.

After installing the actual v4l-dvb tree the device is known from the kernel and modules are installed as reported below. 

The Problem is that no Video aplications is working with the unit. I have testet MoTV, Kaffeine/Xine and VLC.

With MoTV tool i got the following informations:
v4l-conf: using X11 display :0.0
dga: version 2.0
WARNING: No DGA direct video mode for this display.
mode: 1920x1200, depth=24, bpp=32, bpl=7680, base=unknown
/dev/video0 [v4l2]: no overlay support

The device was sold from the "Lidl" discounter in Germany for 27.99 E
UR

 I successfully instaled the Drivers acording to
http://www.linuxtv.org/wiki/index.php/Em28xx_devices
The only differnce was the "make install" needs to be done as root or with sudo. No error messages ocured during the compilation 
and installation.


----------------------------- Package Informations ------------------
Item: USB-Video-Grabber
EAN: 4250133701701
SN: L7088988
Trade Mark: SILVER CREST (or SilverCrest)
Trade Mark Owner: Lidl Stiftung & Co. KG, 74172 Neckarsulm, DE
Distributor: Targa GmbH, Lange Wende 41, D-59494 Soest
Model: Silvercrest VG 2000
TARGA-Nr. 1479836

Technical datas
Interface: USB 2.0
Video-Inputs: Composite and S-Video
Audio-Inputs: 2 x Cinch (stereo)
Video-Resolution: PAL/SECAM: 720 x 576 @ 25 FPS; NTSC: 720 x 480 @ 30 FPS


----------------- Linux Informations --------------------------
Distribution: OpenSuse 11.3

System:
Linux trixi 2.6.34.7-0.5-desktop #1 SMP PREEMPT 2010-10-25 08:40:12 +0200 x86_64 x86_64 x86_64 GNU/Linux


USB Infos:
Bus 002 Device 006: ID eb1a:2863 eMPIA Technology, Inc. 

Kernel informations from /var/log/messages:
Dec 31 16:40:56 trixi kernel: [ 3004.742788] usb 2-5: new high speed USB device using ehci_hcd and address 5
Dec 31 16:40:56 trixi kernel: [ 3004.857132] usb 2-5: New USB device found, idVendor=eb1a, idProduct=2863
Dec 31 16:40:56 trixi kernel: [ 3004.857136] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Dec 31 16:40:56 trixi kernel: [ 3004.857593] em28xx: New device @ 480 Mbps (eb1a:2863, interface 0, class 0)
Dec 31 16:40:56 trixi kernel: [ 3004.857886] em28xx #0: chip ID is em2860
Dec 31 16:40:56 trixi kernel: [ 3004.927236] em28xx #0: board has no eeprom
Dec 31 16:40:56 trixi kernel: [ 3004.928382] em28xx #0: Identified as EM2860/SAA711X Reference Design (card=19)
Dec 31 16:40:56 trixi kernel: [ 3004.928385] em28xx #0: Registering snapshot button...
Dec 31 16:40:56 trixi kernel: [ 3004.928439] input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input9
Dec 31 16:40:56 trixi kernel: [ 3004.928439] input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input9
Dec 31 16:40:56 trixi kernel: [ 3004.931863] em28xx #0: Config register raw data: 0x10
Dec 31 16:40:56 trixi kernel: [ 3004.945893] em28xx #0: AC97 vendor ID = 0x83847650
Dec 31 16:40:56 trixi kernel: [ 3004.952882] em28xx #0: AC97 features = 0x6a90
Dec 31 16:40:56 trixi kernel: [ 3004.952885] em28xx #0: Sigmatel audio processor detected(stac 9750)
Dec 31 16:40:56 trixi kernel: [ 3005.161760] em28xx #0: v4l2 driver version 0.1.2
Dec 31 16:40:57 trixi kernel: [ 3005.628853] em28xx #0: V4L2 video device registered as video0
Dec 31 16:40:57 trixi kernel: [ 3005.628856] em28xx #0: V4L2 VBI device registered as vbi0
Dec 31 16:40:57 trixi kernel: [ 3005.628856] em28xx #0: V4L2 VBI device registered as vbi0
Dec 31 16:40:57 trixi kernel: [ 3005.628859] em28xx-audio.c: probing for em28x1 non standard usbaudio
Dec 31 16:40:57 trixi kernel: [ 3005.628861] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger

Device files (/dev/dvb* is not existing):
> l -R /dev/dvb* /dev/vb* /dev//video* /dev/v4l
ls: Zugriff auf /dev/dvb* nicht möglich: Datei oder Verzeichnis nicht gefunden
crw-rw----+ 1 root video 81, 1  1. Jan 21:01 /dev/vbi0
crw-rw----+ 1 root video 81, 0  1. Jan 21:01 /dev//video0

/dev/v4l:
insgesamt 0
drwxr-xr-x  4 root root   80  1. Jan 21:01 ./
drwxr-xr-x 18 root root 4940  1. Jan 21:02 ../
drwxr-xr-x  2 root root   60  1. Jan 21:01 by-id/
drwxr-xr-x  2 root root   80  1. Jan 21:01 by-path/

/dev/v4l/by-id:
insgesamt 0
drwxr-xr-x 2 root root 60  1. Jan 21:01 ./
drwxr-xr-x 4 root root 80  1. Jan 21:01 ../
lrwxrwxrwx 1 root root 12  1. Jan 21:01 usb-eb1a_2863-video-index0 -> ../../video0

/dev/v4l/by-path:
insgesamt 0
drwxr-xr-x 2 root root 80  1. Jan 21:01 ./
drwxr-xr-x 4 root root 80  1. Jan 21:01 ../
lrwxrwxrwx 1 root root 12  1. Jan 21:01 pci-0000:00:1d.7-usb-0:6:1.0-video-index0 -> ../../video0                                                                                             
lrwxrwxrwx 1 root root 10  1. Jan 21:01 pci-0000:00:1d.7-usb-0:6:1.0-video-index1 -> ../../vbi0

Modules infos from lsmod |grep em28:
em28xx_alsa             7812  1 
em28xx                105961  1 em28xx_alsa
v4l2_common            21343  2 saa7115,em28xx
videodev               51824  3 saa7115,em28xx,v4l2_common
ir_core                17940  6 ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,em28xx
videobuf_vmalloc        5709  1 em28xx
videobuf_core          20773  2 em28xx,videobuf_vmalloc
tveeprom               13945  1 em28xx
snd_pcm               105589  4 snd_pcm_oss,em28xx_alsa,snd_hda_intel,snd_hda_codec
snd                    84444  19 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,em28xx_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer


Best regards
Martin
