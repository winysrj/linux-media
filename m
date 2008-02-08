Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m187qkoS001177
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 02:52:46 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.184])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m187qEl1032500
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 02:52:25 -0500
Received: by fk-out-0910.google.com with SMTP id b27so3955328fka.3
	for <video4linux-list@redhat.com>; Thu, 07 Feb 2008 23:52:14 -0800 (PST)
Message-ID: <77ca8eab0802072352p743337a4p1e22fa0aea10ed7a@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:22:13 +0530
From: "amol verule" <amol.debian@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: tuner 1-0061: tuner type not set
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

hi to all
i am having pctv hybrid pro card,linux 2.6.21 kernel
this is dmesg output
Feb  8 12:45:46 boss kernel: pccard: CardBus card inserted into slot 0
Feb  8 12:45:46 boss kernel: cx2388x v4l2 driver version 0.0.6 loaded
Feb  8 12:45:46 boss kernel: PCI: Enabling device 0000:05:00.0 (0000 ->
0002)
Feb  8 12:45:46 boss kernel: ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16
(level, low) -> IRQ 18
Feb  8 12:45:46 boss kernel: cx88[0]: Your board isn't known (yet) to the
driver.  You can
Feb  8 12:45:46 boss kernel: cx88[0]: try to pick one of the existing card
configs via
Feb  8 12:45:46 boss kernel: cx88[0]: card=<n> insmod option.  Updating to
the latest
Feb  8 12:45:46 boss kernel: cx88[0]: version might help as well.
Feb  8 12:45:46 boss kernel: cx88[0]: Here is a list of valid choices for
the card=<n> insmod option:
Feb  8 12:45:46 boss kernel: cx88[0]:    card=0 -> UNKNOWN/GENERIC
Feb  8 12:45:46 boss kernel: cx88[0]:    card=1 -> Hauppauge WinTV 34xxx
models
Feb  8 12:45:46 boss kernel: cx88[0]:    card=2 -> GDI Black Gold
Feb  8 12:45:46 boss kernel: cx88[0]:    card=3 -> PixelView
Feb  8 12:45:46 boss kernel: cx88[0]:    card=4 -> ATI TV Wonder Pro
Feb  8 12:45:46 boss kernel: cx88[0]:    card=5 -> Leadtek Winfast 2000XP
Expert
Feb  8 12:45:46 boss kernel: cx88[0]:    card=6 -> AverTV Studio 303 (M126)
Feb  8 12:45:46 boss kernel: cx88[0]:    card=7 -> MSI TV-@nywhere Master
Feb  8 12:45:46 boss kernel: cx88[0]:    card=8 -> Leadtek Winfast DV2000
Feb  8 12:45:46 boss kernel: cx88[0]:    card=9 -> Leadtek PVR 2000
Feb  8 12:45:46 boss kernel: cx88[0]:    card=10 -> IODATA GV-VCP3/PCI
Feb  8 12:45:46 boss kernel: cx88[0]:    card=11 -> Prolink PlayTV PVR
Feb  8 12:45:46 boss kernel: cx88[0]:    card=12 -> ASUS PVR-416
Feb  8 12:45:46 boss kernel: cx88[0]:    card=13 -> MSI TV-@nywhere
Feb  8 12:45:46 boss kernel: cx88[0]:    card=14 -> KWorld/VStream XPert
DVB-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=15 -> DViCO FusionHDTV DVB-T1
Feb  8 12:45:46 boss kernel: cx88[0]:    card=16 -> KWorld LTV883RF
Feb  8 12:45:46 boss kernel: cx88[0]:    card=17 -> DViCO FusionHDTV 3
Gold-Q
Feb  8 12:45:46 boss kernel: cx88[0]:    card=18 -> Hauppauge Nova-T DVB-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=19 -> Conexant DVB-T reference
design
Feb  8 12:45:46 boss kernel: cx88[0]:    card=20 -> Provideo PV259
Feb  8 12:45:46 boss kernel: cx88[0]:    card=21 -> DViCO FusionHDTV DVB-T
Plus
Feb  8 12:45:46 boss kernel: cx88[0]:    card=22 -> pcHDTV HD3000 HDTV
Feb  8 12:45:46 boss kernel: cx88[0]:    card=23 -> digitalnow DNTV Live!
DVB-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=24 -> Hauppauge WinTV 28xxx
(Roslyn) models
Feb  8 12:45:46 boss kernel: cx88[0]:    card=25 -> Digital-Logic MICROSPACE
Entertainment Center (MEC)
Feb  8 12:45:46 boss kernel: cx88[0]:    card=26 -> IODATA GV/BCTV7E
Feb  8 12:45:46 boss kernel: cx88[0]:    card=27 -> PixelView PlayTV Ultra
Pro (Stereo)
Feb  8 12:45:46 boss kernel: cx88[0]:    card=28 -> DViCO FusionHDTV 3
Gold-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=29 -> ADS Tech Instant TV
DVB-T PCI
Feb  8 12:45:46 boss kernel: cx88[0]:    card=30 -> TerraTec Cinergy 1400
DVB-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=31 -> DViCO FusionHDTV 5 Gold
Feb  8 12:45:46 boss kernel: cx88[0]:    card=32 -> AverMedia UltraTV Media
Center PCI 550
Feb  8 12:45:46 boss kernel: cx88[0]:    card=33 -> Kworld V-Stream Xpert
DVD
Feb  8 12:45:46 boss kernel: cx88[0]:    card=34 -> ATI HDTV Wonder
Feb  8 12:45:46 boss kernel: cx88[0]:    card=35 -> WinFast DTV1000-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=36 -> AVerTV 303 (M126)
Feb  8 12:45:46 boss kernel: cx88[0]:    card=37 -> Hauppauge Nova-S-Plus
DVB-S
Feb  8 12:45:46 boss kernel: cx88[0]:    card=38 -> Hauppauge Nova-SE2 DVB-S
Feb  8 12:45:46 boss kernel: cx88[0]:    card=39 -> KWorld DVB-S 100
Feb  8 12:45:46 boss kernel: cx88[0]:    card=40 -> Hauppauge WinTV-HVR1100
DVB-T/Hybrid
Feb  8 12:45:46 boss kernel: cx88[0]:    card=41 -> Hauppauge WinTV-HVR1100
DVB-T/Hybrid (Low Profile)
Feb  8 12:45:46 boss kernel: cx88[0]:    card=42 -> digitalnow DNTV Live!
DVB-T Pro
Feb  8 12:45:46 boss kernel: cx88[0]:    card=43 -> KWorld/VStream XPert
DVB-T with cx22702
Feb  8 12:45:46 boss kernel: cx88[0]:    card=44 -> DViCO FusionHDTV DVB-T
Dual Digital
Feb  8 12:45:46 boss kernel: cx88[0]:    card=45 -> KWorld HardwareMpegTV
XPert
Feb  8 12:45:46 boss kernel: cx88[0]:    card=46 -> DViCO FusionHDTV DVB-T
Hybrid
Feb  8 12:45:46 boss kernel: cx88[0]:    card=47 -> pcHDTV HD5500 HDTV
Feb  8 12:45:46 boss kernel: cx88[0]:    card=48 -> Kworld MCE 200 Deluxe
Feb  8 12:45:46 boss kernel: cx88[0]:    card=49 -> PixelView PlayTV P7000
Feb  8 12:45:46 boss kernel: cx88[0]:    card=50 -> NPG Tech Real TV FM Top
10
Feb  8 12:45:46 boss kernel: cx88[0]:    card=51 -> WinFast DTV2000 H
Feb  8 12:45:46 boss kernel: cx88[0]:    card=52 -> Geniatech DVB-S
Feb  8 12:45:46 boss kernel: cx88[0]:    card=53 -> Hauppauge WinTV-HVR3000
TriMode Analog/DVB-S/DVB-T
Feb  8 12:45:46 boss kernel: cx88[0]:    card=54 -> Norwood Micro TV Tuner
Feb  8 12:45:46 boss kernel: cx88[0]:    card=55 -> Shenzhen Tungsten Ages
Tech TE-DTV-250 / Swann OEM
Feb  8 12:45:46 boss kernel: cx88[0]:    card=56 -> Hauppauge WinTV-HVR1300
DVB-T/Hybrid MPEG Encoder
Feb  8 12:45:46 boss kernel: CORE cx88[0]: subsystem: 12ab:1788, board:
UNKNOWN/GENERIC [card=0,autodetected]
Feb  8 12:45:46 boss kernel: TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
Feb  8 12:45:46 boss kernel: cx2388x alsa driver version 0.0.6 loaded
Feb  8 12:45:46 boss kernel: cx88[0]/0: found at 0000:05:00.0, rev: 5, irq:
18, latency: 0, mmio: 0x94000000
Feb  8 12:45:46 boss kernel: tuner 1-0061: chip found @ 0xc2 (cx88[0])
Feb  8 12:45:46 boss kernel: cx88[0]/0: registered device video0 [v4l2]
Feb  8 12:45:46 boss kernel: cx88[0]/0: registered device vbi0
Feb  8 12:45:46 boss kernel: tuner 1-0061: tuner type not set
Feb  8 12:45:46 boss kernel: cx2388x cx88-mpeg Driver Manager version
0.0.6loaded
Feb  8 12:45:46 boss kernel: PCI: Enabling device 0000:05:00.1 (0000 ->
0002)
Feb  8 12:45:46 boss kernel: ACPI: PCI Interrupt 0000:05:00.1[A] -> GSI 16
(level, low) -> IRQ 18
Feb  8 12:45:46 boss kernel: cx88[0]/1: CX88x/0: ALSA support for cx2388x
boards
Feb  8 12:45:46 boss kernel: cx88[0]/2: cx2388x 8802 Driver Manager


how to set tuner type?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
