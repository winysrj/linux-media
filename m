Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas02p.mx.bigpond.com ([61.9.168.140])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <jhhummel@bigpond.com>) id 1NRhhi-0007Nk-Hc
	for linux-dvb@linuxtv.org; Mon, 04 Jan 2010 08:50:20 +0100
From: Jonathan <jhhummel@bigpond.com>
To: linux-dvb@linuxtv.org,
 linux-media@vger.kernel.org
Date: Mon, 4 Jan 2010 18:49:34 +1100
References: <4B4057D0.5030808@internode.on.net>
In-Reply-To: <4B4057D0.5030808@internode.on.net>
MIME-Version: 1.0
Message-Id: <201001041849.35092.jhhummel@bigpond.com>
Subject: Re: [linux-dvb] DTV2000 H Plus
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1281981871=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1281981871==
Content-Type: multipart/alternative;
  boundary="Boundary-01=_P2ZQL+axpw1YJVS"
Content-Transfer-Encoding: 7bit

--Boundary-01=_P2ZQL+axpw1YJVS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I have that card (the J version I think) and run it on the latest version of 
Kubuntu - works fine, but cannot handle the analogue signal, I got it to work 
on analogue once, but then an upgrade came and I forgot and I haven't hd the 
time.

Anyway for digital,

Try adding to "/etc/modprobe.d/options.dpkg-bak"
options cx88xx card=51

and then restart.

I recomend using Me-TV. It's aussie, and simple to setup and use. Particulalry 
if you want to be using the computer for things other than TV.

Also try Add "cx88-dvb" to /etc/modules

Have a look at
http://www.mythtv.org/wiki/Leadtek_DTV-2000H

Cheers

Jon

On Sun, 3 Jan 2010 07:39:44 pm Raena Lea-Shannon wrote:
> I do not seem to be able to get my DTV2000 to find a tuner. Seems to be
> problem finding the card. Any suggestions would be greatly appreciated.
> I am running Kubuntu Karmic 2.6.31-16-generic on AMD64 quadcore.
> 
> I came across this Patch which seesm to be on the point
> http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html
> 
> but I do not have a cx88-cards.c file? I have compiled latest mercurial
> v4l. Do I need to make an empty file cx88-cards.c? Excuse my ignorance I
> am not a developer.
> 
> I have tried to run modprobe cx88xx card=51 to no avail.
> 
> Here is part of an mplayer, lspci and dmesg follow.
> 
> 
> Selected driver: v4l2
>   name: Video 4 Linux 2 input
>   author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>   comment: first try, more to come ;-)
> Selected device: UNKNOWN/GENERIC
>   Capabilites:  video capture  VBI capture device  read/write  streaming
>   supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = NTSC-443; 3 = PAL-BG;
> 4 = PAL-I; 5 = PAL-DK; 6 = PAL-M; 7 = PAL-N; 8 = PAL-Nc; 9 = PAL-60; 10
> = SECAM-B; 11 = SECAM-G; 12 = SECAM-H; 13 = SECAM-DK; 14 = SECAM-L;
>   inputs: 0 = Composite1; 1 = Composite2; 2 = Composite3; 3 = Composite4;
> 
> I am running Kubuntu Karmic 2.6.31-16-generic on AMD64 quadcore. I have
> latest mercurial of v4l installed.
> 
> Here is the Lspci info and dmesg etc
> 
> 5:05.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2
> FlexCopII DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)
> 
>          Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /
> Technisat SkyStar2 DVB card [13d0:2103]
>          Flags: bus master, slow devsel, latency 64, IRQ 20
>          Memory at fbff0000 (32-bit, non-prefetchable) [size=64K]
>          I/O ports at ec00 [size=32]
>          Kernel driver in use: b2c2_flexcop_pci
>          Kernel modules: b2c2-flexcop-pci
> 
> 05:06.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
>          Subsystem: LeadTek Research Inc. Device [107d:6f42]
>          Flags: bus master, medium devsel, latency 64, IRQ 21
>          Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
>          Capabilities: <access denied>
>          Kernel driver in use: cx8800
>          Kernel modules: cx8800
> 
> 05:06.1 Multimedia controller [0480]: Conexant Systems, Inc.
> CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801] (rev 05)
>          Subsystem: LeadTek Research Inc. Device [107d:6f42]
>          Flags: bus master, medium devsel, latency 64, IRQ 21
>          Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
>          Capabilities: <access denied>
>          Kernel driver in use: cx88_audio
>          Kernel modules: cx88-alsa
> 
> 05:06.2 Multimedia controller [0480]: Conexant Systems, Inc.
> CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
>          Subsystem: LeadTek Research Inc. Device [107d:6f42]
>          Flags: bus master, medium devsel, latency 64, IRQ 10
>          Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>          Capabilities: <access denied>
>          Kernel modules: cx8802
> 
> dmesg in part here:
> [snip]
> 
> [   20.387650] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
> receiver chip loaded successfully
> [   20.390596] EDAC MC: Ver: 2.1.0 Dec  8 2009
> [   20.392347] flexcop-pci: will use the HW PID filter.
> [   20.392351] flexcop-pci: card revision 2
> [   20.392359]   alloc irq_desc for 20 on node 0
> [   20.392361]   alloc kstat_irqs on node 0
> [   20.392366] b2c2_flexcop_pci 0000:05:05.0: PCI INT A -> GSI 20
> (level, low) -> IRQ 20
> [   20.403400] EDAC amd64_edac:  Ver: 3.2.0 Dec  8 2009
> [   20.404070] EDAC amd64: This node reports that Memory ECC is
> currently disabled.
> [   20.404073] EDAC amd64: bit 0x400000 in register F3x44 of the
> MISC_CONTROL device (0000:00:18.3) should be enabled
> [   20.404076] EDAC amd64: WARNING: ECC is NOT currently enabled by the
> BIOS. Module will NOT be loaded.
> [   20.404077]     Either Enable ECC in the BIOS, or use the
> 'ecc_enable_override' parameter.
> [   20.404078]     Might be a BIOS bug, if BIOS says ECC is enabled
> [   20.404078]     Use of the override can cause unknown side effects.
> [   20.404541] amd64_edac: probe of 0000:00:18.2 failed with error -22
> [   20.425278] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low)
> -> IRQ 16
> [   20.430203] DVB: registering new adapter (FlexCop Digital TV device)
> [   20.431702] b2c2-flexcop: MAC address = 00:d0:d7:16:5d:8f
> [   20.432308] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
> [   20.432311] CX24123: wrong demod revision: 87
> [   20.547542] Linux video capture interface: v2.00
> [   20.555291] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low)
> -> IRQ 19
> [   20.555310] HDA Intel 0000:01:00.1: setting latency timer to 64
> [   20.608776] EXT3 FS on sda1, internal journal
> [   20.857754] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
> [   20.859425] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
> [   20.859959] b2c2-flexcop: found 'Zarlink MT352 DVB-T' .
> [   20.859963] DVB: registering adapter 0 frontend 0 (Zarlink MT352
> DVB-T)...
> [   20.860017] b2c2-flexcop: initialization of 'Air2PC/AirStar 2 DVB-T'
> at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> [   20.861717] cx2388x alsa driver version 0.0.7 loaded
> [   20.862371]   alloc irq_desc for 21 on node 0
> [   20.862373]   alloc kstat_irqs on node 0
> [   20.862379] cx8800 0000:05:06.0: PCI INT A -> GSI 21 (level, low) ->
> IRQ 21
> [   20.862549] cx88[0]: Your board isn't known (yet) to the driver.  You
>  can [   20.862550] cx88[0]: try to pick one of the existing card configs
>  via [   20.862551] cx88[0]: card=<n> insmod option.  Updating to the
>  latest [   20.862552] cx88[0]: version might help as well.
> [   20.862554] cx88[0]: Here is a list of valid choices for the card=<n>
> insmod option:
> [   20.862556] cx88[0]:    card=0 -> UNKNOWN/GENERIC
> [   20.862558] cx88[0]:    card=1 -> Hauppauge WinTV 34xxx models
> [   20.862559] cx88[0]:    card=2 -> GDI Black Gold
> [   20.862561] cx88[0]:    card=3 -> PixelView
> [   20.862562] cx88[0]:    card=4 -> ATI TV Wonder Pro
> [   20.862563] cx88[0]:    card=5 -> Leadtek Winfast 2000XP Expert
> [   20.862565] cx88[0]:    card=6 -> AverTV Studio 303 (M126)
> [   20.862566] cx88[0]:    card=7 -> MSI TV-@nywhere Master
> [   20.862568] cx88[0]:    card=8 -> Leadtek Winfast DV2000
> [   20.862569] cx88[0]:    card=9 -> Leadtek PVR 2000
> [   20.862571] cx88[0]:    card=10 -> IODATA GV-VCP3/PCI
> [   20.862572] cx88[0]:    card=11 -> Prolink PlayTV PVR
> [   20.862574] cx88[0]:    card=12 -> ASUS PVR-416
> [   20.862575] cx88[0]:    card=13 -> MSI TV-@nywhere
> [   20.862577] cx88[0]:    card=14 -> KWorld/VStream XPert DVB-T
> [   20.862578] cx88[0]:    card=15 -> DViCO FusionHDTV DVB-T1
> [   20.862580] cx88[0]:    card=16 -> KWorld LTV883RF
> [   20.862581] cx88[0]:    card=17 -> DViCO FusionHDTV 3 Gold-Q
> [   20.862583] cx88[0]:    card=18 -> Hauppauge Nova-T DVB-T
> [   20.862584] cx88[0]:    card=19 -> Conexant DVB-T reference design
> [   20.862586] cx88[0]:    card=20 -> Provideo PV259
> [   20.862587] cx88[0]:    card=21 -> DViCO FusionHDTV DVB-T Plus
> [   20.862589] cx88[0]:    card=22 -> pcHDTV HD3000 HDTV
> [   20.862590] cx88[0]:    card=23 -> digitalnow DNTV Live! DVB-T
> [   20.862592] cx88[0]:    card=24 -> Hauppauge WinTV 28xxx (Roslyn) models
> [   20.862593] cx88[0]:    card=25 -> Digital-Logic MICROSPACE
> Entertainment Center (MEC)
> [   20.862595] cx88[0]:    card=26 -> IODATA GV/BCTV7E
> [   20.862597] cx88[0]:    card=27 -> PixelView PlayTV Ultra Pro (Stereo)
> [   20.862598] cx88[0]:    card=28 -> DViCO FusionHDTV 3 Gold-T
> [   20.862600] cx88[0]:    card=29 -> ADS Tech Instant TV DVB-T PCI
> [   20.862601] cx88[0]:    card=30 -> TerraTec Cinergy 1400 DVB-T
> [   20.862603] cx88[0]:    card=31 -> DViCO FusionHDTV 5 Gold
> [   20.862604] cx88[0]:    card=32 -> AverMedia UltraTV Media Center PCI
>  550 [   20.862606] cx88[0]:    card=33 -> Kworld V-Stream Xpert DVD
> [   20.862607] cx88[0]:    card=34 -> ATI HDTV Wonder
> [   20.862609] cx88[0]:    card=35 -> WinFast DTV1000-T
> [   20.862610] cx88[0]:    card=36 -> AVerTV 303 (M126)
> [   20.862611] cx88[0]:    card=37 -> Hauppauge Nova-S-Plus DVB-S
> [   20.862613] cx88[0]:    card=38 -> Hauppauge Nova-SE2 DVB-S
> [   20.862614] cx88[0]:    card=39 -> KWorld DVB-S 100
> [   20.862616] cx88[0]:    card=40 -> Hauppauge WinTV-HVR1100 DVB-T/Hybrid
> [   20.862618] cx88[0]:    card=41 -> Hauppauge WinTV-HVR1100
> DVB-T/Hybrid (Low Profile)
> [   20.862619] cx88[0]:    card=42 -> digitalnow DNTV Live! DVB-T Pro
> [   20.862621] cx88[0]:    card=43 -> KWorld/VStream XPert DVB-T with
> cx22702
> [   20.862623] cx88[0]:    card=44 -> DViCO FusionHDTV DVB-T Dual Digital
> [   20.862624] cx88[0]:    card=45 -> KWorld HardwareMpegTV XPert
> [   20.862626] cx88[0]:    card=46 -> DViCO FusionHDTV DVB-T Hybrid
> [   20.862627] cx88[0]:    card=47 -> pcHDTV HD5500 HDTV
> [   20.862628] cx88[0]:    card=48 -> Kworld MCE 200 Deluxe
> [   20.862630] cx88[0]:    card=49 -> PixelView PlayTV P7000
> [   20.862631] cx88[0]:    card=50 -> NPG Tech Real TV FM Top 10
> [   20.862633] cx88[0]:    card=51 -> WinFast DTV2000 H
> [   20.862634] cx88[0]:    card=52 -> Geniatech DVB-S
> [   20.862636] cx88[0]:    card=53 -> Hauppauge WinTV-HVR3000 TriMode
> Analog/DVB-S/DVB-T
> [   20.862637] cx88[0]:    card=54 -> Norwood Micro TV Tuner
> [   20.862639] cx88[0]:    card=55 -> Shenzhen Tungsten Ages Tech
> TE-DTV-250 / Swann OEM
> [   20.862641] cx88[0]:    card=56 -> Hauppauge WinTV-HVR1300
> DVB-T/Hybrid MPEG Encoder
> [   20.862643] cx88[0]:    card=57 -> ADS Tech Instant Video PCI
> [   20.862644] cx88[0]:    card=58 -> Pinnacle PCTV HD 800i
> [   20.862645] cx88[0]:    card=59 -> DViCO FusionHDTV 5 PCI nano
> [   20.862647] cx88[0]:    card=60 -> Pinnacle Hybrid PCTV
> [   20.862648] cx88[0]:    card=61 -> Leadtek TV2000 XP Global
> [   20.862650] cx88[0]:    card=62 -> PowerColor RA330
> [   20.862651] cx88[0]:    card=63 -> Geniatech X8000-MT DVBT
> [   20.862653] cx88[0]:    card=64 -> DViCO FusionHDTV DVB-T PRO
> [   20.862654] cx88[0]:    card=65 -> DViCO FusionHDTV 7 Gold
> [   20.862656] cx88[0]:    card=66 -> Prolink Pixelview MPEG 8000GT
> [   20.862657] cx88[0]:    card=67 -> Kworld PlusTV HD PCI 120 (ATSC 120)
> [   20.862659] cx88[0]:    card=68 -> Hauppauge WinTV-HVR4000
> DVB-S/S2/T/Hybrid
> [   20.862661] cx88[0]:    card=69 -> Hauppauge WinTV-HVR4000(Lite)
>  DVB-S/S2 [   20.862662] cx88[0]:    card=70 -> TeVii S460 DVB-S/S2
> [   20.862664] cx88[0]:    card=71 -> Omicom SS4 DVB-S/S2 PCI
> [   20.862665] cx88[0]:    card=72 -> TBS 8920 DVB-S/S2
> [   20.862666] cx88[0]:    card=73 -> TeVii S420 DVB-S
> [   20.862668] cx88[0]:    card=74 -> Prolink Pixelview Global Extreme
> [   20.862669] cx88[0]:    card=75 -> PROF 7300 DVB-S/S2
> [   20.862671] cx88[0]:    card=76 -> SATTRADE ST4200 DVB-S/S2
> [   20.862672] cx88[0]:    card=77 -> TBS 8910 DVB-S
> [   20.862674] cx88[0]:    card=78 -> Prof 6200 DVB-S
> [   20.862675] cx88[0]:    card=79 -> Terratec Cinergy HT PCI MKII
> [   20.862677] cx88[0]:    card=80 -> Hauppauge WinTV-IR Only
> [   20.862678] cx88[0]:    card=81 -> Leadtek WinFast DTV1800 Hybrid
> [   20.862680] cx88[0]:    card=82 -> WinFast DTV2000 H rev. J
> [   20.862681] cx88[0]:    card=83 -> Prof 7301 DVB-S/S2
> [   20.862683] cx88[0]: subsystem: 107d:6f42, board: UNKNOWN/GENERIC
> [card=0,autodetected], frontend(s): 0
> [   20.862685] cx88[0]: TV tuner type -1, Radio tuner type -1
> [   21.020478] tuner 3-0061: chip found @ 0xc2 (cx88[0])
> [   21.065392] cx88[0]/0: found at 0000:05:06.0, rev: 5, irq: 21,
> latency: 64, mmio: 0xf8000000
> [   21.065403] IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared
> IRQs
> [   21.065461] cx88[0]/0: registered device video0 [v4l2]
> [   21.065480] cx88[0]/0: registered device vbi0
> [   21.065489] tuner 3-0061: tuner type not set
> [   21.074373] cx88[0]/2: cx2388x 8802 Driver Manager
> [   21.074759] cx88_audio 0000:05:06.1: PCI INT A -> GSI 21 (level, low)
> -> IRQ 21
> [   21.074767] IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared
> IRQs
> [   21.074786] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> 
> 23.773910] tun: Universal TUN/TAP device driver, 1.6
> [   23.773912] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   23.774358] tun0: Disabled Privacy Extensions
> 
> [snip]
>   162.841498] tuner 3-0061: tuner type not set
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

--Boundary-01=_P2ZQL+axpw1YJVS
Content-Type: text/html;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'DejaVu Sans'; font-size:8pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hi,</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I have that card (the J version I think) and run it on the latest version of Kubuntu - works fine, but cannot handle the analogue signal, I got it to work on analogue once, but then an upgrade came and I forgot and I haven't hd the time.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Anyway for digital,</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Try adding to "/etc/modprobe.d/options.dpkg-bak"</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">options cx88xx card=51</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">and then restart.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I recomend using Me-TV. It's aussie, and simple to setup and use. Particulalry if you want to be using the computer for things other than TV.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Also try <span style=" font-family:'dejavu sans';">Add "cx88-dvb" to /etc/modules</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0; font-family:'dejavu sans';"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'dejavu sans';">Have a look at</span></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'dejavu sans';">http://www.mythtv.org/wiki/Leadtek_DTV-2000H</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0; font-family:'dejavu sans';"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'dejavu sans';">Cheers</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0; font-family:'dejavu sans';"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"><span style=" font-family:'dejavu sans';">Jon</span></p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">On Sun, 3 Jan 2010 07:39:44 pm Raena Lea-Shannon wrote:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; I do not seem to be able to get my DTV2000 to find a tuner. Seems to be</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; problem finding the card. Any suggestions would be greatly appreciated.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; I am running Kubuntu Karmic 2.6.31-16-generic on AMD64 quadcore.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; I came across this Patch which seesm to be on the point</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; but I do not have a cx88-cards.c file? I have compiled latest mercurial</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; v4l. Do I need to make an empty file cx88-cards.c? Excuse my ignorance I</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; am not a developer.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; I have tried to run modprobe cx88xx card=51 to no avail.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Here is part of an mplayer, lspci and dmesg follow.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Selected driver: v4l2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   name: Video 4 Linux 2 input</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   author: Martin Olschewski &lt;olschewski@zpr.uni-koeln.de&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   comment: first try, more to come ;-)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Selected device: UNKNOWN/GENERIC</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   Capabilites:  video capture  VBI capture device  read/write  streaming</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = NTSC-443; 3 = PAL-BG;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 4 = PAL-I; 5 = PAL-DK; 6 = PAL-M; 7 = PAL-N; 8 = PAL-Nc; 9 = PAL-60; 10</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; = SECAM-B; 11 = SECAM-G; 12 = SECAM-H; 13 = SECAM-DK; 14 = SECAM-L;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   inputs: 0 = Composite1; 1 = Composite2; 2 = Composite3; 3 = Composite4;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; I am running Kubuntu Karmic 2.6.31-16-generic on AMD64 quadcore. I have</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; latest mercurial of v4l installed.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Here is the Lspci info and dmesg etc</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 5:05.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; FlexCopII DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Technisat SkyStar2 DVB card [13d0:2103]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Flags: bus master, slow devsel, latency 64, IRQ 20</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Memory at fbff0000 (32-bit, non-prefetchable) [size=64K]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          I/O ports at ec00 [size=32]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel driver in use: b2c2_flexcop_pci</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel modules: b2c2-flexcop-pci</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 05:06.0 Multimedia video controller [0400]: Conexant Systems, Inc.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Subsystem: LeadTek Research Inc. Device [107d:6f42]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Flags: bus master, medium devsel, latency 64, IRQ 21</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Memory at f8000000 (32-bit, non-prefetchable) [size=16M]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Capabilities: &lt;access denied&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel driver in use: cx8800</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel modules: cx8800</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 05:06.1 Multimedia controller [0480]: Conexant Systems, Inc.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801] (rev 05)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Subsystem: LeadTek Research Inc. Device [107d:6f42]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Flags: bus master, medium devsel, latency 64, IRQ 21</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Memory at f9000000 (32-bit, non-prefetchable) [size=16M]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Capabilities: &lt;access denied&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel driver in use: cx88_audio</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel modules: cx88-alsa</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 05:06.2 Multimedia controller [0480]: Conexant Systems, Inc.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Subsystem: LeadTek Research Inc. Device [107d:6f42]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Flags: bus master, medium devsel, latency 64, IRQ 10</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Memory at fa000000 (32-bit, non-prefetchable) [size=16M]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Capabilities: &lt;access denied&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;          Kernel modules: cx8802</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; dmesg in part here:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [snip]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.387650] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; receiver chip loaded successfully</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.390596] EDAC MC: Ver: 2.1.0 Dec  8 2009</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.392347] flexcop-pci: will use the HW PID filter.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.392351] flexcop-pci: card revision 2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.392359]   alloc irq_desc for 20 on node 0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.392361]   alloc kstat_irqs on node 0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.392366] b2c2_flexcop_pci 0000:05:05.0: PCI INT A -&gt; GSI 20</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; (level, low) -&gt; IRQ 20</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.403400] EDAC amd64_edac:  Ver: 3.2.0 Dec  8 2009</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404070] EDAC amd64: This node reports that Memory ECC is</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; currently disabled.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404073] EDAC amd64: bit 0x400000 in register F3x44 of the</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; MISC_CONTROL device (0000:00:18.3) should be enabled</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404076] EDAC amd64: WARNING: ECC is NOT currently enabled by the</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; BIOS. Module will NOT be loaded.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404077]     Either Enable ECC in the BIOS, or use the</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 'ecc_enable_override' parameter.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404078]     Might be a BIOS bug, if BIOS says ECC is enabled</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404078]     Use of the override can cause unknown side effects.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.404541] amd64_edac: probe of 0000:00:18.2 failed with error -22</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.425278] HDA Intel 0000:00:14.2: PCI INT A -&gt; GSI 16 (level, low)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; -&gt; IRQ 16</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.430203] DVB: registering new adapter (FlexCop Digital TV device)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.431702] b2c2-flexcop: MAC address = 00:d0:d7:16:5d:8f</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.432308] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.432311] CX24123: wrong demod revision: 87</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.547542] Linux video capture interface: v2.00</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.555291] HDA Intel 0000:01:00.1: PCI INT B -&gt; GSI 19 (level, low)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; -&gt; IRQ 19</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.555310] HDA Intel 0000:01:00.1: setting latency timer to 64</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.608776] EXT3 FS on sda1, internal journal</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.857754] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.859425] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.859959] b2c2-flexcop: found 'Zarlink MT352 DVB-T' .</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.859963] DVB: registering adapter 0 frontend 0 (Zarlink MT352</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; DVB-T)...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.860017] b2c2-flexcop: initialization of 'Air2PC/AirStar 2 DVB-T'</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; at the 'PCI' bus controlled by a 'FlexCopIIb' complete</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.861717] cx2388x alsa driver version 0.0.7 loaded</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862371]   alloc irq_desc for 21 on node 0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862373]   alloc kstat_irqs on node 0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862379] cx8800 0000:05:06.0: PCI INT A -&gt; GSI 21 (level, low) -&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; IRQ 21</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862549] cx88[0]: Your board isn't known (yet) to the driver.  You</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;  can [   20.862550] cx88[0]: try to pick one of the existing card configs</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;  via [   20.862551] cx88[0]: card=&lt;n&gt; insmod option.  Updating to the</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;  latest [   20.862552] cx88[0]: version might help as well.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862554] cx88[0]: Here is a list of valid choices for the card=&lt;n&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; insmod option:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862556] cx88[0]:    card=0 -&gt; UNKNOWN/GENERIC</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862558] cx88[0]:    card=1 -&gt; Hauppauge WinTV 34xxx models</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862559] cx88[0]:    card=2 -&gt; GDI Black Gold</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862561] cx88[0]:    card=3 -&gt; PixelView</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862562] cx88[0]:    card=4 -&gt; ATI TV Wonder Pro</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862563] cx88[0]:    card=5 -&gt; Leadtek Winfast 2000XP Expert</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862565] cx88[0]:    card=6 -&gt; AverTV Studio 303 (M126)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862566] cx88[0]:    card=7 -&gt; MSI TV-@nywhere Master</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862568] cx88[0]:    card=8 -&gt; Leadtek Winfast DV2000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862569] cx88[0]:    card=9 -&gt; Leadtek PVR 2000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862571] cx88[0]:    card=10 -&gt; IODATA GV-VCP3/PCI</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862572] cx88[0]:    card=11 -&gt; Prolink PlayTV PVR</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862574] cx88[0]:    card=12 -&gt; ASUS PVR-416</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862575] cx88[0]:    card=13 -&gt; MSI TV-@nywhere</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862577] cx88[0]:    card=14 -&gt; KWorld/VStream XPert DVB-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862578] cx88[0]:    card=15 -&gt; DViCO FusionHDTV DVB-T1</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862580] cx88[0]:    card=16 -&gt; KWorld LTV883RF</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862581] cx88[0]:    card=17 -&gt; DViCO FusionHDTV 3 Gold-Q</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862583] cx88[0]:    card=18 -&gt; Hauppauge Nova-T DVB-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862584] cx88[0]:    card=19 -&gt; Conexant DVB-T reference design</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862586] cx88[0]:    card=20 -&gt; Provideo PV259</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862587] cx88[0]:    card=21 -&gt; DViCO FusionHDTV DVB-T Plus</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862589] cx88[0]:    card=22 -&gt; pcHDTV HD3000 HDTV</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862590] cx88[0]:    card=23 -&gt; digitalnow DNTV Live! DVB-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862592] cx88[0]:    card=24 -&gt; Hauppauge WinTV 28xxx (Roslyn) models</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862593] cx88[0]:    card=25 -&gt; Digital-Logic MICROSPACE</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Entertainment Center (MEC)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862595] cx88[0]:    card=26 -&gt; IODATA GV/BCTV7E</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862597] cx88[0]:    card=27 -&gt; PixelView PlayTV Ultra Pro (Stereo)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862598] cx88[0]:    card=28 -&gt; DViCO FusionHDTV 3 Gold-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862600] cx88[0]:    card=29 -&gt; ADS Tech Instant TV DVB-T PCI</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862601] cx88[0]:    card=30 -&gt; TerraTec Cinergy 1400 DVB-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862603] cx88[0]:    card=31 -&gt; DViCO FusionHDTV 5 Gold</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862604] cx88[0]:    card=32 -&gt; AverMedia UltraTV Media Center PCI</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;  550 [   20.862606] cx88[0]:    card=33 -&gt; Kworld V-Stream Xpert DVD</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862607] cx88[0]:    card=34 -&gt; ATI HDTV Wonder</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862609] cx88[0]:    card=35 -&gt; WinFast DTV1000-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862610] cx88[0]:    card=36 -&gt; AVerTV 303 (M126)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862611] cx88[0]:    card=37 -&gt; Hauppauge Nova-S-Plus DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862613] cx88[0]:    card=38 -&gt; Hauppauge Nova-SE2 DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862614] cx88[0]:    card=39 -&gt; KWorld DVB-S 100</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862616] cx88[0]:    card=40 -&gt; Hauppauge WinTV-HVR1100 DVB-T/Hybrid</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862618] cx88[0]:    card=41 -&gt; Hauppauge WinTV-HVR1100</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; DVB-T/Hybrid (Low Profile)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862619] cx88[0]:    card=42 -&gt; digitalnow DNTV Live! DVB-T Pro</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862621] cx88[0]:    card=43 -&gt; KWorld/VStream XPert DVB-T with</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; cx22702</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862623] cx88[0]:    card=44 -&gt; DViCO FusionHDTV DVB-T Dual Digital</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862624] cx88[0]:    card=45 -&gt; KWorld HardwareMpegTV XPert</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862626] cx88[0]:    card=46 -&gt; DViCO FusionHDTV DVB-T Hybrid</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862627] cx88[0]:    card=47 -&gt; pcHDTV HD5500 HDTV</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862628] cx88[0]:    card=48 -&gt; Kworld MCE 200 Deluxe</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862630] cx88[0]:    card=49 -&gt; PixelView PlayTV P7000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862631] cx88[0]:    card=50 -&gt; NPG Tech Real TV FM Top 10</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862633] cx88[0]:    card=51 -&gt; WinFast DTV2000 H</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862634] cx88[0]:    card=52 -&gt; Geniatech DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862636] cx88[0]:    card=53 -&gt; Hauppauge WinTV-HVR3000 TriMode</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Analog/DVB-S/DVB-T</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862637] cx88[0]:    card=54 -&gt; Norwood Micro TV Tuner</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862639] cx88[0]:    card=55 -&gt; Shenzhen Tungsten Ages Tech</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; TE-DTV-250 / Swann OEM</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862641] cx88[0]:    card=56 -&gt; Hauppauge WinTV-HVR1300</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; DVB-T/Hybrid MPEG Encoder</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862643] cx88[0]:    card=57 -&gt; ADS Tech Instant Video PCI</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862644] cx88[0]:    card=58 -&gt; Pinnacle PCTV HD 800i</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862645] cx88[0]:    card=59 -&gt; DViCO FusionHDTV 5 PCI nano</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862647] cx88[0]:    card=60 -&gt; Pinnacle Hybrid PCTV</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862648] cx88[0]:    card=61 -&gt; Leadtek TV2000 XP Global</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862650] cx88[0]:    card=62 -&gt; PowerColor RA330</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862651] cx88[0]:    card=63 -&gt; Geniatech X8000-MT DVBT</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862653] cx88[0]:    card=64 -&gt; DViCO FusionHDTV DVB-T PRO</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862654] cx88[0]:    card=65 -&gt; DViCO FusionHDTV 7 Gold</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862656] cx88[0]:    card=66 -&gt; Prolink Pixelview MPEG 8000GT</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862657] cx88[0]:    card=67 -&gt; Kworld PlusTV HD PCI 120 (ATSC 120)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862659] cx88[0]:    card=68 -&gt; Hauppauge WinTV-HVR4000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; DVB-S/S2/T/Hybrid</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862661] cx88[0]:    card=69 -&gt; Hauppauge WinTV-HVR4000(Lite)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;  DVB-S/S2 [   20.862662] cx88[0]:    card=70 -&gt; TeVii S460 DVB-S/S2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862664] cx88[0]:    card=71 -&gt; Omicom SS4 DVB-S/S2 PCI</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862665] cx88[0]:    card=72 -&gt; TBS 8920 DVB-S/S2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862666] cx88[0]:    card=73 -&gt; TeVii S420 DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862668] cx88[0]:    card=74 -&gt; Prolink Pixelview Global Extreme</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862669] cx88[0]:    card=75 -&gt; PROF 7300 DVB-S/S2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862671] cx88[0]:    card=76 -&gt; SATTRADE ST4200 DVB-S/S2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862672] cx88[0]:    card=77 -&gt; TBS 8910 DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862674] cx88[0]:    card=78 -&gt; Prof 6200 DVB-S</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862675] cx88[0]:    card=79 -&gt; Terratec Cinergy HT PCI MKII</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862677] cx88[0]:    card=80 -&gt; Hauppauge WinTV-IR Only</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862678] cx88[0]:    card=81 -&gt; Leadtek WinFast DTV1800 Hybrid</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862680] cx88[0]:    card=82 -&gt; WinFast DTV2000 H rev. J</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862681] cx88[0]:    card=83 -&gt; Prof 7301 DVB-S/S2</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862683] cx88[0]: subsystem: 107d:6f42, board: UNKNOWN/GENERIC</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [card=0,autodetected], frontend(s): 0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   20.862685] cx88[0]: TV tuner type -1, Radio tuner type -1</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.020478] tuner 3-0061: chip found @ 0xc2 (cx88[0])</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.065392] cx88[0]/0: found at 0000:05:06.0, rev: 5, irq: 21,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; latency: 64, mmio: 0xf8000000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.065403] IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; IRQs</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.065461] cx88[0]/0: registered device video0 [v4l2]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.065480] cx88[0]/0: registered device vbi0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.065489] tuner 3-0061: tuner type not set</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.074373] cx88[0]/2: cx2388x 8802 Driver Manager</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.074759] cx88_audio 0000:05:06.1: PCI INT A -&gt; GSI 21 (level, low)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; -&gt; IRQ 21</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.074767] IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; IRQs</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   21.074786] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; 23.773910] tun: Universal TUN/TAP device driver, 1.6</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   23.773912] tun: (C) 1999-2004 Max Krasnyansky &lt;maxk@qualcomm.com&gt;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [   23.774358] tun0: Disabled Privacy Extensions</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; [snip]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt;   162.841498] tuner 3-0061: tuner type not set</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; _______________________________________________</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; linux-dvb users mailing list</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; For V4L/DVB development, please use instead linux-media@vger.kernel.org</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; linux-dvb@linuxtv.org</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; </p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p></body></html>
--Boundary-01=_P2ZQL+axpw1YJVS--


--===============1281981871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1281981871==--
