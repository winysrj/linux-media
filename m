Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:48069 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaASRHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 12:07:34 -0500
Message-ID: <52DC04E8.8020406@fnxweb.com>
Date: Sun, 19 Jan 2014 17:01:28 +0000
From: Neil Bird <gnome@fnxweb.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem getting sensible video out of Hauppauge HVR-1100 composite
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


   I'm in the UK (PAL), & have a Hauppauge HVR-1100 on Scientific Linux6:

2.6.32-358.18.1.el6.i686
libv4l-0.6.3-2.el6.i686
v4l-utils-0.9.0.git5f24b816-2.el6.i686
ivtv-firmware-20080701-20.2.noarch

Hauppauge WinTV-HVR1120 DVB-T/Hybrid [card=156,autodetected]
input: saa7134 IR (Hauppauge WinTV-HVR as 
/devices/pci0000:00/0000:00:14.4/0000:05:07.0/rc/rc1/input13
rc1: saa7134 IR (Hauppauge WinTV-HVR as 
/devices/pci0000:00/0000:00:14.4/0000:05:07.0/rc/rc1
input: MCE IR Keyboard/Mouse (saa7134) as /devices/virtual/input/input14


   (I think that's the relevant firmware)


   I set everything I know of up OK, but when I access /dev/video0 I get 
a garbled pink MPEG file (cat to a file, then mplayer to test).  The 
DVB-T aspect of is works fine (tested using vlc).

   The only logger error I can see that might related is:

kernel: tda18271_write_regs: [2-0060|M] ERROR: idx = 0x25, len = 1, 
i2c_transfer returned: -5
kernel: tda18271_channel_configuration: [2-0060|M] error -5 on line 119
kernel: tda18271_set_analog_params: [2-0060|M] error -5 on line 1050

   .. but I think that may be something else (I have another DVB card 
plugged in).


   I have:

$ v4l2-ctl -I
Video input : 1 (Composite1: ok)

   .. so I think it can see something.  If I unplug the [known working] 
composite feed I get:

$ v4l2-ctl -I
Video input : 1 (Composite1: no hsync lock., no sync lock)


   Lastly:

$ v4l2-ctl --all
Driver Info (not using libv4l2):
	Driver name   : saa7134
	Card type     : Hauppauge WinTV-HVR1120 DVB-T/H
	Bus info      : PCI:0000:05:07.0
	Driver version: 3.0.0
	Capabilities  : 0x05010015
		Video Capture
		Video Overlay
		VBI Capture
		Tuner
		Read/Write
		Streaming
Format Video Capture:
	Width/Height  : 720/576
	Pixel Format  : 'BGR3'
	Field         : Interlaced
	Bytes per Line: 2160
	Size Image    : 1244160
	Colorspace    : Unknown (00000000)
Format Video Overlay:
	Left/Top    : 0/0
	Width/Height: 0/0
	Field       : Any
	Chroma Key  : 0x00000000
	Global Alpha: 0x00
	Clip Count  : 0
	Clip Bitmap : No
Format VBI Capture:
	Sampling Rate   : 27000000 Hz
	Offset          : 256 samples (9.48148e-06 secs after leading edge)
	Samples per Line: 2048
	Sample Format   : GREY
	Start 1st Field : 7
	Count 1st Field : 16
	Start 2nd Field : 319
	Count 2nd Field : 16
Framebuffer Format:
	Capability    : Clipping List
	Flags         :
	Width         : 0
	Height        : 0
	Pixel Format  : ''
	Bytes per Line: 0
	Size image    : 0
	Colorspace    : Unknown (00000000)
Crop Capability Video Capture:
	Bounds      : Left 0, Top 46, Width 720, Height 578
	Default     : Left 0, Top 48, Width 720, Height 576
	Pixel Aspect: 54/59
Crop: Left 0, Top 48, Width 720, Height 576
Video input : 1 (Composite1: ok)
Audio input : 0 (audio)
Frequency: 0 (0.000000 MHz)
Video Standard = 0x000000ff
	PAL-B/B1/G/H/I/D/D1/K
Streaming Parameters Video Capture:
	Frames per second: invalid (0/0)
	Read buffers     : 0
Tuner:
	Name                 : Television
	Capabilities         : 62.5 kHz multi-standard stereo lang1 lang2
	Frequency range      : 0.0 MHz - 268435455.9 MHz
	Signal strength/AFC  : 100%/0
	Current audio mode   : mono
	Available subchannels: mono
Priority: 2


   I had done a 'v4l2-ctl --set-fmt-video=width=720,height=576' 
previously as that's what I've done on my old Hauppauge PVR-350, but 
don't recall why it was necessary, I was just trying anything I could. 
I'd also done 'v4l2-ctl --set-standard pal'.

-- 
[phoenix@fnx ~]# rm -f .signature
[phoenix@fnx ~]# ls -l .signature
ls: .signature: No such file or directory
[phoenix@fnx ~]# exit
