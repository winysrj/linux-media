Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thewatchman@gmail.com>) id 1LHo0U-000272-DU
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 00:28:15 +0100
Received: by an-out-0708.google.com with SMTP id b38so1515632ana.41
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 15:28:10 -0800 (PST)
Message-ID: <c715948d0812301528h5a4f2a57xa973099ffb33730@mail.gmail.com>
Date: Tue, 30 Dec 2008 17:28:09 -0600
From: Greg <thewatchman@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] pcHDTV-5500 and FC10 (resend, was too big)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1474143740=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1474143740==
Content-Type: multipart/alternative;
	boundary="----=_Part_118264_9614636.1230679689918"

------=_Part_118264_9614636.1230679689918
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have been trying to get my PCHD-5500 card to work  with FC10. So far I am
able to get  the analog tuner portion of the card to work but not the
digital. Devinheitmueller was pointing me in the direction to look. I am
getting a crash in one of the modules, which looks like it is coming from
the line:

div = ((frequency + t_params->iffreq) * 62500 + offset + tun->stepsize/2) /
tun->stepsize;

The crash is apparently being cased by a zero stepsize. This crash occured
when I was scanning for channels either from mythtvset or Kaffeine, or a
command line program that came with the card. I also have  Hauppague 250
card in the system which seems to work.

If I select the digital tuner from mythtv the application just hangs and I
get a blank screen.

I tried hacking the tuner-types.mod.c file and adding the following lines to
it that I coppied from one of the other cards (though I suspect these values
are not right for this card)

    [TUNER_LG_NTSC_TAPE] = { /* LGINNOTEK NTSC */
                .name   = "LG NTSC (TAPE series)",
                .params = tuner_fm1236_mk3_params,
                .count  = ARRAY_SIZE(tuner_fm1236_mk3_params),
                //adding these lines copied from above so that we have
no-zero values
                .min = 16 * 53.00,
                .max = 16 * 803.00,
                .stepsize = 62500,

This at least allowed the applications to do the scan without  a crash, but
the net result was that no channels were returned as valid by the
applications, though it did indicate a lock for some of the channels. I am
guessin other informatino is still missing somewhere. Seems like a driver or
something is not being loaded, or the wrong driver is being loaded. Analog
instead of digital or whatever, I don't know.

Any help resolving this would be appreciated. Here is the output from dmesg.
Search for divide error near the bottom. I added the print to show that the
step size is zero.

Greg
_________________________________________________________

.
.
.

hiddev96hidraw0: USB HID v1.10 Device [American Power Conversion Smart-UPS
1500 FW:601.3.D USB FW:1.5] on usb-0000:00:1a.0-2
input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input4
input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Receiver] on
usb-0000:00:1d.1-1
Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.1/input/input5
input,hiddev97,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on
usb-0000:00:1d.1-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 4:900:252
uhci_hcd 0000:00:1d.0: hash matches
Freeing unused kernel memory: 1292k freed
Write protecting the kernel read-only data: 4748k
pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pata_jmicron 0000:03:00.1: setting latency timer to 64
scsi6 : pata_jmicron
scsi7 : pata_jmicron
ata7: PATA max UDMA/100 cmd 0x8000 ctl 0x8400 bmdma 0x9000 irq 16
ata8: PATA max UDMA/100 cmd 0x8800 ctl 0x8c00 bmdma 0x9008 irq 16
ata7.00: HPA detected: current 781420655, native 781422768
ata7.00: ATA-7: ST3400832A, 3.03, max UDMA/100
ata7.00: 781420655 sectors, multi 16: LBA48
ata7.01: ATA-6: ST3160023A, 3.06, max UDMA/100
ata7.01: 312581808 sectors, multi 16: LBA48
ata7.00: configured for UDMA/100
ata7.01: configured for UDMA/100
scsi 6:0:0:0: Direct-Access     ATA      ST3400832A       3.03 PQ: 0 ANSI: 5
sd 6:0:0:0: [sda] 781420655 512-byte hardware sectors (400087 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
sd 6:0:0:0: [sda] 781420655 512-byte hardware sectors (400087 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2
sd 6:0:0:0: [sda] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg1 type 0
scsi 6:0:1:0: Direct-Access     ATA      ST3160023A       3.06 PQ: 0 ANSI: 5
sd 6:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 6:0:1:0: [sdb] Write Protect is off
sd 6:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
sd 6:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 6:0:1:0: [sdb] Write Protect is off
sd 6:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdb: sdb1
sd 6:0:1:0: [sdb] Attached SCSI disk
sd 6:0:1:0: Attached scsi generic sg2 type 0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1230678750.789:2): selinux=0 auid=4294967295 ses=4294967295
udevd version 127 started
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
input: PC Speaker as /devices/platform/pcspkr/input/input6
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.80  Wed Oct  1 14:43:46
PDT 2008
gameport: EMU10K1 is pci0000:05:02.1/gameport0, io 0xb400, speed 960kHz
sky2 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: v1.22 addr 0xe9000000 irq 16 Yukon-2 EC Ultra rev 2
sky2 eth0: addr 00:16:e6:d3:c5:1f
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Linux video capture interface: v2.00
ivtv: Start initialization, version 1.4.0
ivtv0: Initializing card 0
ivtv0: Autodetected Hauppauge card (cx23416 based)
ivtv 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
tveeprom 1-0050: Hauppauge model 32032, rev B310, serial# 6985430
tveeprom 1-0050: tuner model is Philips FI1236 MK2 (idx 10, type 2)
tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 1-0050: audio processor is MSP4448 (idx 27)
tveeprom 1-0050: decoder processor is SAA7115 (idx 19)
tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
ivtv0: Autodetected Hauppauge WinTV PVR-250
ppdev: user-space parallel port driver
saa7115 1-0021: saa7115 found (1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
msp3400 1-0040: MSP4448G-A2 found @ 0x80 (ivtv i2c driver #0)
msp3400 1-0040: msp3400 supports radio, mode is autodetect and autoselect
cx2388x alsa driver version 0.0.6 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
compatibles))
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Initialized card: Hauppauge WinTV PVR-250
ivtv: End initialization
EMU10K1_Audigy 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ALSA sound/core/control.c:232: Control name 'Sigmatel Surround Phase
Inversion Playback Switch' truncated to 'Sigmatel Surround Phase Inversion
Playback '
cx88_audio 0000:05:01.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
cx88[0]: subsystem: 7063:5500, board: pcHDTV HD5500 HDTV
[card=47,autodetected], frontend(s): 1
cx88[0]: TV tuner type 47, Radio tuner type -1
tuner' 2-0043: chip found @ 0x86 (cx88[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 47 (LG NTSC (TAPE series))
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx8800 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
cx88[0]/0: found at 0000:05:01.0, rev: 5, irq: 19, latency: 32, mmio:
0xea000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:05:01.2: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
cx88[0]/2: found at 0000:05:01.2, rev: 5, irq: 19, latency: 32, mmio:
0xec000000
cx8802_probe() allocating 1 frontend(s)
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 7063:5500, board: pcHDTV HD5500 HDTV [card=47]
cx88[0]/2: cx2388x based DVB/ATSC card
device-mapper: multipath: version 1.0.5 loaded
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 64 (LG NTSC (TAPE series))
tda9887 2-0043: attaching existing instance
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM
Frontend)...
EXT3 FS on dm-0, internal journal
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug
enabled
SGI XFS Quota Management subsystem
Filesystem "dm-1": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 3047416k swap on /dev/mapper/charity_lvm-swap_space.  Priority:-1
extents:1 across:3047416k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-0f-02
firmware: requesting intel-ucode/06-0f-02
microcode: CPU0 updated from revision 0x51 to 0x5a, date = 09262007
microcode: CPU1 updated from revision 0x51 to 0x5a, date = 09262007
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
firmware: requesting v4l-cx2341x-enc.fw
ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
ivtv0: Encoder revision: 0x02060039
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
fuse init (API version 7.9)
cdrom: sr0: mrw address space DMA selected
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
stepsize=0
*divide error: 0000 [1] SMP *
CPU 0
Modules linked in: nls_utf8 fuse sco bridge stp bnep l2cap bluetooth sunrpc
nf_conntrack_netbios_ns nf_conntrack_ftp ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table xfs
lgdt330x dm_multipath cx88_dvb cx88_vp3054_i2c uinput tda9887 tda8290
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul
tuner_simple tuner_types tuner cx8800 cx8802 cx88_alsa msp3400 cx88xx
snd_emu10k1 snd_rawmidi ir_common snd_ac97_codec ac97_bus saa7115
snd_seq_dummy videobuf_dvb snd_seq_oss dvb_core snd_seq_midi_event snd_seq
ivtv i2c_algo_bit cx2341x v4l2_common videodev ppdev snd_pcm_oss
snd_mixer_oss parport_pc parport snd_pcm v4l1_compat v4l2_compat_ioctl32
btcx_risc videobuf_dma_sg snd_seq_device videobuf_core snd_timer
snd_page_alloc snd_util_mem snd_hwdep sky2 emu10k1_gp snd soundcore tveeprom
nvidia(P) gameport joydev i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support
pcspkr floppy shpchp ata_generic pata_acpi pata_jmicron [last unloaded:
microcode]
Pid: 3561, comm: kdvb-ad-0-fe-0 Tainted: P          2.6.27.9-159.fc10.x86_64
#1
RIP: 0010:[<ffffffffa09ba380>]  [<ffffffffa09ba380>]
simple_dvb_calc_regs+0xb1/0x241 [tuner_simple]
RSP: 0018:ffff88005e431d30  EFLAGS: 00010246
RAX: 000000000365c040 RBX: ffff88005e431db0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88005e431bf0 RDI: 0000000000000246
RBP: ffff88005e431da0 R08: ffff88005e431ba0 R09: 0000000000000000
R10: 0000001129de48b7 R11: 0000000100000000 R12: ffff88007c0c00c0
R13: ffff88007c0c00c0 R14: ffff880077d24808 R15: ffff880077d24010
FS:  0000000000000000(0000) GS:ffffffff8155e100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fb806a6cdf0 CR3: 000000005e4a4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-ad-0-fe-0 (pid: 3561, threadinfo ffff88005e430000, task
ffff88006b8f8000)
Stack:  ffff88005e431d40 00000000ffffffa1 ffff880078c2e860 0000000000000001
 ffff88005e431da0 ffff88005e431da0 ffffffffa09b4fb0 ffffffffa003d48c
 8e01880000000390 ffff880077d24010 ffff88007c0c00c0 0000000000000000
Call Trace:
 [<ffffffffa003d48c>] ? i2c_transfer+0x80/0x8b [i2c_core]
 [<ffffffffa09ba728>] simple_dvb_set_params+0x3e/0x9b [tuner_simple]
 [<ffffffffa0a0135a>] lgdt330x_set_parameters+0x188/0x1b9 [lgdt330x]
 [<ffffffffa08df116>] dvb_frontend_swzigzag_autotune+0x18e/0x1b5 [dvb_core]
 [<ffffffffa08dff6a>] dvb_frontend_swzigzag+0x1bc/0x21e [dvb_core]
 [<ffffffffa08e04f4>] dvb_frontend_thread+0x528/0x62b [dvb_core]
 [<ffffffff810551e1>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa08dffcc>] ? dvb_frontend_thread+0x0/0x62b [dvb_core]
 [<ffffffff81054e9b>] kthread+0x49/0x76
 [<ffffffff810116e9>] child_rip+0xa/0x11
 [<ffffffff81010a07>] ? restore_args+0x0/0x30
 [<ffffffff81054e52>] ? kthread+0x0/0x76
 [<ffffffff810116df>] ? child_rip+0x0/0x11


Code: 8b 05 a5 4d 00 00 48 8b 55 c0 0f b7 40 0a 44 8b 4a 1c 31 d2 03 45 d0
44 89 c9 d1 e9 03 0d 99 4d 00 00 69 c0 24 f4 00 00 8d 04 01 <41> f7 f1 8a 55
d6 88 53 04 41 89 c4 c1 e8 08 88 43 01 8a 45 d7
RIP  [<ffffffffa09ba380>] simple_dvb_calc_regs+0xb1/0x241 [tuner_simple]
 RSP <ffff88005e431d30>
---[ end trace 5d1bf039ccd63f37 ]---

------=_Part_118264_9614636.1230679689918
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div class=3D"gmail_quote">I have been trying to get my PCHD-5500 card to w=
ork&nbsp; with FC10. So far I am able to get&nbsp; the analog tuner portion=
 of the card to work but not the digital. Devinheitmueller was pointing me =
in the direction to look. I am getting a crash in one of the modules, which=
 looks like it is coming from the line:<br>


<br><div style=3D"margin-left: 40px;">div =3D ((frequency + t_params-&gt;if=
freq) * 62500 + offset + tun-&gt;stepsize/2) / tun-&gt;stepsize;<br></div><=
br>The crash is apparently being cased by a zero stepsize. This crash occur=
ed when I was scanning for channels either from mythtvset or Kaffeine, or a=
 command line program that came with the card. I also have&nbsp; Hauppague =
250 card in the system which seems to work.&nbsp; <br>


<br>If I select the digital tuner from mythtv the application just hangs an=
d I get a blank screen.<br><br>I tried hacking the tuner-types.mod.c file a=
nd adding the following lines to it that I coppied from one of the other ca=
rds (though I suspect these values are not right for this card)<br>


<br>&nbsp;&nbsp;&nbsp; [TUNER_LG_NTSC_TAPE] =3D { /* LGINNOTEK NTSC */<br>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; .name&nbsp;&nbsp; =3D &quot;LG NTSC (TAPE series)&quot;,<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; .params =3D tuner_fm1236_mk3_params,<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .co=
unt&nbsp; =3D ARRAY_SIZE(tuner_fm1236_mk3_params),<br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; //adding these lines copied from above so that we have no-z=
ero values<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .min =3D 16 * 53.00,<br>&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .max =
=3D 16 * 803.00,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .stepsize =3D 62500,<br><br>
This at least allowed the applications to do the scan without&nbsp; a crash=
, but the net result was that no channels were returned as valid by the app=
lications, though it did indicate a lock for some of the channels. I am gue=
ssin other informatino is still missing somewhere. Seems like a driver or s=
omething is not being loaded, or the wrong driver is being loaded. Analog i=
nstead of digital or whatever, I don&#39;t know.<br>


<br>Any help resolving this would be appreciated. Here is the output from d=
mesg. Search for divide error near the bottom. I added the print to show th=
at the step size is zero.<br><br>Greg<br>__________________________________=
_______________________<br>

<br>.<br>.<br>.<br><br>hiddev96hidraw0: USB HID v1.10 Device [American Powe=
r Conversion Smart-UPS 1500 FW:601.3.D USB FW:1.5] on usb-0000:00:1a.0-2<br=
>
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6=
-1:1.0/input/input4<br>input,hidraw1: USB HID v1.10 Keyboard [Logitech USB =
Receiver] on usb-0000:00:1d.1-1<br>Fixing up Logitech keyboard report descr=
iptor<br>

input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6=
-1:1.1/input/input5<br>input,hiddev97,hidraw2: USB HID v1.10 Mouse [Logitec=
h USB Receiver] on usb-0000:00:1d.1-1<br>usbcore: registered new interface =
driver usbhid<br>

usbhid: v2.6:USB HID core driver<br>nf_conntrack version 0.5.0 (16384 bucke=
ts, 65536 max)<br>CONFIG_NF_CT_ACCT is deprecated and will be removed soon.=
 Plase use<br>nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack=
 module option or<br>

sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.<br>ip_tables: (C) =
2000-2006 Netfilter Core Team<br>TCP cubic registered<br>Initializing XFRM =
netlink socket<br>NET: Registered protocol family 17<br>registered taskstat=
s version 1<br>

&nbsp; Magic number: 4:900:252<br>uhci_hcd 0000:00:1d.0: hash matches<br>Fr=
eeing unused kernel memory: 1292k freed<br>Write protecting the kernel read=
-only data: 4748k<br>pata_jmicron 0000:03:00.1: enabling device (0000 -&gt;=
 0001)<br>

pata_jmicron 0000:03:00.1: PCI INT B -&gt; GSI 16 (level, low) -&gt; IRQ 16=
<br>pata_jmicron 0000:03:00.1: setting latency timer to 64<br>scsi6 : pata_=
jmicron<br>scsi7 : pata_jmicron<br>ata7: PATA max UDMA/100 cmd 0x8000 ctl 0=
x8400 bmdma 0x9000 irq 16<br>

ata8: PATA max UDMA/100 cmd 0x8800 ctl 0x8c00 bmdma 0x9008 irq 16<br>ata7.0=
0: HPA detected: current 781420655, native 781422768<br>ata7.00: ATA-7: ST3=
400832A, 3.03, max UDMA/100<br>ata7.00: 781420655 sectors, multi 16: LBA48 =
<br>

ata7.01: ATA-6: ST3160023A, 3.06, max UDMA/100<br>ata7.01: 312581808 sector=
s, multi 16: LBA48 <br>ata7.00: configured for UDMA/100<br>ata7.01: configu=
red for UDMA/100<br>scsi 6:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; ATA=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ST3400832A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 3.03 PQ: 0 ANSI: 5<br>

sd 6:0:0:0: [sda] 781420655 512-byte hardware sectors (400087 MB)<br>sd 6:0=
:0:0: [sda] Write Protect is off<br>sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 =
00<br>sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn&#3=
9;t support DPO or FUA<br>

sd 6:0:0:0: [sda] 781420655 512-byte hardware sectors (400087 MB)<br>sd 6:0=
:0:0: [sda] Write Protect is off<br>sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 =
00<br>sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn&#3=
9;t support DPO or FUA<br>

&nbsp;sda: sda1 sda2<br>sd 6:0:0:0: [sda] Attached SCSI disk<br>sd 6:0:0:0:=
 Attached scsi generic sg1 type 0<br>scsi 6:0:1:0: Direct-Access&nbsp;&nbsp=
;&nbsp;&nbsp; ATA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ST3160023A&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 3.06 PQ: 0 ANSI: 5<br>sd 6:0:1:0: [sdb] 312581808 512-b=
yte hardware sectors (160042 MB)<br>

sd 6:0:1:0: [sdb] Write Protect is off<br>sd 6:0:1:0: [sdb] Mode Sense: 00 =
3a 00 00<br>sd 6:0:1:0: [sdb] Write cache: enabled, read cache: enabled, do=
esn&#39;t support DPO or FUA<br>sd 6:0:1:0: [sdb] 312581808 512-byte hardwa=
re sectors (160042 MB)<br>

sd 6:0:1:0: [sdb] Write Protect is off<br>sd 6:0:1:0: [sdb] Mode Sense: 00 =
3a 00 00<br>sd 6:0:1:0: [sdb] Write cache: enabled, read cache: enabled, do=
esn&#39;t support DPO or FUA<br>&nbsp;sdb: sdb1<br>sd 6:0:1:0: [sdb] Attach=
ed SCSI disk<br>

sd 6:0:1:0: Attached scsi generic sg2 type 0<br>shpchp: Standard Hot Plug P=
CI Controller Driver version: 0.4<br>kjournald starting.&nbsp; Commit inter=
val 5 seconds<br>EXT3-fs: mounted filesystem with ordered data mode.<br>SEL=
inux:&nbsp; Disabled at runtime.<br>

SELinux:&nbsp; Unregistering netfilter hooks<br>type=3D1404 audit(123067875=
0.789:2): selinux=3D0 auid=3D4294967295 ses=3D4294967295<br>udevd version 1=
27 started<br>Floppy drive(s): fd0 is 1.44M<br>FDC 0 is a post-1991 82077<b=
r>input: PC Speaker as /devices/platform/pcspkr/input/input6<br>

iTCO_vendor_support: vendor-support=3D0<br>iTCO_wdt: Intel TCO WatchDog Tim=
er Driver v1.03 (30-Apr-2008)<br>iTCO_wdt: Found a ICH8 or ICH8R TCO device=
 (Version=3D2, TCOBASE=3D0x0460)<br>iTCO_wdt: initialized. heartbeat=3D30 s=
ec (nowayout=3D0)<br>

i801_smbus 0000:00:1f.3: PCI INT C -&gt; GSI 18 (level, low) -&gt; IRQ 18<b=
r>nvidia: module license &#39;NVIDIA&#39; taints kernel.<br>nvidia 0000:01:=
00.0: PCI INT A -&gt; GSI 16 (level, low) -&gt; IRQ 16<br>nvidia 0000:01:00=
.0: setting latency timer to 64<br>

NVRM: loading NVIDIA UNIX x86_64 Kernel Module&nbsp; 177.80&nbsp; Wed Oct&n=
bsp; 1 14:43:46 PDT 2008<br>gameport: EMU10K1 is pci0000:05:02.1/gameport0,=
 io 0xb400, speed 960kHz<br>sky2 0000:04:00.0: PCI INT A -&gt; GSI 16 (leve=
l, low) -&gt; IRQ 16<br>

sky2 0000:04:00.0: setting latency timer to 64<br>sky2 0000:04:00.0: v1.22 =
addr 0xe9000000 irq 16 Yukon-2 EC Ultra rev 2<br>sky2 eth0: addr 00:16:e6:d=
3:c5:1f<br>parport_pc 00:08: reported by Plug and Play ACPI<br>parport0: PC=
-style at 0x378, irq 7 [PCSPP,TRISTATE]<br>

Linux video capture interface: v2.00<br>ivtv: Start initialization, version=
 1.4.0<br>ivtv0: Initializing card 0<br>ivtv0: Autodetected Hauppauge card =
(cx23416 based)<br>ivtv 0000:05:00.0: PCI INT A -&gt; GSI 20 (level, low) -=
&gt; IRQ 20<br>

ivtv0: Unreasonably low latency timer, setting to 64 (was 32)<br>tveeprom 1=
-0050: Hauppauge model 32032, rev B310, serial# 6985430<br>tveeprom 1-0050:=
 tuner model is Philips FI1236 MK2 (idx 10, type 2)<br>tveeprom 1-0050: TV =
standards NTSC(M) (eeprom 0x08)<br>

tveeprom 1-0050: audio processor is MSP4448 (idx 27)<br>tveeprom 1-0050: de=
coder processor is SAA7115 (idx 19)<br>tveeprom 1-0050: has no radio, has I=
R receiver, has no IR transmitter<br>ivtv0: Autodetected Hauppauge WinTV PV=
R-250<br>

ppdev: user-space parallel port driver<br>saa7115 1-0021: saa7115 found (1f=
7115d0e100000) @ 0x42 (ivtv i2c driver #0)<br>msp3400 1-0040: MSP4448G-A2 f=
ound @ 0x80 (ivtv i2c driver #0)<br>msp3400 1-0040: msp3400 supports radio,=
 mode is autodetect and autoselect<br>

cx2388x alsa driver version 0.0.6 loaded<br>cx88/2: cx2388x MPEG-TS Driver =
Manager version 0.0.6 loaded<br>cx88/0: cx2388x v4l2 driver version 0.0.6 l=
oaded<br>tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)<br>tuner-simp=
le 1-0061: creating new instance<br>

tuner-simple 1-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and compati=
bles))<br>ivtv0: Registered device video0 for encoder MPG (4096 kB)<br>ivtv=
0: Registered device video32 for encoder YUV (2048 kB)<br>ivtv0: Registered=
 device vbi0 for encoder VBI (1024 kB)<br>

ivtv0: Registered device video24 for encoder PCM (320 kB)<br>ivtv0: Initial=
ized card: Hauppauge WinTV PVR-250<br>ivtv: End initialization<br>EMU10K1_A=
udigy 0000:05:02.0: PCI INT A -&gt; GSI 18 (level, low) -&gt; IRQ 18<br>

ALSA sound/core/control.c:232: Control name &#39;Sigmatel Surround Phase In=
version Playback Switch&#39; truncated to &#39;Sigmatel Surround Phase Inve=
rsion Playback &#39;<br>cx88_audio 0000:05:01.1: PCI INT A -&gt; GSI 19 (le=
vel, low) -&gt; IRQ 19<br>

cx88[0]: subsystem: 7063:5500, board: pcHDTV HD5500 HDTV [card=3D47,autodet=
ected], frontend(s): 1<br>cx88[0]: TV tuner type 47, Radio tuner type -1<br=
>tuner&#39; 2-0043: chip found @ 0x86 (cx88[0])<br>tda9887 2-0043: creating=
 new instance<br>

tda9887 2-0043: tda988[5/6/7] found<br>tuner&#39; 2-0061: chip found @ 0xc2=
 (cx88[0])<br>tuner-simple 2-0061: creating new instance<br>tuner-simple 2-=
0061: type set to 47 (LG NTSC (TAPE series))<br>cx88[0]/1: CX88x/0: ALSA su=
pport for cx2388x boards<br>

cx8800 0000:05:01.0: PCI INT A -&gt; GSI 19 (level, low) -&gt; IRQ 19<br>cx=
88[0]/0: found at 0000:05:01.0, rev: 5, irq: 19, latency: 32, mmio: 0xea000=
000<br>cx88[0]/0: registered device video1 [v4l2]<br>cx88[0]/0: registered =
device vbi1<br>

cx88[0]/2: cx2388x 8802 Driver Manager<br>cx88-mpeg driver manager 0000:05:=
01.2: PCI INT A -&gt; GSI 19 (level, low) -&gt; IRQ 19<br>cx88[0]/2: found =
at 0000:05:01.2, rev: 5, irq: 19, latency: 32, mmio: 0xec000000<br>cx8802_p=
robe() allocating 1 frontend(s)<br>

cx88/2: cx2388x dvb driver version 0.0.6 loaded<br>cx88/2: registering cx88=
02 driver, type: dvb access: shared<br>cx88[0]/2: subsystem: 7063:5500, boa=
rd: pcHDTV HD5500 HDTV [card=3D47]<br>cx88[0]/2: cx2388x based DVB/ATSC car=
d<br>

device-mapper: multipath: version 1.0.5 loaded<br>tuner-simple 2-0061: atta=
ching existing instance<br>tuner-simple 2-0061: type set to 64 (LG NTSC (TA=
PE series))<br>tda9887 2-0043: attaching existing instance<br>DVB: register=
ing new adapter (cx88[0])<br>

DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Fron=
tend)...<br>EXT3 FS on dm-0, internal journal<br>SGI XFS with ACLs, securit=
y attributes, large block/inode numbers, no debug enabled<br>SGI XFS Quota =
Management subsystem<br>

Filesystem &quot;dm-1&quot;: Disabling barriers, trial barrier write failed=
<br>XFS mounting filesystem dm-1<br>Ending clean XFS mount for filesystem: =
dm-1<br>XFS mounting filesystem sdb1<br>Ending clean XFS mount for filesyst=
em: sdb1<br>

kjournald starting.&nbsp; Commit interval 5 seconds<br>EXT3 FS on sda1, int=
ernal journal<br>EXT3-fs: mounted filesystem with ordered data mode.<br>Add=
ing 3047416k swap on /dev/mapper/charity_lvm-swap_space.&nbsp; Priority:-1 =
extents:1 across:3047416k<br>

IA-32 Microcode Update Driver: v1.14a &lt;<a href=3D"mailto:tigran@aivazian=
.fsnet.co.uk" target=3D"_blank">tigran@aivazian.fsnet.co.uk</a>&gt;<br>firm=
ware: requesting intel-ucode/06-0f-02<br>firmware: requesting intel-ucode/0=
6-0f-02<br>
microcode: CPU0 updated from revision 0x51 to 0x5a, date =3D 09262007 <br>
microcode: CPU1 updated from revision 0x51 to 0x5a, date =3D 09262007 <br>N=
ET: Registered protocol family 10<br>lo: Disabled Privacy Extensions<br>ip6=
_tables: (C) 2000-2006 Netfilter Core Team<br>RPC: Registered udp transport=
 module.<br>

RPC: Registered tcp transport module.<br>firmware: requesting v4l-cx2341x-e=
nc.fw<br>ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)<br>ivtv0:=
 Encoder revision: 0x02060039<br>Bluetooth: Core ver 2.13<br>NET: Registere=
d protocol family 31<br>

Bluetooth: HCI device and connection manager initialized<br>Bluetooth: HCI =
socket layer initialized<br>Bluetooth: L2CAP ver 2.11<br>Bluetooth: L2CAP s=
ocket layer initialized<br>Bluetooth: BNEP (Ethernet Emulation) ver 1.3<br>

Bluetooth: BNEP filters: protocol multicast<br>Bridge firewalling registere=
d<br>pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.<br>Blueto=
oth: SCO (Voice Link) ver 0.6<br>Bluetooth: SCO socket layer initialized<br=
>

sky2 eth0: enabling interface<br>ADDRCONF(NETDEV_UP): eth0: link is not rea=
dy<br>sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx<br>AD=
DRCONF(NETDEV_CHANGE): eth0: link becomes ready<br>eth0: no IPv6 routers pr=
esent<br>

fuse init (API version 7.9)<br>cdrom: sr0: mrw address space DMA selected<b=
r>ISO 9660 Extensions: Microsoft Joliet Level 3<br>ISO 9660 Extensions: RRI=
P_1991A<br>stepsize=3D0<br><b style=3D"background-color: rgb(255, 255, 153)=
;">divide error: 0000 [1] SMP </b><br>

CPU 0 <br>Modules linked in: nls_utf8 fuse sco bridge stp bnep l2cap blueto=
oth sunrpc nf_conntrack_netbios_ns nf_conntrack_ftp ip6t_REJECT nf_conntrac=
k_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_t=
able xfs lgdt330x dm_multipath cx88_dvb cx88_vp3054_i2c uinput tda9887 tda8=
290 snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul tune=
r_simple tuner_types tuner cx8800 cx8802 cx88_alsa msp3400 cx88xx snd_emu10=
k1 snd_rawmidi ir_common snd_ac97_codec ac97_bus saa7115 snd_seq_dummy vide=
obuf_dvb snd_seq_oss dvb_core snd_seq_midi_event snd_seq ivtv i2c_algo_bit =
cx2341x v4l2_common videodev ppdev snd_pcm_oss snd_mixer_oss parport_pc par=
port snd_pcm v4l1_compat v4l2_compat_ioctl32 btcx_risc videobuf_dma_sg snd_=
seq_device videobuf_core snd_timer snd_page_alloc snd_util_mem snd_hwdep sk=
y2 emu10k1_gp snd soundcore tveeprom nvidia(P) gameport joydev i2c_i801 i2c=
_core iTCO_wdt iTCO_vendor_support pcspkr floppy shpchp ata_generic pata_ac=
pi pata_jmicron [last unloaded: microcode]<br>

Pid: 3561, comm: kdvb-ad-0-fe-0 Tainted: P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 2.6.27.9-159.fc10.x86_64 #1<br>RIP: 0010:[&lt;fffffff=
fa09ba380&gt;]&nbsp; [&lt;ffffffffa09ba380&gt;] simple_dvb_calc_regs+0xb1/0=
x241 [tuner_simple]<br>RSP: 0018:ffff88005e431d30&nbsp; EFLAGS: 00010246<br=
>

RAX: 000000000365c040 RBX: ffff88005e431db0 RCX: 0000000000000000<br>RDX: 0=
000000000000000 RSI: ffff88005e431bf0 RDI: 0000000000000246<br>RBP: ffff880=
05e431da0 R08: ffff88005e431ba0 R09: 0000000000000000<br>R10: 0000001129de4=
8b7 R11: 0000000100000000 R12: ffff88007c0c00c0<br>

R13: ffff88007c0c00c0 R14: ffff880077d24808 R15: ffff880077d24010<br>FS:&nb=
sp; 0000000000000000(0000) GS:ffffffff8155e100(0000) knlGS:0000000000000000=
<br>CS:&nbsp; 0010 DS: 0018 ES: 0018 CR0: 000000008005003b<br>CR2: 00007fb8=
06a6cdf0 CR3: 000000005e4a4000 CR4: 00000000000006e0<br>

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000<br>DR3: 0=
000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400<br>Process kdvb=
-ad-0-fe-0 (pid: 3561, threadinfo ffff88005e430000, task ffff88006b8f8000)<=
br>

Stack:&nbsp; ffff88005e431d40 00000000ffffffa1 ffff880078c2e860 00000000000=
00001<br>&nbsp;ffff88005e431da0 ffff88005e431da0 ffffffffa09b4fb0 ffffffffa=
003d48c<br>&nbsp;8e01880000000390 ffff880077d24010 ffff88007c0c00c0 0000000=
000000000<br>

Call Trace:<br>&nbsp;[&lt;ffffffffa003d48c&gt;] ? i2c_transfer+0x80/0x8b [i=
2c_core]<br>&nbsp;[&lt;ffffffffa09ba728&gt;] simple_dvb_set_params+0x3e/0x9=
b [tuner_simple]<br>&nbsp;[&lt;ffffffffa0a0135a&gt;] lgdt330x_set_parameter=
s+0x188/0x1b9 [lgdt330x]<br>

&nbsp;[&lt;ffffffffa08df116&gt;] dvb_frontend_swzigzag_autotune+0x18e/0x1b5=
 [dvb_core]<br>&nbsp;[&lt;ffffffffa08dff6a&gt;] dvb_frontend_swzigzag+0x1bc=
/0x21e [dvb_core]<br>&nbsp;[&lt;ffffffffa08e04f4&gt;] dvb_frontend_thread+0=
x528/0x62b [dvb_core]<br>

&nbsp;[&lt;ffffffff810551e1&gt;] ? autoremove_wake_function+0x0/0x38<br>&nb=
sp;[&lt;ffffffffa08dffcc&gt;] ? dvb_frontend_thread+0x0/0x62b [dvb_core]<br=
>&nbsp;[&lt;ffffffff81054e9b&gt;] kthread+0x49/0x76<br>&nbsp;[&lt;ffffffff8=
10116e9&gt;] child_rip+0xa/0x11<br>

&nbsp;[&lt;ffffffff81010a07&gt;] ? restore_args+0x0/0x30<br>&nbsp;[&lt;ffff=
ffff81054e52&gt;] ? kthread+0x0/0x76<br>&nbsp;[&lt;ffffffff810116df&gt;] ? =
child_rip+0x0/0x11<br><br><br>Code: 8b 05 a5 4d 00 00 48 8b 55 c0 0f b7 40 =
0a 44 8b 4a 1c 31 d2 03 45 d0 44 89 c9 d1 e9 03 0d 99 4d 00 00 69 c0 24 f4 =
00 00 8d 04 01 &lt;41&gt; f7 f1 8a 55 d6 88 53 04 41 89 c4 c1 e8 08 88 43 0=
1 8a 45 d7 <br>

RIP&nbsp; [&lt;ffffffffa09ba380&gt;] simple_dvb_calc_regs+0xb1/0x241 [tuner=
_simple]<br>&nbsp;RSP &lt;ffff88005e431d30&gt;<br>---[ end trace 5d1bf039cc=
d63f37 ]---<br><br><br>
</div><br>

------=_Part_118264_9614636.1230679689918--


--===============1474143740==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1474143740==--
