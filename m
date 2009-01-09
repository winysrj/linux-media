Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx33.mail.ru ([194.67.23.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1LLGYI-00006c-KX
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 13:33:29 +0100
Received: from [92.101.142.149] (port=7034 helo=localhost.localdomain)
	by mx33.mail.ru with asmtp id 1LLGXk-000DHv-00
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 15:32:52 +0300
Date: Fri, 9 Jan 2009 15:40:05 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20090109154005.3295d447@bk.ru>
Mime-Version: 1.0
Subject: [linux-dvb] current v4l-dvb - cannot access /dev/dvb/: No such file
 or directory
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hI

With today v4l-dvb I couldn't run my hvr4000 card on 2.6.27 kernel 

dmesg | grep DVB
[ 13.156637] cx88[0]: subsystem: 0070:6900, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[ 14.345650] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ 14.645283] cx88[0]/2: subsystem: 0070:6900, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[ 14.645342] cx88[0]/2: cx2388x based DVB/ATSC card


from dmesg 

  13.048809] FDC 0 is a post-1991 82077
[   13.063263] input: PC Speaker as /class/input/input3
[   13.232315] Linux video capture interface: v2.00
[   13.273216] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.308529] gameport: NS558 PnP Gameport is pnp00:0c/gameport0, io 0x200, speed 890kHz
[   13.425179] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   13.426114] cx88[0]: subsystem: 0070:6900, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[   13.426182] cx88[0]: TV tuner type 63, Radio tuner type -1
[   13.437869] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   13.511674] ivtv: Start initialization, version 1.4.0
[   13.547135] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
[   14.174719] cx2388x alsa driver version 0.0.6 loaded
[   14.229866] tuner' 1-0043: chip found @ 0x86 (cx88[0])
[   14.301182] tda9887 1-0043: creating new instance
[   14.301234] tda9887 1-0043: tda988[5/6/7] found
[   14.304474] tuner' 1-0061: chip found @ 0xc2 (cx88[0])
[   14.305474] tuner' 1-0063: chip found @ 0xc6 (cx88[0])
[   14.352647] tveeprom 1-0050: Hauppauge model 69559, rev B2A0, serial# 804345
[   14.352700] tveeprom 1-0050: MAC address is 00-0D-FE-0C-45-F9
[   14.352746] tveeprom 1-0050: tuner model is Philips FMD1216ME (idx 100, type 63)
[   14.352800] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   14.352857] tveeprom 1-0050: audio processor is CX882 (idx 33)
[   14.352903] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[   14.352948] tveeprom 1-0050: has radio
[   14.352990] cx88[0]: hauppauge eeprom: model=69559
[   14.393070] tuner-simple 1-0061: creating new instance
[   14.393155] tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
[   14.395754] input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input4
[   14.405094] cx88[0]/2: cx2388x 8802 Driver Manager
[   14.405156] cx88-mpeg driver manager 0000:02:03.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   14.405213] cx88[0]/2: found at 0000:02:03.2, rev: 5, irq: 20, latency: 32, mmio: 0xde000000
[   14.405476] cx8800 0000:02:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   14.405537] cx88[0]/0: found at 0000:02:03.0, rev: 5, irq: 20, latency: 32, mmio: 0xdc000000
[   14.506629] wm8775' 1-001b: chip found @ 0x36 (cx88[0])
[   14.513475] cx88[0]/0: registered device video0 [v4l2]
[   14.513575] cx88[0]/0: registered device vbi0
[   14.513682] cx88[0]/0: registered device radio0
[   14.524681] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.524778] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   14.525589] ivtv0: Initializing card 0
[   14.525642] ivtv0: Autodetected GotView PCI DVD2 Deluxe card (cx23416 based)
[   14.533014] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
[   14.544093] ivtv 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.544158] ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
[   14.555162] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   14.555231] cx88/2: registering cx8802 driver, type: dvb access: shared
[   14.555303] cx88[0]/2: subsystem: 0070:6900, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[   14.555374] cx88[0]/2: cx2388x based DVB/ATSC card
[   14.555446] BUG: unable to handle kernel NULL pointer dereference at 00000000
[   14.555560] IP: [<c02e6bff>] __mutex_lock_common+0x3c/0xe4
[   14.555652] *pde = 00000000
[   14.555735] Oops: 0002 [#1] SMP
[   14.555851] Modules linked in: cx88_dvb(+) cx88_vp3054_i2c videobuf_dvb wm8775 dvb_core tuner_simple tuner_types snd_seq_dummy tda9887 snd_seq_oss(+) snd_intel8x0(+) tda8290 snd_seq_midi snd_seq_midi_event snd_ac97_codec cx88_alsa(+) snd_seq ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_rawmidi snd_timer tuner snd_seq_device psmouse snd serio_raw ivtv(+) cx8800 cx8802 cx88xx soundcore cx2341x ir_common ns558 i2c_i801 v4l2_common videodev i2c_algo_bit gameport v4l1_compat snd_page_alloc tveeprom pcspkr floppy videobuf_dma_sg videobuf_core btcx_risc i2c_core parport_pc parport button intel_agp agpgart shpchp pci_hotplug rng_core iTCO_wdt sd_mod evdev usbhid hid ff_memless ext3 jbd mbcache ide_cd_mod cdrom ide_disk ata_piix libata dock 8139too usb_storage scsi_mod piix 8139cp mii ide_core uhci_hcd ehci_hcd usbcore thermal processor fan thermal_sys
[   14.557013]
[   14.557013] Pid: 2310, comm: modprobe Not tainted (2.6.27.1-custom-default1 #1)
[   14.557013] EIP: 0060:[<c02e6bff>] EFLAGS: 00010246 CPU: 1
[   14.557013] EIP is at __mutex_lock_common+0x3c/0xe4
[   14.557013] EAX: de653e98 EBX: de739118 ECX: de739120 EDX: 00000000
[   14.557013] ESI: dd4209e0 EDI: de73911c EBP: de653eb0 ESP: de653e88
[   14.557013]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   14.557013] Process modprobe (pid: 2310, ti=de652000 task=dd4209e0 task.ti=de652000)
[   14.557013] Stack: 3535352e 5d343733 00000002 de739120 de739120 00000000 c044a6c0 de739110
[   14.557013]        de739118 00000001 de653ebc c02e6d38 c02e6b88 de653ec4 c02e6b88 de653ed8
[   14.557013]        e1ac7115 de6a9000 00000001 00000000 de653f0c e1aeca62 de739004 de739000
[   14.557013] Call Trace:
[   14.557013]  [<c02e6d38>] ? __mutex_lock_slowpath+0x17/0x1a
[   14.557013]  [<c02e6b88>] ? mutex_lock+0x12/0x14
[   14.557013]  [<c02e6b88>] ? mutex_lock+0x12/0x14
[   14.557013]  [<e1ac7115>] ? videobuf_dvb_get_frontend+0x19/0x40 [videobuf_dvb]
[   14.557013]  [<e1aeca62>] ? cx8802_dvb_probe+0xc9/0x1945 [cx88_dvb]
[   14.557013]  [<e09ee41e>] ? cx8802_register_driver+0xbd/0x1ac [cx8802]
[   14.557013]  [<e09ee467>] ? cx8802_register_driver+0x106/0x1ac [cx8802]
[   14.557013]  [<e1aee37f>] ? dvb_init+0x22/0x27 [cx88_dvb]
[   14.557013]  [<c0101132>] ? _stext+0x42/0x11a
[   14.557013]  [<e1aee35d>] ? dvb_init+0x0/0x27 [cx88_dvb]
[   14.557013]  [<c013d2ca>] ? __blocking_notifier_call_chain+0xe/0x51
[   14.557013]  [<c014970b>] ? sys_init_module+0x8c/0x17d
[   14.557013]  [<c0103b42>] ? syscall_call+0x7/0xb
[   14.557013]  [<c013007b>] ? round_jiffies_relative+0x14/0x16
[   14.557013]  =======================
[   14.557013] Code: 78 04 89 f8 89 55 e0 64 8b 35 00 30 3f c0 e8 2e 0c 00 00 8d 43 08 89 45 e4 8b 53 0c 8d 45 e8 8b 4d e4 89 43 0c 89 4d e8 89 55 ec <89> 02 89 75 f0 83 c8 ff 87 03 48 74 55 8a 45 e0 8b 4d e0 83 e0
[   14.557013] EIP: [<c02e6bff>] __mutex_lock_common+0x3c/0xe4 SS:ESP 0068:de653e88
[   14.565211] ---[ end trace 94d8b014e067ac7b ]---
[   14.639501] cx25840 2-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)
[   14.713180] tuner 2-0043: chip found @ 0x86 (ivtv i2c driver #0)
[   14.713430] tda9887 2-0043: creating new instance
[   14.713495] tda9887 2-0043: tda988[5/6/7] found
[   14.778413] All bytes are equal. It is not a TEA5767
[   14.778557] tuner 2-0060: chip found @ 0xc0 (ivtv i2c driver #0)
[   14.779143] tuner-simple 2-0060: creating new instance
[   14.779186] tuner-simple 2-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
[   14.781867] ivtv0: Registered device video1 for encoder MPG (4096 kB)
[   14.781948] ivtv0: Registered device video33 for encoder YUV (2048 kB)
[   14.782023] ivtv0: Registered device vbi1 for encoder VBI (1024 kB)
[   14.782097] ivtv0: Registered device video25 for encoder PCM (320 kB)
[   14.782174] ivtv0: Registered device radio1 for encoder radio
[   14.782217] ivtv0: Initialized card: GotView PCI DVD2 Deluxe
[   14.782347] cx88_audio 0000:02:03.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   14.782460] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   14.783176] ivtv: End initialization
[   14.849033] intel8x0_measure_ac97_clock: measured 53593 usecs
[   14.849085] intel8x0: clocking to 48000
[   15.918647] Adding 626492k swap on /dev/hda6.  Priority:-1 extents:1 across:626492k
[   15.928361] Adding 56156k swap on /dev/hdb5.  Priority:-2 extents:1 across:56156k
[   16.082504] EXT3 FS on hda2, internal journal
[   20.264662] device-mapper: uevent: version 1.0.3
[   20.265339] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   56.024553] kjournald starting.  Commit interval 5 seconds
[   56.024748] EXT3 FS on hda3, internal journal
[   56.024825] EXT3-fs: mounted filesystem with ordered data mode.
[   56.037399] kjournald starting.  Commit interval 5 seconds
[   56.037627] EXT3 FS on hda5, internal journal
[   56.037702] EXT3-fs: mounted filesystem with ordered data mode.
[   58.129611] eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
[   63.336544] process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
[   64.945747] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   73.192024] firmware: requesting v4l-cx2341x-enc.fw
[   73.288401] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
[   73.489134] ivtv0: Encoder revision: 0x02060039
[   73.506785] firmware: requesting v4l-cx25840.fw
[   77.004190] cx25840 2-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[   80.030364] [drm] Initialized drm 1.1.0 20060810
[   80.059688] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   80.060282] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   80.302075] agpgart-intel 0000:00:00.0: AGP 3.0 bridge
[   80.302099] agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
[   80.302140] pci 0000:01:00.0: putting AGP V3 device into 8x mode
[   80.619333] [drm] Setting GART location based on new memory map
[   80.619344] [drm] Loading R300 Microcode
[   80.619377] [drm] Num pipes: 1
[   80.619384] [drm] writeback test succeeded in 1 usecs
[ 1552.680755] [drm] Num pipes: 1
[ 1569.479839] agpgart-intel 0000:00:00.0: AGP 3.0 bridge
[ 1569.479867] agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
[ 1569.479908] pci 0000:01:00.0: putting AGP V3 device into 8x mode
[ 1569.479954] [drm] Loading R300 Microcode
[ 1569.479988] [drm] Num pipes: 1
[ 1614.959936] [drm] Num pipes: 1
[ 1619.666414] agpgart-intel 0000:00:00.0: AGP 3.0 bridge
[ 1619.666441] agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
[ 1619.666482] pci 0000:01:00.0: putting AGP V3 device into 8x mode
[ 1619.666528] [drm] Loading R300 Microcode
[ 1619.666562] [drm] Num pipes: 1




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
