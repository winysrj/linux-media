Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Mon, 17 Mar 2008 12:04:06 -0500
Message-ID: <C82A808D35A16542ACB16AF56367E0580A7968FB@exchange01.nsighttel.com>
In-Reply-To: <47DE9362.4050706@linuxtv.org>
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com><c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com><c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com><c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com>
	<47DE9362.4050706@linuxtv.org>
From: "Mark A Jenks" <Mark.Jenks@nsighttel.com>
To: "Steven Toth" <stoth@linuxtv.org>, <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
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

Okay, clean install.  Did it again.

Installed Suse 10.3, installed all updates.  Uninstalled lirc, but I see
the modules are still there.

So, pretty much clean install.  Added kernel-sources, and gcc.  Compiled
and installed CVS.

Modprobe cx23885

Didn't even load the Nvidia drivers.

Let me get rid of lirc_imon & lirc_imon2 and see what happens.

-Mark


mythtv:~ # lsmod
Module                  Size  Used by
mt2131                  9732  1
s5h1409                12548  1
cx23885                66644  2
videodev               35584  1 cx23885
v4l1_compat            17412  1 videodev
compat_ioctl32          5376  1 cx23885
v4l2_common            14976  1 cx23885
btcx_risc               8712  1 cx23885
tveeprom               15748  1 cx23885
videobuf_dvb           10628  1 cx23885
dvb_core               76548  1 videobuf_dvb
videobuf_dma_sg        17028  2 cx23885,videobuf_dvb
videobuf_core          21380  3 cx23885,videobuf_dvb,videobuf_dma_sg
xfs                   502932  1
snd_pcm_oss            50432  0
snd_mixer_oss          20096  1 snd_pcm_oss
snd_seq_midi           13440  0
snd_seq_midi_event     10880  1 snd_seq_midi
snd_seq                54452  2 snd_seq_midi,snd_seq_midi_event
iptable_filter          6912  0
ip_tables              16324  1 iptable_filter
ip6_tables             17476  0
x_tables               18308  2 ip_tables,ip6_tables
loop                   21636  0
dm_mod                 56880  3
osst                   54172  0
ohci1394               36272  0
ieee1394               91136  1 ohci1394
st                     40092  0
button                 12560  0
rtc_cmos               12064  0
lirc_imon              19716  0
rtc_core               23048  1 rtc_cmos
rtc_lib                 7040  1 rtc_core
lirc_imon2             19204  0
snd_hda_intel         273180  1
snd_pcm                82564  2 snd_pcm_oss,snd_hda_intel
snd_mpu401             12684  0
snd_mpu401_uart        12416  1 snd_mpu401
snd_rawmidi            28416  2 snd_seq_midi,snd_mpu401_uart
snd_seq_device         12172  3 snd_seq_midi,snd_seq,snd_rawmidi
k8temp                  9600  0
snd_timer              26756  2 snd_seq,snd_pcm
parport_pc             40892  0
snd                    58164  13
snd_pcm_oss,snd_mixer_oss,snd_seq_midi,snd_seq,snd_hda_intel,snd_pcm,snd
_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq_device,snd_timer
hwmon                   7300  1 k8temp
forcedeth              50056  0
parport                37832  1 parport_pc
soundcore              11460  1 snd
lirc_dev               18136  2 lirc_imon,lirc_imon2
i2c_nforce2             9856  0
snd_page_alloc         14472  2 snd_hda_intel,snd_pcm
sr_mod                 19492  0
cdrom                  37020  1 sr_mod
i2c_core               27520  6
mt2131,s5h1409,cx23885,v4l2_common,tveeprom,i2c_nforce2
sg                     37036  0
sd_mod                 31104  7
ohci_hcd               23684  0
ehci_hcd               35340  0
usbcore               124268  5 lirc_imon,lirc_imon2,ohci_hcd,ehci_hcd
edd                    12996  0
ext3                  131848  4
mbcache                12292  1 ext3
jbd                    68148  1 ext3
fan                     9220  0
aic7xxx               157348  0
scsi_transport_spi     27008  1 aic7xxx
sata_nv                22664  6
pata_amd               16644  0
libata                139216  2 sata_nv,pata_amd
scsi_mod              140376  8
osst,st,sr_mod,sg,sd_mod,aic7xxx,scsi_transport_spi,libata
thermal                20872  0
processor              40876  1 thermal



mythtv:~ # dmesg
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
[card=3,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xc0
cx23885[0]/0: found at 0000:02:00.0, rev: 3, irq: 22, latency: 0, mmio:
0xfd600000
PCI: Setting latency timer of device 0000:02:00.0 to 64
BUG: unable to handle kernel paging request at virtual address fd7fffff
 printing eip:
c01090bd
*pde = 00000000
Oops: 0000 [#1]
SMP
last sysfs file: /devices/pci0000:00/0000:00:00.0/class
Modules linked in: mt2131 s5h1409 cx23885 videodev v4l1_compat
compat_ioctl32 v4l2_common btcx_risc tveeprom videobuf_dvb dvb_core
videobuf_dma_sg videobuf_core xfs snd_pcm_oss snd_mixer_oss snd_seq_midi
snd_seq_midi_event snd_seq iptable_filter ip_tables ip6_tables x_tables
loop dm_mod osst ohci1394 ieee1394 st button rtc_cmos lirc_imon rtc_core
rtc_lib lirc_imon2 snd_hda_intel snd_pcm snd_mpu401 snd_mpu401_uart
snd_rawmidi snd_seq_device k8temp snd_timer parport_pc snd hwmon
forcedeth parport soundcore lirc_dev i2c_nforce2 snd_page_alloc sr_mod
cdrom i2c_core sg sd_mod ohci_hcd ehci_hcd usbcore edd ext3 mbcache jbd
fan aic7xxx scsi_transport_spi sata_nv pata_amd libata scsi_mod thermal
processor
CPU:    0
EIP:    0060:[<c01090bd>]    Tainted: G      N VLI
EFLAGS: 00010286   (2.6.22.17-0.1-default #1)
EIP is at dma_free_coherent+0x22/0x53
eax: 00000000   ebx: edafc000   ecx: fd7fffff   edx: 000001d4
esi: 00000000   edi: ef745aec   ebp: ef6e51e0   esp: ef5e5f60
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cx23885[0] dvb (pid: 14819, ti=ef5e4000 task=f758b030
task.ti=ef5e4000)
Stack: dfe01c90 dfe01c48 f8f18416 2dafc000 ffffffe9 f8ec796f ef745a80
ef745b08
       ef6e5128 f9377dcd ef6e5128 00000000 00000282 f8e87414 ef6e5128
00000000
       ef745080 f8e87504 ef6e5128 ef6e5120 f8e8758b ef7450a4 f8f0f3e7
c011dfa6
Call Trace:
 [<f8f18416>] btcx_riscmem_free+0x58/0x68 [btcx_risc]
 [<f8ec796f>] videobuf_dma_free+0x1/0x8f [videobuf_dma_sg]
 [<f9377dcd>] cx23885_free_buffer+0x4a/0x55 [cx23885]
 [<f8e87414>] videobuf_queue_cancel+0x72/0x8e [videobuf_core]
 [<f8e87504>] __videobuf_read_stop+0xb/0x53 [videobuf_core]
 [<f8e8758b>] videobuf_read_stop+0xf/0x17 [videobuf_core]
 [<f8f0f3e7>] videobuf_dvb_thread+0xec/0x12f [videobuf_dvb]
 [<c011dfa6>] complete+0x39/0x48
 [<f8f0f2fb>] videobuf_dvb_thread+0x0/0x12f [videobuf_dvb]
 [<c01350ee>] kthread+0x38/0x5e
 [<c01350b6>] kthread+0x0/0x5e
 [<c0106117>] kernel_thread_helper+0x7/0x10
 =======================
Code: d8 5b e9 eb 44 06 00 5b c3 56 53 89 cb 31 c9 85 c0 74 06 8b 88 40
01 00 00 8d 42 ff 83 ce ff c1 e8 0b 46 d1 e8 75 fb 85 c9 74 26 <8b> 11
39 d3 72 20 8b 41 08 c1 e0 0c 8d 04 02 39 c3 73 13 29 d3
EIP: [<c01090bd>] dma_free_coherent+0x22/0x53 SS:ESP 0068:ef5e5f60 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
