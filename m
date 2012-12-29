Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44352 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2L2EZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 23:25:40 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4621074eaa.33
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 20:25:39 -0800 (PST)
Message-ID: <50DE70C0.5090803@gmail.com>
Date: Sat, 29 Dec 2012 05:25:36 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com
Subject: [BUG] crystalhd git.linuxtv.org kernel driver: NULL pointer deref
 in crystalhd_dioq_fetch_wait() while playing SBS 3D h.264 in mplayer2
Content-Type: multipart/mixed;
 boundary="------------030909020801050107060308"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030909020801050107060308
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello guys,

I'm working on supporting BCM 970012/15 crystalhd decoder in userspace video/tv apps and

can't find where to report bugs of

http://git.linuxtv.org/jarod/crystalhd.git
<devinheitmueller> I think he just borrowed our git server.

So I borrow this list to get more developers, testers and sw- quality guys in.

Got another null pointer deref OOPS in crystalhd_dioq_fetch_wait after chd_dec_free_iodata while playing 3D SBS with -vf stereo3d=sbsl:agmc using crystalhd driver on
debian wheezy
Linux vdr1 3.6.10-PM #8 PREEMPT Sat Dec 15 00:54:11 CET 2012 i686 GNU/Linux
crystalhd driver+lib, libavcodec crystalhd.c git HEAD but libavcodec53

System not crashed but this issue needs rmmod -f and modprobe /-r again otherwise crash on access, see bt #2 below.

And there's something strange: Why is pulseaudio loading libcrystalhd.so , see lsof output end of logs below.

Note: I've disabled the legacy h264 software codec in libavcodec53 to force every app using h264_crystalhd for h.264 with
my backport patch -Attached- from ffmpeg git HEAD of yesterday to libavcodec.so.53.61.100 , debian src ffmpeg 7:0.10.3-dmo1 0
using
./configure ... --disable-decoder='h264,h264_vdpau,h264_vda'
to automate testing of (lib)crystalhd(.ko) with all apps requesting libavcodec h.264 ;-)
Don't worry, I've left the "childlock" in the patch to not get this patch in any distro.

y
tom

-Att: Backport patch for crystalhd.c using in libavcodec53
-Att: Kernel OOPS bt, etc

Dec 29 03:45:48 vdr1 kernel: [21380.312142] crystalhd 0000:02:00.0: list_index:0 rx[631] rxtot[65358] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:45:48 vdr1 kernel: [21380.345357] crystalhd 0000:02:00.0: MISSING 2 PICTURES
Dec 29 03:45:57 vdr1 kernel: [21389.239365] crystalhd 0000:02:00.0: list_index:1 rx[632] rxtot[65907] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
Dec 29 03:45:57 vdr1 kernel: [21389.299893] crystalhd 0000:02:00.0: list_index:0 rx[633] rxtot[65910] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:45:58 vdr1 kernel: [21390.298013] crystalhd 0000:02:00.0: list_index:1 rx[634] rxtot[65971] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
Dec 29 03:45:59 vdr1 kernel: [21391.287414] crystalhd 0000:02:00.0: list_index:0 rx[635] rxtot[66032] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:46:03 vdr1 kernel: [21395.291567] crystalhd 0000:02:00.0: list_index:0 rx[636] rxtot[66278] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:46:04 vdr1 kernel: [21396.298724] crystalhd 0000:02:00.0: list_index:0 rx[637] rxtot[66340] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:46:06 vdr1 kernel: [21398.262450] crystalhd 0000:02:00.0: list_index:1 rx[638] rxtot[66461] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
Dec 29 03:46:09 vdr1 kernel: [21400.767268] crystalhd 0000:02:00.0: list_index:1 rx[639] rxtot[66615] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
Dec 29 03:46:11 vdr1 kernel: [21403.254963] crystalhd 0000:02:00.0: list_index:0 rx[640] rxtot[66768] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:46:13 vdr1 kernel: [21405.292398] crystalhd 0000:02:00.0: list_index:1 rx[641] rxtot[66893] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
Dec 29 03:46:14 vdr1 kernel: [21406.288434] crystalhd 0000:02:00.0: list_index:0 rx[642] rxtot[66954] Y:2 UV:0 Int:8 YDnSz:0 UVDnSz:0
Dec 29 03:46:15 vdr1 kernel: [21406.782372] BUG: unable to handle kernel NULL pointer dereference at 00000018
Dec 29 03:46:15 vdr1 kernel: [21406.782876] IP: [<fa46e8cc>] crystalhd_dioq_fetch_wait+0x19c/0x330 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173] *pdpt = 000000002f95e001 *pde = 0000000000000000
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Oops: 0000 [#1] PREEMPT
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon isl6405 uvcvideo dvb_pll tda10086 saa7134_dvb videobuf_dvb tuner tda10021 cryptomgr aead arc4 crypto_blkcipher crypto_algapi snd_usb_audio stv0297 snd_usbmidi_lib snd_intel8x0 snd_ac97_codec ac97_bus rt73usb rt2x00usb rt2x00lib snd_hwdep snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi snd_pcm_oss snd_mixer_oss joydev snd_pcm snd_rawmidi saa7134 hid_sunplus hid_generic snd_seq_midi_event videobuf2_vmalloc videobuf2_memops budget_av videobuf2_core cfg80211 usbhid hid snd_page_alloc snd_seq dvb_ttpci saa7146_vv budget_core crc_itu_t ttpci_eeprom crypto saa7146
 dvb_core tveeprom videobu
Dec 29 03:46:15 vdr1 kernel: f_dma_sg videobuf_core v4l2_common snd_seq_device snd_timer crystalhd(O) videodev snd rc_core shpchp i2c_i801 pci_hotplug serio_raw pcspkr rng_core soundcore 8250_pnp 8250 serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod cdrom crc_t10dif ata_piix ahci libahci libata scsi_mod uhci_hcd ehci_hcd usbcore
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Pid: 17775, comm: mplayer2 Tainted: G           O 3.6.10-PM #8    /Alviso
Dec 29 03:46:15 vdr1 kernel: [21406.783173] EIP: 0060:[<fa46e8cc>] EFLAGS: 00010246 CPU: 0
Dec 29 03:46:15 vdr1 kernel: [21406.783173] EIP is at crystalhd_dioq_fetch_wait+0x19c/0x330 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173] EAX: 00000000 EBX: efbcbde0 ECX: 00000000 EDX: f5110000
Dec 29 03:46:15 vdr1 kernel: [21406.783173] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 29 03:46:15 vdr1 kernel: [21406.783173] DR6: ffff0ff0 DR7: 00000400
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Process mplayer2 (pid: 17775, ti=f5110000 task=efbcbde0 task.ti=f5110000)
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Stack:
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  70029071 efbcbde0 efbcbde0 0142105d f7138064 f5111e98 efbcbde0 c5b72d28
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  0142182d c5b72c00 f0626094 f06260bc 00000000 efbcbde0 c1052e00 00100100
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  00200200 f5e66c28 c5b72c00 f5111ec4 f5111ea8 fa4728bd f5110000 00000000
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Call Trace:
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c1052e00>] ? try_to_wake_up+0x150/0x150
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa4728bd>] crystalhd_hw_get_cap_buffer+0x4d/0x130 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa46feef>] bc_cproc_fetch_frame+0xbf/0x1b0 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa46d3b9>] ? chd_dec_proc_user_data+0x59/0x320 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa46db5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa46fe30>] ? bc_cproc_start_capture+0xc0/0xc0 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<f9a274e6>] ? snd_pcm_playback_ioctl+0x26/0x40 [snd_pcm]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<fa46d9f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 03:46:15 vdr1 kernel: [21406.783173]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 03:46:15 vdr1 kernel: [21406.783173] Code: fb eb ef c6 85 f6 0f 85 23 01 00 00 8b 45 d4 05 28 01 00 00 89 45 cc e8 f3 0c be c6 85 c0 0f 85 78 01 00 00 89 f8 e8 34 fc ff ff <f6> 40 18 03 89 45 dc 0f 85 5a 01 00 00 8b 55 d4 8b 42 7c 8b 40
Dec 29 03:46:15 vdr1 kernel: [21406.783173] EIP: [<fa46e8cc>] crystalhd_dioq_fetch_wait+0x19c/0x330 [crystalhd] SS:ESP 0068:f5111e34
Dec 29 03:46:15 vdr1 kernel: [21406.783173] CR2: 0000000000000018
Dec 29 03:46:15 vdr1 kernel: [21407.078300] ---[ end trace 748e55df23d79087 ]---
Dec 29 03:46:15 vdr1 kernel: [21407.091266] crystalhd 0000:02:00.0: list_index:1 rx[643] rxtot[66988] Y:810 UV:0 Int:8 YDnSz:0 UVDnSz:0
...
Dec 29 03:52:00 vdr1 kernel: [21752.561571] crystalhd 0000:02:00.0: Opening new user[1] handle
Dec 29 03:52:00 vdr1 kernel: [21752.668914] crystalhd 0000:02:00.0: Link invalid state notify mode 7
Dec 29 03:52:01 vdr1 kernel: [21752.786732] crystalhd 0000:02:00.0: Handle is already closed
Dec 29 03:52:01 vdr1 kernel: [21752.786764] crystalhd 0000:02:00.0: Closing user[1] handle with mode ffffffff
Dec 29 03:52:01 vdr1 kernel: [21752.788719] crystalhd 0000:02:00.0: Opening new user[1] handle
Dec 29 03:52:01 vdr1 kernel: [21752.879065] crystalhd 0000:02:00.0: Link invalid state notify mode 7
Dec 29 03:52:01 vdr1 kernel: [21752.994580] crystalhd 0000:02:00.0: Handle is already closed
Dec 29 03:52:01 vdr1 kernel: [21752.994605] crystalhd 0000:02:00.0: Closing user[1] handle with mode ffffffff
Dec 29 03:52:18 vdr1 kernel: [21770.235803] crystalhd 0000:02:00.0: Opening new user[1] handle
Dec 29 03:52:18 vdr1 kernel: [21770.349508] crystalhd 0000:02:00.0: Link invalid state notify mode 7
Dec 29 04:03:11 vdr1 kernel: [22422.728993] crystalhd 0000:02:00.0: Opening new user[2] handle
Dec 29 04:03:11 vdr1 kernel: [22422.918255] crystalhd 0000:02:00.0: Link invalid state notify mode 7
Dec 29 04:03:11 vdr1 kernel: [22423.036070] crystalhd 0000:02:00.0: Handle is already closed
Dec 29 04:03:11 vdr1 kernel: [22423.036099] crystalhd 0000:02:00.0: Closing user[2] handle with mode ffffffff
Dec 29 04:03:11 vdr1 kernel: [22423.037706] crystalhd 0000:02:00.0: Opening new user[2] handle
Dec 29 04:03:11 vdr1 kernel: [22423.141613] crystalhd 0000:02:00.0: Link invalid state notify mode 7
Dec 29 04:03:11 vdr1 kernel: [22423.256788] crystalhd 0000:02:00.0: Handle is already closed
Dec 29 04:03:11 vdr1 kernel: [22423.256813] crystalhd 0000:02:00.0: Closing user[2] handle with mode ffffffff

# lsof |grep crystal
pulseaudi  5049          schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
alsa-sour  5049  5136    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
alsa-sour  5049  5137    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
alsa-sink  5049  5138    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
alsa-sour  5049  5139    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
module-tu  5049  5153    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
module-tu  5049  5155    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
module-tu  5049  5157    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
module-tu  5049  5159    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
mplayer   18436          schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
mplayer   18436          schorpp    6u      CHR      251,0        0t0       1891 /dev/crystalhd
mplayer   18436 18437    schorpp  mem       REG        8,2     129936    3080231 /usr/lib/i386-linux-gnu/libcrystalhd.so.3.6
mplayer   18436 18437    schorpp    6u      CHR      251,0        0t0       1891 /dev/crystalhd

02:00.0 Multimedia controller [0480]: Broadcom Corporation BCM70012 Video Decoder [Crystal HD] [14e4:1612] (rev 01)
	Subsystem: Broadcom Corporation Device [14e4:2612]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at df7f0000 (64-bit, non-prefetchable) [size=64K]
	Region 2: Memory at df000000 (64-bit, non-prefetchable) [size=4M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [60] Vendor Specific Information: Len=6c <?>
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 41c1
	Capabilities: [cc] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: crystalhd

bt #2: Trogger'd by nautilus calling mplayer for file properties info window:

Dec 29 04:26:13 vdr1 kernel: [23805.358203] Unloading crystalhd 3.10.0
Dec 29 04:26:13 vdr1 kernel: [23805.358524] crystalhd 0000:02:00.0: released api device - 251
# rmmod -f crystalhd &
Dec 29 04:28:18 vdr1 kernel: [23930.046660] Loading crystalhd v3.10.0
Dec 29 04:28:18 vdr1 kernel: [23930.046733] crystalhd 0000:02:00.0: Starting Device:0x1612
Dec 29 04:28:18 vdr1 kernel: [23930.056036] crystalhd 0000:02:00.0: irq 42 for MSI/MSI-X
Dec 29 04:28:18 vdr1 kernel: [23930.311168] crystalhd 0000:02:00.0: enabling bus mastering
...
Dec 29 04:29:21 vdr1 kernel: [23993.017376] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 04:29:23 vdr1 kernel: [23995.223881] start_capture: pause_th:12, resume_th:5
Dec 29 04:29:26 vdr1 kernel: [23998.226044] BUG: scheduling while atomic: mplayer/19442/0x00000002
Dec 29 04:29:26 vdr1 kernel: [23998.226053] INFO: lockdep is turned off.
Dec 29 04:29:26 vdr1 kernel: [23998.226058] Modules linked in: crystalhd(O) md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon isl6405 uvcvideo dvb_pll tda10086 saa7134_dvb videobuf_dvb tuner tda10021 cryptomgr aead arc4 crypto_blkcipher crypto_algapi snd_usb_audio stv0297 snd_usbmidi_lib snd_intel8x0 snd_ac97_codec ac97_bus rt73usb rt2x00usb rt2x00lib snd_hwdep snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi snd_pcm_oss snd_mixer_oss joydev snd_pcm snd_rawmidi saa7134 hid_sunplus hid_generic snd_seq_midi_event videobuf2_vmalloc videobuf2_memops budget_av videobuf2_core cfg80211 usbhid hid snd_page_alloc snd_seq dvb_ttpci saa7146_vv budget_core crc_itu_t ttpci_eeprom c
rypto saa7146 dvb_core tve
Dec 29 04:29:26 vdr1 kernel: eprom videobuf_dma_sg videobuf_core v4l2_common snd_seq_device snd_timer videodev snd rc_core shpchp i2c_i801 pci_hotplug serio_raw pcspkr rng_core soundcore 8250_pnp 8250 serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod cdrom crc_t10dif ata_piix ahci libahci libata scsi_mod uhci_hcd ehci_hcd usbcore [last unloaded: crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226403] irq event stamp: 0
Dec 29 04:29:26 vdr1 kernel: [23998.226408] hardirqs last  enabled at (0): [<  (null)>]   (null)
Dec 29 04:29:26 vdr1 kernel: [23998.226417] hardirqs last disabled at (0): [<c102b14e>] copy_process+0x51e/0x11d0
Dec 29 04:29:26 vdr1 kernel: [23998.226433] softirqs last  enabled at (0): [<c102b14e>] copy_process+0x51e/0x11d0
Dec 29 04:29:26 vdr1 kernel: [23998.226443] softirqs last disabled at (0): [<  (null)>]   (null)
Dec 29 04:29:26 vdr1 kernel: [23998.226455] Pid: 19442, comm: mplayer Tainted: G  R   D    O 3.6.10-PM #8
Dec 29 04:29:26 vdr1 kernel: [23998.226460] Call Trace:
Dec 29 04:29:26 vdr1 kernel: [23998.226476]  [<c1365680>] __schedule_bug+0x60/0x70
Dec 29 04:29:26 vdr1 kernel: [23998.226487]  [<c136b69c>] __schedule+0x5c/0x610
Dec 29 04:29:26 vdr1 kernel: [23998.226500]  [<c103a1b4>] ? lock_timer_base.isra.32+0x24/0x50
Dec 29 04:29:26 vdr1 kernel: [23998.226511]  [<c136c9d4>] ? _raw_spin_lock_irqsave+0x74/0x90
Dec 29 04:29:26 vdr1 kernel: [23998.226521]  [<c1369b69>] ? schedule_timeout+0x119/0x150
Dec 29 04:29:26 vdr1 kernel: [23998.226531]  [<c136bd95>] schedule+0x55/0x60
Dec 29 04:29:26 vdr1 kernel: [23998.226541]  [<c1369b6e>] schedule_timeout+0x11e/0x150
Dec 29 04:29:26 vdr1 kernel: [23998.226551]  [<c103a1b4>] ? lock_timer_base.isra.32+0x24/0x50
Dec 29 04:29:26 vdr1 kernel: [23998.226561]  [<c103a0f0>] ? run_timer_softirq+0x270/0x270
Dec 29 04:29:26 vdr1 kernel: [23998.226573]  [<c1369bf4>] schedule_timeout_interruptible+0x14/0x20
Dec 29 04:29:26 vdr1 kernel: [23998.226583]  [<c103a690>] msleep_interruptible+0x30/0x50
Dec 29 04:29:26 vdr1 kernel: [23998.226607]  [<f8f301c5>] crystalhd_link_stop_tx_dma_engine+0x125/0x1e0 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226617]  [<c136c9d4>] ? _raw_spin_lock_irqsave+0x74/0x90
Dec 29 04:29:26 vdr1 kernel: [23998.226636]  [<f8f2e727>] crystalhd_hw_cancel_tx+0x57/0x80 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226653]  [<f8f2c47c>] bc_cproc_proc_input+0x3ac/0x420 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226664]  [<c10c473d>] ? might_fault+0x2d/0x80
Dec 29 04:29:26 vdr1 kernel: [23998.226675]  [<c1052e00>] ? try_to_wake_up+0x150/0x150
Dec 29 04:29:26 vdr1 kernel: [23998.226692]  [<f8f29b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226708]  [<f8f2c0d0>] ? bc_cproc_codein_sleep+0xf0/0xf0 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226723]  [<f8f299f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 04:29:26 vdr1 kernel: [23998.226734]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 04:29:26 vdr1 kernel: [23998.226746]  [<c104e73e>] ? hrtimer_nanosleep+0x6e/0xf0
Dec 29 04:29:26 vdr1 kernel: [23998.226757]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 04:29:26 vdr1 kernel: [23998.226767]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 04:29:26 vdr1 kernel: [23998.226776]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 04:29:26 vdr1 kernel: [23998.226786]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 04:29:26 vdr1 kernel: [23998.226797]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 04:29:26 vdr1 kernel: [23998.338894] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
Dec 29 04:29:26 vdr1 kernel: [23998.661131] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 04:29:29 vdr1 kernel: [24000.872835] start_capture: pause_th:12, resume_th:5
Dec 29 04:29:29 vdr1 kernel: [24001.207584] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200

modprobe crystalhd &
tail /var/log/syslog
lsof |grep crystal
modprobe -r crystalhd &
modprobe crystalhd &
(nautilus file info properties window tab "Audio/Video")

Dec 29 05:16:48 vdr1 kernel: [26840.586877] crystalhd 0000:02:00.0: Starting Device:0x1612
Dec 29 05:16:48 vdr1 kernel: [26840.589676] crystalhd 0000:02:00.0: irq 42 for MSI/MSI-X
Dec 29 05:16:49 vdr1 kernel: [26840.844145] crystalhd 0000:02:00.0: enabling bus mastering
Dec 29 05:17:01 vdr1 /USR/SBIN/CRON[20627]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Dec 29 05:17:03 vdr1 kernel: [26854.918037] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 05:17:05 vdr1 kernel: [26857.165594] start_capture: pause_th:12, resume_th:5
Dec 29 05:17:05 vdr1 kernel: [26857.375727] crystalhd 0000:02:00.0: [FMT CH] PIB:0 0 420 2 500 2d0 500 0 9 0
Dec 29 05:17:05 vdr1 kernel: [26857.484739] crystalhd 0000:02:00.0: MISSING 3 PICTURES
Dec 29 05:17:06 vdr1 kernel: [26857.960339] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
Dec 29 05:17:06 vdr1 kernel: [26858.283365] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 05:17:08 vdr1 kernel: [26860.485621] start_capture: pause_th:12, resume_th:5
Dec 29 05:17:09 vdr1 kernel: [26860.830317] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200


--------------030909020801050107060308
Content-Type: text/x-diff;
 name="crystalhd.c.54~53.bpo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd.c.54~53.bpo.patch"

--- ffmpeg-dmo-0.10.3/libavcodec/crystalhd.c.53	2012-12-27 15:56:05.000000000 +0100
+++ ffmpeg-dmo-0.10.3/libavcodec/crystalhd.c.54-bpo	2012-12-27 16:46:52.000000000 +0100
@@ -43,7 +43,7 @@
  * on testing, the code will wait until 3 pictures are ready before starting
  * to copy out - and this has the effect of extending the pipeline.
  *
- * Finally, while it is tempting to say that once the decoder starts outputing
+ * Finally, while it is tempting to say that once the decoder starts outputting
  * frames, the software should never fail to return a frame from a decode(),
  * this is a hard assertion to make, because the stream may switch between
  * differently encoded content (number of b-frames, interlacing, etc) which
@@ -85,6 +85,7 @@
 
 #include "avcodec.h"
 #include "h264.h"
+#include "internal.h"
 #include "libavutil/imgutils.h"
 #include "libavutil/intreadwrite.h"
 #include "libavutil/opt.h"
@@ -153,7 +154,7 @@
     { "crystalhd_downscale_width",
       "Turn on downscaling to the specified width",
       offsetof(CHDContext, sWidth),
-      AV_OPT_TYPE_INT, 0, 0, UINT32_MAX,
+      AV_OPT_TYPE_INT, {.i64 = 0}, 0, UINT32_MAX,
       AV_OPT_FLAG_VIDEO_PARAM | AV_OPT_FLAG_DECODING_PARAM, },
     { NULL, },
 };
@@ -535,7 +536,7 @@
 
 static inline CopyRet copy_frame(AVCodecContext *avctx,
                                  BC_DTS_PROC_OUT *output,
-                                 void *data, int *data_size)
+                                 void *data, int *got_frame)
 {
     BC_STATUS ret;
     BC_DTS_STATUS decoder_status = { 0, };
@@ -656,8 +657,7 @@
             pStride = 720;
         else if (width <= 1280)
             pStride = 1280;
-        else if (width <= 1080)
-            pStride = 1080;
+        else pStride = 1920;
         sStride = av_image_get_linesize(avctx->pix_fmt, pStride, 0);
     } else {
         sStride = bwidth;
@@ -696,7 +696,7 @@
     priv->pic.pkt_pts = pkt_pts;
 
     if (!priv->need_second_field) {
-        *data_size       = sizeof(AVFrame);
+        *got_frame       = 1;
         *(AVFrame *)data = priv->pic;
     }
 
@@ -714,17 +714,26 @@
     }
 
     /*
-     * Testing has shown that in all cases where we don't want to return the
-     * full frame immediately, VDEC_FLAG_UNKNOWN_SRC is set.
+     * The logic here is purely based on empirical testing with samples.
+     * If we need a second field, it could come from a second input packet,
+     * or it could come from the same field-pair input packet at the current
+     * field. In the first case, we should return and wait for the next time
+     * round to get the second field, while in the second case, we should
+     * ask the decoder for it immediately.
+     *
+     * Testing has shown that we are dealing with the fieldpair -> two fields
+     * case if the VDEC_FLAG_UNKNOWN_SRC is not set or if the input picture
+     * type was PICT_FRAME (in this second case, the flag might still be set)
      */
     return priv->need_second_field &&
-           !(output->PicInfo.flags & VDEC_FLAG_UNKNOWN_SRC) ?
+           (!(output->PicInfo.flags & VDEC_FLAG_UNKNOWN_SRC) ||
+            pic_type == PICT_FRAME) ?
            RET_COPY_NEXT_FIELD : RET_OK;
 }
 
 
 static inline CopyRet receive_frame(AVCodecContext *avctx,
-                                    void *data, int *data_size)
+                                    void *data, int *got_frame)
 {
     BC_STATUS ret;
     BC_DTS_PROC_OUT output = {
@@ -734,7 +743,7 @@
     CHDContext *priv = avctx->priv_data;
     HANDLE dev       = priv->dev;
 
-    *data_size = 0;
+    *got_frame = 0;
 
     // Request decoded data from the driver
     ret = DtsProcOutputNoCopy(dev, OUTPUT_PROC_TIMEOUT, &output);
@@ -742,6 +751,56 @@
         av_log(avctx, AV_LOG_VERBOSE, "CrystalHD: Initial format change\n");
         avctx->width  = output.PicInfo.width;
         avctx->height = output.PicInfo.height;
+        switch ( output.PicInfo.aspect_ratio ) {
+        case vdecAspectRatioSquare:
+            avctx->sample_aspect_ratio = (AVRational) {  1,  1};
+            break;
+        case vdecAspectRatio12_11:
+            avctx->sample_aspect_ratio = (AVRational) { 12, 11};
+            break;
+        case vdecAspectRatio10_11:
+            avctx->sample_aspect_ratio = (AVRational) { 10, 11};
+            break;
+        case vdecAspectRatio16_11:
+            avctx->sample_aspect_ratio = (AVRational) { 16, 11};
+            break;
+        case vdecAspectRatio40_33:
+            avctx->sample_aspect_ratio = (AVRational) { 40, 33};
+            break;
+        case vdecAspectRatio24_11:
+            avctx->sample_aspect_ratio = (AVRational) { 24, 11};
+            break;
+        case vdecAspectRatio20_11:
+            avctx->sample_aspect_ratio = (AVRational) { 20, 11};
+            break;
+        case vdecAspectRatio32_11:
+            avctx->sample_aspect_ratio = (AVRational) { 32, 11};
+            break;
+        case vdecAspectRatio80_33:
+            avctx->sample_aspect_ratio = (AVRational) { 80, 33};
+            break;
+        case vdecAspectRatio18_11:
+            avctx->sample_aspect_ratio = (AVRational) { 18, 11};
+            break;
+        case vdecAspectRatio15_11:
+            avctx->sample_aspect_ratio = (AVRational) { 15, 11};
+            break;
+        case vdecAspectRatio64_33:
+            avctx->sample_aspect_ratio = (AVRational) { 64, 33};
+            break;
+        case vdecAspectRatio160_99:
+            avctx->sample_aspect_ratio = (AVRational) {160, 99};
+            break;
+        case vdecAspectRatio4_3:
+            avctx->sample_aspect_ratio = (AVRational) {  4,  3};
+            break;
+        case vdecAspectRatio16_9:
+            avctx->sample_aspect_ratio = (AVRational) { 16,  9};
+            break;
+        case vdecAspectRatio221_1:
+            avctx->sample_aspect_ratio = (AVRational) {221,  1};
+            break;
+        }
         return RET_COPY_AGAIN;
     } else if (ret == BC_STS_SUCCESS) {
         int copy_ret = -1;
@@ -781,8 +840,8 @@
                priv->last_picture = output.PicInfo.picture_number - 1;
             }
 
-            copy_ret = copy_frame(avctx, &output, data, data_size);
-            if (*data_size > 0) {
+            copy_ret = copy_frame(avctx, &output, data, got_frame);
+            if (*got_frame > 0) {
                 avctx->has_b_frames--;
                 priv->last_picture++;
                 av_log(avctx, AV_LOG_VERBOSE, "CrystalHD: Pipeline length: %u\n",
@@ -809,7 +868,7 @@
 }
 
 
-static int decode(AVCodecContext *avctx, void *data, int *data_size, AVPacket *avpkt)
+static int decode(AVCodecContext *avctx, void *data, int *got_frame, AVPacket *avpkt)
 {
     BC_STATUS ret;
     BC_DTS_STATUS decoder_status = { 0, };
@@ -869,7 +928,7 @@
                     av_log(avctx, AV_LOG_WARNING,
                            "CrystalHD: Failed to parse h.264 packet "
                            "completely. Interlaced frames may be "
-                           "incorrectly detected\n.");
+                           "incorrectly detected.\n");
                 } else {
                     av_log(avctx, AV_LOG_VERBOSE,
                            "CrystalHD: parser picture type %d\n",
@@ -967,8 +1026,8 @@
     }
 
     do {
-        rec_ret = receive_frame(avctx, data, data_size);
-        if (rec_ret == RET_OK && *data_size == 0) {
+        rec_ret = receive_frame(avctx, data, got_frame);
+        if (rec_ret == RET_OK && *got_frame == 0) {
             /*
              * This case is for when the encoded fields are stored
              * separately and we get a separate avpkt for each one. To keep
@@ -993,8 +1052,8 @@
                 ret = DtsGetDriverStatus(dev, &decoder_status);
                 if (ret == BC_STS_SUCCESS &&
                     decoder_status.ReadyListCount > 0) {
-                    rec_ret = receive_frame(avctx, data, data_size);
-                    if ((rec_ret == RET_OK && *data_size > 0) ||
+                    rec_ret = receive_frame(avctx, data, got_frame);
+                    if ((rec_ret == RET_OK && *got_frame > 0) ||
                         rec_ret == RET_ERROR)
                         break;
                 }

--------------030909020801050107060308--
