Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45825 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2K0Vz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 16:55:59 -0500
Received: by mail-vb0-f46.google.com with SMTP id ff1so7385747vbb.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 13:55:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+8K-g=2DOsWs1Px=T0q69GPmcFQFgH6WpVepyZDrxYheN=VeQ@mail.gmail.com>
References: <CA+8K-g=2DOsWs1Px=T0q69GPmcFQFgH6WpVepyZDrxYheN=VeQ@mail.gmail.com>
Date: Tue, 27 Nov 2012 22:55:58 +0100
Message-ID: <CA+8K-gmxss6DfkMcHYuaa1yn2LdF_qAQiZOnQUMqc2UO8LDvPA@mail.gmail.com>
Subject: cx231xx device not working
From: Vincent Gerris <vgerris@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently bought an Elro DVR14 set in a sale.
I plugged in Ubuntu Linux 12.10 with recent updates and noticed the
following in dmesg:

[ 3339.600316] usb 2-1: new high-speed USB device number 7 using ehci_hcd
[ 3339.736181] usb 2-1: New USB device found, idVendor=0572, idProduct=58a6
[ 3339.736192] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 3339.736200] usb 2-1: Product: Polaris AV Capture
[ 3339.736207] usb 2-1: Manufacturer: Conexant Corporation
[ 3339.736213] usb 2-1: SerialNumber: 0000000002
[ 3339.741425] cx231xx #0: New device Conexant Corporation Polaris AV
Capture @ 480 Mbps (0572:58a6) with 6 interfaces
[ 3339.741433] cx231xx #0: registering interface 1
[ 3339.741551] cx231xx #0: can't change interface 4 alt no. to 3: Max.
Pkt size = 0
[ 3339.741672] cx231xx #0: can't change interface 5 alt no. to 1: Max.
Pkt size = 0
[ 3339.741798] cx231xx #0: Identified as Conexant VIDEO GRABBER (card=5)
[ 3339.834063] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[ 3339.841321] cx231xx #0: Changing the i2c master port to 3
[ 3339.846561] cx25840 9-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[ 3339.865576] cx25840 9-0044:  Firmware download size changed to 16
bytes max length
[ 3341.999466] cx25840 9-0044: loaded v4l-cx231xx-avcore-01.fw
firmware (16382 bytes)
[ 3342.039833] attach 417 5
[ 3342.039843] cx231xx #0: cx231xx_417_register()
[ 3342.039849] cx231xx #0: cx231xx_video_dev_alloc()
[ 3342.040114] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.2
[ 3342.063910] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[ 3342.114209] cx231xx #0: video_mux : 0
[ 3342.114218] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[ 3342.115053] cx231xx #0: do_mode_ctrl_overrides NTSC
[ 3342.121757] cx231xx #0: cx231xx #0/0: registered device video2 [v4l2]
[ 3342.122004] cx231xx #0: cx231xx #0/0: registered device vbi0
[ 3342.122010] cx231xx #0: V4L2 device registered as video2 and vbi0
[ 3342.122016] cx231xx #0: cx231xx-audio.c: probing for cx231xx non
standard usbaudio
[ 3342.122499] cx231xx #0: EndPoint Addr 0x83, Alternate settings: 3
[ 3342.122504] cx231xx #0: Alternate setting 0, max size= 512
[ 3342.122509] cx231xx #0: Alternate setting 1, max size= 28
[ 3342.122514] cx231xx #0: Alternate setting 2, max size= 52
[ 3342.122519] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
[ 3342.122524] cx231xx #0: Alternate setting 0, max size= 512
[ 3342.122528] cx231xx #0: Alternate setting 1, max size= 184
[ 3342.122533] cx231xx #0: Alternate setting 2, max size= 728
[ 3342.122537] cx231xx #0: Alternate setting 3, max size= 2892
[ 3342.122542] cx231xx #0: Alternate setting 4, max size= 1800
[ 3342.122547] cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
[ 3342.122551] cx231xx #0: Alternate setting 0, max size= 512
[ 3342.122555] cx231xx #0: Alternate setting 1, max size= 512
[ 3342.122560] cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
[ 3342.122565] cx231xx #0: Alternate setting 0, max size= 512
[ 3342.122569] cx231xx #0: Alternate setting 1, max size= 576
[ 3342.122574] cx231xx #0: EndPoint Addr 0x81, Alternate settings: 6
[ 3342.122578] cx231xx #0: Alternate setting 0, max size= 512
[ 3342.122583] cx231xx #0: Alternate setting 1, max size= 64
[ 3342.122587] cx231xx #0: Alternate setting 2, max size= 128
[ 3342.122591] cx231xx #0: Alternate setting 3, max size= 316
[ 3342.122595] cx231xx #0: Alternate setting 4, max size= 712
[ 3342.122600] cx231xx #0: Alternate setting 5, max size= 1424
[ 3342.593524] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.597936] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.597939] cx231xx #0: cx231xx_initialize_codec()
[ 3342.601917] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.606041] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.610260] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.614291] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.618664] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.622964] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.626914] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.633590] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.637546] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.641673] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.645800] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.645803] cx231xx_load_firmware: Error with mc417_register_write
[ 3342.645806] cx231xx_initialize_codec() f/w load failed
[ 3342.645824] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[ 3342.658192] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.662312] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.662488] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[ 3342.670943] cx231xx #0: can't change interface 4 alt no. to 0 (err=-71)
[ 3342.680104] cx231xx #0: can't change interface 3 alt no. to 1 (err=-71)
[ 3342.680119] cx231xx #0: failed to set alternate setting !
[ 3342.688925] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[ 3342.697175] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[ 3342.701316] cx231xx #0: can't change interface 3 alt no. to 1 (err=-71)
[ 3342.701323] cx231xx #0: failed to set alternate setting !
[ 3342.705685] cx231xx #0: can't change interface 3 alt no. to 1 (err=-71)
[ 3342.705691] cx231xx #0: failed to set alternate setting !

A fellow hacker helped me trying to see if it worked and issued this command:
vincent@ThinkPad-T400s:~$ mplayer -tv device=/dev/video1 pvr://
MPlayer svn r34540 (Ubuntu), built with gcc-4.6 (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing pvr://.
[v4l2] select channel list europe-east, entries 133
[pvr] Using device /dev/video1
[pvr] Detected VideoGrabber
[v4l2] Available video inputs: '#0, Composite1' '#1, S-Video'
[v4l2] Available audio inputs: '#0, VideoGrabber A'
[v4l2] Available norms: '#0, NTSC-M' '#1, NTSC-M-JP' '#2, NTSC-443'
'#3, PAL-BG' '#4, PAL-I' '#5, PAL-DK' '#6, PAL-M' '#7, PAL-N' '#8,
PAL-Nc' '#9, PAL-60' '#10, SECAM-DK' '#11, SECAM-L'
[v4l2] Using current set frequency 0, to set channel
[encoder] Error setting MPEG controls (Operation not permitted).
[pvr] can't set encoder settings
Failed to open pvr://.


Exiting... (End of file)

Then as root I got some more:
root@ThinkPad-T400s:~# mplayer -tv device=/dev/video1 pvr://
Creating config file: /root/.mplayer/config
MPlayer svn r34540 (Ubuntu), built with gcc-4.6 (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing pvr://.
[v4l2] select channel list europe-east, entries 133
[pvr] Using device /dev/video1
[pvr] Detected VideoGrabber
[v4l2] Available video inputs: '#0, Composite1' '#1, S-Video'
[v4l2] Available audio inputs: '#0, VideoGrabber A'
[v4l2] Available norms: '#0, NTSC-M' '#1, NTSC-M-JP' '#2, NTSC-443'
'#3, PAL-BG' '#4, PAL-I' '#5, PAL-DK' '#6, PAL-M' '#7, PAL-N' '#8,
PAL-Nc' '#9, PAL-60' '#10, SECAM-DK' '#11, SECAM-L'
[v4l2] Using current set frequency 0, to set channel
[v4l2] Video input: Composite1
[v4l2] Audio input: VideoGrabber A
[v4l2] Norm: NTSC-M.
libavformat version 53.21.0 (external)
Mismatching header version 53.19.0
[pvr] failed with errno 22 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 22 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 22 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 22 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 22 when reading 2048 bytes
[pvr] read 0 bytes

MPlayer interrupted by signal 2 in module: demux_open
[pvr] failed with errno 4 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 4 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 4 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 4 when reading 2048 bytes
[pvr] read 0 bytes
[pvr] failed with errno 4 when reading 2048 bytes
[pvr] read 0 bytes

MPlayer interrupted by signal 2 in module: demux_open (after a ctrl+c)

More info about the device:
http://www.elro.eu/en/products/category/beveiliging/camerabewaking/dvrs/bewakingsrecorder
The box says DVR14 USB DVR BOX and TE-3204E
Lot no: 12SX11 Version 2

I got this email as a tip to mail to, so I hope anybody has a clue?
Any help is appreciated.
By the way, the Windows driver I use is the one that does not have
Windows_XP added to it.
That one seems to be for a 3104 or something device.

Thanks for any help!

Kind regards,
Vincent
