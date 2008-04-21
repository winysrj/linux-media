Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tr14.bluewin.ch ([195.186.19.82])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <fearless.spiff@bluewin.ch>) id 1JnxqQ-0008Ld-TV
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 17:22:18 +0200
Received: from [192.168.1.123] (85.5.148.171) by tr14.bluewin.ch (Bluewin
	7.3.122) (authenticated as fearless.spiff)
	id 480CA5BE00002972 for linux-dvb@linuxtv.org;
	Mon, 21 Apr 2008 15:19:14 +0000
Message-Id: <3D6B1A98-6474-4DD3-ADF0-C4B40606970B@bluewin.ch>
From: Fearless Spiff <fearless.spiff@bluewin.ch>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 21 Apr 2008 17:21:10 +0200
Subject: [linux-dvb] [Patch] Terratec Cinergy S2 PCI HD CI
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

Hi all

I'm new to the list and trying to make my VP-1041 based "Terratec  
Cinergy S2 PCI HD CI" running. I already managed to get the card  
recognized with an older revision of Mantis. Now I did a little patch,  
so that i don't have to edit the file described in the Wiki (http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI 
) all the time, when compiling a new revision.  Now the patch is  
working fine, but I cannot load the module properly.  I'm pretty sure  
it has nothing to do with the patch. Btw, could somebody please  
integrate the attached patch into mantis if it is good enough? I have  
no idea how you manage things like this?

Here's the relevant output of dmesg:

Apr 21 17:06:15 HTPC kernel: [   17.008000] ACPI: PCI Interrupt  
0000:02:06.0[A] -> GSI 21 (level, low) -> IRQ 21
Apr 21 17:06:15 HTPC kernel: [   17.024000] irq: 21, latency: 64
Apr 21 17:06:15 HTPC kernel: [   17.024000]  memory: 0xfdeff000, mmio:  
0xf8a66000
Apr 21 17:06:15 HTPC kernel: [   17.024000] found a VP-1041 PCI DSS/ 
DVB-S/DVB-S2 device on (02:06.0),
Apr 21 17:06:15 HTPC kernel: [   17.024000]     Mantis Rev 1 [153b: 
1179], irq: 21, latency: 64
Apr 21 17:06:15 HTPC kernel: [   17.024000]     memory: 0xfdeff000,  
mmio: 0xf8a66000
Apr 21 17:06:15 HTPC kernel: [   17.028000]     MAC Address=[00:08:ca: 
1c:a2:49]
Apr 21 17:06:15 HTPC kernel: [   17.028000] mantis_alloc_buffers (0):  
DMA=0x37930000 cpu=0xf7930000 size=65536
Apr 21 17:06:15 HTPC kernel: [   17.028000] mantis_alloc_buffers (0):  
RISC=0x37901000 cpu=0xf7901000 size=1000
Apr 21 17:06:15 HTPC kernel: [   17.028000] DVB: registering new  
adapter (Mantis dvb adapter)
Apr 21 17:06:15 HTPC kernel: [   17.552000] stb0899_get_dev_id: Device  
ID=[8], Release=[2]
Apr 21 17:06:15 HTPC kernel: [   17.564000] stb0899_get_dev_id:  
Demodulator Core ID=[DMD1], Version=[1]
Apr 21 17:06:15 HTPC kernel: [   17.576000] stb0899_get_dev_id: FEC  
Core ID=[FEC1], Version=[1]
Apr 21 17:06:15 HTPC kernel: [   17.576000] stb0899_attach: Attaching  
STB0899
Apr 21 17:06:15 HTPC kernel: [   17.576000] mantis_frontend_init (0):  
found STB0899 DVB-S/DVB-S2 frontend @0x68
Apr 21 17:06:15 HTPC kernel: [   17.576000] stb6100_attach: Attaching  
STB6100
Apr 21 17:06:15 HTPC kernel: [   17.576000] DVB: registering frontend  
0 (STB0899 Multistandard)...
Apr 21 17:06:15 HTPC kernel: [   17.576000] mantis_ca_init (0):  
Registering EN50221 device
Apr 21 17:06:15 HTPC kernel: [   17.576000] mantis_ca_init (0):  
Registered EN50221 device
Apr 21 17:06:15 HTPC kernel: [   17.576000] mantis_hif_init (0):  
Adapter(0) Initializing Mantis Host Interface
Apr 21 17:06:15 HTPC kernel: [   17.576000] ACPI: PCI Interrupt  
0000:02:05.0[A] -> GSI 20 (level, low) -> IRQ 22
Apr 21 17:06:15 HTPC kernel: [   17.576000] cmipci: no OPL device at  
0x388, skipping...
Apr 21 17:06:15 HTPC kernel: [   17.776000] BUG: unable to handle  
kernel paging request at virtual address 08a65fff
Apr 21 17:06:15 HTPC kernel: [   17.776000]  printing eip:
Apr 21 17:06:15 HTPC kernel: [   17.776000] f8b32c44
Apr 21 17:06:15 HTPC kernel: [   17.776000] *pde = 00000000
Apr 21 17:06:15 HTPC kernel: [   17.776000] Oops: 0002 [#1]
Apr 21 17:06:15 HTPC kernel: [   17.776000] SMP
Apr 21 17:06:15 HTPC kernel: [   17.776000] Modules linked in:  
snd_usb_audio snd_pcm_oss snd_mixer_oss snd_cmipci gameport  
snd_opl3_lib snd_mpu401_uart snd_pcm mantis snd_page_alloc snd_usb_lib  
snd_seq_dummy lnbp21 snd_seq_oss mb86a16 stb6100 tda10021 lirc_mceusb2  
lirc_imon tda10023 stb0899 snd_seq_midi snd_seq_midi_event lirc_dev  
stv0299 snd_rawmidi nvidia(P) snd_seq snd_timer dvb_core mcs7830  
usbnet i2c_piix4 snd_seq_device parport_pc parport mii snd_hwdep  
serio_raw snd soundcore psmouse pcspkr i2c_core k8temp shpchp  
pci_hotplug ati_agp agpgart evdev joydev ext3 jbd mbcache sg ide_cd  
cdrom sd_mod usbhid hid usb_storage ata_generic libusual ehci_hcd ahci  
floppy ohci1394 ieee1394 atiixp ide_core ohci_hcd usbcore libata  
scsi_mod thermal processor fan fuse apparmor commoncap
Apr 21 17:06:15 HTPC kernel: [   17.776000] CPU:    0
Apr 21 17:06:15 HTPC kernel: [   17.776000] EIP:    0060: 
[<f8b32c44>]    Tainted: P       VLI
Apr 21 17:06:15 HTPC kernel: [   17.776000] EFLAGS: 00010282    
(2.6.22-14-generic #1)
Apr 21 17:06:15 HTPC kernel: [   17.776000] EIP is at  
mantis_hif_read_mem+0x44/0x210 [mantis]
Apr 21 17:06:15 HTPC kernel: [   17.776000] eax: f8a66000   ebx:  
80000000   ecx: 00000000   edx: 00000016
Apr 21 17:06:15 HTPC kernel: [   17.776000] esi: f7ea0a80   edi:  
00000000   ebp: f7c95800   esp: f7959df4
Apr 21 17:06:15 HTPC kernel: [   17.776000] ds: 007b   es: 007b   fs:  
00d8  gs: 0000  ss: 0068
Apr 21 17:06:15 HTPC kernel: [   17.776000] Process kdvb-ca-0:0 (pid:  
4330, ti=f7958000 task=df93e530 task.ti=f7958000)
Apr 21 17:06:15 HTPC kernel: [   17.776000] Stack: c01317e7 f7959e2c  
ffffffff 00000000 00000282 c0131867 00000282 f7959e2c
Apr 21 17:06:15 HTPC kernel: [   17.776000]        fffeec64 c013187e  
f7ea0af8 00000000 00000000 f7f75080 f8a6c16e 00200200
Apr 21 17:06:15 HTPC kernel: [   17.776000]        fffeec64 c0131470  
df93e530 f7959fc0 00000000 f7f75080 f8a6be54 f7f75100
Apr 21 17:06:15 HTPC kernel: [   17.776000] Call Trace:
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [lock_timer_base+39/96]  
lock_timer_base+0x27/0x60
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [try_to_del_timer_sync 
+71/80] try_to_del_timer_sync+0x47/0x50
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [del_timer_sync+14/32]  
del_timer_sync+0xe/0x20
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [<f8a6c16e>]  
dvb_ca_en50221_read_tuple+0x1e/0x180 [dvb_core]
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [process_timeout+0/16]  
process_timeout+0x0/0x10
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [<f8a6be54>]  
dvb_ca_en50221_check_camstatus+0x54/0xe0 [dvb_core]
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [<f8a6d4b4>]  
dvb_ca_en50221_thread+0x464/0xa40 [dvb_core]
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [__wake_up_sync+63/112]  
__wake_up_sync+0x3f/0x70
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [do_notify_parent 
+273/384] do_notify_parent+0x111/0x180
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [deactivate_task+26/48]  
deactivate_task+0x1a/0x30
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [__activate_task+33/64]  
__activate_task+0x21/0x40
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [try_to_wake_up+70/1152]  
try_to_wake_up+0x46/0x480
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [__switch_to+170/464]  
__switch_to+0xaa/0x1d0
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [kprobe_flush_task 
+68/144] kprobe_flush_task+0x44/0x90
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [schedule+1301/2192]  
schedule+0x515/0x890
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [__fput+299/416] __fput 
+0x12b/0x1a0
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [complete+64/96] complete 
+0x40/0x60
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [<f8a6d050>]  
dvb_ca_en50221_thread+0x0/0xa40 [dvb_core]
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [kthread+66/112] kthread 
+0x42/0x70
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [kthread+0/112] kthread 
+0x0/0x70
Apr 21 17:06:15 HTPC kernel: [   17.776000]  [kernel_thread_helper 
+7/16] kernel_thread_helper+0x7/0x10
Apr 21 17:06:15 HTPC kernel: [   17.776000]  =======================
Apr 21 17:06:15 HTPC kernel: [   17.776000] Code: 00 00 8b 45 18 81 cb  
00 00 00 80 89 98 a0 00 00 00 8b 45 18 c7 80 a4 00 00 00 04 00 00 00  
b8 8c 4f 01 00 e8 8f ba 6c c7 8b 45 18 <89> 98 ff ff ff 0f 8b 46 74 89  
44 24 10 b8 f4 01 00 00 e8 15 9e
Apr 21 17:06:15 HTPC kernel: [   17.776000] EIP: [<f8b32c44>]  
mantis_hif_read_mem+0x44/0x210 [mantis] SS:ESP 0068:f7959df4



Thanks and regards
Spiff

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
