Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy.quengel.org ([213.146.113.159]:34151 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbZCJMBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 08:01:42 -0400
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Twinhan DVB-T card does not tune with 2.6.29
From: Ralf Gerbig <rge@quengel.org>
Date: Tue, 10 Mar 2009 12:52:43 +0100
Message-ID: <8763ihy4qc.fsf@gerlin1.hsp-law.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=

Hi Mauro, everybody else,

it is a Twinhan VisionPlus DVB, works perfectly with 2.6.28 and
previous.

I tried rc6, rc7 and current git. The only thing that stands out (to
my untrained eye) is:

IRQ 17/bt878: IRQF_DISABLED is not guaranteed on shared IRQs

messages, /proc/interrupts, modules, lspci included, config.gz
attached.

I hope this helps,

thanks Ralf




Kaffeine says:
2.6.29:

Tuning to: MDR FERNSEHEN / autocount: 0
DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
Using DVB device 0:0 "DST DVB-T"
tuning DVB-T to 594000000 Hz
inv:2 bw:0 fecH:2 fecL:9 mod:1 tm:1 gi:3 hier:0
...............

Not able to lock to the signal on the given frequency
Frontend closed
Tuning delay: 1602 ms
Tuning to: RTL Television / autocount: 0
Using DVB device 0:0 "DST DVB-T"
tuning DVB-T to 498000000 Hz
inv:2 bw:0 fecH:2 fecL:9 mod:1 tm:1 gi:3 hier:0
...............

Not able to lock to the signal on the given frequency
Frontend closed
Tuning delay: 1602 ms
Saved epg data : 4667 events (70 msecs)

2.6.28:

Tuning to: RTL Television / autocount: 0
DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
Using DVB device 0:0 "DST DVB-T"
tuning DVB-T to 498000000 Hz
inv:2 bw:0 fecH:2 fecL:9 mod:1 tm:1 gi:3 hier:0
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 559 ms
pipe opened
xine pipe opened /home/rge/.kaxtv.ts
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: NDR FS NDS / autocount: 1
Using DVB device 0:0 "DST DVB-T"
tuning DVB-T to 594000000 Hz
inv:2 bw:0 fecH:2 fecL:9 mod:1 tm:1 gi:3 hier:0
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 304 ms
pipe opened
xine pipe opened /home/rge/.kaxtv1.ts
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Saved epg data : 5506 events (78 msecs)

Messages 2.6.29-git-00143-g99adcd9
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:02:07.0, irq: 17, latency: 32, mmio: 0xfdeff000
bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI subsystem ID is 1822:0001
bttv0: using: Twinhan DST + clones [card=113,autodetected]
IRQ 17/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=00000000, out=00000000 in=00fb0efe [pre-init]
bttv0: risc main @ bf8ab000
bttv0: gpio: en=00000000, out=00000000 in=00f92bfe [init]
bttv0: tuner absent
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878 0000:02:07.1: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
bt878(0): Bt878 (rev 17) at 02:07.1, irq: 17, latency: 32, memory: 0xfdefe000
IRQ 17/bt878: IRQF_DISABLED is not guaranteed on shared IRQs
dvb_bt8xx: identified card0 as bttv0
DVB: registering new adapter (bttv0)
dst(0) dst_comm_init: Initializing DST.
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
bttv0: gpio: en=00000001, out=00000000 in=00fbfffe [extern enable]
bttv0: gpio: en=00000001, out=00000000 in=00fb46fe [extern write]
dst(0) rdc_reset_state: Resetting state machine
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
bttv0: gpio: en=00000003, out=00000002 in=00f9fffc [extern enable]
bttv0: gpio: en=00000003, out=00000000 in=00fbe4fc [extern write]
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
bttv0: gpio: en=00000003, out=00000000 in=00fb5dfc [extern enable]
bttv0: gpio: en=00000003, out=00000002 in=00fb1afc [extern write]
writing [ 00 06 00 00 00 00 00 fa ]
bt-i2c: <W aa 00 06 00 00 00 00 00 fa >
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fbacfe [extern enable]
bt-i2c: <R ab =ff >
dst(0) read_dst: reply is 0xff
dst(0) dst_wait_dst_ready: dst wait ready after 1
bt-i2c: <R ab =20 =44 =54 =54 =44 =49 =47 =20 >
dst(0) read_dst: reply is 0x20
0x44 0x54 0x54 0x44 0x49 0x47 0x20
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fb1eff [extern enable]
dst(0) dst_get_device_id: Recognise [DTTDIG]
dst(0) dst_type_print: DST type: terrestrial
DST type flags : 0x10 firmware version = 2
dst(0) dst_comm_init: Initializing DST.
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
bttv0: gpio: en=00000001, out=00000000 in=00f975fe [extern enable]
bttv0: gpio: en=00000001, out=00000000 in=00fb03fe [extern write]
dst(0) rdc_reset_state: Resetting state machine
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
bttv0: gpio: en=00000003, out=00000002 in=00fbccfc [extern enable]
bttv0: gpio: en=00000003, out=00000000 in=00f9ccfc [extern write]
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
bttv0: gpio: en=00000003, out=00000000 in=00fbdcfc [extern enable]
bttv0: gpio: en=00000003, out=00000002 in=00fbb7fc [extern write]
writing [ 00 0a 00 00 00 00 00 f6 ]
bt-i2c: <W aa 00 0a 00 00 00 00 00 f6 >
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fbadff [extern enable]
bt-i2c: <R ab =ff >
dst(0) read_dst: reply is 0xff
dst(0) dst_wait_dst_ready: dst wait ready after 0
bt-i2c: <R ab =00 =08 =ca =30 =10 =4c =2f =73 >
dst(0) read_dst: reply is 0x0
0x8 0xca 0x30 0x10 0x4c 0x2f 0x73
dst(0) dst_get_mac: MAC Address=[00:08:ca:30:10:4c]
DVB: registering adapter 0 frontend 0 (DST DVB-T)...

2.6.28.7:

Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:02:07.0, irq: 17, latency: 32, mmio: 0xfdeff000
bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI subsystem ID is 1822:0001
bttv0: using: Twinhan DST + clones [card=113,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fb5bfe [pre-init]
bttv0: risc main @ 3cf54000
bttv0: gpio: en=00000000, out=00000000 in=00fb5bfe [init]
bttv0: tuner absent
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878 0000:02:07.1: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
bt878(0): Bt878 (rev 17) at 02:07.1, irq: 17, latency: 32, memory: 0xfdefe000
dvb_bt8xx: identified card0 as bttv0
DVB: registering new adapter (bttv0)
dst(0) dst_comm_init: Initializing DST.
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
bttv0: gpio: en=00000001, out=00000000 in=00f9b6fe [extern enable]
bttv0: gpio: en=00000001, out=00000000 in=00fb52fe [extern write]
dst(0) rdc_reset_state: Resetting state machine
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
bttv0: gpio: en=00000003, out=00000002 in=00fbe6fc [extern enable]
bttv0: gpio: en=00000003, out=00000000 in=00f963fc [extern write]
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
bttv0: gpio: en=00000003, out=00000000 in=00fbd5fc [extern enable]
bttv0: gpio: en=00000003, out=00000002 in=00fb0ffc [extern write]
writing [ 00 06 00 00 00 00 00 fa ]
bt-i2c: <W aa 00 06 00 00 00 00 00 fa >
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fb2ffe [extern enable]
bt-i2c: <R ab =ff >
dst(0) read_dst: reply is 0xff
dst(0) dst_wait_dst_ready: dst wait ready after 1
bt-i2c: <R ab =20 =44 =54 =54 =44 =49 =47 =20 >
dst(0) read_dst: reply is 0x20
0x44 0x54 0x54 0x44 0x49 0x47 0x20
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00f96eff [extern enable]
dst(0) dst_get_device_id: Recognise [DTTDIG]
dst(0) dst_type_print: DST type: terrestrial
DST type flags : 0x10 firmware version = 2
dst(0) dst_comm_init: Initializing DST.
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
bttv0: gpio: en=00000001, out=00000000 in=00fb39fe [extern enable]
bttv0: gpio: en=00000001, out=00000000 in=00f9ddfe [extern write]
dst(0) rdc_reset_state: Resetting state machine
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
bttv0: gpio: en=00000003, out=00000002 in=00fbe5fc [extern enable]
bttv0: gpio: en=00000003, out=00000000 in=00fb01fc [extern write]
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
bttv0: gpio: en=00000003, out=00000000 in=00fb2efc [extern enable]
bttv0: gpio: en=00000003, out=00000002 in=00fbecfc [extern write]
writing [ 00 0a 00 00 00 00 00 f6 ]
bt-i2c: <W aa 00 0a 00 00 00 00 00 f6 >
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fb1eff [extern enable]
bt-i2c: <R ab =ff >
dst(0) read_dst: reply is 0xff
dst(0) dst_wait_dst_ready: dst wait ready after 0
bt-i2c: <R ab =00 =08 =ca =30 =10 =4c =2f =73 >
dst(0) read_dst: reply is 0x0
0x8 0xca 0x30 0x10 0x4c 0x2f 0x73
dst(0) dst_get_mac: MAC Address=[00:08:ca:10:4c:00]
DVB: registering adapter 0 frontend 1601332596 (DST DVB-T)...
dst(0) dst_set_freq: set Frequency 682000000
dst(0) dst_set_frontend: Set Frequency=[682000000]
dst(0) dst_write_tuna: type_flags 0x10 
dst(0) dst_comm_init: Initializing DST.
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
bttv0: gpio: en=00000001, out=00000000 in=00fbaefe [extern enable]
bttv0: gpio: en=00000001, out=00000000 in=00fb62fe [extern write]
dst(0) rdc_reset_state: Resetting state machine
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
bttv0: gpio: en=00000003, out=00000002 in=00f921fc [extern enable]
bttv0: gpio: en=00000003, out=00000000 in=00fbedfc [extern write]
dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
bttv0: gpio: en=00000003, out=00000000 in=00fbc5fc [extern enable]
bttv0: gpio: en=00000003, out=00000002 in=00fbccfc [extern write]
writing [ 0a 68 10 07 08 00 00 6f ]
bt-i2c: <W aa 0a 68 10 07 08 00 00 6f >
dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
bttv0: gpio: en=00000000, out=00000000 in=00fb74fe [extern enable]
bt-i2c: <R ab =ff >
dst(0) read_dst: reply is 0xff
dst(0) dst_wait_dst_ready: dst wait ready after 17
bt-i2c: <R ab =0a =68 =00 =56 =39 =00 =00 =ff >
dst(0) read_dst: reply is 0xa
0x68 0x0 0x56 0x39 0x0 0x0 0xff
function : dvb_dvr_open
dvb_bt8xx: start_feed
dvb_bt8xx: start_feed
function : dvb_dmxdev_filter_set
dvb_bt8xx: start_feed
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
function : dvb_dvr_poll
[...]
dmxdev: section callback 4e f1 3a 00 02 ef

interupts-2.6.29-git-00143-g99adcd9:

           CPU0       CPU1       CPU2       CPU3       
  0:         41          0          0          3   IO-APIC-edge      timer
  1:          0          0          1        679   IO-APIC-edge      i8042
  6:          0          0          0          3   IO-APIC-edge      floppy
  7:          1          0          0          0   IO-APIC-edge      parport0
  8:          0          0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          1        100   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0         33   IO-APIC-fasteoi   sata_sil24, ohci1394, HDA Intel
 17:          0          0          0         34   IO-APIC-fasteoi   bttv0, bt878
 18:          0          0          0          2   IO-APIC-fasteoi   fcpcipnp
 21:          0         10        781       8885   IO-APIC-fasteoi   sata_nv, HDA Intel
 22:          0          5        743      19891   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
 23:          0          5        128      17205   IO-APIC-fasteoi   sata_nv, ehci_hcd:usb1
 26:          0          3         68      36598   PCI-MSI-edge      inner
 27:          0          2         77      36011   PCI-MSI-edge      outer
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      18479      12585      12330      28107   Local timer interrupts
RES:       7334       7904       6049       7152   Rescheduling interrupts
CAL:        103        197        193        104   Function call interrupts
TLB:       1306       1138        941        730   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1
MIS:          0


interupts-2.6.28.7:

           CPU0       CPU1       CPU2       CPU3       
  0:         41          0          1        277   IO-APIC-edge      timer
  1:          0          1         80      22235   IO-APIC-edge      i8042
  6:          0          0          0          3   IO-APIC-edge      floppy
  7:          1          0          0          0   IO-APIC-edge      parport0
  8:          0          0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          0         96   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 16:          0          0          0         29   IO-APIC-fasteoi   sata_sil24, ohci1394, HDA Intel
 17:          0          0         15       4970   IO-APIC-fasteoi   bttv0, bt878
 18:          0          0          0          2   IO-APIC-fasteoi   fcpcipnp
 20:          0          4        286     138957   IO-APIC-fasteoi   ehci_hcd:usb1, HDA Intel
 21:          1        368     129404    1685931   IO-APIC-fasteoi   sata_nv
 22:          0        300     109509    3054730   IO-APIC-fasteoi   sata_nv
 23:          0         49        848     136499   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
380:          0        231       9545    5827745   PCI-MSI-edge      outer
381:          0        212       8358    4778392   PCI-MSI-edge      inner
NMI:          0          0          0          0   Non-maskable interrupts
LOC:    2065225    1275523     589089    2608517   Local timer interrupts
RES:     487139     309466     439503     415886   Rescheduling interrupts
CAL:        395        488        486        188   Function call interrupts
TLB:      19918       9095      37597       9974   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1
MIS:          0

modules-2.6.29-git-00143-g99adcd9:

dvb_bt8xx              13596  0 
nxt6000                 7068  1 dvb_bt8xx
mt352                   6428  1 dvb_bt8xx
sp887x                  7164  1 dvb_bt8xx
dst_ca                 12104  1 dvb_bt8xx
tuner_simple           12676  1 dvb_bt8xx
tuner_types            17656  1 tuner_simple
or51211                 7548  1 dvb_bt8xx
zl10353                 7472  1 dvb_bt8xx
lgdt330x                8700  1 dvb_bt8xx
dst                    26976  2 dvb_bt8xx,dst_ca
dvb_core               87548  5 dvb_bt8xx,dst_ca,or51211,lgdt330x,dst
cx24110                 7628  1 dvb_bt8xx
bt878                  10296  2 dvb_bt8xx,dst
bttv                  234868  2 dvb_bt8xx,bt878
i2c_algo_bit            5692  1 bttv
v4l2_common            14904  1 bttv
videodev               38064  2 bttv,v4l2_common
v4l1_compat            12604  1 videodev
videobuf_dma_sg        11468  1 bttv
videobuf_core          16284  2 bttv,videobuf_dma_sg
btcx_risc               4352  1 bttv
tveeprom               13292  1 bttv

modules-2.6.8.7:

dvb_bt8xx              13636  0 
nxt6000                 7300  1 dvb_bt8xx
mt352                   6660  1 dvb_bt8xx
sp887x                  7364  1 dvb_bt8xx
dst_ca                 12352  1 dvb_bt8xx
tuner_simple           12820  1 dvb_bt8xx
tuner_types            17920  1 tuner_simple
or51211                 7876  1 dvb_bt8xx
zl10353                 7624  1 dvb_bt8xx
dst                    26824  2 dvb_bt8xx,dst_ca
lgdt330x                8900  1 dvb_bt8xx
dvb_core               81052  5 dvb_bt8xx,dst_ca,or51211,dst,lgdt330x
cx24110                 7812  1 dvb_bt8xx
bt878                  10584  2 dvb_bt8xx,dst
bttv                  187684  2 dvb_bt8xx,bt878
compat_ioctl32          8320  1 bttv
videodev               31104  2 bttv,compat_ioctl32
v4l1_compat            12548  1 videodev
i2c_algo_bit            5828  1 bttv
v4l2_common            12480  1 bttv
videobuf_dma_sg        11716  1 bttv
videobuf_core          16452  2 bttv,videobuf_dma_sg
btcx_risc               4616  1 bttv
tveeprom               13636  1 bttv


lspci:

00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:08.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:09.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:09.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:0a.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:0a.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
00:10.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:11.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:16.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV770 LE [Radeon HD 4800 Series]
01:00.1 Audio device: ATI Technologies Inc HD48x0 audio
02:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:08.0 Network controller: AVM GmbH Fritz!PCI v2.0 ISDN (rev 01)
02:0b.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)
03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment;
 filename=config-2.6.29-git-00143-g99adcd9.gz
Content-Transfer-Encoding: base64

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
AP8PKYOTWNzuAAA=
--=-=-=--
