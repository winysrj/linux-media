Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <kreuzritter2000@gmx.de>) id 1S0Uck-0003ko-HV
	for linux-dvb@linuxtv.org; Thu, 23 Feb 2012 10:06:03 +0100
Received: from mailout-de.gmx.net ([213.165.64.22])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with smtp
	for <linux-dvb@linuxtv.org>
	id 1S0Ucj-000464-Fy; Thu, 23 Feb 2012 10:06:02 +0100
From: kreuzritter2000 <kreuzritter2000@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 23 Feb 2012 10:05:54 +0100
Message-ID: <1329987954.2465.25.camel@blackbox>
Mime-Version: 1.0
Subject: [linux-dvb] SkyStar HD2 tv playback runs jerky - Subsystem: Device
	1ae4:0003
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

i have a Technisat SkyStar HD2 DVB-S2 tv card and it is working rather
poorly on my Linux Ubuntu 11.04 system (Linux Kernel version 2.6.38 that
is shipped via the official Ubuntu repository)
Scanning for channels worked.
TV programs show up, but they're out of sync and audio shatters
extremely and runs jerky. Recording the TV program or just watching it
is a waste of time because of the above quality problems.
I tested several dvb player software like  mplayer, xine, vlc, kaffeine
and totem (with dvb plugin) but all have the same problem.
On Windows this card works perfectly with the dvbviewer application.


On 
http://linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_%28VP-1041%
29#Identification

i found the following text:

> Note also that a different subsystem ID for a Skystar HD2 (1ae4:0003) 
> has been reported for some cards at 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027261.html so
> perhaps a change needs to be made to allow for this possibility too. 

and i also read the additional mailinglist report:
http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027261.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027279.html


And i can confirm that, what is in this report.
My Skystar HD2 has the ID (1ae4:0003) too.

lspci -vv

05:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0003
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at f2200000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis


lspci -vvn

05:00.0 0480: 1822:4e35 (rev 01)
        Subsystem: 1ae4:0003
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at f2200000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

lsmod | grep mantis

mantis                 23328  0 
mantis_core            40423  1 mantis
dvb_core              110487  1 mantis_core
rc_core                26918  7
ir_lirc_codec,mantis_core,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder



ls -l /dev/dvb/adapter0/
insgesamt 0
crw-rw----+ 1 root video 212, 0 2012-02-23 08:17 demux0
crw-rw----+ 1 root video 212, 1 2012-02-23 08:17 dvr0
crw-rw----+ 1 root video 212, 3 2012-02-23 08:17 frontend0
crw-rw----+ 1 root video 212, 2 2012-02-23 08:17 net0

dmesg 
[    6.240921] Mantis 0000:05:00.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[    6.241985] DVB: registering new adapter (Mantis DVB adapter)
...
[    0.331995] pci 0000:05:00.0: [1822:4e35] type 0 class 0x000480
[    0.332008] pci 0000:05:00.0: reg 10: [mem 0xf2200000-0xf2200fff
pref]
[    0.332070] pci 0000:05:02.0: [1102:0004] type 0 class 0x000401
[    0.332086] pci 0000:05:02.0: reg 10: [io  0xd000-0xd03f]
[    0.332146] pci 0000:05:02.0: supports D1 D2
[    0.332161] pci 0000:05:02.1: [1102:7003] type 0 class 0x000980
[    0.332176] pci 0000:05:02.1: reg 10: [io  0xd100-0xd107]
[    0.332236] pci 0000:05:02.1: supports D1 D2
[    0.332255] pci 0000:05:02.2: [1102:4001] type 0 class 0x000c00
[    0.332272] pci 0000:05:02.2: reg 10: [mem 0xf2104000-0xf21047ff]
[    0.332281] pci 0000:05:02.2: reg 14: [mem 0xf2100000-0xf2103fff]
[    0.332337] pci 0000:05:02.2: supports D1 D2
[    0.332339] pci 0000:05:02.2: PME# supported from D0 D1 D2 D3hot
[    0.332343] pci 0000:05:02.2: PME# disabled


Undloading and Loading the kernel module:
~$ sudo modprobe -r mantis
~$ lsmod | grep mantis
~$ sudo modprobe -v  mantis
insmod /lib/modules/2.6.38-13-generic/kernel/drivers/media/dvb/dvb-core/dvb-core.ko 
insmod /lib/modules/2.6.38-13-generic/kernel/drivers/media/dvb/mantis/mantis_core.ko 
insmod /lib/modules/2.6.38-13-generic/kernel/drivers/media/dvb/mantis/mantis.ko 
~$ lsmod | grep mantis
mantis                 23328  0 
mantis_core            40423  1 mantis
dvb_core              110487  1 mantis_core
rc_core                26918  7
mantis_core,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
~$

kern.log syslog shows then:
Feb 23 09:56:17 xxx kernel: [ 5934.470544] Mantis 0000:05:00.0: PCI INT
A disabled
Feb 23 09:57:19 xxx kernel: [ 5995.614854] Mantis 0000:05:00.0: PCI INT
A -> GSI 20 (level, low) -> IRQ 20
Feb 23 09:57:19 xxx kernel: [ 5995.616286] DVB: registering new adapter
(Mantis DVB adapter)
Feb 23 09:57:19 xxx kernel: [ 5996.541357] stb0899_attach: Attaching
STB0899 
Feb 23 09:57:19 xxx kernel: [ 5996.541449] stb6100_attach: Attaching
STB6100 
Feb 23 09:57:19 xxx kernel: [ 5996.541748] LNBx2x attached on addr=8
Feb 23 09:57:19 xxx kernel: [ 5996.541752] DVB: registering adapter 0
frontend 0 (STB0899 Multistandard)...




Here's an example session using mplayer:

mplayer dvb://zdf_neo
mplayer: Symbol `ff_codec_bmp_tags' has different size in shared object,
consider re-linking
MPlayer 1.0rc4-4.5.2 (C) 2000-2010 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing dvb://zdf_neo.
dvb_tune Freq: 11953000
TS file format detected.
VIDEO MPEG2(pid=660) AUDIO MPA(pid=670) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  720x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0
kbyte/s)
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
[VO_TDFXFB] Can't open /dev/fb0: Permission denied.
[VO_3DFX] Unable to open /dev/3dfx.
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 256.0 kbit/16.67% (ratio: 32000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [pulse] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
Movie-Aspect is 1.78:1 - prescaling to correct movie aspect.
VO: [vdpau] 720x576 => 1024x576 Planar YV12 
[mpeg2video @ 0x7fb8db1b2020]ac-tex damaged at 16 29  6%  1%  9.1% 0 0 
[mpeg2video @ 0x7fb8db1b2020]Warning MVs not available
[mpeg2video @ 0x7fb8db1b2020]concealing 0 DC, 0 AC, 0 MV errors
[mpeg2video @ 0x7fb8db1b2020]00 motion_type at 37 59  6%  3% 14.4% 10 0 
[mpeg2video @ 0x7fb8db1b2020]Warning MVs not available
[mpeg2video @ 0x7fb8db1b2020]concealing 900 DC, 900 AC, 900 MV errors
A:83882.5 V:83879.9 A-V:  2.630 ct: -0.365 1269/1269  6%  3% 19.6% 50 0 

           ************************************************
           **** Your system is too SLOW to play this!  ****
           ************************************************

Possible reasons, problems, workarounds:
- Most common: broken/buggy _audio_ driver
  - Try -ao sdl or use the OSS emulation of ALSA.
  - Experiment with different values for -autosync, 30 is a good start.
- Slow video output
  - Try a different -vo driver (-vo help for a list) or try -framedrop!
- Slow CPU
  - Don't try to play a big DVD/DivX on a slow CPU! Try some of the
lavdopts,
    e.g. -vfm ffmpeg -lavdopts lowres=1:fast:skiploopfilter=all.
- Broken file
  - Try various combinations of -nobps -ni -forceidx -mc 0.
- Slow media (NFS/SMB mounts, DVD, VCD etc)
  - Try -cache 8192.
- Are you using -cache to play a non-interleaved AVI file?
  - Try -nocache.
Read DOCS/HTML/en/video.html for tuning/speedup tips.
If none of this helps you, read DOCS/HTML/en/bugreports.html.

A:83888.4 V:83883.5 A-V:  4.942 ct: -0.364 1359/1359  6%  4% 28.0% 139
0 

MPlayer interrupted by signal 2 in module: decode_audio
dvb_streaming_read, attempt N. 6 failed with errno 4 when reading 1120
bytes
A:83888.6 V:83883.5 A-V:  5.061 ct: -0.364 1360/1360  6%  4% 28.3% 140
0 
Exiting... (Quit)



Annotation:
On Windows my system is more than fast enough to even play HD TV
videostreams.



Does anyone know why the tv program runs so jerky on Linux with my TV
card?
Do you have any ideas to solve that?


Best Regards,
 Oliver C.








_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
