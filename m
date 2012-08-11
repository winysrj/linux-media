Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60144 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab2HKXXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 19:23:07 -0400
Subject: Re: HVR 1600 - Analog goes south again
From: Andy Walls <awalls@md.metrocast.net>
To: Bob Lightfoot <boblfoot@mymail.coop>
Cc: linux-media@vger.kernel.org
Date: Sat, 11 Aug 2012 19:22:57 -0400
In-Reply-To: <5025857E.2030109@mymail.coop>
References: <5025857E.2030109@mymail.coop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1344727381.2468.18.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-08-10 at 18:04 -0400, Bob Lightfoot wrote:
> Dear Media List Members:
>     I have been using my Hauppage HVR1600 on Centos 6 for some time
> and getting good analog reception.  Now the other day for a reason I
> have not been able to determine the Analog quit working and I have not
> had success restoring it.  I'm looking for the usual helpful
> suggestions I've gotten from this group in the past. Here has been my
> troubleshooting to date.
> 1.  Verified that analog signal is present in cable by hooking a TV to
> cable.
> 2.  Reinstalled all latest v4l and v4l2 drivers from atrpms.net
> packages.  These are what has worked in past.


Please try to use a DVD player or camera on the S-Video or CVBS analog
video input and L/R line in audio input, instead of the tuner.  (Use
'v4l2-ctl' on /dev/videoN to set the input.)  That will narrow down
whether or not this is an analog tuner problem.

Obviously check cables and connectors for breaks, including inspecting,
as best you can, the connector on the HVR-1600 itself.

With analog problems, I always encourgae people to double-check their
cable plant:
http://ivtvdriver.org/index.php/Howto:Improve_signal_quality

Also as a temporary test, you may want to run a line from the analog
source straight to the HVR-1600 with no splits, to see if things start
to work.

> v4l2-ctl --log-status shows video signal not present
> > Status Log:
> > 
> > cx18-0: =================  START STATUS CARD #0  ================= 
> > cx18-0: Version: 1.5.1  Card: Hauppauge HVR-1600

>  tveeprom 4-0050: Hauppauge model 74041, rev C6B2, serial# 5267091
>  tveeprom 4-0050: MAC address is 00:0d:fe:50:5e:93
>  tveeprom 4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
>  tveeprom 4-0050: TV standards NTSC(M) (eeprom 0x08)
>  tveeprom 4-0050: audio processor is CX23418 (idx 38)
>  tveeprom 4-0050: decoder processor is CX23418 (idx 31) 
> > tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter 
> > cx18-0 843: Video signal:              not present
> > cx18-0 843: Detected format:           NTSC-M
>   cx18-0 843: Specified standard: NTSC-M
>   cx18-0 843: Specified video input:     Composite 7
>   cx18-0 843: Specified audioclock freq: 48000 Hz
>   cx18-0 843: Detected audio mode:       mono
>   cx18-0 843: Detected audio standard:   no detected audio standard
>   cx18-0 843: Audio muted:               yes
>   cx18-0 843: Audio microcontroller:     running
>   cx18-0 843: Configured audio standard: automatic detection
>   cx18-0 843: Configured audio system:   BTSC
>   cx18-0 843: Specified audio input:     Tuner (In8) 
> > cx18-0 843: Preferred audio mode:      stereo cx18-0
> > gpio-reset-ctrl: GPIO:  direction 0x00003001, value 0x00003001 
> > tuner 5-0061: Tuner mode:      analog TV
>   tuner 5-0061: Frequency:       67.25 MHz

67.25 MHz is US analog broadcast channel 4 (the default channel to which
the cx18 driver sets the tuner upon module load).  Make sure you have an
analog signal on channel 4.

Otherwise tune the channel freq using 'ivtv-ctl' or 'v4l2-ctl'
on /dev/videoN.  If using 'v4l2-ctl', analog frequency tables for North
America are here:

http://en.wikipedia.org/wiki/North_American_broadcast_television_frequencies
http://en.wikipedia.org/wiki/North_American_cable_television_frequencies

>   tuner 5-0061: Standard:        0x00001000
>   cs5345 4-004c: Input:  1
>   cs5345 4-004c: Volume: 0 dB
>   cx18-0: Video Input: Tuner 1 
> > cx18-0: Audio Input: Tuner 1
>   cx18-0: GPIO:  direction 0x00003001, value 0x00003001
>   cx18-0: Tuner: TV
>   cx18-0: Stream Type: MPEG-2 Program Stream
>   cx18-0: Stream VBI Format: No VBI
>   cx18-0: Audio Sampling Frequency: 48 kHz cx18-0: Audio Encoding: MPEG-1/2 Layer
> > II cx18-0: Audio Layer II Bitrate: 224 kbps cx18-0: Audio Stereo
> > Mode: Stereo cx18-0: Audio Stereo Mode Extension: Bound 4 inactive 
> > cx18-0: Audio Emphasis: No Emphasis cx18-0: Audio CRC: No CRC 
> > cx18-0: Audio Mute: false cx18-0: Video Encoding: MPEG-2 cx18-0:
> > Video Aspect: 4x3 cx18-0: Video B Frames: 2 cx18-0: Video GOP Size:
> > 15 cx18-0: Video GOP Closure: true cx18-0: Video Bitrate Mode:
> > Variable Bitrate cx18-0: Video Bitrate: 6000000 cx18-0: Video Peak
> > Bitrate: 8000000 cx18-0: Video Temporal Decimation: 0 cx18-0: Video
> > Mute: false cx18-0: Video Mute YUV: 32896 cx18-0: Spatial Filter
> > Mode: Manual cx18-0: Spatial Filter: 0 cx18-0: Spatial Luma Filter
> > Type: 1D Horizontal cx18-0: Spatial Chroma Filter Type: 1D
> > Horizontal cx18-0: Temporal Filter Mode: Manual cx18-0: Temporal
> > Filter: 8 cx18-0: Median Filter Type: Off cx18-0: Median Luma
> > Filter Minimum: 0 inactive cx18-0: Median Luma Filter Maximum: 255
> > inactive cx18-0: Median Chroma Filter Minimum: 0 inactive cx18-0:
> > Median Chroma Filter Maximum: 255 inactive cx18-0: Insert
> > Navigation Packets: false cx18-0: Status flags: 0x00200001 cx18-0:
> > Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64 buffers) in
> > use cx18-0: Stream encoder YUV: status 0x0000, 0% of 2025 KiB (20
> > buffers) in use cx18-0: Stream encoder VBI: status 0x0000, 0% of
> > 1015 KiB (20 buffers) in use cx18-0: Stream encoder PCM audio:
> > status 0x0000, 0% of 1024 KiB (256 buffers) in use cx18-0: Read
> > MPEG/VBI: 0/0 bytes cx18-0: ==================  END STATUS CARD #0
> > ==================
> 
> I have been modprobing the cx18 in /etc/rc.local > # This section is
> added to make the HVR1600 Analog Audio Work
> > # service mythbackend stop modprobe -vv cx18 modprobe -v cx18_alsa 
> > # service mythbackend start

Be advised, for a delayed load of the cx18 module, you must blacklist it
in /etc/modprobe.d/*, otherwise it will get loaded for you anyway.

There is no need to modprobe cx18-alsa, the cx18 driver should
request/cause that to load automatically if it exists.

Regards,
Andy

> Even disabling the mythbackend so that it doesn't affect things until
> this is sorted out.
> > [root@mythbox bob]# lspci -s 01:00.0 -vv 01:00.0 Multimedia video
> > controller: Conexant Systems, Inc. CX23418 Single-Chip MPEG-2
> > Encoder with Integrated Analog Video/Broadcast Audio Decoder 
> > Subsystem: Hauppauge computer works Inc. WinTV HVR-1600 Control:
> > I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+
> > ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> > INTx- Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32
> > bytes Interrupt: pin A routed to IRQ 17 Region 0: Memory at
> > f4000000 (32-bit, non-prefetchable) [size=64M] Capabilities: [44]
> > Vital Product Data pcilib: sysfs_read_vpd: read failed: Connection
> > timed out Not readable Capabilities: [4c] Power Management version
> > 2 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> > PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
> > DSel=0 DScale=0 PME- Kernel driver in use: cx18 Kernel modules:
> > cx18
> > 
> 
> Not sure where to look/try next.
> 
> Bob Lightfoot
> lspci confirms that it is using cx18 as always
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


