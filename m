Return-path: <mchehab@localhost>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o84Nh4Dg027611
	for <video4linux-list@redhat.com>; Sat, 4 Sep 2010 19:43:04 -0400
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o84NgshW000546
	for <video4linux-list@redhat.com>; Sat, 4 Sep 2010 19:42:54 -0400
From: "Avner" <avner-moshkovitz@shaw.ca>
To: <video4linux-list@redhat.com>
Subject: Failure to operate video card: Hauppauge WinTV-HVR 1850 on Linux
	kernel 2.6.27-17-generic (Ubuntu Intrepid distribution)
Date: Sat, 4 Sep 2010 16:42:43 -0700
Message-ID: <A321E38ABF8C45F898BE00F718A4A015@familypc>
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@localhost>
List-ID: <video4linux-list@redhat.com>

 

Hello,

I am trying to install a Hauppauge 1850 video card into Linux Home
automation system (LinuxMCE) which is based on Ubuntu Intrepid (I can't
upgrade the kernel since this is what the LinuxMCE distribution supports)

I am feeding analog signal to the video card, either through a coax analog
connection or an RCA analog connection. I cannot see any picture from the
card (I verified that the video card is working properly under a Windows
Vista OS)

I am trying to use the video card using a lightweight application such as
tvtime, xawtv. In all applications I am failing to see an image. (For
example, tvtime shows the message "No inputs avialble Cannot open capture
device /dev/video0". Right clicking on Input configuration / Change video
source doesn't give any options)

 

I installed the drivers for the card, according to the instructions in:

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1800

 

Building the drivers from source, according to the section "Making it Work /
Analog" fails with error.

cd v4l-dvb

make

I'm getting the following compilation error: 

avner@dcerouter:~$ cd v4l-dvb/
avner@dcerouter:~/v4l-dvb$ make
make -C /home/avner/v4l-dvb/v4l
make[1]: Entering directory `/home/avner/v4l-dvb/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/home/avner/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/home/avner/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/home/avner/v4l-dvb/v4l/firmware'
make[2]: Nothing to be done for `default'.
make[2]: Leaving directory `/home/avner/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.27-17-generic/build
make -C /lib/modules/2.6.27-17-generic/build SUBDIRS=/home/avner/v4l-dvb/v4l
modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.27-17-generic'
CC [M] /home/avner/v4l-dvb/v4l/dvb_demux.o
/home/avner/v4l-dvb/v4l/dvb_demux.c: In function 'dvbdmx_write':
/home/avner/v4l-dvb/v4l/dvb_demux.c:1137: error: implicit declaration of
function 'memdup_user'
/home/avner/v4l-dvb/v4l/dvb_demux.c:1137: warning: assignment makes pointer
from integer without a cast
make[3]: *** [/home/avner/v4l-dvb/v4l/dvb_demux.o] Error 1
make[2]: *** [_module_/home/avner/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-17-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/avner/v4l-dvb/v4l'
make: *** [all] Error 2

 

According to the instructions in the section "Making it Work / Firmware" I
downloaded the prebuilt firmware and created the files:
v4l-cx23885-avcore-01.fw and v4l-cx23885-enc.fw. Then I loaded the drivers
using:

modprobe cx23885

modprobe tuner

 

In dmesg I see the following output:

 

[   17.696559] cx23885 driver version 0.0.2 loaded
[   17.696766] cx23885 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ
18
[   17.697103] CORE cx23885[0]: subsystem: 0070:8541, board: Hauppauge
WinTV-HVR1850 [card=24,autodetected]
[   18.023353] tveeprom 0-0050: Hauppauge model 85021, rev C5F5, serial#
6418425
[   18.023360] tveeprom 0-0050: MAC address is f7b0bd91
[   18.023364] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type
54)
[   18.023368] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   18.023373] tveeprom 0-0050: audio processor is CX23888 (idx 40)
[   18.023376] tveeprom 0-0050: decoder processor is CX23888 (idx 34)
[   18.023380] tveeprom 0-0050: has radio, has IR receiver, has no IR
transmitter
[   18.023385] cx23885[0]: hauppauge eeprom: model=85021
[   18.075129] cx25840 2-0044: cx23888 A/V decoder found @ 0x88 (cx23885[0])
[   18.094106] firmware: requesting v4l-cx23885-avcore-01.fw
[   20.652675] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   20.658952] cx23885[0]: registered device video0 [mpeg]
[   20.658957] cx23885_dvb_register() allocating 1 frontend(s)
[   20.658960] cx23885[0]: cx23885 based dvb card
[   20.763471] tda18271 0-0060: creating new instance
[   20.765478] TDA18271HD/C2 detected @ 0-0060
[   20.996721] DVB: registering new adapter (cx23885[0])
[   20.996727] DVB: registering adapter 0 frontend 0 (Samsung S5H1411
QAM/8VSB Frontend)...
[   20.997486] cx23885_dev_checkrevision() Hardware revision = 0xd0
[   20.997499] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 18,
latency: 0, mmio: 0xbbc00000
[   20.997511] cx23885 0000:02:00.0: setting latency timer to 64
[   21.032019] Registered IR keymap rc-hauppauge-new
[   21.032189] input: cx23885 IR (Hauppauge WinTV-HVR as
/devices/pci0000:00/0000:00:1c.2/0000:02:00.0/input/input7
[   21.037190] BUG: unable to handle kernel NULL pointer dereference at
00000000
[   21.037200] IP: [<f8be8879>] :ir_core:__ir_input_register+0x269/0x300
[   21.037214] *pde = 00000000 
[   21.037222] Oops: 0000 [#1] SMP 
[   21.037229] Modules linked in: rc_hauppauge_new tda18271 s5h1411 cx25840
serio_raw psmouse evdev cx23885(+) cx2341x v4l2_common pcspkr videodev
v4l1_compat videobuf_dma_sg videobuf_dvb snd_hda_codec_cmedia dvb_core
videobuf_core ir_common ir_core btcx_risc tveeprom nvidia(P) snd_hda_intel
snd_hda_codec i2c_core snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device
parport_pc parport snd iTCO_wdt button iTCO_vendor_support soundcore shpchp
pci_hotplug snd_page_alloc intel_agp agpgart ipv6 ext3 jbd mbcache sd_mod
crc_t10dif sr_mod cdrom sg usbhid hid ata_piix pata_acpi ata_generic libata
tulip scsi_mod dock sky2 uhci_hcd usbcore floppy raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan nbd fbcon tileblit font bitblit softcursor fuse
[   21.037364] 
[   21.037370] Pid: 2802, comm: modprobe Tainted: P
(2.6.27-17-generic #1)
[   21.037375] EIP: 0060:[<f8be8879>] EFLAGS: 00010246 CPU: 1
[   21.037382] EIP is at __ir_input_register+0x269/0x300 [ir_core]
[   21.037385] EAX: 00000000 EBX: 00000000 ECX: c0486ab4 EDX: f7ac7800
[   21.037388] ESI: f8cbb348 EDI: f712e800 EBP: f7b0bd5c ESP: f7b0bd2c
[   21.037390]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   21.037394] Process modprobe (pid: 2802, ti=f7b0a000 task=f781b240
task.ti=f7b0a000)
[   21.037396] Stack: 00000074 00000000 f8d178cd c037e40b 00000000 f7ac7938
f7ac7800 00000246 
[   21.037406]        f7ac7954 f8d0f2e0 f7b93000 f8cbb348 f7b0bdc0 f8d0e58e
f8d178cd 00000000 
[   21.037415]        f8d178b1 f71224f4 f7ac6418 f7ac6438 f712e800 f7ac6400
c049d680 00000004 
[   21.037425] Call Trace:
[   21.037431]  [<c037e40b>] ? printk+0x1d/0x22
[   21.037440]  [<f8d0f2e0>] ? cx23888_ir_rx_s_parameters+0x0/0x2e0
[cx23885]
[   21.037458]  [<f8d0e58e>] ? cx23885_input_init+0x21e/0x330 [cx23885]
[   21.037475]  [<f8d11ad0>] ? cx23885_initdev+0x270/0xbf1 [cx23885]
[   21.037492]  [<c02649ee>] ? pci_device_probe+0x5e/0x80
[   21.037503]  [<c02c5439>] ? really_probe+0x59/0x190
[   21.037510]  [<c0263fa6>] ? pci_match_device+0xc6/0xd0
[   21.037527]  [<c02c55b3>] ? driver_probe_device+0x43/0x60
[   21.037533]  [<c02c5649>] ? __driver_attach+0x79/0x80
[   21.037540]  [<c02c4d13>] ? bus_for_each_dev+0x53/0x80
[   21.037545]  [<c0264930>] ? pci_device_remove+0x0/0x40
[   21.037551]  [<c02c52ee>] ? driver_attach+0x1e/0x20
[   21.037555]  [<c02c55d0>] ? __driver_attach+0x0/0x80
[   21.037560]  [<c02c46af>] ? bus_add_driver+0x1cf/0x250
[   21.037570]  [<c0264930>] ? pci_device_remove+0x0/0x40
[   21.037575]  [<c02c581e>] ? driver_register+0x6e/0x150
[   21.037585]  [<f8868000>] ? cx23885_init+0x0/0x45 [cx23885]
[   21.037597]  [<c0264c1f>] ? __pci_register_driver+0x4f/0x90
[   21.037603]  [<f8868000>] ? cx23885_init+0x0/0x45 [cx23885]
[   21.037612]  [<f8868043>] ? cx23885_init+0x43/0x45 [cx23885]
[   21.037622]  [<c0101120>] ? _stext+0x30/0x160
[   21.037628]  [<c012b65e>] ? try_to_wake_up+0xde/0x290
[   21.037637]  [<c014c914>] ? __blocking_notifier_call_chain+0x14/0x70
[   21.037650]  [<c015c5a8>] ? sys_init_module+0x88/0x1b0
[   21.037657]  [<c019187a>] ? sys_mmap_pgoff+0x7a/0x160
[   21.037663]  [<c0103f7b>] ? sysenter_do_call+0x12/0x2f
[   21.037668]  =======================
[   21.037670] Code: e8 ad 4d 5c c7 e9 de fd ff ff 8b 55 ec 8b 45 f0 e8 5d
7e 79 c7 89 f8 e8 f6 83 6e c7 85 c0 89 c3 78 bf 8b 55 e8 8b 82 5c 01 00 00
<83> 38 01 74 3a a1 00 cf be f8 31 db 85 c0 0f 8e a9 fd ff ff 8b 
[   21.037723] EIP: [<f8be8879>] __ir_input_register+0x269/0x300 [ir_core]
SS:ESP 0068:f7b0bd2c
[   21.037732] ---[ end trace 5aec1bfd58a8395d ]---



...

 

signature = 0xeedefb64, cmd = STOP_CAPTURE
[  444.083448] Firmware and/or mailbox pointer not initialized or corrupted,
signature = 0xeedefb64, cmd = PING_FW
[  444.083562] firmware: requesting v4l-cx23885-enc.fw

 

I notice the line:

BUG: unable to handle kernel NULL pointer dereference at 00000000.

and the stack trace just after loading the cx23885 driver.

 

The Linux kernel I'm using is 2.6.27-17-generic

My questions are:

1.      How can I fix the compilation error so that to build the drivers
from source

2.      Does it indicate a problem with the prebuilt driver?

Any help is greatly appreciated.

Regards,

Avner

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
