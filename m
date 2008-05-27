Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from edna.telenet-ops.be ([195.130.132.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bernardenmartine@pandora.be>) id 1K10oi-0003vj-NT
	for linux-dvb@linuxtv.org; Tue, 27 May 2008 17:10:28 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by edna.telenet-ops.be (Postfix) with SMTP id 6A529E40A5
	for <linux-dvb@linuxtv.org>; Tue, 27 May 2008 17:10:17 +0200 (CEST)
Received: from [192.168.1.105] (d54C56A71.access.telenet.be [84.197.106.113])
	by edna.telenet-ops.be (Postfix) with ESMTP id 4A4BDE409B
	for <linux-dvb@linuxtv.org>; Tue, 27 May 2008 17:10:17 +0200 (CEST)
Message-ID: <483C2458.4080004@pandora.be>
Date: Tue, 27 May 2008 17:10:16 +0200
From: B&M <bernardenmartine@pandora.be>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem initialising Terratec Cinergy HT USB XE
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

Hello,

I found some mails on this mailing list about guys who managed to put 
the Terratec Cinergy HT USB XE to work. So, I tought I'd give it a try, 
but it didn't really went as expected.
There seems to be a problem at registration of frontend causing a crash.
Any idea what this could be?

Do you know how I can debug this? I suppose I should deactivate the 
automatic detection of my USB and launch the driver load manually with 
gdb, but I'm not yet comfortable on how to do this.

I'm running a brand new install of fedora 9 (2.6.25.3-18.fc9.x86_64)

Below (part of) the output of dmesg:
dib0700: loaded with support for 7 different device-types
dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to 
load a firmware
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff900 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff980 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa00 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa80 irq 22
ata3: SATA link down (SStatus 0 SControl 300)
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Terratec Cinergy HT USB XE)
ata6: SATA link down (SStatus 0 SControl 300)
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
ALSA sound/pci/hda/hda_intel.c:1810: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:2857: autoconfig: line_outs=4 
(0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:2861:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2865:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2866:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:2874:    inputs: mic=0x18, fmic=0x19, 
line=0x1a, fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Headphone 
Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker Playback 
Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback 
Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Line-Out Playback 
Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker Playback 
Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback 
Switch, skipped
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.0 to 64
r8169 0000:02:00.0: no MSI. Back to INTx.
eth0: RTL8168b/8111b at 0xffffc200004fe000, 00:19:db:c0:16:4f, XID 
38000000 IRQ 19
DVB: registering frontend 0 (DiBcom 7000PC)...
general protection fault: 0000 [1] SMP
CPU 1
Modules linked in: tuner_xc2028 snd_hda_intel snd_seq_dummy snd_seq_oss 
dvb_usb_dib0700(+) dib7000p snd_seq_midi_event dib7000m snd_seq dvb_usb 
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm dvb_core dib3000mc 
dibx000_common i2c_piix4 snd_timer snd_page_alloc floppy snd_hwdep 
k8temp r8169 snd button hwmon ahci soundcore shpchp dib0070 i2c_core 
pcspkr sr_mod sg cdrom dm_snapshot dm_zero dm_mirror dm_mod pata_acpi 
ata_generic pata_atiixp libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd 
ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 660, comm: modprobe Not tainted 2.6.25.3-18.fc9.x86_64 #1
RIP: 0010:[<ffffffff882917f1>]  [<ffffffff882917f1>] 
:tuner_xc2028:xc2028_attach+0x19d/0x1f0
RSP: 0018:ffff810036da5aa8  EFLAGS: 00010206
RAX: 0020000000a08c00 RBX: ffffffff882936b0 RCX: 0000000000000080
RDX: 00000000ffffffff RSI: ffffffff88291970 RDI: ffff810032cf1270
RBP: ffff810036da5ad8 R08: ffffffff88198869 R09: ffff810036da5ad0
R10: 0000000000000002 R11: ffff810036da56a8 R12: ffffffff88208be0
R13: 0000000000000000 R14: ffff810032cf1000 R15: 0000000000000000
FS:  00007fc93594e6f0(0000) GS:ffff810037802680(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003bde0a6550 CR3: 00000000331ab000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 660, threadinfo ffff810036da4000, task 
ffff810036da2000)
Stack:  0000000000000001 0000000000000000 ffff810036cc8d50 ffff810036cc8618
 ffff810036cc8d50 0000000000000001 ffff810036da5af8 ffffffff882008e7
 ffff810036cc8618 ffff810036cc8d50 ffff810036da5b18 ffffffff881d4f27
Call Trace:
 [<ffffffff882008e7>] :dvb_usb_dib0700:stk7700ph_tuner_attach+0x6b/0x99
 [<ffffffff881d4f27>] :dvb_usb:dvb_usb_adapter_frontend_init+0xdc/0xff
 [<ffffffff881d4979>] :dvb_usb:dvb_usb_device_init+0x4b4/0x597
 [<ffffffff8820065c>] :dvb_usb_dib0700:dib0700_probe+0x44/0x6f
 [<ffffffff811c5e98>] usb_probe_interface+0xe5/0x133
 [<ffffffff811aba99>] driver_probe_device+0xc0/0x16e
 [<ffffffff811abbda>] __driver_attach+0x93/0xd3
 [<ffffffff811abb47>] ? __driver_attach+0x0/0xd3
 [<ffffffff811ab2b6>] bus_for_each_dev+0x4f/0x89
 [<ffffffff811ab8e4>] driver_attach+0x1c/0x1e
 [<ffffffff811aab2d>] bus_add_driver+0xb7/0x200
 [<ffffffff811abda3>] driver_register+0x5e/0xde
 [<ffffffff811c60ec>] usb_register_driver+0x80/0xe4
 [<ffffffff8820d037>] :dvb_usb_dib0700:dib0700_module_init+0x37/0x53
 [<ffffffff81057747>] sys_init_module+0x193f/0x1a87
 [<ffffffff810a4db8>] ? do_sync_read+0xe7/0x12d
 [<ffffffff8103e30e>] ? msleep+0x0/0x1e
 [<ffffffff810a57fd>] ? vfs_read+0xab/0x154
 [<ffffffff8100bedb>] system_call_after_swapgs+0x7b/0x80


Code: 31 c0 e8 16 6f 00 f9 49 8d be 70 01 00 00 48 c7 c6 70 18 29 88 b9 
40 00 00 00 f3 a5 83 ca ff 48 8b 43 18 8a 4b 10 48 85 c0 74 06 <8b> 90 
b8 02 00 00 48 8b 73 28 31 c0 0f b6 c9 49 c7 c0 08 27 29
RIP  [<ffffffff882917f1>] :tuner_xc2028:xc2028_attach+0x19d/0x1f0
 RSP <ffff810036da5aa8>
---[ end trace de2b9667e3d5dcad ]---


Thanks for your help !

Bernard

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
