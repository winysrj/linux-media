Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:64348 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2KXRbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 12:31:51 -0500
Received: by mail-ye0-f174.google.com with SMTP id m6so826544yen.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 09:31:49 -0800 (PST)
Message-ID: <50B1047B.4040901@gmail.com>
Date: Sat, 24 Nov 2012 12:31:39 -0500
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Poor HVR 1600 Video Quality
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear Linux Media Community:
    I am struggling with what has changed in recent {past 6-9 months} of
kernel releases as related to the HVR-1600 Tuner Card and Analog Signal
processing.  I spent the bulk of today going through my video chain
feeding into the HVR-1600 and tried multiple sources all of which
provide good video and sound when fed into a Sanyo TV bought in the
1990s.  They all produce recordings similar to the attached file.
It almost looks like noise on the system and I am beginning to suspect
my card may be hosed on the analog side.  Just looking for any thing I
may have missed while RTFM and Google.  I'd share a 1 minute sample
capture but 30.5 mb is too large to attach to a google email and I'm not
sure where to drop a sample file for others to download and check out.
It should be noted analog video was fine, but sound was intermittent
with the kernels and drivers in use back in May.  Now the sound it rock
solid, but the video has gone noisy.

The particulars of my system are as follows:

HP Pavillion Elite M9040n - Purchased 2010 with an HVR-1600

uname -a :
> Linux mythbox.ladodomain 2.6.32-279.14.1.el6.x86_64 #1 SMP Tue Nov
>  6 23:43:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

lspci -vvv :
> 01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23418
> Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast
> Audio Decoder Subsystem: Hauppauge computer works Inc. WinTV
> HVR-1600 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+
> VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+
> 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx- Latency: 64 (500ns min, 50000ns max),
> Cache Line Size: 32 bytes Interrupt: pin A routed to IRQ 17 Region
> 0: Memory at f4000000 (32-bit, non-prefetchable) [size=64M]
> Capabilities: [44] Vital Product Data Not readable Capabilities:
> [4c] Power Management version 2 Flags: PMEClk- DSI+ D1- D2-
> AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 
> NoSoftRst- PME-Enable- DSel=0 DScale=0 PME- Kernel driver in use: 
> cx18 Kernel modules: cx18

lsmod | grep cx18 :
> cx18_alsa               7420  1 cx18                  125338  59 
> cx18_alsa i2c_algo_bit            5762  1 cx18 cx2341x 19763  2 
> cx18,cx23885 v4l2_common            10670  6 
> cs5345,cx18,tuner,cx25840,cx23885,cx2341x videodev 76310  7 
> cs5345,cx18,tuner,cx25840,cx23885,cx2341x,v4l2_common dvb_core 
> 104074  3 cx18,cx23885,videobuf_dvb tveeprom 14044  2 cx18,cx23885 
> snd_pcm                85828  3 
> cx18_alsa,snd_hda_intel,snd_hda_codec snd                    71339
>  15 
> cx18_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer
>
>
>
> 
Sincerely,
Bob Lightfoot

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJQsQR7AAoJEKqgpLIhfz3XnuAH/AuO5z4Lz2hJD+ItBztf5uUE
UEvPEvOkacQxDHJr7yMNdNd8XfHQiyahKS8brnATlUJLSllQ7L4QfyFJdL+X2o0z
0QXln/M6jdx+o86Yd284fKtWBQBPMAnpWRDH4TVMeitHsJyFgNAZgSlkSXlg+Slv
qET4vDLnmLRZ32n+bZop+2gr3KySgg/K6wepo38rreiUneF4aQdYJoslKV7PjrXE
Z87KjEp+iB2p4kTdRR4cO0bCIMtInzpdxfS5vJi33T2XHFvTqD7u3TfTDIQ31A4b
ey9gC1ahAXrFOYp2rxFYZK17733Py2MicLU+vE8tIkt62kKvfwQB3RZHwVxNFjY=
=HYnR
-----END PGP SIGNATURE-----
