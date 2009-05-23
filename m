Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:54839 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZEWVPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 17:15:05 -0400
Received: from homiemail-a4.g.dreamhost.com (caiajhbdcahe.dreamhost.com [208.97.132.74])
	by hapkido.dreamhost.com (Postfix) with ESMTP id EC58D17DFB5
	for <linux-media@vger.kernel.org>; Sat, 23 May 2009 14:15:06 -0700 (PDT)
Message-ID: <4A186764.4080007@klepeis.net>
Date: Sat, 23 May 2009 14:15:16 -0700
From: N Klepeis <list1@klepeis.net>
Reply-To: list1@klepeis.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com
Subject: Temporary success with Pinnacle PCTV 801e (xc5000 chip)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I installed the latest v4l-dvb from CVS with the latest firmware 
(dvb-fe-xc5000-1.6.114.fw) for the 801e (XC5000 chip).   I can  scan for 
channels no problem.   But after a first use with either mplayer or 
mythtv, it then immediately stops working and won't start again until I 
unplug and then reinsert the device from the USB port.       On the 
first time use everything seems fine and I can watch TV through mplayer 
for as long as I want.    On the 2nd use (restart mplayer), there's an 
error (FE_GET_INFO error: 19, FD: 3).    On the 2nd use with mythtv, 
mythtv cannot connect to the card at all in mythtvsetup, but on the 
first time use I can assign channel.conf.      I know there have been 
recent updates to the xc5000 driver.    I only started trying this chip 
this week so I never confirmed that any prior driver version worked.

Any thoughts on how to proceed?     Below are the full console outputs 
when using with mplayer and when running dmesg.   (This is fedora 10).

--Neil


FIRE UP mplayer AND IT PLAYS TV FOR AS LONG AS I WANT:

[mythuser@mythbox ~]$ mplayer dvb://KTEH
MPlayer SVN-r28461-4.3.2 (C) 2000-2009 MPlayer Team
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz (Family: 6, Model: 
23, Stepping: 10)
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing dvb://KTEH.
dvb_tune Freq: 539028615
TS file format detected.
VIDEO MPEG2(pid=65) AUDIO A52(pid=67) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  704x480  (aspect 2)  29.970 fps  2892.4 kbps (361.6 kbyte/s)
==========================================================================
Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
VDec: vo config request - 704 x 480 (preferred colorspace: Mpeg PES)
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
The selected video_out device is incompatible with this codec.
Try appending the scale filter to your filter list,
e.g. -vf spp,scale instead of -vf spp.
VDecoder init failed :(
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [liba52] AC3 decoding with liba52
Using SSE optimized IMDCT transform
Using MMX optimized resampler
AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
Selected audio codec: [a52] afm: liba52 (AC3-liba52)
==========================================================================
AO: [pulse] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
VDec: vo config request - 704 x 480 (preferred colorspace: Planar YV12)
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO: [xv] 704x480 => 704x528 Planar YV12
A:45262.2 V:45262.2 A-V: -0.006 ct: -0.704 2050/2047  4%  0%  0.4% 0 0 

demux_mpg: 24000/1001fps progressive NTSC content detected, switching 
framerate.
A:45276.4 V:45276.3 A-V:  0.043 ct: -0.659 2391/2388  4%  0%  0.4% 0 0 

demux_mpg: 30000/1001fps NTSC content detected, switching framerate.
Warning! FPS changed 23.976 -> 29.970  (-5.994005) [4]    0%  0.4% 0 0 

a52: CRC check failed!    0.002 ct: -0.603 2561/2558  4%  0%  0.3% 0 0 

a52: error at resampling
[mpeg2video @ 0x873c440]00 motion_type at 14 29/2581  4%  0%  0.5% 0 0 

[mpeg2video @ 0x873c440]mb incr damaged
[mpeg2video @ 0x873c440]ac-tex damaged at 4 14
[mpeg2video @ 0x873c440]slice mismatch
[mpeg2video @ 0x873c440]00 motion_type at 0 16
[mpeg2video @ 0x873c440]slice mismatch
[mpeg2video @ 0x873c440]00 motion_type at 14 18
[mpeg2video @ 0x873c440]00 motion_type at 0 19
[mpeg2video @ 0x873c440]00 motion_type at 0 20
[mpeg2video @ 0x873c440]00 motion_type at 0 21
[mpeg2video @ 0x873c440]00 motion_type at 0 22
[mpeg2video @ 0x873c440]00 motion_type at 0 23
[mpeg2video @ 0x873c440]00 motion_type at 0 24
[mpeg2video @ 0x873c440]00 motion_type at 0 25
[mpeg2video @ 0x873c440]00 motion_type at 0 26
[mpeg2video @ 0x873c440]00 motion_type at 6 28
[mpeg2video @ 0x873c440]00 motion_type at 0 29
[mpeg2video @ 0x873c440]Warning MVs not available
[mpeg2video @ 0x873c440]concealing 792 DC, 792 AC, 792 MV errors
A:46603.5 V:46603.5 A-V: -0.001 ct: -0.594 42141/42138  4%  0%  4.6% 0 0 

Exiting... (Quit)


AFTER QUITTING, TRY AGAIN AND IT FAILS:

[mythuser@mythbox ~]$ mplayer dvb://KTEH
MPlayer SVN-r28461-4.3.2 (C) 2000-2009 MPlayer Team
CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz (Family: 6, Model: 
23, Stepping: 10)
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing dvb://KTEH.
FE_GET_INFO error: 19, FD: 3

DVB CONFIGURATION IS EMPTY, exit
Failed to open dvb://KTEH.


Exiting... (End of file)


WON'T START WORKING AGAIN WITH mplayer UNTIL I REMOVE AND RE-INSERT THE 
801e FROM THE USB PLUG.

I CAN ALWAYS SCAN FOR CHANNELS WITH scandvb WHETHER OR NOT I CAN PLAY 
ANYTHING WITH mplayer:

scandvb /usr/share/dvb-apps/atsc/us-ATSC-center-frequencies-8VSB



dmesg OUTPUT WHEN 801e PLUGGED IN:

usb 2-2: new high speed USB device using ehci_hcd and address 6
usb 2-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'Pinnacle PCTV HD Pro USB Stick' in cold state, will 
try to load a firmware
firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Pinnacle PCTV HD Pro USB Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Pinnacle PCTV HD Pro USB Stick)
DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
xc5000 1-0064: creating new instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.
7/usb2/2-2/input/input8
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Pinnacle PCTV HD Pro USB Stick successfully initialized and 
connected.
usb 2-2: New USB device found, idVendor=2304, idProduct=023a
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: PCTV 801e
usb 2-2: Manufacturer: YUANRD
usb 2-2: SerialNumber: 03017A14DA


dmesg OUTPUT WHEN 801e UNPLUGGED:

usb 2-2: USB disconnect, address 5
xc5000 1-0064: destroying instance
dvb-usb: Pinnacle PCTV HD Pro USB Stick successfully deinitialized and 
disconnec
ted.





