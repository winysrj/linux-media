Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NK1Pt5010594
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:01:25 -0400
Received: from post.rzg.mpg.de (post.rzg.mpg.de [130.183.30.42])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2NK15fJ024700
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:01:06 -0400
Received: from [192.168.178.25] (p5498EA37.dip.t-dialin.net [84.152.234.55])
	(authenticated bits=0)
	by post.rzg.mpg.de (8.14.3/8.14.3) with ESMTP id n2NK13vS2204062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 21:01:04 +0100
Message-ID: <49C7EA80.5070004@ipp.mpg.de>
Date: Mon, 23 Mar 2009 21:01:04 +0100
From: Kurt Behringer <kub@ipp.mpg.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Subject: saa7134, Tevion MD 9717: fields of different frames interlaced
Reply-To: kub@ipp.mpg.de
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello All,

I have a peculier problem with my tv pci card Tevion MD 9717 (PAL).

At first glance, the card appears to be working perfectly under Suse
11.1, Ubuntu 8.10 and Windows XP.

However, when recording videos under Suse 11.1 or Ubuntu 8.10 (mencoder
or ffmpeg),there are statistical "jerks" in the pictures, about once
every few minutes. These are best detected during slow panning of the
camera. Closer inspection shows that one field of an earlier frame, e.g.
4 frames back, is interlaced with the present frame, causing a short
jump up/down or sideways in this picture. I have good screen copies, if
someone is interested. When de-interlacing, one just gets the average of
the two fields not belonging together. This does not happen at all under
Windows, just the Linux systems.

100 different recording options (even rawvideo), formats etc. did not
change anything. The problem is not related to cpu load. Meanwhile I am
sure that tv play-back with vlc or mplayer also has these jerks
(difficult to prove without replay). Changing more or less all relevant
driver options - buffers, latency, overlay - made no difference.

I would be most grateful, if anyone could help.

Thank you and best regards	Kurt


System:  openSUSE 11.1 (x86_64) Kernel 2.6.27.7-9-default
		  or  Ubuntu 8.10 (i386 or amd64, 2.6.27-11)

CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ (Family: 15, Model:
75, Stepping: 2)
CPUflags: Type: 15 MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1

Driver: version of the Kernels

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) ->
IRQ 16
saa7134[0]: setting pci latency timer to 64
saa7134[0]: found at 0000:04:08.0, rev: 1, irq: 16, latency: 64, mmio:
0xfdbff000
saa7134[0]: subsystem: 1131:0000, board: Tevion MD 9717 [card=6,insmod
option]
Modules linked in: saa7134(+) snd_emu10k1(+) ir_common snd_rawmidi
snd_ac97_codec compat_ioctl32 ac97_bus snd_hda_intel snd_seq_device
videodev v4l1_compat snd_pcm snd_util_mem v4l2_common ppdev snd_timer
videobuf_dma_sg videobuf_core snd_page_alloc snd_hwdep emu10k1_gp snd
parport_pc rtc_cmos dcdbas(X) tveeprom i2c_nforce2 rtc_core button
gameport parport rtc_lib tg3 i2c_core soundcore k8temp(N) floppy pcspkr
libphy sr_mod cdrom sg sd_mod crc_t10dif ehci_hcd ohci_hcd usbcore edd
ext3 mbcache jbd fan ide_pci_generic ide_core ata_generic sata_nv libata
scsi_mod dock thermal processor thermal_sys hwmon
 [<ffffffffa0340699>] saa7134_initdev+0x429/0x874 [saa7134]
saa7134[0]: board init: gpio is 100a0
saa7134[0]: Huh, no eeprom present (err=-5)?
saa7134[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
tuner' 2-0060: chip found @ 0xc0 (saa7134[0])
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0

04:08.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL
Video Broadcast Decoder (rev 01)
        Subsystem: Philips Semiconductors Device 0000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdbff000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
