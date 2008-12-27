Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mjenks1968@gmail.com>) id 1LGcD2-0002i5-RL
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 17:40:18 +0100
Received: by wf-out-1314.google.com with SMTP id 27so4897116wfd.17
	for <linux-dvb@linuxtv.org>; Sat, 27 Dec 2008 08:40:11 -0800 (PST)
Message-ID: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
Date: Sat, 27 Dec 2008 10:40:11 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1895297672=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1895297672==
Content-Type: multipart/alternative;
	boundary="----=_Part_117633_22805510.1230396011053"

------=_Part_117633_22805510.1230396011053
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

G'morning all!  (at least it's morning here.)

I have a running Mythtv server that is running Suse 10.3 with a hvr-1250
just fine on Kernel 2.6.24, and haven't had any problems at all.

I tried to install a hvr-1800 in it yesterday, and I get a kernel oops on it
and X won't start.   I compiled up a 2.6.27.10 kernel for it, and moved to
that, and I still get the oops.    Checked my vmalloc and I am fine, but
increased it anyways to 384 just for grins.

I compiled v4l-dvb-cae6de452897 up against the 2.6.24, and the 2.6.27
kernels without any changes.   Server boots just fine without the 1800, but
with I get the oops.

The only thing that I can see, is that the 1250 and the 1800 look to be
using the same interrupt.

Here is more than enough debug info, I hope.  :)

Thanks!

-Mark


BUG: unable to handle kernel NULL pointer dereference at 000001a0
IP: [<f8e5a594>] :cx23885:video_open+0x2c/0x150
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: iptable_filter ip_tables ip6_tables x_tables
cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 xfs
loop dm_mod cx25840 mt2131 s5h1409 nvidia(P) cx23885 v4l2_compat_ioctl32
cx2341x videobuf_dma_sg button videobuf_dvb dvb_core videobuf_core
v4l2_common snd_hda_intel snd_usb_audio snd_usb_lib snd_mpu401 snd_cs4232
snd_opl3_lib snd_cs4231_lib snd_pcm ohci1394 videodev v4l1_compat osst
agpgart btcx_risc rtc_cmos i2c_nforce2 snd_timer ieee1394 snd_mpu401_uart
tveeprom sr_mod snd_hwdep i2c_core rtc_core rtc_lib parport_pc parport st
lirc_mceusb2 snd_rawmidi snd_seq_device snd k8temp hwmon cdrom forcedeth
soundcore snd_page_alloc lirc_dev sg usbhid hid ff_memless ohci_hcd ehci_hcd
usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi sata_nv
pata_amd libata scsi_mod dock thermal processor thermal_sys

Pid: 3178, comm: X Tainted: P          (2.6.27.10-default #3)
EIP: 0060:[<f8e5a594>] EFLAGS: 00013287 CPU: 1
EIP is at video_open+0x2c/0x150 [cx23885]
EAX: 00000000 EBX: 00000000 ECX: f7a9f000 EDX: f7a0e000
ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f764de90
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process X (pid: 3178, ti=f764c000 task=f7398c00 task.ti=f764c000)
Stack: f7a6e540 00000000 f7b16538 00000000 f7bc30a0 c016bee5 f7a6e540
00000000
       f7a6e540 f7bc30a0 00000000 c016bdd9 c01683cd f701ebc0 f6d756c0
f764df14
       f7a6e540 f764df14 00000003 c01684d8 f7a6e540 00000000 00000000
f764df14
Call Trace:
 [<c016bee5>] chrdev_open+0x10c/0x122
 [<c016bdd9>] chrdev_open+0x0/0x122
 [<c01683cd>] __dentry_open+0x10d/0x1fc
 [<c01684d8>] nameidata_to_filp+0x1c/0x2c
 [<c0172986>] do_filp_open+0x33d/0x63e
 [<f9b7d8ce>] _nv004117rm+0x9/0x12 [nvidia]
 [<c01582f8>] handle_mm_fault+0x2b3/0x5dd
 [<c017ab2d>] alloc_fd+0x57/0xd3
 [<c01681e8>] do_sys_open+0x3f/0xb8
 [<c01682a5>] sys_open+0x1e/0x23
 [<c01037ad>] sysenter_do_call+0x12/0x21
 =======================
Code: 31 ed 57 31 ff 56 31 f6 53 83 ec 04 89 14 24 8b 58 34 e8 16 18 46 c7
8b 15 d0 ad e6 f8 81 e3 ff ff 0f 00 eb 49 8b 82 84 0d 00 00 <39> 98 a0 01 00
00 75 07 89 d6 bf 01 00 00 00 8b 82 88 0d 00 00
EIP: [<f8e5a594>] video_open+0x2c/0x150 [cx23885] SS:ESP 0068:f764de90
---[ end trace c26ff07c077248e0 ]---

# dmesg | grep cx
cx23885 driver version 0.0.1 loaded
cx23885 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ
16
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
[card=3,autodetected]
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DVB: registering new adapter (cx23885[0])
cx23885_dev_checkrevision() Hardware revision = 0xc0
cx23885[0]/0: found at 0000:02:00.0, rev: 3, irq: 16, latency: 0, mmio:
0xfd400000
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:03:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ
16
CORE cx23885[1]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800
[card=2,autodetected]
cx23885[1]: hauppauge eeprom: model=78521
cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx25840' 7-0044: cx25  0-21 found @ 0x88 (cx23885[1])
cx23885[1]/0: registered device video0 [v4l2]
cx23885[1]: registered device video1 [mpeg]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[1]: cx23885 based dvb card
DVB: registering new adapter (cx23885[1])
cx23885_dev_checkrevision() Hardware revision = 0xb1
cx23885[1]/0: found at 0000:03:00.0, rev: 15, irq: 16, latency: 0, mmio:
0xfd600000
cx23885 0000:03:00.0: setting latency timer to 64

# dmesg | grep DVB
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 671089123 (Samsung S5H1409 QAM/8VSB
Frontend)...
tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
DVB: registering new adapter (cx23885[1])
DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...



# ls -l vid*
lrwxrwxrwx 1 root root      6 Dec 27 03:35 video -> video0
crw-rw---- 1 root video 81, 0 Dec 27 03:35 video0
crw-rw---- 1 root video 81, 1 Dec 27 03:35 video1


# ls -lR dvb*
dvb:
total 0
drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter0
drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter1

dvb/adapter0:
total 0
crw-rw---- 1 root video 212, 1 Dec 27 03:35 demux0
crw-rw---- 1 root video 212, 2 Dec 27 03:35 dvr0
crw-rw---- 1 root video 212, 0 Dec 27 03:35 frontend0
crw-rw---- 1 root video 212, 3 Dec 27 03:35 net0

dvb/adapter1:
total 0
crw-rw---- 1 root video 212, 5 Dec 27 03:35 demux0
crw-rw---- 1 root video 212, 6 Dec 27 03:35 dvr0
crw-rw---- 1 root video 212, 4 Dec 27 03:35 frontend0
crw-rw---- 1 root video 212, 7 Dec 27 03:35 net0

 # cat /proc/meminfo
MemTotal:      3115468 kB
MemFree:       2787964 kB
Buffers:          9580 kB
Cached:         224572 kB
SwapCached:          0 kB
Active:         106360 kB
Inactive:       185368 kB
HighTotal:     2489280 kB
HighFree:      2191700 kB
LowTotal:       626188 kB
LowFree:        596264 kB
SwapTotal:     2104504 kB
SwapFree:      2104504 kB
Dirty:            2000 kB
Writeback:           0 kB
AnonPages:       57640 kB
Mapped:          27928 kB
Slab:            14800 kB
SReclaimable:     8112 kB
SUnreclaim:       6688 kB
PageTables:        972 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:   3662236 kB
Committed_AS:   321112 kB
VmallocTotal:   376824 kB
VmallocUsed:     22080 kB
VmallocChunk:   354048 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB
DirectMap4k:     20480 kB
DirectMap4M:    634880 kB

# cat /proc/interrupts
           CPU0       CPU1
  0:         43          1   IO-APIC-edge      timer
  1:          0          8   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge      parport0
  8:          0         79   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 10:          0          0   IO-APIC-edge      MPU401 UART
 12:          0        114   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      pata_amd
 15:          8         70   IO-APIC-edge      pata_amd
 16:          0         14   IO-APIC-fasteoi   cx23885[0], cx23885[1]
 17:          4         55   IO-APIC-fasteoi   aic7xxx
 19:          0          3   IO-APIC-fasteoi   ohci1394
 20:          0          4   IO-APIC-fasteoi   ehci_hcd:usb2
 21:         50        639   IO-APIC-fasteoi   ohci_hcd:usb1
 22:          0          0   IO-APIC-fasteoi   sata_nv
 23:       4394       9058   IO-APIC-fasteoi   sata_nv, eth0
NMI:          0          0   Non-maskable interrupts
LOC:       6058       6020   Local timer interrupts
RES:       3291       1978   Rescheduling interrupts
CAL:       2402        122   function call interrupts
TLB:        261        129   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0

------=_Part_117633_22805510.1230396011053
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

G&#39;morning all!&nbsp; (at least it&#39;s morning here.)<br><br>I have a running Mythtv server that is running Suse 10.3 with a hvr-1250 just fine on Kernel 2.6.24, and haven&#39;t had any problems at all.<br><br>I tried to install a hvr-1800 in it yesterday, and I get a kernel oops on it and X won&#39;t start.&nbsp;&nbsp; I compiled up a 2.6.27.10 kernel for it, and moved to that, and I still get the oops.&nbsp;&nbsp;&nbsp; Checked my vmalloc and I am fine, but increased it anyways to 384 just for grins.<br>
<br>I compiled v4l-dvb-cae6de452897 up against the 2.6.24, and the 2.6.27 kernels without any changes.&nbsp;&nbsp; Server boots just fine without the 1800, but with I get the oops.<br><br>The only thing that I can see, is that the 1250 and the 1800 look to be using the same interrupt.<br>
<br>Here is more than enough debug info, I hope.&nbsp; :)<br><br>Thanks!<br><br>-Mark<br><br><br>BUG: unable to handle kernel NULL pointer dereference at 000001a0<br>IP: [&lt;f8e5a594&gt;] :cx23885:video_open+0x2c/0x150<br>*pde = 00000000<br>
Oops: 0000 [#1] SMP<br>Modules linked in: iptable_filter ip_tables ip6_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 xfs loop dm_mod cx25840 mt2131 s5h1409 nvidia(P) cx23885 v4l2_compat_ioctl32 cx2341x videobuf_dma_sg button videobuf_dvb dvb_core videobuf_core v4l2_common snd_hda_intel snd_usb_audio snd_usb_lib snd_mpu401 snd_cs4232 snd_opl3_lib snd_cs4231_lib snd_pcm ohci1394 videodev v4l1_compat osst agpgart btcx_risc rtc_cmos i2c_nforce2 snd_timer ieee1394 snd_mpu401_uart tveeprom sr_mod snd_hwdep i2c_core rtc_core rtc_lib parport_pc parport st lirc_mceusb2 snd_rawmidi snd_seq_device snd k8temp hwmon cdrom forcedeth soundcore snd_page_alloc lirc_dev sg usbhid hid ff_memless ohci_hcd ehci_hcd usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi sata_nv pata_amd libata scsi_mod dock thermal processor thermal_sys<br>
<br>Pid: 3178, comm: X Tainted: P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (2.6.27.10-default #3)<br>EIP: 0060:[&lt;f8e5a594&gt;] EFLAGS: 00013287 CPU: 1<br>EIP is at video_open+0x2c/0x150 [cx23885]<br>EAX: 00000000 EBX: 00000000 ECX: f7a9f000 EDX: f7a0e000<br>
ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f764de90<br>&nbsp;DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068<br>Process X (pid: 3178, ti=f764c000 task=f7398c00 task.ti=f764c000)<br>Stack: f7a6e540 00000000 f7b16538 00000000 f7bc30a0 c016bee5 f7a6e540 00000000<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f7a6e540 f7bc30a0 00000000 c016bdd9 c01683cd f701ebc0 f6d756c0 f764df14<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f7a6e540 f764df14 00000003 c01684d8 f7a6e540 00000000 00000000 f764df14<br>Call Trace:<br>&nbsp;[&lt;c016bee5&gt;] chrdev_open+0x10c/0x122<br>
&nbsp;[&lt;c016bdd9&gt;] chrdev_open+0x0/0x122<br>&nbsp;[&lt;c01683cd&gt;] __dentry_open+0x10d/0x1fc<br>&nbsp;[&lt;c01684d8&gt;] nameidata_to_filp+0x1c/0x2c<br>&nbsp;[&lt;c0172986&gt;] do_filp_open+0x33d/0x63e<br>&nbsp;[&lt;f9b7d8ce&gt;] _nv004117rm+0x9/0x12 [nvidia]<br>
&nbsp;[&lt;c01582f8&gt;] handle_mm_fault+0x2b3/0x5dd<br>&nbsp;[&lt;c017ab2d&gt;] alloc_fd+0x57/0xd3<br>&nbsp;[&lt;c01681e8&gt;] do_sys_open+0x3f/0xb8<br>&nbsp;[&lt;c01682a5&gt;] sys_open+0x1e/0x23<br>&nbsp;[&lt;c01037ad&gt;] sysenter_do_call+0x12/0x21<br>
&nbsp;=======================<br>Code: 31 ed 57 31 ff 56 31 f6 53 83 ec 04 89 14 24 8b 58 34 e8 16 18 46 c7 8b 15 d0 ad e6 f8 81 e3 ff ff 0f 00 eb 49 8b 82 84 0d 00 00 &lt;39&gt; 98 a0 01 00 00 75 07 89 d6 bf 01 00 00 00 8b 82 88 0d 00 00<br>
EIP: [&lt;f8e5a594&gt;] video_open+0x2c/0x150 [cx23885] SS:ESP 0068:f764de90<br>---[ end trace c26ff07c077248e0 ]---<br><br># dmesg | grep cx<br>cx23885 driver version 0.0.1 loaded<br>cx23885 0000:02:00.0: PCI INT A -&gt; Link[APC5] -&gt; GSI 16 (level, low) -&gt; IRQ 16<br>
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]<br>cx23885[0]: warning: unknown hauppauge model #0<br>cx23885[0]: hauppauge eeprom: model=0<br>cx23885_dvb_register() allocating 1 frontend(s)<br>
cx23885[0]: cx23885 based dvb card<br>DVB: registering new adapter (cx23885[0])<br>cx23885_dev_checkrevision() Hardware revision = 0xc0<br>cx23885[0]/0: found at 0000:02:00.0, rev: 3, irq: 16, latency: 0, mmio: 0xfd400000<br>
cx23885 0000:02:00.0: setting latency timer to 64<br>cx23885 0000:03:00.0: PCI INT A -&gt; Link[APC5] -&gt; GSI 16 (level, low) -&gt; IRQ 16<br>CORE cx23885[1]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800 [card=2,autodetected]<br>
cx23885[1]: hauppauge eeprom: model=78521<br>cx25840&#39; 4-0044: cx25&nbsp; 0-21 found @ 0x88 (cx23885[0])<br>cx25840&#39; 7-0044: cx25&nbsp; 0-21 found @ 0x88 (cx23885[1])<br>cx23885[1]/0: registered device video0 [v4l2]<br>cx23885[1]: registered device video1 [mpeg]<br>
cx23885_dvb_register() allocating 1 frontend(s)<br>cx23885[1]: cx23885 based dvb card<br>DVB: registering new adapter (cx23885[1])<br>cx23885_dev_checkrevision() Hardware revision = 0xb1<br>cx23885[1]/0: found at 0000:03:00.0, rev: 15, irq: 16, latency: 0, mmio: 0xfd600000<br>
cx23885 0000:03:00.0: setting latency timer to 64<br><br># dmesg | grep DVB<br>DVB: registering new adapter (cx23885[0])<br>DVB: registering adapter 0 frontend 671089123 (Samsung S5H1409 QAM/8VSB Frontend)...<br>tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)<br>
DVB: registering new adapter (cx23885[1])<br>DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...<br><br><br><br># ls -l vid*<br>lrwxrwxrwx 1 root root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6 Dec 27 03:35 video -&gt; video0<br>crw-rw---- 1 root video 81, 0 Dec 27 03:35 video0<br>
crw-rw---- 1 root video 81, 1 Dec 27 03:35 video1<br><br><br># ls -lR dvb*<br>dvb:<br>total 0<br>drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter0<br>drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter1<br><br>dvb/adapter0:<br>
total 0<br>crw-rw---- 1 root video 212, 1 Dec 27 03:35 demux0<br>crw-rw---- 1 root video 212, 2 Dec 27 03:35 dvr0<br>crw-rw---- 1 root video 212, 0 Dec 27 03:35 frontend0<br>crw-rw---- 1 root video 212, 3 Dec 27 03:35 net0<br>
<br>dvb/adapter1:<br>total 0<br>crw-rw---- 1 root video 212, 5 Dec 27 03:35 demux0<br>crw-rw---- 1 root video 212, 6 Dec 27 03:35 dvr0<br>crw-rw---- 1 root video 212, 4 Dec 27 03:35 frontend0<br>crw-rw---- 1 root video 212, 7 Dec 27 03:35 net0<br>
<br>&nbsp;# cat /proc/meminfo<br>MemTotal:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3115468 kB<br>MemFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2787964 kB<br>Buffers:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9580 kB<br>Cached:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 224572 kB<br>SwapCached:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<br>Active:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 106360 kB<br>Inactive:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 185368 kB<br>
HighTotal:&nbsp;&nbsp;&nbsp;&nbsp; 2489280 kB<br>HighFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2191700 kB<br>LowTotal:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 626188 kB<br>LowFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 596264 kB<br>SwapTotal:&nbsp;&nbsp;&nbsp;&nbsp; 2104504 kB<br>SwapFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2104504 kB<br>Dirty:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2000 kB<br>Writeback:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<br>
AnonPages:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 57640 kB<br>Mapped:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27928 kB<br>Slab:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14800 kB<br>SReclaimable:&nbsp;&nbsp;&nbsp;&nbsp; 8112 kB<br>SUnreclaim:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6688 kB<br>PageTables:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 972 kB<br>NFS_Unstable:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<br>Bounce:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<br>
WritebackTmp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<br>CommitLimit:&nbsp;&nbsp; 3662236 kB<br>Committed_AS:&nbsp;&nbsp; 321112 kB<br>VmallocTotal:&nbsp;&nbsp; 376824 kB<br>VmallocUsed:&nbsp;&nbsp;&nbsp;&nbsp; 22080 kB<br>VmallocChunk:&nbsp;&nbsp; 354048 kB<br>HugePages_Total:&nbsp;&nbsp;&nbsp;&nbsp; 0<br>HugePages_Free:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
HugePages_Rsvd:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>HugePages_Surp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>Hugepagesize:&nbsp;&nbsp;&nbsp;&nbsp; 4096 kB<br>DirectMap4k:&nbsp;&nbsp;&nbsp;&nbsp; 20480 kB<br>DirectMap4M:&nbsp;&nbsp;&nbsp; 634880 kB<br><br># cat /proc/interrupts<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CPU0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CPU1<br>&nbsp; 0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 43&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; timer<br>
&nbsp; 1:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i8042<br>&nbsp; 7:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parport0<br>&nbsp; 8:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 79&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rtc0<br>&nbsp; 9:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; acpi<br>
&nbsp;10:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MPU401 UART<br>&nbsp;12:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 114&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i8042<br>&nbsp;14:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pata_amd<br>&nbsp;15:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70&nbsp;&nbsp; IO-APIC-edge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pata_amd<br>
&nbsp;16:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; cx23885[0], cx23885[1]<br>&nbsp;17:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 55&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; aic7xxx<br>&nbsp;19:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ohci1394<br>&nbsp;20:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ehci_hcd:usb2<br>
&nbsp;21:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 50&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 639&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; ohci_hcd:usb1<br>&nbsp;22:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; sata_nv<br>&nbsp;23:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4394&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9058&nbsp;&nbsp; IO-APIC-fasteoi&nbsp;&nbsp; sata_nv, eth0<br>NMI:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Non-maskable interrupts<br>
LOC:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6058&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6020&nbsp;&nbsp; Local timer interrupts<br>RES:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3291&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1978&nbsp;&nbsp; Rescheduling interrupts<br>CAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2402&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 122&nbsp;&nbsp; function call interrupts<br>TLB:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 261&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 129&nbsp;&nbsp; TLB shootdowns<br>TRM:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Thermal event interrupts<br>
SPU:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Spurious interrupts<br>ERR:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>MIS:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br><br>

------=_Part_117633_22805510.1230396011053--


--===============1895297672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1895297672==--
