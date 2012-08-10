Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54954 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HJWEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 18:04:50 -0400
Received: by yenl14 with SMTP id l14so896351yen.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 15:04:49 -0700 (PDT)
Message-ID: <5025857E.2030109@mymail.coop>
Date: Fri, 10 Aug 2012 18:04:46 -0400
From: Bob Lightfoot <boblfoot@mymail.coop>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR 1600 - Analog goes south again
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear Media List Members:
    I have been using my Hauppage HVR1600 on Centos 6 for some time
and getting good analog reception.  Now the other day for a reason I
have not been able to determine the Analog quit working and I have not
had success restoring it.  I'm looking for the usual helpful
suggestions I've gotten from this group in the past. Here has been my
troubleshooting to date.
1.  Verified that analog signal is present in cable by hooking a TV to
cable.
2.  Reinstalled all latest v4l and v4l2 drivers from atrpms.net
packages.  These are what has worked in past.

v4l2-ctl --log-status shows video signal not present
> Status Log:
> 
> cx18-0: =================  START STATUS CARD #0  ================= 
> cx18-0: Version: 1.5.1  Card: Hauppauge HVR-1600 tveeprom 4-0050:
> Hauppauge model 74041, rev C6B2, serial# 5267091 tveeprom 4-0050:
> MAC address is 00:0d:fe:50:5e:93 tveeprom 4-0050: tuner model is
> TCL M2523_5N_E (idx 112, type 50) tveeprom 4-0050: TV standards
> NTSC(M) (eeprom 0x08) tveeprom 4-0050: audio processor is CX23418
> (idx 38) tveeprom 4-0050: decoder processor is CX23418 (idx 31) 
> tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter 
> cx18-0 843: Video signal:              not present cx18-0 843:
> Detected format:           NTSC-M cx18-0 843: Specified standard:
> NTSC-M cx18-0 843: Specified video input:     Composite 7 cx18-0
> 843: Specified audioclock freq: 48000 Hz cx18-0 843: Detected audio
> mode:       mono cx18-0 843: Detected audio standard:   no detected
> audio standard cx18-0 843: Audio muted:               yes cx18-0
> 843: Audio microcontroller:     running cx18-0 843: Configured
> audio standard: automatic detection cx18-0 843: Configured audio
> system:   BTSC cx18-0 843: Specified audio input:     Tuner (In8) 
> cx18-0 843: Preferred audio mode:      stereo cx18-0
> gpio-reset-ctrl: GPIO:  direction 0x00003001, value 0x00003001 
> tuner 5-0061: Tuner mode:      analog TV tuner 5-0061: Frequency:
> 67.25 MHz tuner 5-0061: Standard:        0x00001000 cs5345 4-004c:
> Input:  1 cs5345 4-004c: Volume: 0 dB cx18-0: Video Input: Tuner 1 
> cx18-0: Audio Input: Tuner 1 cx18-0: GPIO:  direction 0x00003001,
> value 0x00003001 cx18-0: Tuner: TV cx18-0: Stream Type: MPEG-2
> Program Stream cx18-0: Stream VBI Format: No VBI cx18-0: Audio
> Sampling Frequency: 48 kHz cx18-0: Audio Encoding: MPEG-1/2 Layer
> II cx18-0: Audio Layer II Bitrate: 224 kbps cx18-0: Audio Stereo
> Mode: Stereo cx18-0: Audio Stereo Mode Extension: Bound 4 inactive 
> cx18-0: Audio Emphasis: No Emphasis cx18-0: Audio CRC: No CRC 
> cx18-0: Audio Mute: false cx18-0: Video Encoding: MPEG-2 cx18-0:
> Video Aspect: 4x3 cx18-0: Video B Frames: 2 cx18-0: Video GOP Size:
> 15 cx18-0: Video GOP Closure: true cx18-0: Video Bitrate Mode:
> Variable Bitrate cx18-0: Video Bitrate: 6000000 cx18-0: Video Peak
> Bitrate: 8000000 cx18-0: Video Temporal Decimation: 0 cx18-0: Video
> Mute: false cx18-0: Video Mute YUV: 32896 cx18-0: Spatial Filter
> Mode: Manual cx18-0: Spatial Filter: 0 cx18-0: Spatial Luma Filter
> Type: 1D Horizontal cx18-0: Spatial Chroma Filter Type: 1D
> Horizontal cx18-0: Temporal Filter Mode: Manual cx18-0: Temporal
> Filter: 8 cx18-0: Median Filter Type: Off cx18-0: Median Luma
> Filter Minimum: 0 inactive cx18-0: Median Luma Filter Maximum: 255
> inactive cx18-0: Median Chroma Filter Minimum: 0 inactive cx18-0:
> Median Chroma Filter Maximum: 255 inactive cx18-0: Insert
> Navigation Packets: false cx18-0: Status flags: 0x00200001 cx18-0:
> Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64 buffers) in
> use cx18-0: Stream encoder YUV: status 0x0000, 0% of 2025 KiB (20
> buffers) in use cx18-0: Stream encoder VBI: status 0x0000, 0% of
> 1015 KiB (20 buffers) in use cx18-0: Stream encoder PCM audio:
> status 0x0000, 0% of 1024 KiB (256 buffers) in use cx18-0: Read
> MPEG/VBI: 0/0 bytes cx18-0: ==================  END STATUS CARD #0
> ==================

I have been modprobing the cx18 in /etc/rc.local > # This section is
added to make the HVR1600 Analog Audio Work
> # service mythbackend stop modprobe -vv cx18 modprobe -v cx18_alsa 
> # service mythbackend start

Even disabling the mythbackend so that it doesn't affect things until
this is sorted out.
> [root@mythbox bob]# lspci -s 01:00.0 -vv 01:00.0 Multimedia video
> controller: Conexant Systems, Inc. CX23418 Single-Chip MPEG-2
> Encoder with Integrated Analog Video/Broadcast Audio Decoder 
> Subsystem: Hauppauge computer works Inc. WinTV HVR-1600 Control:
> I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+
> ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> INTx- Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32
> bytes Interrupt: pin A routed to IRQ 17 Region 0: Memory at
> f4000000 (32-bit, non-prefetchable) [size=64M] Capabilities: [44]
> Vital Product Data pcilib: sysfs_read_vpd: read failed: Connection
> timed out Not readable Capabilities: [4c] Power Management version
> 2 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
> DSel=0 DScale=0 PME- Kernel driver in use: cx18 Kernel modules:
> cx18
> 

Not sure where to look/try next.

Bob Lightfoot
lspci confirms that it is using cx18 as always
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJQJYV+AAoJEJmjZo18LAlsU68IALFjUxUvML+VwAjFH5UIhWNS
duTJMZle4exIJ9KKEWXTbDykazVmqRw8F523N8sfoE4kFovhlLqPB+Ry/1XA9L+j
5ilkiOIMfLW6X9j2H/xafjgjAtLpFTK2KiGRPrHsZZCtjBB5B7cjl1VIEX0huJsL
q3JDZEvoQLsdS04QCG5rvScItLTkMp8HwUnqQUyzycyEXUXlduFx/Mjc9UxxCBL9
zNlLRmNxsJsHpnN7XFX//YZ82ZXGafgo4NScdyoIA35bez0CGHxLUQXCkieUm8q3
CZiqX9VjiOptjKLDQlUEUHQfnhECmDfdXMh2LyEElTnLSHqOM5r+z01AbWgRyAc=
=/UCF
-----END PGP SIGNATURE-----
